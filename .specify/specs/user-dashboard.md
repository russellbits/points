# Feature Specification: User Dashboard

**Feature Branch**: `master`  
**Created**: November 10, 2025  
**Status**: Implemented  
**Input**: User dashboard creation - this application is a points exchange. Points are nothing more than that. Points are granted to users by other users for any reason they submit. The first page is the user dashboard.

## User Scenarios & Testing

### User Story 1 - View Login Form When Not Authenticated (Priority: P1)

An unauthenticated user visiting the dashboard should see a login form to gain access to their points data.

**Why this priority**: This is the entry point to the application. Without authentication, users cannot access any features.

**Independent Test**: Can be fully tested by navigating to the root URL while logged out and verifying the login form is displayed with email/password fields.

**Acceptance Scenarios**:

1. **Given** a user is not logged in, **When** they visit the dashboard page, **Then** they see a login form
2. **Given** a user enters invalid credentials, **When** they submit the login form, **Then** they see an error message
3. **Given** a user enters valid credentials, **When** they submit the login form, **Then** they are authenticated and see the dashboard

---

### User Story 2 - View Points Awarded (Priority: P2)

An authenticated user should see a table of all points they have been awarded by other users, showing who granted them, when, how many points, and the message.

**Why this priority**: This is core functionality - users need to see what points they've received and who gave them.

**Independent Test**: Can be fully tested by logging in as a user who has received points and verifying the "Points Awarded" table displays messages where `user_id` matches the logged-in user and `points` is not null, with columns for From, When, Points, and Message.

**Acceptance Scenarios**:

1. **Given** a user has received points, **When** they view the dashboard, **Then** they see a table with columns: From, When, Points, Message
2. **Given** a user has not received any points, **When** they view the dashboard, **Then** they see "No points awarded yet" message
3. **Given** multiple point awards, **When** viewing the table, **Then** they are sorted by date (most recent first)
4. **Given** a points award, **When** viewing the sender, **Then** it displays the sender's username if available, otherwise email, otherwise 'Unknown'

---

### User Story 3 - View Points Granted (Priority: P2)

An authenticated user should see a table of all points they have granted to other users, showing who they granted them to, when, how many points, and the message.

**Why this priority**: Users need to track their point allocations and maintain awareness of their giving history.

**Independent Test**: Can be fully tested by logging in as a user who has sent points and verifying the "Points Granted" table displays messages where `from_id` matches the logged-in user and `points` is not null, with columns for To, When, Points, and Message.

**Acceptance Scenarios**:

1. **Given** a user has granted points, **When** they view the dashboard, **Then** they see a table with columns: To, When, Points, Message
2. **Given** a user has not granted any points, **When** they view the dashboard, **Then** they see "No points granted yet" message
3. **Given** multiple point grants, **When** viewing the table, **Then** they are sorted by date (most recent first)
4. **Given** a points grant, **When** viewing the recipient, **Then** it displays the recipient's username if available, otherwise email, otherwise 'Unknown'

---

### User Story 4 - Logout (Priority: P3)

An authenticated user should be able to logout and return to the login screen.

**Why this priority**: Important for security but not required for MVP viewing functionality.

**Independent Test**: Can be fully tested by clicking the logout button and verifying the user is signed out and redirected to the login form.

**Acceptance Scenarios**:

1. **Given** a user is logged in, **When** they click the logout button, **Then** their session is terminated and they see the login form

---

### Edge Cases

- What happens when a message in the database has a null `points` value? (System filters these out)
- What happens when a user has never sent or received points? (Shows empty state message)
- What happens when the Supabase session expires? (User is redirected to login form)
- What happens when database queries fail? (Returns empty arrays, gracefully handles errors)

## Requirements

### Functional Requirements

- **FR-001**: System MUST authenticate users via Supabase email/password authentication
- **FR-002**: System MUST display a login form to unauthenticated users
- **FR-003**: System MUST protect the dashboard page, requiring valid authentication
- **FR-004**: System MUST fetch points awarded from the `messages` table where `user_id` matches the authenticated user and `points` is not null, including sender information
- **FR-005**: System MUST fetch points granted from the `messages` table where `from_id` matches the authenticated user and `points` is not null, including recipient information
- **FR-006**: System MUST display points awarded in a table with columns: From (sender), When (date), Points (amount), Message (message_text)
- **FR-007**: System MUST display points granted in a table with columns: To (recipient), When (date), Points (amount), Message (message_text)
- **FR-008**: System MUST sort transactions by date in descending order (newest first)
- **FR-009**: System MUST provide a logout mechanism that terminates the user session
- **FR-010**: System MUST display user email in the dashboard header
- **FR-011**: System MUST show empty state messages when no transactions exist
- **FR-012**: System MUST display username if available, otherwise email, otherwise 'Unknown' for sender/recipient identification

### Key Entities

- **messages**: Represents point transactions and messages between users
  - `id`: Primary key (serial)
  - `user_id`: Recipient of the points (references users table)
  - `from_id`: Sender of the points (references users table)
  - `points`: Numeric value representing points exchanged (nullable)
  - `message_text`: The reason or message accompanying the points
  - `sent_at`: Timestamp when the message/points were sent
  - `is_read`: Boolean indicating if message has been read
  - `site_id`: Reference to sites table
  - `category_id`: Reference to message_categories table

- **User Session**: Represents authenticated user state
  - Managed by Supabase Auth
  - Includes user ID and email
  - Persisted via cookies

## Implementation Details

### Technology Stack

- **Framework**: SvelteKit 2.x with Svelte 5
- **Authentication**: Supabase Auth with SSR (@supabase/ssr)
- **Database**: Supabase PostgreSQL
- **Styling**: Component-scoped CSS

### File Structure

```
src/
├── hooks.server.js              # Server-side session management
├── lib/
│   ├── supabaseClient.js        # Client-side Supabase initialization
│   ├── supabaseServer.js        # Server-side Supabase client factory
│   └── components/
│       └── LoginForm.svelte     # Reusable login form component
└── routes/
    ├── +page.svelte             # Dashboard UI
    └── +page.server.js          # Server load function and form actions
```

### Authentication Flow

1. **Server Hook** (`hooks.server.js`): Creates Supabase client for each request, manages cookies
2. **Page Load** (`+page.server.js`): Checks session via `locals.safeGetSession()`
3. **Conditional Rendering** (`+page.svelte`): Shows login form if no session, dashboard if authenticated
4. **Form Actions**: Handles login and logout via SvelteKit form actions

### Database Queries

**Points Awarded**:
```javascript
await locals.supabase
  .from('messages')
  .select(`
    *,
    sender:from_id (
      id,
      email,
      username
    )
  `)
  .eq('user_id', user.id)
  .not('points', 'is', null)
  .order('sent_at', { ascending: false });
```

**Points Granted**:
```javascript
await locals.supabase
  .from('messages')
  .select(`
    *,
    recipient:user_id (
      id,
      email,
      username
    )
  `)
  .eq('from_id', user.id)
  .not('points', 'is', null)
  .order('sent_at', { ascending: false });
```

### Environment Configuration

Required environment variables in `.env.local`:
- `PUBLIC_SUPABASE_URL`: Supabase project URL
- `PUBLIC_SUPABASE_ANON_KEY`: Supabase anonymous key

## Success Criteria

### Measurable Outcomes

- **SC-001**: Users can successfully log in with valid credentials and see their dashboard
- **SC-002**: Dashboard correctly displays all point transactions from the messages table with sender/recipient information
- **SC-003**: Points awarded and points granted are accurately separated and displayed in their respective table sections
- **SC-004**: Empty states are shown when users have no transactions
- **SC-005**: Transactions are sorted chronologically (newest first)
- **SC-006**: Users can successfully log out and return to the login screen
- **SC-007**: Unauthenticated users are prevented from accessing dashboard data
- **SC-008**: Dashboard is responsive and usable on mobile and desktop screens
- **SC-009**: Tables display proper columns: "Points Awarded" shows From/When/Points/Message, "Points Granted" shows To/When/Points/Message
- **SC-010**: Sender/recipient names display username preferentially, falling back to email or 'Unknown'
