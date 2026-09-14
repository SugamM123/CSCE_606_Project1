# frozen_string_literal: true

require_relative 'library'

# Command-line interface for the Library Manager: displays the menu,
# reads user input, and routes to the corresponding action.
class Cli
  def initialize(input: $stdin, output: $stdout, library: Library.new)
    @input = input
    @output = output
    @library = library
  end

  def run
    loop do
      display_menu
      choice = @input.gets&.strip
      break if choice.nil?

      break if handle_choice(choice) == :exit
    end
  end

  private

  def display_menu
    @output.puts <<-MENU
      ==== Library Manager ====
      1. Add a book
      2. Add a member
      3. Check out a book
      4. Check in (return) a book
      5. Search catalog
      6. List checked-out books
      7. Exit
    MENU
  end

  def handle_choice(choice)
    action = actions[choice]
    return @output.puts('Invalid option, please try again.') unless action

    action.call
  end

  def actions
    {
      '1' => method(:add_book),
      '2' => method(:add_member),
      '3' => method(:checkout_book),
      '4' => method(:return_book),
      '5' => method(:search_catalog),
      '6' => method(:list_checked_out),
      '7' => method(:exit_app)
    }
  end

  def prompt(label)
    @output.print(label)
    @input.gets&.strip
  end

  # --- Actions below are stubbed until the Library class exists ---
  #  Once Library is built, these will look roughly like:
  #     book = Book.new(id: next_id, title: title, author: author)
  #     @library.add_book(book)

  def add_book
    title = prompt('Title: ')
    author = prompt('Author: ')
    book = @library.add_book(title, author)
    @output.puts "Added: #{book.title} by #{book.author} (ID: #{book.id})"
  end

  def add_member
    name = prompt('Name: ')
    id = prompt('Member ID: ')
    member = @library.add_member(name, id)
    @output.puts "Added member: #{member.name} (ID: #{member.id})"
  rescue ArgumentError => e
    @output.puts "Error: #{e.message}"
  end

  def checkout_book
    @output.puts '[Checkout not yet implemented - waiting on Library class]'
  end

  def return_book
    book_id = prompt('Book ID: ')
    book = @library.return_book(book_id)
    @output.puts "Returned: #{book.title} (ID: #{book.id})"
  rescue ArgumentError => e
    @output.puts "Error: #{e.message}"
  end

  def search_catalog
    @output.puts '[Search not yet implemented - waiting on Library class]'
  end

  def list_checked_out
    @output.puts '[List checked-out not yet implemented - waiting on Library class]'
  end

  def exit_app
    @output.puts('Goodbye!')
    :exit
  end
end

Cli.new.run if __FILE__ == $PROGRAM_NAME
