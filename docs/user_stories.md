# User Stories & Acceptance Criteria

### 1. Setup: Define Book, Member, and Loan domain classes (3 pts)
- **User Story**: As a developer, I want to define the Book, Member, and Loan classes so that book, member, and loan data has a structured foundation.
- **Acceptance Criteria**:
  - [ ] Define `Book` model with attributes (`id`, `title`, `author`, `status`).
  - [ ] Define `Member` model with attributes (`id`, `name`).
  - [ ] Define `Loan` model with tracking attributes (`book_id`, `member_id`, `due_date`, `status`, `return_date`).
- **Notes**: Candidate for pair programming (graded rubric item).

---

### 2. Feature: Command-line interface and menu navigation (2 pts)
- **User Story**: As a user, I want a command-line menu so that I can navigate the app's features.
- **Acceptance Criteria**:
  - [ ] Display interactive menu with options for all core features.
  - [ ] Read and route user input to corresponding operations.
  - [ ] Provide a clean exit option.

---

### 3. Feature: Add a new book to catalog (2 pts)
- **User Story**: As a librarian, I want to add a new book to the catalog so that it becomes available for checkout.
- **Acceptance Criteria**:
  - [ ] Prompt user for book title and author.
  - [ ] Generate unique book identifier and set initial status to available.
  - [ ] Append record to catalog and return confirmation message.

---

### 4. Feature: Add a new member to system (2 pts)
- **User Story**: As a librarian, I want to add a new member to the system so that they can check out books.
- **Acceptance Criteria**:
  - [ ] Prompt user for member details (name, member ID).
  - [ ] Validate member ID uniqueness.
  - [ ] Append new member to storage and display confirmation.

---

### 5. Feature: Check out a book to a member (3 pts)
- **User Story**: As a librarian, I want to check out a book to a member so that its availability and loan info are tracked.
- **Acceptance Criteria**:
  - [ ] Verify member exists and book is currently available.
  - [ ] Update book availability status to checked out.
  - [ ] Create new active Loan record with calculated due date.

---

### 6. Feature: Check in (return) a book (2 pts)
- **User Story**: As a librarian, I want to check in (return) a book so that the loan is marked returned and the book becomes available again.
- **Acceptance Criteria**:
  - [ ] Locate active loan for the specified book.
  - [ ] Update loan status to 'returned' and set 'return_date' (do NOT delete loan record).
  - [ ] Update book availability status back to available.

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
  - [ ] Filter loans for active status.
  - [ ] Display formatted list showing book title, borrower ID/name, and due date.
  - [ ] Indicate overdue status if due date has passed.

---

### 9. Infrastructure: Persist catalog, member, and loan data to YAML (3 pts)
- **User Story**: As a developer, I want to persist catalog/member/loan data to a YAML file so that data survives between sessions.
- **Acceptance Criteria**:
  - [ ] Load system state from YAML file on program start.
  - [ ] Serialize and save all data to YAML on record updates or app exit.
  - [ ] Gracefully handle or initialize file if YAML file does not exist on first run.

---

### 10. Refactor: Input validation and defensive error handling (2 pts)
- **User Story**: As a developer, I want input validation and error handling on core actions so that invalid input doesn't crash the app or corrupt data.
- **Acceptance Criteria**:
  - [ ] Validate non-empty inputs, numeric constraints, and date formatting.
  - [ ] Catch input exceptions and invalid lookup IDs without crashing the CLI.
  - [ ] Print helpful error messages and prompt user to retry.

---

### 11. Testing: Automated test suite for core features (3 pts)
- **User Story**: As a developer, I want automated tests for each core feature so that we can verify behavior and catch regressions.
- **Acceptance Criteria**:
  - [ ] Test harness set up and executable from command line.
  - [ ] Unit tests for Book, Member, and Loan models.
  - [ ] Functional/integration tests for checkout, return, search, and YAML I/O.
