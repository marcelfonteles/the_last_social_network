module Trades
  class Creator
    include Interactor

    TRADES_POINTS = {
      water: 4,
      food: 3,
      medicine: 2,
      ammo: 1
    }.freeze

    delegate :params, to: :context

    def call
      validate_transaction

      return if context.failure?

      make_transaction
    end

    private

    def validate_transaction
      validate_points
      validate_inventories
    end

    def validate_inventories
      inventory_1.each do |inventory_item|
        trade_quantity = user_trader_1['send'][inventory_item.item.to_s]

        next if trade_quantity.nil?

        if inventory_item.quantity < trade_quantity
          context.fail!(message: 'User does not have available resources.')
          break
        end
      end

      inventory_2.each do |inventory_item|
        trade_quantity = user_trader_2['send'][inventory_item.item.to_s]

        next if trade_quantity.nil?

        if inventory_item.quantity < trade_quantity
          context.fail!(message: 'User does not have available resources.')
          break
        end
      end
    end

    def validate_points
      user_trader_1_points = get_points(user_trader_1['send'])
      user_trader_2_points = get_points(user_trader_2['send'])

      context.fail!(message: 'Invalid transaction.') if user_trader_1_points != user_trader_2_points
    end

    def get_points(items)
      points = 0
      items.each do |item|
        points += TRADES_POINTS[item[0].to_sym] * item[1].to_i
      end

      points
    end

    def user_trader_1
      params['user_trader_1']
    end

    def user_trader_2
      params['user_trader_2']
    end

    def user_1
      @user_1 ||= User.find(user_trader_1['id'])
    end

    def inventory_1
      @inventory_1 ||= user_1.inventories
    end

    def user_2
      @user_2 ||= User.find(user_trader_2['id'])
    end

    def inventory_2
      @inventory_2 ||= user_2.inventories
    end

    # Eu sei que percorri o mesmo array duas vezes.
    # Poderia percorrer apenas 1 vez, fazer a validação se tem
    # a quantidade de itens necessarios e depois salvar, mas prefiri
    # percorrer o array duas vezes para manter o codigo mais
    # organizado.
    # Metodos onde percorri o array:
    #   - validate_inventories
    #   - make_transaction
    def make_transaction
      ActiveRecord::Base.transaction do
        inventory_1.each do |inventory_item|
          # Diminui o que foi enviado
          inventory_item.quantity -= user_trader_1['send'][inventory_item.item.to_s].to_i

          # Aumenta o que foi recebido
          inventory_item.quantity += user_trader_2['send'][inventory_item.item.to_s].to_i
        end

        user_1.update(inventories_attributes: inventory_1.as_json)

        inventory_2.each do |inventory_item|
          # Diminui o que foi enviado
          inventory_item.quantity -= user_trader_2['send'][inventory_item.item.to_s].to_i

          # Aumenta o que foi recebido
          inventory_item.quantity += user_trader_1['send'][inventory_item.item.to_s].to_i
        end

        user_2.update(inventories_attributes: inventory_2.as_json)
      end
    end
  end
end
