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
end
