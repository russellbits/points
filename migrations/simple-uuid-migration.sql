-- SIMPLE MIGRATION: Fresh start with UUID-based schema
-- Use this if you can recreate your tables without preserving existing data

-- 1. Drop existing tables (WARNING: This deletes all data!)
DROP TABLE IF EXISTS public.messages CASCADE;

-- 2. Create messages table with UUID foreign keys directly to auth.users
CREATE TABLE public.messages (
  id SERIAL PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  site_id INTEGER NULL,
  category_id INTEGER NULL,
  message_text TEXT NOT NULL,
  sent_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
  from_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  is_read BOOLEAN DEFAULT FALSE,
  points NUMERIC NULL
);

-- 3. Create indexes for performance
CREATE INDEX messages_user_id_idx ON public.messages(user_id);
CREATE INDEX messages_from_id_idx ON public.messages(from_id);
CREATE INDEX messages_sent_at_idx ON public.messages(sent_at DESC);
CREATE INDEX messages_points_idx ON public.messages(points) WHERE points IS NOT NULL;

-- 4. Enable Row Level Security
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- 5. Create RLS policies
CREATE POLICY "Users can view messages they received"
  ON public.messages FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can view messages they sent"
  ON public.messages FOR SELECT
  USING (auth.uid() = from_id);

CREATE POLICY "Users can insert messages they send"
  ON public.messages FOR INSERT
  WITH CHECK (auth.uid() = from_id);

-- 6. Recreate trigger function
CREATE OR REPLACE FUNCTION notify_on_message_insert()
RETURNS TRIGGER AS $$
BEGIN
  -- Add your notification logic here if needed
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 7. Create trigger
DROP TRIGGER IF EXISTS on_message_insert ON public.messages;
CREATE TRIGGER on_message_insert
  AFTER INSERT ON public.messages
  FOR EACH ROW
  EXECUTE FUNCTION notify_on_message_insert();

-- 8. Insert sample data for testing
-- Replace the UUIDs with actual auth.users IDs from your Supabase Auth
-- You can find your auth user ID by running: SELECT id, email FROM auth.users;

-- Example (replace UUIDs with real ones):
-- INSERT INTO public.messages (user_id, from_id, message_text, points)
-- VALUES (
--   'your-recipient-uuid-here',
--   'your-sender-uuid-here', 
--   'Great job on the project!',
--   12
-- );
