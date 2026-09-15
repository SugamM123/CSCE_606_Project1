# frozen_string_literal: true

require_relative '../lib/library'
require_relative '../lib/loan'

RSpec.describe Library do
  describe '#add_book' do
    it 'adds a book with the given title and author' do
      library = described_class.new
      book = library.add_book('The Hobbit', 'J.R.R. Tolkien')

      expect(book.title).to eq('The Hobbit')
      expect(book.author).to eq('J.R.R. Tolkien')
    end

    it 'assigns a unique, incrementing id to each book' do
      library = described_class.new
      first = library.add_book('Book One', 'Author One')
      second = library.add_book('Book Two', 'Author Two')

      expect(first.id).not_to eq(second.id)
      expect(second.id).to eq(first.id + 1)
    end

    it 'sets the book status to available by default' do
      library = described_class.new
      book = library.add_book('Dune', 'Frank Herbert')

      expect(book.available?).to be true
    end

    it 'adds the book to the catalog' do
      library = described_class.new
      library.add_book('1984', 'George Orwell')

      expect(library.books.size).to eq(1)
    end
  end

  describe '#add_member' do
    it 'adds a member with the given name and id' do
      library = described_class.new
      member = library.add_member('Alice Smith', 101)

      expect(member.name).to eq('Alice Smith')
      expect(member.id).to eq(101)
    end

    it 'appends the new member to the members collection' do
      library = described_class.new
      library.add_member('Alice Smith', 101)

      expect(library.members.size).to eq(1)
      expect(library.members.first.name).to eq('Alice Smith')
    end

    it 'raises an ArgumentError when adding a duplicate member id' do
      library = described_class.new
      library.add_member('Alice Smith', 101)

      expect do
        library.add_member('Bob Jones', 101)
      end.to raise_error(ArgumentError, /already exists/i)
    end

    it 'raises an ArgumentError when duplicate id is provided as a string' do
      library = described_class.new
      library.add_member('Alice Smith', 101)

      expect do
        library.add_member('Bob Jones', '101')
      end.to raise_error(ArgumentError, /already exists/i)
    end
  end

  describe '#find_member' do
    it 'returns the member when found by integer or string id' do
      library = described_class.new
      created = library.add_member('Alice Smith', 101)

      expect(library.find_member(101)).to eq(created)
      expect(library.find_member('101')).to eq(created)
    end

    it 'returns nil when member is not found' do
      library = described_class.new
      expect(library.find_member(999)).to be_nil
    end
  end

  describe '#find_book' do
    it 'returns the book when found by integer or string id' do
      library = described_class.new
      book = library.add_book('Dune', 'Frank Herbert')

      expect(library.find_book(book.id)).to eq(book)
      expect(library.find_book(book.id.to_s)).to eq(book)
    end

    it 'returns nil when book is not found' do
      library = described_class.new
      expect(library.find_book(999)).to be_nil
    end
  end

  describe '#checkout_book' do
    it 'checks out an available book to an existing member' do
      library = described_class.new
      book = library.add_book('Dune', 'Frank Herbert')
      member = library.add_member('Alice', '1')

      loan = library.checkout_book(book.id, member.id)

      expect(loan).to be_a(Loan)
      expect(book.checked_out?).to be true
    end

    it 'raises an error when the book does not exist' do
      library = described_class.new
      member = library.add_member('Alice', '1')

      expect { library.checkout_book(999, member.id) }
        .to raise_error(ArgumentError, /Book with ID 999 not found/)
    end

    it 'raises an error when the member does not exist' do
      library = described_class.new
      book = library.add_book('Dune', 'Frank Herbert')

      expect { library.checkout_book(book.id, 999) }
        .to raise_error(ArgumentError, /Member with ID 999 not found/)
    end

    it 'raises an error when the book is already checked out' do
      library = described_class.new
      book = library.add_book('Dune', 'Frank Herbert')
      member = library.add_member('Alice', '1')
      library.checkout_book(book.id, member.id)

      expect { library.checkout_book(book.id, member.id) }
        .to raise_error(ArgumentError, /already checked out/)
    end
  end

  describe '#return_book' do
    let(:library) { described_class.new }
    let(:book) { library.add_book('1984', 'George Orwell') }
    let(:member) { library.add_member('Alice', 101) }

    before do
      book.status = Book::STATUS_CHECKED_OUT
      library.add_loan(Loan.new(book_id: book.id, member_id: member.id, due_date: '2026-09-30'))
    end

    it 'locates the active loan and updates its status to returned' do
      library.return_book(book.id)
      loan = library.loans.first

      expect(loan.status).to eq('returned')
      expect(loan.returned?).to be true
    end

    it 'sets the return_date on the loan' do
      library.return_book(book.id, '2026-09-20')
      loan = library.loans.first

      expect(loan.return_date).to eq('2026-09-20')
    end

    it 'does NOT delete the loan record from storage' do
      library.return_book(book.id)

      expect(library.loans.size).to eq(1)
    end

    it 'updates the book availability status back to available' do
      returned_book = library.return_book(book.id)

      expect(returned_book.available?).to be true
      expect(book.status).to eq(Book::STATUS_AVAILABLE)
    end

    it 'works when book id is passed as a string' do
      library.return_book(book.id.to_s)

      expect(book.available?).to be true
    end

    it 'raises an ArgumentError when no active loan exists for the book' do
      other_book = library.add_book('The Hobbit', 'J.R.R. Tolkien')

      expect do
        library.return_book(other_book.id)
      end.to raise_error(ArgumentError, /no active loan found/i)
    end
  end
end
