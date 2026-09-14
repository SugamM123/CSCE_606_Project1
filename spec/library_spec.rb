# frozen_string_literal: true

require_relative '../lib/library'

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
end
