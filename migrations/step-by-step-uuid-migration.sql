-- STEP-BY-STEP Migration: Convert to UUID
-- Run each step separately and verify before proceeding

-- NOTE: Based on schema inspection, messages.user_id and messages.from_id 
-- are ALREADY UUID columns that reference auth.users.id directly.
-- This migration simply adds the new columns and copies the existing UUIDs.

-- ============================================================================
-- STEP 1: Add UUID columns to messages (if not already present)
-- ============================================================================
ALTER TABLE public.messages 
ADD COLUMN IF NOT EXISTS user_auth_id UUID,
ADD COLUMN IF NOT EXISTS from_auth_id UUID;

-- Add auth_id to users table for optional future use
ALTER TABLE public.users 
ADD COLUMN IF NOT EXISTS auth_id UUID;

CREATE UNIQUE INDEX IF NOT EXISTS users_auth_id_idx ON public.users(auth_id);

-- ============================================================================
-- STEP 2: Populate auth_id in users table (optional, for reference)
-- ============================================================================
-- This matches users by email to auth.users
UPDATE public.users u
SET auth_id = au.id
FROM auth.users au
WHERE u.email = au.email;

-- Verify the update worked:
-- SELECT id, email, auth_id FROM public.users;

-- ============================================================================
-- STEP 3: Copy existing UUID values to new columns
-- ============================================================================
-- Since messages.user_id and from_id are already UUIDs referencing auth.users,
-- we simply copy them to the new columns

-- Copy user_id (recipient UUID) to user_auth_id
UPDATE public.messages
SET user_auth_id = user_id
WHERE user_id IS NOT NULL;

-- Copy from_id (sender UUID) to from_auth_id
UPDATE public.messages
SET from_auth_id = from_id
WHERE from_id IS NOT NULL;

-- Verify the migration:
-- SELECT id, user_id, user_auth_id, from_id, from_auth_id, points 
-- FROM public.messages 
-- WHERE points IS NOT NULL;

-- ============================================================================
-- STEP 4: Add foreign key constraints
-- ============================================================================
ALTER TABLE public.messages
ADD CONSTRAINT messages_user_auth_id_fkey 
FOREIGN KEY (user_auth_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public.messages
ADD CONSTRAINT messages_from_auth_id_fkey 
FOREIGN KEY (from_auth_id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- ============================================================================
-- STEP 5: Update your application code to use user_auth_id and from_auth_id
-- Then test thoroughly before proceeding to step 6
-- ============================================================================

-- ============================================================================
-- STEP 6: (OPTIONAL) Clean up old columns after verifying everything works
-- ONLY RUN AFTER THOROUGH TESTING!
-- ============================================================================
/*
-- Drop old foreign key constraints
ALTER TABLE public.messages DROP CONSTRAINT IF EXISTS messages_user_id_fkey;
ALTER TABLE public.messages DROP CONSTRAINT IF EXISTS messages_from_id_fkey;

-- Rename new UUID columns to replace old ones
ALTER TABLE public.messages RENAME COLUMN user_auth_id TO user_id;
ALTER TABLE public.messages RENAME COLUMN from_auth_id TO from_id;

-- Drop old integer columns (they should be named differently now)
-- Only if you renamed the UUID columns above
-- ALTER TABLE public.messages DROP COLUMN IF EXISTS user_id_old;
-- ALTER TABLE public.messages DROP COLUMN IF EXISTS from_id_old;
*/
