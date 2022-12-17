class AuthorsPresenter
  def initialize(authors)
    @authors = authors.map { |author| FullName.of(author) }
  end

  def to_s
    @authors.join(", ")
  end
end
