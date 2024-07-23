class BooksRepresenter
  def initialize(books)
    @books=books
  end

  def as_json
    books.map do |book|
      {
        id: book.id,
        title: book.title,
        author_name: author_name(book),
        author_age: book.author.age
      }
    end
  end

  def author_name(book)
    "#{book.author.first_name} #{book.author.last_name}"
  end
  private
  attr_reader :books

end