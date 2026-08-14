class Strategies::Base
  def initialize
    log 'Starting migration'
    log self.to_s
  end

  def migrate_group!(group)
    @group = group
    apply_to_group
    self
  end

  def migrate_page!(page)
    @page = page
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

  def apply_to_group
    raise "You need to implement apply_to_group in #{to_s}"
  end

  def apply_to_page
    raise "You need to implement apply_to_page in #{to_s}"
  end
end