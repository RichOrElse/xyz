class Repository
  delegate_missing_to :@records
  delegate :build, :connection, :each, :where, to: :@records

  def initialize(records, key: :id)
    @records = records
    @key = key
  end

  def with(condition)
    where(@key => condition)
  end

  def without(condition)
    with(condition).tap do |scope|
      scope.where_clause = scope.where_clause.invert
    end
  end

  def at(param)
    with(param).first
  end

  def fetch(param, default = nil, &block)
    at(param) || block&.call(param) || default
  end

  def fetch_or_build_with(param)
    fetch(param) { build_with(param) }
  end

  def fetch_or_add_with(param)
    fetch(param) { add_with(param) }
  end

  def build_with(param)
    build(@key => param)
  end

  def add_with(param)
    add build_with(param)
  end

  def add(entry)
    self << entry
    entry
  end

  def renove(entry)
    entry.destroy
  end

  def <<(entry)
    entry.save if entry.valid?
    self
  end

  def store(id, params)
    self[id].tap do |entry|
      entry.attributes = params
      self << entry
    end
  end

  def index_for(name)
    connection.indexes(table_name).index_by(&:name)[name.to_s]
  end

  singleton_class.delegate :build, :each, *public_instance_methods(false), to: :new
  singleton_class.delegate_missing_to :new
end
