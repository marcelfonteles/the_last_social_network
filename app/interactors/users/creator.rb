module Users
  class Creator
    include Interactor

    delegate :params, to: :context

    def call
      ActiveRecord::Base.transaction do
        create_user
        create_user_inventory
      end
    end

    private

    def create_user
      context.user = User.new(params)

      context.fail!(message: 'fail_user_creation') unless context.user.save
    end

    def create_user_inventory
      return if context.failure?

      context.inventories = []

      Inventory.items.keys.each do |item|
        inventory = Inventory.create(item:, user: context.user, quantity: 0)
        context.inventories << inventory
      end
    end
  end
end
