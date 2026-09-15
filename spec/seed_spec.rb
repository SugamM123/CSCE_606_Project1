# frozen_string_literal: true

require 'yaml'
require_relative '../lib/book'
require_relative '../lib/member'
require_relative '../lib/loan'

RSpec.describe 'Seed Data' do
  let(:seed_file) { File.expand_path('../data/seed.yml', __dir__) }
  let(:seed_data) { YAML.safe_load_file(seed_file) }

  it 'exists and is valid YAML' do
    expect(File.exist?(seed_file)).to be true
    expect(seed_data).to be_a(Hash)
  end

  describe 'books' do
    let(:books) { seed_data['books'].map { |b| Book.from_h(b) } }

    it 'contains sample books with both available and checked_out statuses' do
      expect(books).not_to be_empty
      statuses = books.map(&:status).uniq
      expect(statuses).to include('available', 'checked_out')
    end

    it 'assigns valid ids, titles, and authors to each book' do
      books.each do |book|
        expect(book.id).not_to be_nil
        expect(book.title).not_to be_empty
        expect(book.author).not_to be_empty
      end
    end
  end

  describe 'members' do
    let(:members) { seed_data['members'].map { |m| Member.from_h(m) } }

    it 'contains sample members with distinct IDs and names' do
      expect(members.size).to be >= 2
      ids = members.map(&:id)
      expect(ids.uniq.size).to eq(members.size)
      members.each do |member|
        expect(member.name).not_to be_empty
      end
    end
  end

  describe 'loans' do
    let(:loans) { seed_data['loans'].map { |l| Loan.from_h(l) } }

    it 'contains active, overdue, and returned loans' do
      expect(loans.any? { |l| l.active? && !l.overdue? }).to be true
      expect(loans.any? { |l| l.active? && l.overdue? }).to be true
      expect(loans.any?(&:returned?)).to be true
    end

    it 'references valid book and member ids' do
      book_ids = seed_data['books'].map { |b| b['id'] }
      member_ids = seed_data['members'].map { |m| m['id'] }

      loans.each do |loan|
        expect(book_ids).to include(loan.book_id)
        expect(member_ids).to include(loan.member_id)
      end
    end
  end
end
