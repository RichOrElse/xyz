class PublisherRepository < Repository
  def initialize(publishers = Publisher.all, key: :name)
    super
  end
  
  def with(name)
    where table[:name].lower.eq(name.downcase)
  end

  def [](name)
    fetch(name, build(name: name))
  end

  def <<(publisher)
    super
  rescue ActiveRecord::RecordNotUnique => not_unique
    publisher.errors.add(:name, :taken) if not_unique.message.end_with? "'index_publishers_on_lower_name'"
  ensure
    self
  end
end
