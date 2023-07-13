module Reports
  class Fetcher
    include Interactor

    def call
      context.reports = {}
      context.reports[:total_users] = User.all.count
      context.reports[:total_infect_users] = User.where(infected: true).count
      context.reports[:total_healthy_users] = context.reports[:total_users] - context.reports[:total_infect_users]

      context.reports[:fraction_of_infected_users] = (context.reports[:total_infect_users] / context.reports[:total_users].to_f).round(3)
      context.reports[:fraction_of_healthy_users] = 1.0 - context.reports[:fraction_of_infected_users]
      context.reports[:mean_items_per_healthy_user] = Inventory
                                                .includes(:user)
                                                .select(:item, :quantity)
                                                .where(users: { infected: false })
                                                .group(:item)
                                                .sum(:quantity)
                                                .map { |item| { "#{item[0]}": (item[1] / context.reports[:total_healthy_users].to_f).round(3) } }

      context.reports[:lost_points] = Inventory.includes(:user).where(users: { infected: true }).sum(:quantity)
    rescue StandardError => e
      puts e
      context.fail!(message: 'An error occurred.')
    end

    private

  end
end

Inventory.includes(:user).select(:item, :quantity).where(users: { infected: false }).group(:item).sum(:quantity)