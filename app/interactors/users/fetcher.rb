module Users
  class Fetcher
    include Interactor

    delegate :user, to: :context

    def call
      get_user_inventory
      build_user
    end

    private

    def get_user_inventory
      context.inventories = user.inventories
    end

    def build_user
      context.user = user.as_json
      context.user['inventories'] = context.inventories.as_json
    end
  end
end