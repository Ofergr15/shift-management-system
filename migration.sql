-- מיגרציה לבסיס נתונים קיים.
-- להריץ פעם אחת ב-Supabase SQL Editor לפני/אחרי הדיפלוי.
-- (idempotent — בטוח להריץ שוב)

-- 1) settings: כמות אנשים נדרשת לכל תפקיד (חול/סופ״ש)
CREATE TABLE IF NOT EXISTS settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow all" ON settings;
CREATE POLICY "Allow all" ON settings FOR ALL USING (true) WITH CHECK (true);

INSERT INTO settings (key, value) VALUES
  ('weekday_armory', '3'),
  ('weekday_support', '1'),
  ('weekend_armory', '2'),
  ('weekend_support', '1')
ON CONFLICT (key) DO NOTHING;

-- 2) shifts.support: המרה מטקסט בודד למערך טקסט (כדי לתמוך בכמה אנשי נשקייה)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'shifts' AND column_name = 'support' AND data_type <> 'ARRAY'
  ) THEN
    ALTER TABLE shifts
      ALTER COLUMN support TYPE TEXT[]
      USING (CASE WHEN support IS NULL OR support = '' THEN '{}'::TEXT[] ELSE ARRAY[support] END);
    ALTER TABLE shifts ALTER COLUMN support SET DEFAULT '{}';
  END IF;
END $$;
