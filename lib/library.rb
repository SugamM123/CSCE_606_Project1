# frozen_string_literal: true

require_relative 'book'
require_relative 'member'

# manages books and members
class Library
  def initialize
    @books = []
    @members = []
  end

  def add_book(title, author)
    book = Book.new(id: next_book_id, title: title, author: author)
    @books << book
    book
  end

  def books
    @books.dup
  end

  def add_member(name, id)
    # check for duplicate member ID
    if find_member(id)
      raise ArgumentError, "Member with ID #{id} already exists"
    end

    member = Member.new(id: id, name: name)
    @members << member
    member
  end

  def members
    @members.dup
  end

  # find member by ID int/str
  def find_member(id)
    @members.find do |member|
      member.id == id || member.id.to_s == id.to_s
    end
  end

  private

  def next_book_id
    # ids arennt reused
    return 1 if @books.empty?

    @books.map(&:id).max + 1
  end
end
