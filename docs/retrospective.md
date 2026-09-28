# Project Retrospective

## Sprint 1 Retrospective

### What Went Well
* Separating the Cli logic from the Library business logic right from the start allowed for easier testing later on.
* Collaborating closely on the initial setup and domain classes reduced bugs and improved our shared understanding of the repository.

### What Could Be Improved
* We experienced friction early on with Ruby versions and Xcode setup.
* We initially wrote code with mixed styles using camelCase instead of the standard snake_case formatting.

### Key Learnings and Takeaways
* Setting naming and style conventions like RuboCop rules before writing code saves a lot of time.

### Action Items for Next Sprint
* Refactor existing camelCase methods and attributes to snake_case.
* Configure and enforce RuboCop rules more strictly.

***

## Sprint 2 Retrospective

### What Went Well
* Distributing the complex circulation logic and YAML persistence evenly kept us on track.
* Our design decision to use errors as exceptions and have the Cli handle them centrally worked out very well for all the new features.

### What Could Be Improved
* Coordinating a stacked branch Git workflow sometimes caused merge conflicts especially when overlapping refactoring tasks with new features.

### Key Learnings and Takeaways
* Communicating branch dependencies before merging is critical in a team environment to prevent broken main branches.
* Writing automated tests alongside our refactoring efforts helped us catch regressions immediately.

### Action Items for Future Projects
* Finalize style guidelines and linter configurations in Sprint 1 before any feature code is written.
* Explore using Git rebase or better branch management strategies to minimize merge conflicts.
* Continue utilizing pair programming for the most complex architectural features.
