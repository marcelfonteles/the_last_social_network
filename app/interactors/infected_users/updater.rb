module InfectedUsers
  class Updater
    include Interactor

    delegate :user_id, to: :context

    def call
      find_user

      return if context.failure?

      update_amount_of_warnings

      return if context.failure?

      verify_infected_user
    end

    private

    def find_user
      context.user = User.find(user_id)
    rescue ActiveRecord::RecordNotFound
      context.fail!(message: 'User not found')
    end

    def update_amount_of_warnings
      context.user.warning_count += 1
      unless context.user.save
        context.fail!(message: 'Error saving user')
      end
    end

    def verify_infected_user
      if context.user.warning_count >= 3
        context.user.infected = true
        unless context.user.save
          context.fail!(message: 'Error saving user')
        end
      end
    end
  end
end
