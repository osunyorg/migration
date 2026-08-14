namespace :app do
  desc 'Fix things'
  task fix: :environment do
  end

  namespace :db do
    desc 'Get database from Scalingo'
    task :production do
      Bundler.with_unbundled_env do
        # Get a new backup archive from Scalingo
        sh "scalingo --app osuny-migration backups-create --addon postgresql"
        sh "scalingo --app osuny-migration backups-download --addon postgresql --output db/scalingo-dump.tar.gz"

        sh 'rm -f db/latest.dump' # Remove an old backup file if it exists
        sh 'tar zxvf db/scalingo-dump.tar.gz -C db/' # Extract the new backup archive
        sh 'rm db/scalingo-dump.tar.gz' # Remove the backup archive
        sh 'mv db/*.pgsql db/latest.dump' # Rename the backup file
        sh 'DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:drop'
        sh 'bundle exec rails db:create'
        begin
          sh 'pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d osuny_migrator_development db/latest.dump'
        rescue
          'There were some warnings or errors while restoring'
        end
        sh 'rails db:migrate'
        sh 'rails db:seed'
      end
    end
  end
end
