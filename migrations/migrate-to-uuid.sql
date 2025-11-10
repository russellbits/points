-- Migration: Convert users and messages tables to use UUID for user identification
-- This aligns with Supabase Auth's UUID-based user system

-- Step 1: Add new UUID columns to users table
ALTER TABLE public.users 
ADD COLUMN IF NOT EXISTS auth_id UUID;

-- Step 2: Create a unique index on auth_id for performance
CREATE UNIQUE INDEX IF NOT EXISTS users_auth_id_idx ON public.users(auth_id);

-- Step 3: Add new UUID columns to messages table for foreign keys
ALTER TABLE public.messages 
ADD COLUMN IF NOT EXISTS user_auth_id UUID,
ADD COLUMN IF NOT EXISTS from_auth_id UUID;

-- Step 4: Populate auth_id in users table from auth.users if you have existing mappings
-- NOTE: You'll need to manually populate this based on your data
-- Example if you have email matches:
-- UPDATE public.users u
-- SET auth_id = au.id
-- FROM auth.users au
-- WHERE u.email = au.email;

-- Step 5: Migrate existing messages to use the new UUID columns
-- This assumes you've populated auth_id in the users table first
-- Note: user_id and from_id in messages are integers, id in users is integer
UPDATE public.messages m
SET user_auth_id = u.auth_id
FROM public.users u
WHERE m.user_id::INTEGER = u.id::INTEGER AND u.auth_id IS NOT NULL;

UPDATE public.messages m
SET from_auth_id = u.auth_id
FROM public.users u
WHERE m.from_id::INTEGER = u.id::INTEGER AND u.auth_id IS NOT NULL;

-- Step 6: Add foreign key constraints to the new UUID columns
ALTER TABLE public.messages
ADD CONSTRAINT messages_user_auth_id_fkey 
FOREIGN KEY (user_auth_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public.messages
ADD CONSTRAINT messages_from_auth_id_fkey 
FOREIGN KEY (from_auth_id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- Step 7: (Optional) Drop old integer-based foreign keys if you're fully migrating
-- IMPORTANT: Only run these after verifying the migration worked!
-- ALTER TABLE public.messages DROP CONSTRAINT IF EXISTS messages_user_id_fkey;
-- ALTER TABLE public.messages DROP CONSTRAINT IF EXISTS messages_from_id_fkey;

-- Step 8: (Optional) Drop old integer columns after migration is verified
-- IMPORTANT: Only run these after verifying the migration worked!
-- ALTER TABLE public.messages DROP COLUMN IF EXISTS user_id;
-- ALTER TABLE public.messages DROP COLUMN IF EXISTS from_id;
-- ALTER TABLE public.users DROP CONSTRAINT IF EXISTS users_pkey;
-- ALTER TABLE public.users DROP COLUMN IF EXISTS id;
-- ALTER TABLE public.users ADD PRIMARY KEY (auth_id);


-- ============================================================================
-- ALTERNATIVE SIMPLER APPROACH: Create new tables with UUID from scratch
-- ============================================================================
-- If you prefer to start fresh, here's a cleaner approach:

/*
-- Drop existing constraints and table (CAREFUL - this deletes data!)
DROP TABLE IF EXISTS public.messages CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;

-- Create users table with UUID as primary key
CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  username TEXT,
  created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

-- Enable RLS on users
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Create policy for users to read their own data
CREATE POLICY "Users can view their own profile"
  ON public.users FOR SELECT
  USING (auth.uid() = id);

-- Create messages table with UUID foreign keys
CREATE TABLE public.messages (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  site_id INTEGER REFERENCES public.sites(id) ON DELETE CASCADE,
  category_id INTEGER REFERENCES public.message_categories(id) ON DELETE SET NULL,
  message_text TEXT NOT NULL,
  sent_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
  from_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  is_read BOOLEAN DEFAULT FALSE,
  points NUMERIC
);

-- Enable RLS on messages
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- Create policies for messages
CREATE POLICY "Users can view messages sent to them"
  ON public.messages FOR SELECT
  USING (auth.uid() = user_id OR auth.uid() = from_id);

CREATE POLICY "Users can insert messages they send"
  ON public.messages FOR INSERT
  WITH CHECK (auth.uid() = from_id);

-- Recreate the trigger
CREATE OR REPLACE FUNCTION notify_on_message_insert()
RETURNS TRIGGER AS $$
BEGIN
  -- Your trigger logic here
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_message_insert
  AFTER INSERT ON public.messages
  FOR EACH ROW
  EXECUTE FUNCTION notify_on_message_insert();

-- Create indexes for performance
CREATE INDEX messages_user_id_idx ON public.messages(user_id);
CREATE INDEX messages_from_id_idx ON public.messages(from_id);
CREATE INDEX messages_sent_at_idx ON public.messages(sent_at DESC);
CREATE INDEX messages_points_idx ON public.messages(points) WHERE points IS NOT NULL;
*/
