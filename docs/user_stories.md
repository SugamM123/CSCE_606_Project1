# User Stories & Acceptance Criteria

### 1. Setup: Define Book, Member, and Loan domain classes (3 pts)
- **User Story**: As a developer, I want to define the Book, Member, and Loan classes so that book, member, and loan data has a structured foundation.
- **Acceptance Criteria**:
  - [x] Define `Book` model with attributes (`id`, `title`, `author`, `status`).
  - [x] Define `Member` model with attributes (`id`, `name`).
  - [x] Define `Loan` model with tracking attributes (`book_id`, `member_id`, `due_date`, `status`, `return_date`).
- **Notes**: Candidate for pair programming (graded rubric item).

---

### 2. Feature: Command-line interface and menu navigation (2 pts)
- **User Story**: As a user, I want a command-line menu so that I can navigate the app's features.
- **Acceptance Criteria**:
  - [x] Display interactive menu with options for all core features.
  - [x] Read and route user input to corresponding operations.
  - [x] Provide a clean exit option.

---

### 3. Feature: Add a new book to catalog (2 pts)
- **User Story**: As a librarian, I want to add a new book to the catalog so that it becomes available for checkout.
- **Acceptance Criteria**:
  - [x] Prompt user for book title and author.
  - [x] Generate unique book identifier and set initial status to available.
  - [x] Append record to catalog and return confirmation message.

---

### 4. Feature: Add a new member to system (2 pts)
- **User Story**: As a librarian, I want to add a new member to the system so that they can check out books.
- **Acceptance Criteria**:
  - [x] Prompt user for member details (name, member ID).
  - [x] Validate member ID uniqueness.
  - [x] Append new member to storage and display confirmation.

---

### 5. Feature: Check out a book to a member (3 pts)
- **User Story**: As a librarian, I want to check out a book to a member so that its availability and loan info are tracked.
- **Acceptance Criteria**:
  - [x] Verify member exists and book is currently available.
  - [x] Update book availability status to checked out.
  - [x] Create new active Loan record with calculated due date.

---

### 6. Feature: Check in (return) a book (2 pts)
- **User Story**: As a librarian, I want to check in (return) a book so that the loan is marked returned and the book becomes available again.
- **Acceptance Criteria**:
  - [x] Locate active loan for the specified book.
  - [x] Update loan status to 'returned' and set 'return_date' (do NOT delete loan record).
  - [x] Update book availability status back to available.

---

### 7. Feature: Search catalog by title or author (2 pts)
- **User Story**: As a librarian, I want to search the catalog by title or author so that I can quickly find a book.
- **Acceptance Criteria**:
  - [ ] Case-insensitive partial matching on book title and author.
  - [ ] Display matching results with IDs, author, title, and current availability status.
  - [ ] Display friendly message when zero matches are found.

---

### 8. Feature: List all checked-out books with due dates (2 pts)
- **User Story**: As a librarian, I want to list all currently checked-out books with due dates so that I can track outstanding loans.
- **Acceptance Criteria**:
  - [x] Filter loans for active status.
  - [x] Display formatted list showing book title, borrower ID/name, and due date.
  - [x] Indicate overdue status if due date has passed.

---

### 9. Infrastructure: Persist catalog, member, and loan data to YAML (3 pts)
- **User Story**: As a developer, I want to persist catalog/member/loan data to a YAML file so that data survives between sessions.
- **Acceptance Criteria**:
  - [x] Load system state from YAML file on program start.
  - [x] Serialize and save all data to YAML on record updates or app exit.
  - [x] Gracefully handle or initialize file if YAML file does not exist on first run.

---

### 10. Refactor: Input validation and defensive error handling (2 pts)
- **User Story**: As a developer, I want input validation and error handling on core actions so that invalid input doesn't crash the app or corrupt data.
- **Acceptance Criteria**:
  - [x] Validate non-empty inputs, numeric constraints, and date formatting.
  - [x] Catch input exceptions and invalid lookup IDs without crashing the CLI.
  - [x] Print helpful error messages and prompt user to retry.

---

### 11. Testing: Automated test suite for core features (3 pts)
- **User Story**: As a developer, I want automated tests for each core feature so that we can verify behavior and catch regressions.
- **Acceptance Criteria**:
  - [ ] Test harness set up and executable from command line.
  - [ ] Unit tests for Book, Member, and Loan models.
  - [ ] Functional/integration tests for checkout, return, search, and YAML I/O.

---

### 12. Chore: Autocorrect RuboCop style offenses (0.5 pts)
- **User Story**: As a developer, I want RuboCop's auto-fixable style offenses corrected so that the codebase follows consistent formatting.
- **Acceptance Criteria**:
  - [x] Run `rubocop -A` across `lib/` and `spec/`.
  - [x] Confirm all tests still pass after autocorrect.
  - [x] No remaining auto-fixable offenses.

---

### 13. Refactor: Rename camelCase methods/attrs to snake_case in Book, Loan, Member (1.5 pts)
- **User Story**: As a developer, I want method and attribute names to follow Ruby's snake_case convention so that the codebase passes RuboCop naming checks and reads idiomatically.
- **Acceptance Criteria**:
  - [ ] Rename `checkedOut?`, `toHash`, `fromHash` (and equivalents in Loan/Member) to snake_case.
  - [ ] Rename `bookId`, `memberId`, `dueDate`, `returnDate` attributes to snake_case.
  - [ ] Update all specs referencing the old names.
  - [ ] Full test suite passes after rename.

---

### 14. Refactor: Simplify Loan#initialize (AbcSize/complexity) (2 pts)
- **User Story**: As a developer, I want Loan#initialize simplified so that it passes RuboCop's complexity thresholds and is easier to maintain.
- **Acceptance Criteria**:
  - [ ] Reduce AbcSize below 17 (currently 34.37).
  - [ ] Reduce cyclomatic/perceived complexity below their thresholds.
  - [ ] Extract helper method(s) for resolving book/member id from object-or-raw-id inputs.
  - [ ] Existing Loan specs still pass unchanged.

---

### 15. Refactor: Simplify Book.fromHash and Loan.fromHash complexity (1 pt)
- **User Story**: As a developer, I want fromHash simplified so that it passes RuboCop's complexity thresholds.
- **Acceptance Criteria**:
  - [ ] Reduce cyclomatic/perceived complexity on both fromHash methods.
  - [ ] Extract shared helper for checking multiple hash key variants (string/symbol/camelCase/snake_case).
  - [ ] Existing serialization specs still pass.

---

### 16. Docs: Add class-level documentation comments to Book and Member (0.5 pts)
- **User Story**: As a developer, I want top-level doc comments on Book and Member so that RuboCop's documentation check passes and the classes are self-explanatory.
- **Acceptance Criteria**:
  - [ ] Add one-line class comment to `Book`.
  - [ ] Add one-line class comment to `Member`.

---

### 17. Infrastructure: Seed sample data for testing (2 pts)
- **User Story**: As a developer/tester, I want sample seed data (books, members, loans) so that I can easily test and demonstrate all library workflows without manual setup every time.
- **Acceptance Criteria**:
  - [x] Provide YAML seed file containing sample books with various statuses (available, checked out).
  - [x] Provide sample members with distinct IDs and names.
  - [x] Provide sample active, overdue, and returned loans.
  - [x] Ensure data matches the domain model attributes and schemas.

