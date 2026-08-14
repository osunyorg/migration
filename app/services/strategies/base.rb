class Strategies::Base
  attr_reader :website, :osuny_api_instance, :group, :page, :dry_run

  def initialize(website)
    @website = website
  end

  def osuny_api_instance
    raise NoMethodError, "You need to define `osuny_api_instance` in #{self.class.name}."
  end

  def migrate_group!(group, dry_run: false)
    @group = group
    @dry_run = dry_run
    log "Migrate group #{group}"
    log self.to_s
    apply_to_group
    self
  end

  def migrate_page!(page, dry_run: false)
    @page = page
    @group = page.group
    @dry_run = dry_run
    log "Migrate page #{page}"
    log self.to_s
    apply_to_page
    self
  end

  def logs
    @logs ||= ''
  end

  def to_s
    self.class
  end

  protected

  def log(message)
    logs << "#{message}\n"
  end

  def apply_to_page
    raise "You need to implement apply_to_page in #{to_s}"
  end

  def apply_to_group
    @group.pages.root.ordered.each do |page|
      @page = page
      apply_to_page
    end
  end

end