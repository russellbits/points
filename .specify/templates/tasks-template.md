---

description: "Task list template for feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Per project constitution (Principle I), this project does NOT include automated tests. Manual testing and code review ensure quality.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **SvelteKit project**: `src/lib/`, `src/routes/`, `static/` at repository root
- Components go in `src/lib/components/`
- Stores go in `src/lib/stores/`
- Routes follow file-based routing in `src/routes/`
- Layouts: `+layout.svelte`, Pages: `+page.svelte`, Server code: `+page.server.js`
- Paths shown below assume SvelteKit structure - adjust based on plan.md

<!-- 
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration purposes only.
  
  The /speckit.tasks command MUST replace these with actual tasks based on:
  - User stories from spec.md (with their priorities P1, P2, P3...)
  - Feature requirements from plan.md
  - Entities from data-model.md
  - Endpoints from contracts/
  
  Tasks MUST be organized by user story so each story can be:
  - Implemented independently
  - Tested independently
  - Delivered as an MVP increment
  
  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create project structure per implementation plan
- [ ] T002 Initialize [language] project with [framework] dependencies
- [ ] T003 [P] Configure linting and formatting tools

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

Examples of foundational tasks (adjust based on your project):

- [ ] T004 Setup base layout and styling framework
- [ ] T005 [P] Create reusable component library structure with Bits UI
- [ ] T006 [P] Setup routing structure in src/routes/
- [ ] T007 Create base Svelte stores for shared state management
- [ ] T008 Configure error handling and user feedback patterns
- [ ] T009 Setup responsive design breakpoints and utilities
- [ ] T010 Configure ESLint and Prettier (required per constitution)

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - [Title] (Priority: P1) 🎯 MVP

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to manually verify this story works on its own]

### Implementation for User Story 1

- [ ] T011 [P] [US1] Create [Component1] component in src/lib/components/[component1].svelte
- [ ] T012 [P] [US1] Create [Component2] component in src/lib/components/[component2].svelte
- [ ] T013 [P] [US1] Create [Store] for state management in src/lib/stores/[store].js
- [ ] T014 [US1] Implement [route/page] in src/routes/[path]/+page.svelte
- [ ] T015 [US1] Add form validation and error handling
- [ ] T016 [US1] Ensure responsive design across mobile/tablet/desktop
- [ ] T017 [US1] Manual testing checklist: [list key scenarios to verify]

**Checkpoint**: At this point, User Story 1 should be fully functional and manually testable

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to manually verify this story works on its own]

### Implementation for User Story 2

- [ ] T018 [P] [US2] Create [Component] in src/lib/components/[component].svelte
- [ ] T019 [P] [US2] Create [Store] for state in src/lib/stores/[store].js
- [ ] T020 [US2] Implement [route/page] in src/routes/[path]/+page.svelte
- [ ] T021 [US2] Integrate with User Story 1 components (if needed)
- [ ] T022 [US2] Ensure responsive design compliance
- [ ] T023 [US2] Manual testing checklist: [list key scenarios to verify]

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to manually verify this story works on its own]

### Implementation for User Story 3

- [ ] T024 [P] [US3] Create [Component] in src/lib/components/[component].svelte
- [ ] T025 [P] [US3] Create [Store] for state in src/lib/stores/[store].js
- [ ] T026 [US3] Implement [route/page] in src/routes/[path]/+page.svelte
- [ ] T027 [US3] Ensure responsive design compliance
- [ ] T028 [US3] Manual testing checklist: [list key scenarios to verify]

**Checkpoint**: All user stories should now be independently functional

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] TXXX [P] Documentation updates in docs/ or README.md
- [ ] TXXX Code cleanup and refactoring
- [ ] TXXX Performance optimization across all stories
- [ ] TXXX ESLint and Prettier cleanup (required per constitution)
- [ ] TXXX Responsive design validation across all viewports
- [ ] TXXX Accessibility improvements (ARIA labels, keyboard navigation)
- [ ] TXXX Bundle size optimization
- [ ] TXXX Run quickstart.md validation (manual testing)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable

### Within Each User Story

- Components before pages/routes
- Stores before components that use them
- Core implementation before integration
- Story complete (and manually tested) before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- Components within a story marked [P] can run in parallel
- Stores within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all components for User Story 1 together:
Task: "Create [Component1] component in src/lib/components/[component1].svelte"
Task: "Create [Component2] component in src/lib/components/[component2].svelte"
Task: "Create [Store] for state management in src/lib/stores/[store].js"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Stories complete and integrate independently

---

## docs: establish project constitution v1.0.0

- Define 5 core principles: No Testing (supersedes all), Clean Code, Simple UX, Responsive Design, Minimal Dependencies
- Establish required tech stack: Svelte 5, SvelteKit, Bits UI
- Update plan-template.md with SvelteKit structure and constitution check
- Update tasks-template.md to remove all testing tasks, add manual testing guidance
- Add governance rules for constitution amendments and compliance

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and manually testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently (via manual testing)
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
- **No automated tests**: Manual testing via browser and code review only (per constitution)
