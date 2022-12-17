class FullName < Struct.new(:first_name, :middle_name, :last_name)
  def to_s
    reject(&:blank?).join(" ")
  end

  def empty?
    all?(&:blank?)
  end

  class << self
    alias_method :call,
    def parse(name)
      first_name, *middle_name, last_name = name.to_s.split(" ")
      new(first_name, middle_name.join(" "), last_name)
    end

    def of(other)
      new(other.first_name, other.middle_name, other.last_name)
    end

    def to_proc
      method(:call).to_proc
    end
  end
end
