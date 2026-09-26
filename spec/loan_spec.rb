# frozen_string_literal: true

require 'spec_helper'
require 'date'
require_relative '../lib/loan'
require_relative '../lib/book'
require_relative '../lib/member'

RSpec.describe Loan do
  let(:today) { Date.today }
  let(:two_weeks_later) { (today + 14).to_s }
  let(:past_date) { (today - 5).to_s }

  describe 'initialization' do
    it 'initializes with keyword arguments and default values' do
      loan = Loan.new(book_id: 1, member_id: 101, due_date: two_weeks_later)
      expect(loan.book_id).to eq(1)
      expect(loan.member_id).to eq(101)
      expect(loan.due_date).to eq(two_weeks_later)
      expect(loan.status).to eq('active')
      expect(loan.return_date).to be_nil
    end

    it 'initializes with positional arguments' do
      loan = Loan.new(1, 101, two_weeks_later, 'returned', today.to_s)
      expect(loan.book_id).to eq(1)
      expect(loan.member_id).to eq(101)
      expect(loan.due_date).to eq(two_weeks_later)
      expect(loan.status).to eq('returned')
      expect(loan.return_date).to eq(today.to_s)
    end

    it 'extracts ids when passed book and member objects' do
      book = Book.new(id: 42, title: 'Ruby Book')
      member = Member.new(id: 99, name: 'Reader')
      loan = Loan.new(book: book, member: member, due_date: two_weeks_later)
      expect(loan.book_id).to eq(42)
      expect(loan.member_id).to eq(99)
    end
  end

  describe 'status and overdue predicates' do
    it 'reports active? accurately' do
      active_loan = Loan.new(book_id: 1, member_id: 101, due_date: two_weeks_later, status: 'active')
      returned_loan = Loan.new(book_id: 1, member_id: 101, due_date: two_weeks_later, status: 'returned')

      expect(active_loan.active?).to be true
      expect(active_loan.returned?).to be false
      expect(returned_loan.active?).to be false
      expect(returned_loan.returned?).to be true
    end

    it 'detects overdue when active and due_date is in the past' do
      loan = Loan.new(book_id: 1, member_id: 101, due_date: past_date, status: 'active')
      expect(loan.overdue?(today)).to be true
    end

    it 'does not report overdue when due_date is in the future' do
      loan = Loan.new(book_id: 1, member_id: 101, due_date: two_weeks_later, status: 'active')
      expect(loan.overdue?(today)).to be false
    end

    it 'does not report overdue if loan is already returned' do
      loan = Loan.new(book_id: 1, member_id: 101, due_date: past_date, status: 'returned')
      expect(loan.overdue?(today)).to be false
    end

    it 'handles invalid date strings gracefully' do
      loan = Loan.new(book_id: 1, member_id: 101, due_date: 'not-a-date', status: 'active')
      expect(loan.overdue?(today)).to be false
    end
  end

  describe 'serialization' do
    let(:loan) do
      Loan.new(
        book_id: 1,
        member_id: 101,
        due_date: '2026-09-25',
        status: 'returned',
        return_date: '2026-09-20'
      )
    end

    it 'serializes to hash with to_hash or to_h' do
      hash = loan.to_hash
      expect(hash['book_id']).to eq(1)
      expect(hash['member_id']).to eq(101)
      expect(hash['due_date']).to eq('2026-09-25')
      expect(hash['status']).to eq('returned')
      expect(hash['return_date']).to eq('2026-09-20')
      expect(loan.to_h).to eq(hash)
    end

    it 'reconstructs Loan object from snake_case hash with from_hash' do
      hash = {
        'book_id' => 5,
        'member_id' => 105,
        'due_date' => '2026-10-01',
        'status' => 'active',
        'return_date' => nil
      }
      reconstructed = Loan.from_hash(hash)
      expect(reconstructed.book_id).to eq(5)
      expect(reconstructed.member_id).to eq(105)
      expect(reconstructed.due_date).to eq('2026-10-01')
      expect(reconstructed.status).to eq('active')
      expect(reconstructed.return_date).to be_nil
      expect(Loan.from_h(hash)).to eq(reconstructed)
    end

    it 'handles nil gracefully in from_h' do
      expect(Loan.from_h(nil)).to be_nil
    end
  end

  describe 'equality' do
    it 'considers loans with matching attributes equal' do
      l1 = Loan.new(book_id: 1, member_id: 101, due_date: '2026-09-25', status: 'active')
      l2 = Loan.new(book_id: 1, member_id: 101, due_date: '2026-09-25', status: 'active')
      expect(l1).to eq(l2)
    end

    it 'considers loans with different attributes not equal' do
      l1 = Loan.new(book_id: 1, member_id: 101, due_date: '2026-09-25', status: 'active')
      l2 = Loan.new(book_id: 2, member_id: 101, due_date: '2026-09-25', status: 'active')
      expect(l1).not_to eq(l2)
    end
  end
end
