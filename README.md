# CSCE 606 Project 1: Library Management System

A command-line library management system built with Ruby. This application allows librarians to manage a book catalog, register library members, process checkouts and returns, search the catalog, and track overdue loans, with state persisted to YAML.

## Project Structure

```text
CSCE_606_Project1/
├── .gitignore
├── .rspec
├── .rubocop.yml
├── Gemfile
├── Gemfile.lock
├── README.md
├── lib/
│   ├── book.rb           # Book domain model
│   ├── member.rb         # Member domain model
│   ├── loan.rb            # Loan domain model
│   ├── library.rb         # Library catalog and persistence coordinator
│   └── cli.rb              # Interactive command-line interface
├── spec/
│   ├── spec_helper.rb    # RSpec test configuration with SimpleCov
│   ├── book_spec.rb       # Unit tests for Book model
│   ├── member_spec.rb  # Unit tests for Member model
│   ├── loan_spec.rb       # Unit tests for Loan model
│   ├── library_spec.rb # Tests for Library catalog operations
│   ├── cli_spec.rb        # Tests for the CLI menu and interaction flow
│   └── seed_spec.rb      # Tests validating the seed data file
├── data/
│   ├── seed.yml            # Initial baseline/demo dataset
│   └── library.yml        # Working runtime data file (gitignored)
└── docs/
    ├── planning.md         # Project planning and point allocations
    ├── design.md            # Architecture and domain schema design
    ├── user_stories.md   # User stories and acceptance criteria
    ├── backlog.md           # Sprint backlog tracking
    ├── pairing_log.md    # Pair programming logs
    └── retrospective.md # Sprint retrospective
```

## Features

- Add books to the catalog with auto-generated IDs
- Register library members with librarian-assigned IDs
- Check out books to members, with a 14-day default due date
- Check in (return) books — loan history is preserved, not deleted
- Search the catalog by title or author (case-insensitive, partial match)
- List all currently checked-out books, flagging overdue loans
- Persistent state via YAML, with sample seed data for a fresh install

## Known Limitations

- No support for multiple copies of the same book (one Book = one
  physical copy)
- No reservation/holds system for books that are already checked out
- Member checkout history beyond the current active/returned loan
  records is not yet surfaced in the CLI
- No authentication — anyone running the app has full librarian access

## Team

- Jason Atkins
- Sugam Mishra

## Setup & Installation

Ensure you have Ruby (>= 3.0) and Bundler installed.

```bash
# Clone the repository
git clone https://github.com/SugamM123/CSCE_606_Project1.git
cd CSCE_606_Project1

# Install dependencies
bundle install
```

## Running Tests

Execute the automated test suite and generate a SimpleCov coverage report:

```bash
bundle exec rspec
```

The test coverage report will be available at `coverage/index.html`.

## Running the Application

To launch the interactive command-line interface:

```bash
ruby lib/cli.rb
```
