module DatabaseOperations
  extend ActiveSupport::Concern

  included do
    def self.paginate(page, hits_per_page)
      page = page.to_i
      page = 1 if page <= 0

      hits_per_page = hits_per_page.to_i
      hits_per_page = 10 if hits_per_page <= 0
      offset((page - 1) * hits_per_page).limit(hits_per_page)
    end
  end
end