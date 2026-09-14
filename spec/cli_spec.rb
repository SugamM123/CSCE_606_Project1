# frozen_string_literal: true

require 'stringio'
require_relative '../lib/cli'

RSpec.describe Cli do
  def run_cli_with(input_text, library: Library.new)
    input = StringIO.new(input_text)
    output = StringIO.new
    described_class.new(input: input, output: output, library: library).run
    output.string
  end

  describe 'menu display' do
    it 'shows all core feature options' do
      output = run_cli_with("7\n")

      expect(output).to include('Add a book')
      expect(output).to include('Add a member')
      expect(output).to include('Check out a book')
      expect(output).to include('Check in (return) a book')
      expect(output).to include('Search catalog')
      expect(output).to include('List checked-out books')
      expect(output).to include('Exit')
    end
  end

  describe 'routing (happy path)' do
    it 'adds a book with the entered title and author' do
      output = run_cli_with("1\nThe Hobbit\nJ.R.R. Tolkien\n7\n")

      expect(output).to include('Added: The Hobbit by J.R.R. Tolkien')
    end

    it 'adds a member with the entered name and member id' do
      output = run_cli_with("2\nAlice Smith\n101\n7\n")

      expect(output).to include('Added member: Alice Smith (ID: 101)')
    end

    it 'returns a checked-out book with the entered book id' do
      library = Library.new
      book = library.add_book('The Hobbit', 'J.R.R. Tolkien')
      member = library.add_member('Alice', 101)
      book.status = Book::STATUS_CHECKED_OUT
      library.add_loan(Loan.new(book_id: book.id, member_id: member.id, due_date: '2026-09-30'))

      output = run_cli_with("4\n#{book.id}\n7\n", library: library)

      expect(output).to include("Returned: The Hobbit (ID: #{book.id})")
    end

    it 'routes option 5 to the search action' do
      output = run_cli_with("5\n7\n")

      expect(output).to include('[Search not yet implemented')
    end
  end

  describe 'exit option (happy path)' do
    it 'prints a goodbye message and stops the loop on option 7' do
      output = run_cli_with("7\n")

      expect(output).to include('Goodbye!')
    end

    it 'does not loop forever once exit is chosen' do
      # if this test hangs, the loop isn't breaking correctly
      expect { run_cli_with("7\n") }.not_to raise_error
    end
  end

  describe 'invalid input (sad path)' do
    it 'shows an error message for an unrecognized option' do
      output = run_cli_with("9\n7\n")

      expect(output).to include('Invalid option, please try again.')
    end

    it 'shows an error message when adding a member with an existing member id' do
      output = run_cli_with("2\nAlice Smith\n101\n2\nBob Jones\n101\n7\n")

      expect(output).to include('Added member: Alice Smith (ID: 101)')
      expect(output).to include('Error: Member with ID 101 already exists')
    end

    it 'shows an error message when returning a book with no active loan' do
      output = run_cli_with("4\n999\n7\n")

      expect(output).to include('Error: No active loan found for book ID 999')
    end

    it 're-displays the menu after an invalid option instead of crashing' do
      output = run_cli_with("9\n7\n")

      expect(output.scan('==== Library Manager ====').size).to eq(2)
    end
  end

  describe 'empty input stream (sad path)' do
    it 'exits gracefully when input runs out without a 7' do
      expect { run_cli_with('') }.not_to raise_error
    end
  end
end
