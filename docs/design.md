# Design

## System architecture

The app is organized around five classes: four domain/data classes and one
CLI class that ties them together.

### `Book`
Represents a single book in the catalog.
- Attributes: `id`, `title`, `author`, `status` (`available`/`checked_out`)
- Responsibility: knows its own identity and availability. Supports both
  keyword and positional construction, and an `isbn` alias for `id`.
- Serialization: `to_h`/`from_h` for converting to and from a plain hash
  (used by `Library#save`/`Library.load`).

### `Member`
Represents a library member.
- Attributes: `id` (entered by the librarian, not auto-generated), `name`
- Responsibility: identifies who is borrowing a book. `Library` rejects
  duplicate member IDs at creation time.
- Serialization: `to_h`/`from_h`, same pattern as `Book`.

### `Loan`
Represents a single checkout event.
- Attributes: `book_id`, `member_id`, `due_date`, `status`
  (`active`/`returned`), `return_date`
- Responsibility: tracks the relationship between a book and a member over
  time, and whether it's overdue (`overdue?`, compares `due_date` against
  today). Returning a book does not delete the loan — it's marked
  `returned` with a `return_date`, so loan history is preserved. This
  reflects instructor feedback on the original proposal and supports
  showing loan history later.
- Serialization: `to_h`/`from_h`, same pattern as `Book`/`Member`.

### `Library`
The core manager class — owns the in-memory collections and all business
logic. Nothing outside `Library` mutates `@books`, `@members`, or `@loans`
directly; the `Cli` only calls `Library`'s public methods.
- **Catalog**: `add_book`, `books`, `find_book`, `search_books` (case-
  insensitive partial match against title or author)
- **Members**: `add_member` (raises `ArgumentError` on a duplicate ID),
  `members`, `find_member`
- **Circulation**: `checkout_book` (validates the book exists, the member
  exists, and the book is available, then creates an active `Loan` and
  flips the book to `checked_out`), `return_book` (finds the active loan,
  marks it `returned` with a `return_date`, and restores the book to
  `available`), `active_loans` (loans still checked out), `find_active_loan`
- **Persistence**: `save`/`self.load` (see below)

Every public method that can fail (duplicate member, missing book/member,
double-checkout, return with no active loan) raises `ArgumentError` with a
descriptive message rather than returning `nil` or a sentinel value. The
`Cli` is responsible for catching these and displaying them; `Library`
itself never prints anything.

### `Cli`
Displays the menu, reads input, and routes to the corresponding action.
Accepts `input`/`output`/`library` as constructor arguments (defaulting to
`$stdin`/`$stdout`/`Library.load(DATA_PATH)`), which is what makes it
possible to unit-test the whole interaction loop with `StringIO` instead
of a real terminal.

- The menu loop (`run`) reads one line at a time and dispatches through a
  hash of `'1' => method(:add_book)`, etc. (`actions`), rather than a long
  `case` statement — this keeps `handle_choice` short and lets RuboCop's
  complexity checks pass.
- `handle_choice` wraps every action call in `rescue StandardError`, so an
  unexpected error anywhere in the app prints a message and returns to the
  menu instead of crashing the whole program.
- `prompt_required` wraps the basic `prompt` helper with a retry loop (up
  to 3 attempts) for fields that can't be blank (title, author, name,
  member ID, book ID). After 3 blank attempts it gives up and returns to
  the menu rather than looping forever.
- Each action method (`add_book`, `add_member`, `checkout_book`,
  `return_book`, `search_catalog`, `list_checked_out`) prompts for its own
  inputs, calls the matching `Library` method, and prints either a
  confirmation or a caught `ArgumentError`'s message.

## Data flow / persistence

- `Library#save(path)` serializes `@books`, `@members`, and `@loans` (via
  each object's `to_h`) to a YAML file.
- `Library.load(path)` deserializes a YAML file back into a fresh
  `Library`, rebuilding each `Book`/`Member`/`Loan` via `from_h`. If the
  given path doesn't exist (e.g. the very first run), it falls back to
  `data/seed.yml` instead of starting empty — so a fresh install shows a
  populated catalog rather than nothing. `data/seed.yml` is committed to
  the repo for exactly this purpose.
- `Cli` loads from `data/library.yml` (gitignored — it's the live/working
  state, regenerated from the seed on first run) when it starts, and saves
  back to that same path when the user exits (option 7).

## User interface / workflow

The app runs as a command-line menu loop:

```
==== Library Manager ====
1. Add a book
2. Add a member
3. Check out a book
4. Check in (return) a book
5. Search catalog
6. List checked-out books
7. Exit
```

Each option prompts for the needed input (e.g. title/author for adding a
book, book ID and member ID for checkout), validates it (retrying blank
entries up to 3 times where the field is required), performs the action
via `Library`, and prints a confirmation or an error message before
returning to the menu. Choosing 7 saves the current state to
`data/library.yml` and exits.

## Key design decisions & tradeoffs

- **YAML over JSON/SQLite:** chosen for built-in availability, minimal
  boilerplate, and human-readable output — a good fit for a small project
  built by two developers new to Ruby.
- **Loan records are preserved, not deleted, on return:** slightly more
  bookkeeping up front, but necessary for accurate history.
- **Seed-data fallback on first load:** rather than starting with an empty
  catalog, a missing `data/library.yml` falls back to the committed
  `data/seed.yml`, so the app is immediately demonstrable without manual
  setup.
- **Configurable loan due dates:** implemented as a `DEFAULT_LOAN_DAYS`
  constant rather than a hardcoded value, so the loan period can be
  adjusted without changing checkout logic.
- **Librarian-supplied member IDs (not auto-generated):** unlike book IDs,
  which auto-increment, member IDs are entered by the librarian and
  checked for duplicates — this matches how a real membership number
  might already exist outside the system.
- **Errors as exceptions, not return values:** `Library` methods raise
  `ArgumentError` on invalid operations rather than returning `nil`/false,
  keeping validation logic in one place and letting `Cli` handle display
  and retry behavior uniformly via a single `rescue` pattern.
- **Action dispatch via a hash instead of a long `case` statement:** keeps
  `Cli#handle_choice` short and readable, and was also the fix for a
  RuboCop cyclomatic-complexity warning during development.
