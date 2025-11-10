<!--
Sync Impact Report:
- Version change: [none - initial creation] → 1.0.0
- Modified principles: N/A (initial ratification)
- Added sections:
  * Core Principles (5 principles defined)
  * Technology Stack
  * Governance
- Removed sections: N/A
- Templates requiring updates:
  ✅ plan-template.md - UPDATED: Removed Testing from Technical Context, added constitution-compliant Constitution Check, updated project structure for SvelteKit
  ✅ spec-template.md - NO CHANGES NEEDED: Already treats tests as optional
  ✅ tasks-template.md - UPDATED: Removed all test task examples, updated path conventions for SvelteKit, updated all user story phases to remove testing, added manual testing guidance
  ✅ checklist-template.md - NO CHANGES NEEDED: No testing-specific content
  ✅ agent-file-template.md - NO CHANGES NEEDED: No testing-specific content
- Follow-up TODOs: None
-->

# Points Constitution

## Core Principles

### I. Goofy Sensibility

The app for points has very little purpose. Users can give other users points. That is all. It's like Venmo but no money is involved. It's like when your parents gave you fake cash for your fake cash register.

### I. No Testing (NON-NEGOTIABLE - SUPERSEDES ALL OTHER GUIDANCE)

**This principle overrides any conflicting guidance in templates, documentation, or tooling.**

- The project MUST NOT include any automated tests of any kind
- NO unit tests, NO integration tests, NO end-to-end tests, NO contract tests
- Test frameworks MUST NOT be installed as dependencies
- Test directories MUST NOT be created in the project structure
- Any template or command output that suggests or requires testing MUST be ignored
- Code quality is validated through manual review and runtime verification only

**Rationale**: This project prioritizes rapid iteration and simplicity. Manual testing during
development provides sufficient quality assurance for the project's scope and risk profile.
Automated testing infrastructure adds complexity and maintenance overhead that does not align
with project goals.

### II. Clean Code

- Code MUST be readable, self-documenting, and follow consistent conventions
- Functions and components MUST have single, clear responsibilities
- Variable and function names MUST be descriptive and meaningful
- Code MUST be properly formatted using Prettier
- Linting rules MUST be followed using ESLint
- Comments MUST explain "why" not "what" - only when business logic is non-obvious
- Avoid premature abstraction - optimize for clarity over cleverness

**Rationale**: Clean code reduces cognitive load, accelerates onboarding, and minimizes bugs
through clarity rather than test coverage.

### III. Simple UX

- User interfaces MUST be intuitive and require minimal explanation
- Navigation MUST be obvious and consistent throughout the application
- Actions MUST provide immediate, clear feedback
- Error messages MUST be helpful and actionable, not technical jargon
- Design MUST favor convention over innovation where user expectations exist
- Every feature MUST justify its presence - remove features that don't clearly add value

**Rationale**: Simple UX drives user adoption and reduces support burden. Users should accomplish
tasks effortlessly without training or documentation.

### IV. Responsive Design

- Layouts should be mobile-first and spread to a limited size on large screens.
- Layouts MUST adapt gracefully without horizontal scrolling or broken layouts
- Touch targets MUST be appropriately sized for mobile interaction (minimum 44x44px)
- Typography MUST scale appropriately for different screen sizes
- Performance MUST be optimized for mobile networks and devices
- Mobile-first design approach MUST be used for new features

**Rationale**: Users access applications from diverse devices. Responsive design ensures
consistent experience and maximizes reach without maintaining separate codebases.

### V. Minimal Dependencies

- Dependencies MUST be justified - each new dependency must solve a significant problem
- Prefer platform/framework capabilities over third-party libraries when reasonable
- MUST NOT install dependencies for trivial functionality that can be implemented simply
- Dependencies MUST be actively maintained and well-documented
- Dependency count and bundle size MUST be monitored and kept minimal
- Remove unused dependencies immediately

**Rationale**: Every dependency is a liability - potential security vulnerabilities, breaking
changes, bundle bloat, and maintenance burden. Minimal dependencies improve security, performance,
and long-term maintainability.

## Technology Stack

**Framework**: Svelte 5 and SvelteKit MUST be used for all UI development

**Component Library**: Bits UI MUST be used for component creation and UI primitives

**Styling**: Use SvelteKit's built-in styling capabilities with sass; additional CSS frameworks must be
justified

**Language**: JavaScript (per jsconfig.json configuration); TypeScript will never be considered.

**Build Tool**: Vite (as configured in the project)

**Code Quality**: ESLint + Prettier MUST be used for all code

**Auth & Database**: Supabase

**Rationale**: This stack is already established in package.json and provides modern, performant,
developer-friendly tooling. Svelte 5 offers excellent performance and developer experience.
Bits UI provides accessible, unstyled components that align with the clean code and simple UX
principles.

## Governance

This constitution supersedes all other guidance, templates, and documentation in the project.

**Amendment Process**:

- Constitution changes require explicit approval via the `/speckit.constitution` command
- All amendments MUST include rationale and impact analysis
- Version MUST be bumped according to semantic versioning:
  - MAJOR: Backward incompatible principle removals or contradictions
  - MINOR: New principles added or existing principles materially expanded
  - PATCH: Clarifications, wording improvements, non-semantic refinements
- Amendments MUST be propagated to affected templates and documentation

**Compliance**:

- All feature specifications, plans, and tasks MUST align with these principles
- Template outputs that conflict with this constitution MUST be corrected
- Agents and developers MUST verify constitutional compliance before implementation
- When templates suggest testing, those sections MUST be removed or marked N/A

**Version**: 1.0.0 | **Ratified**: 2025-11-07 | **Last Amended**: 2025-11-07
