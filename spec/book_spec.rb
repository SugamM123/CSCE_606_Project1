# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/book'

RSpec.describe Book do
  describe 'initialization' do
    it 'initializes with keyword arguments' do
      book = Book.new(id: 1, title: 'Clean Code', author: 'Robert C. Martin')
      expect(book.id).to eq(1)
      expect(book.title).to eq('Clean Code')
      expect(book.author).to eq('Robert C. Martin')
      expect(book.status).to eq('available')
    end

    it 'initializes with positional arguments' do
      book = Book.new(2, 'The Pragmatic Programmer', 'Andy Hunt', 'checked_out')
      expect(book.id).to eq(2)
      expect(book.title).to eq('The Pragmatic Programmer')
      expect(book.author).to eq('Andy Hunt')
      expect(book.status).to eq('checked_out')
    end

    it 'supports isbn as an alias for id' do
      book = Book.new(isbn: '978-0132350884', title: 'Clean Code', author: 'Robert C. Martin')
      expect(book.isbn).to eq('978-0132350884')
      expect(book.id).to eq('978-0132350884')
    end

    it 'defaults status to available' do
      book = Book.new(id: 3, title: 'Refactoring', author: 'Martin Fowler')
      expect(book.status).to eq('available')
    end
  end

  describe 'status methods' do
    it 'returns true for available? when status is available' do
      book = Book.new(id: 1, title: 'Test', author: 'Author', status: 'available')
      expect(book.available?).to be true
      expect(book.checked_out?).to be false
    end

    it 'returns true for checked_out? when status is checked_out' do
      book = Book.new(id: 1, title: 'Test', author: 'Author', status: 'checked_out')
      expect(book.checked_out?).to be true
      expect(book.checked_out?).to be true
      expect(book.available?).to be false
    end
  end

  describe 'serialization' do
    let(:book) { Book.new(id: 1, title: 'Design Patterns', author: 'Gang of Four', status: 'available') }

    it 'serializes to a hash with to_hash or to_h' do
      expected = {
        'id' => 1,
        'title' => 'Design Patterns',
        'author' => 'Gang of Four',
        'status' => 'available'
      }
      expect(book.to_hash).to eq(expected)
      expect(book.to_h).to eq(expected)
    end

    it 'reconstructs a Book object from hash using from_hash or from_h' do
      hash = { 'id' => 10, 'title' => 'Sample', 'author' => 'Author', 'status' => 'checked_out' }
      reconstructed = Book.from_hash(hash)
      expect(reconstructed.id).to eq(10)
      expect(reconstructed.title).to eq('Sample')
      expect(reconstructed.author).to eq('Author')
      expect(reconstructed.status).to eq('checked_out')
      expect(Book.from_h(hash)).to eq(reconstructed)
    end

    it 'handles nil gracefully in from_h' do
      expect(Book.from_h(nil)).to be_nil
    end
  end

  describe 'equality' do
    it 'considers books with identical attributes equal' do
      b1 = Book.new(id: 1, title: 'T', author: 'A', status: 'available')
      b2 = Book.new(id: 1, title: 'T', author: 'A', status: 'available')
      expect(b1).to eq(b2)
    end

    it 'considers books with different attributes not equal' do
      b1 = Book.new(id: 1, title: 'T', author: 'A', status: 'available')
      b2 = Book.new(id: 2, title: 'T', author: 'A', status: 'available')
      expect(b1).not_to eq(b2)
    end
  end
end
