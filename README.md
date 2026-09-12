# CSCE 606 Project 1: Library Management System

A command-line library management system built with Ruby. This application allows librarians to manage a book catalog, register library members, process checkouts and returns, search the catalog, and track overdue loans, with state persisted to YAML.

## Project Structure

```text
CSCE_606_Project1/
├── .gitignore
├── .rspec
├── Gemfile
├── Gemfile.lock
├── README.md
├── lib/
│   ├── book.rb           # Book domain model
│   ├── member.rb         # Member domain model
│   ├── loan.rb           # Loan domain model
│   ├── library.rb        # Library catalog and persistence coordinator
│   └── cli.rb            # Interactive command-line interface
├── spec/
│   ├── spec_helper.rb    # RSpec test configuration with SimpleCov
│   ├── book_spec.rb      # Unit tests for Book model
│   ├── member_spec.rb    # Unit tests for Member model
│   ├── loan_spec.rb      # Unit tests for Loan model
│   └── library_spec.rb   # Tests for Library catalog operations
├── data/
│   ├── seed.yml          # Initial baseline/demo dataset
│   └── library.yml       # Working runtime data file (gitignored)
└── docs/
    ├── planning.md       # Project planning and point allocations
    ├── design.md         # Architecture and domain schema design
    ├── user_stories.md   # User stories and acceptance criteria
    ├── backlog.md        # Sprint backlog tracking
    ├── pairing_log.md    # Pair programming logs
    └── retrospective.md  # Sprint retrospective
```

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
