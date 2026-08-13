class MigrateGroupJob < ApplicationJob
  queue_as :default

  def perform(group)
    group.pages.root.find_each do |root_page|
      MigratePageJob.perform_later(root_page)
    end
  end
end
