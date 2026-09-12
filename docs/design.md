# Design

## System architecture

The app is organized around four main classes:

### `Book`
Represents a single book in the catalog.
- Attributes: title, author, ISBN, availability status
- Responsibility: knows its own identity and whether it's currently
  available for checkout

### `Member`
Represents a library member.
- Attributes: name, auto-incrementing member ID
- Responsibility: identifies who is borrowing a book

### `Loan`
Represents a single checkout event.
- Attributes: book, member, checkout date, due date, status
  (`active`/`returned`), return date
- Responsibility: tracks the relationship between a book and a member over
  time. Returning a book does not delete the loan — it's marked
  `returned` with a return date, so loan history is preserved (this
  supports the member checkout history stretch feature and reflects
  instructor feedback on the original proposal).

### `Library`
The core manager/catalog class that ties everything together.
- Responsibility: add books, add members, check out/check in books, search
  the catalog, list active loans, and handle persistence (loading/saving
  state to YAML)

## Data flow / persistence

- All catalog, member, and loan data is serialized to a YAML file using
  Ruby's built-in `YAML` library.
- A small seed YAML file is committed to the repo so the app has sample
  data to run and demo immediately. The live data file used during actual
  runs is gitignored so it doesn't overwrite the seed.

## User interface / workflow

The app runs as a command-line menu loop. Rough flow:

```
==== Library Manager ====
1. Add a book
2. Add a member
3. Check out a book
4. Check in (return) a book
5. Search catalog
6. List checked-out books
7. Exit
Choose an option:
```

Each option prompts the user for the needed input (e.g. title/author for
adding a book, member ID and book ISBN for checkout), validates it, performs
the action, and prints a confirmation or an error message before returning
to the menu.

## Key design decisions & tradeoffs

- **YAML over JSON/SQLite:** chosen for built-in availability, minimal
  boilerplate, and human-readable output — a good fit for a small project
  built by two developers new to Ruby.
- **Loan records are preserved, not deleted, on return:** slightly more
  bookkeeping up front, but necessary for accurate history and the checkout
  history stretch feature.
- **Configurable loan due dates:** implemented as a constant rather than a
  hardcoded value, so the loan period can be adjusted without changing
  checkout logic.
- **Auto-incrementing member IDs:** removes the need for the librarian to
  invent or track unique IDs manually, reducing input validation surface
  area for member creation.
