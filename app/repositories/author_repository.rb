class AuthorRepository < Repository
  def initialize(authors = Author.all, key: :full_name)
    super
  end

  def with(full_name)
    where(FullName.parse(full_name).to_h)
  end

  def build_with(full_name)
    build FullName.parse(full_name).to_h
  end
end
