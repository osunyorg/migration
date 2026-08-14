class MigrateGroupJob < ApplicationJob
  queue_as :default

  def perform(group)
    group.migrate!
  end
end
