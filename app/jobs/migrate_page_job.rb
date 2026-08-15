class MigratePageJob < ApplicationJob
  queue_as :default

  def perform(page)
    page.strategy.migrate_page!(page)
  end
end
