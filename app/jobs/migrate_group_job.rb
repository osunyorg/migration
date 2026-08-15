class MigrateGroupJob < ApplicationJob
  queue_as :default

  def perform(group)
    group.strategy.migrate_group!(group)
  end
end
