# frozen_string_literal: true

# Command-line interface for the Library Manager: displays the menu,
# reads user input, and routes to the corresponding action.
class Cli
  def initialize(input: $stdin, output: $stdout)
    @input = input
    @output = output
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

  # --- Actions below are stubbed until the Library class exists ---
  #  Once Library is built, these will look roughly like:
  #     book = Book.new(id: next_id, title: title, author: author)
  #     @library.add_book(book)

  def add_book
    @output.puts '[Add book not yet implemented - waiting on Library class]'
  end

  def add_member
    @output.puts '[Add member not yet implemented - waiting on Library class]'
  end

  def checkout_book
    @output.puts '[Checkout not yet implemented - waiting on Library class]'
  end

  def return_book
    @output.puts '[Return not yet implemented - waiting on Library class]'
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
