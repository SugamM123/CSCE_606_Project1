# frozen_string_literal: true

require 'date'
require_relative 'book'
require_relative 'member'
require_relative 'loan'

# manages books and members
class Library
  DEFAULT_LOAN_DAYS = 14

  def initialize
    @books = []
    @members = []
    @loans = []
  end

  def add_book(title, author)
    book = Book.new(id: next_book_id, title: title, author: author)
    @books << book
    book
  end

  def books
    @books.dup
  end

  # find book by ID
  def find_book(id)
    @books.find do |book|
      book.id == id || book.id.to_s == id.to_s
    end
  end

  def add_member(name, id)
    # check for duplicate member ID
    raise ArgumentError, "Member with ID #{id} already exists" if find_member(id)

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

  def checkout_book(book_id, member_id, due_date: Date.today + DEFAULT_LOAN_DAYS)
    book = find_book(book_id)
    member = find_member(member_id)

    raise ArgumentError, "Book with ID #{book_id} not found" unless book
    raise ArgumentError, "Member with ID #{member_id} not found" unless member
    raise ArgumentError, "Book '#{book.title}' is already checked out" unless book.available?

    book.status = Book::STATUS_CHECKED_OUT
    loan = Loan.new(book_id: book.id, member_id: member.id, due_date: due_date)
    @loans << loan
    loan
  end

  def add_loan(loan)
    @loans << loan
    loan
  end

  # find active loan for a book
  def find_active_loan(book_id)
    @loans.find do |loan|
      loan.active? && (loan.book_id == book_id || loan.book_id.to_s == book_id.to_s)
    end
  end

  def active_loans
    @loans.select(&:active?)
  end

  def return_book(book_id, return_date = Date.today.to_s)
    loan = find_active_loan(book_id)
    raise ArgumentError, "No active loan found for book ID #{book_id}" if loan.nil?

    loan.status = Loan::STATUS_RETURNED
    loan.return_date = return_date

    book = find_book(loan.book_id)
    book.status = Book::STATUS_AVAILABLE if book

    book || loan
  end

  def loans
    @loans.dup
  end

  private

  def next_book_id
    # ids arennt reused
    return 1 if @books.empty?

    @books.map(&:id).max + 1
  end
end
