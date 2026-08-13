class MigratePageJob < ApplicationJob
  queue_as :default

  def perform(page)
    page.migrate!
  end
end
