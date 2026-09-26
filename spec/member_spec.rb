# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/member'

RSpec.describe Member do
  describe 'initialization' do
    it 'initializes with keyword arguments' do
      member = Member.new(id: 101, name: 'Alice Smith')
      expect(member.id).to eq(101)
      expect(member.name).to eq('Alice Smith')
    end

    it 'initializes with positional arguments' do
      member = Member.new(102, 'Bob Jones')
      expect(member.id).to eq(102)
      expect(member.name).to eq('Bob Jones')
    end
  end

  describe 'serialization' do
    let(:member) { Member.new(id: 101, name: 'Alice Smith') }

    it 'serializes to a hash with to_hash or to_h' do
      expected = {
        'id' => 101,
        'name' => 'Alice Smith'
      }
      expect(member.to_hash).to eq(expected)
      expect(member.to_h).to eq(expected)
    end

    it 'reconstructs a Member from a hash using from_hash or from_h' do
      hash = { 'id' => 103, 'name' => 'Carol Williams' }
      reconstructed = Member.from_hash(hash)
      expect(reconstructed.id).to eq(103)
      expect(reconstructed.name).to eq('Carol Williams')
      expect(Member.from_h(hash)).to eq(reconstructed)
    end

    it 'handles nil gracefully in from_h' do
      expect(Member.from_h(nil)).to be_nil
    end
  end

  describe 'equality' do
    it 'considers members with matching id and name equal' do
      m1 = Member.new(id: 101, name: 'Alice')
      m2 = Member.new(id: 101, name: 'Alice')
      expect(m1).to eq(m2)
    end

    it 'considers members with different attributes not equal' do
      m1 = Member.new(id: 101, name: 'Alice')
      m2 = Member.new(id: 102, name: 'Alice')
      expect(m1).not_to eq(m2)
    end
  end
end
