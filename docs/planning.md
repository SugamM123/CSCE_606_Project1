# Project Planning

## Team Members & Point Breakdown

- **Sugam Mishra**: 13 points
  - Issue 5: Domain Models Setup (Book, Member, Loan) [3 pts]
  - Issue 8: Add Member Feature [2 pts]
  - Issue 10: Check In / Return Book Feature [2 pts]
  - Issue 11: Search Catalog Feature [2 pts]
  - Issue 12: List Checked-Out Books Feature [2 pts]
  - Issue 15: Automated Tests Suite [3 pts]
- **Jason Atkins**: 13 points
  - Issue 6: CLI Menu and Navigation [2 pts]
  - Issue 7: Add Book Feature [2 pts]
  - Issue 9: Check Out Book Feature [3 pts]
  - Issue 13: YAML Persistence [3 pts]
  - Issue 14: Input Validation & Error Handling [2 pts]

**Total Rubric Points**: 26 points

---

## Project Timeline & Milestones

### Phase 1: Foundation & Setup
- Initialize repository structure, bundler, gitignore, RSpec, SimpleCov.
- Define domain models (`Book`, `Member`, `Loan`).
- Document user stories, backlog, and architecture design.

### Phase 2: Core Domain Logic & Catalog
- Implement `Library` collection manager and YAML serialization / persistence.
- Implement Member addition, Book addition, and Catalog Search.
- Unit tests for domain operations.

### Phase 3: Circulation (Checkout & Check-In)
- Implement checkout logic (verify book availability, member existence, due date calculation).
- Implement check-in/return logic (update loan status, return date, restore availability).
- Implement overdue tracking and listing checked-out books.

### Phase 4: CLI Interface & Defensive Handling
- Command-line menu loop with user routing and clean exit.
- Input validation, boundary checks, graceful exception handling.
- End-to-end user testing.

### Phase 5: Testing, Review & Retrospective
- Complete automated test suite (aiming for high branch/line coverage with SimpleCov).
- Pair programming log review.
- Project retrospective documentation.
