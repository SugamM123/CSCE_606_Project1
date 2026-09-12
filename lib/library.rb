# frozen_string_literal: true

require_relative 'book'

# Manages the collection of books, members, and loans for the library.
class Library
  def initialize
    @books = []
  end

  def add_book(title, author)
    book = Book.new(id: next_book_id, title: title, author: author)
    @books << book
    book
  end

  def books
    @books.dup
  end

  private

  def next_book_id
    # IDs are never reused, even if a book is later removed, to avoid
    # accidentally reassigning an old book's ID to a new one.
    return 1 if @books.empty?

    @books.map(&:id).max + 1
  end
end
