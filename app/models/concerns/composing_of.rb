class ComposingOf < Module
  def initialize(**composition)
    @composition = composition.each do |of, compose|
      define_method(of) { compose.of(self) }

      define_method("#{of}=") do |value|
        component = compose.(value)
        assign_attributes(component.to_h)
        component
      end
    end
  end

  def included(base)
    @composition.each do |of, compose|
      base.scope :"with_#{of}", ->(value) { where(compose.(value).to_h) }
    end
  end

  singleton_class.alias_method :[], :new
end
