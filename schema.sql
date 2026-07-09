-- טבלת עובדים
CREATE TABLE employees (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  short_name TEXT NOT NULL,
  tasks TEXT[] DEFAULT '{}',
  manager BOOLEAN DEFAULT false,
  location TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- טבלת אי-זמינות
CREATE TABLE unavailability (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  employee_name TEXT NOT NULL REFERENCES employees(name) ON DELETE CASCADE,
  type TEXT NOT NULL,
  label TEXT NOT NULL,
  from_date DATE,
  to_date DATE
);

-- טבלת משמרות (שורה ליום) — support הוא מערך כדי לתמוך בכמה אנשי נשקייה
CREATE TABLE shifts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  date DATE NOT NULL UNIQUE,
  armory TEXT[] DEFAULT '{}',
  support TEXT[] DEFAULT '{}'
);

-- טבלת ימי חופש
CREATE TABLE day_offs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  date DATE NOT NULL,
  employee_name TEXT NOT NULL,
  UNIQUE(date, employee_name)
);

-- טבלת הגדרות (כמות אנשים נדרשת לכל תפקיד, חול/סופ״ש)
CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

-- הפעלת RLS
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE unavailability ENABLE ROW LEVEL SECURITY;
ALTER TABLE shifts ENABLE ROW LEVEL SECURITY;
ALTER TABLE day_offs ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

-- גישה ציבורית (כלי פנימי)
CREATE POLICY "Allow all" ON employees FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON unavailability FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON shifts FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON day_offs FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON settings FOR ALL USING (true) WITH CHECK (true);

-- ערכי ברירת מחדל לכמות אנשים
INSERT INTO settings (key, value) VALUES
  ('weekday_armory', '3'),
  ('weekday_support', '1'),
  ('weekend_armory', '2'),
  ('weekend_support', '1');

-- הכנסת עובדים
INSERT INTO employees (name, short_name, tasks, manager, location) VALUES
  ('אביחי כהן צמח', 'אביחי', ARRAY['armory','support'], true, ''),
  ('טל עופר', 'טל', ARRAY['armory','support'], true, ''),
  ('בר מלול', 'בר', ARRAY['armory','support'], false, ''),
  ('אדם', 'אדם', ARRAY['armory','support'], false, ''),
  ('מלכה', 'מלכה', ARRAY['armory','support'], true, ''),
  ('אושרי', 'אושרי', ARRAY['armory','support'], false, ''),
  ('פרדו', 'פרדו', ARRAY['armory','support'], true, ''),
  ('שמעון זעפרני', 'שמעון', ARRAY['armory','support'], true, ''),
  ('שרוני', 'שרוני', ARRAY[]::TEXT[], false, ''),
  ('רמי', 'רמי', ARRAY[]::TEXT[], false, '');

-- הכנסת אי-זמינות
INSERT INTO unavailability (employee_name, type, label, from_date, to_date) VALUES
  ('אביחי כהן צמח', 'vacation', 'חופשה', '2026-07-30', '2026-07-31'),
  ('אביחי כהן צמח', 'vacation', 'חופשה', '2026-08-01', '2026-08-29'),
  ('טל עופר', 'vacation', 'חופשה', '2026-07-12', '2026-07-19'),
  ('טל עופר', 'vacation', 'חופשה', '2026-07-26', '2026-07-30'),
  ('טל עופר', 'vacation', 'חופשה', '2026-08-16', '2026-08-20'),
  ('טל עופר', 'vacation', 'חופשה', '2026-09-10', '2026-09-10'),
  ('בר מלול', 'vacation', 'חופשה', '2026-07-19', '2026-07-19'),
  ('בר מלול', 'vacation', 'חופשה', '2026-07-29', '2026-08-01'),
  ('בר מלול', 'vacation', 'חופשה', '2026-08-05', '2026-08-07'),
  ('בר מלול', 'vacation', 'חופשה', '2026-08-23', '2026-08-30'),
  ('אדם', 'vacation', 'חופשה', '2026-08-04', '2026-08-05'),
  ('מלכה', 'vacation', 'חופשה', '2026-08-05', '2026-08-05'),
  ('פרדו', 'vacation', 'חופשה', '2026-07-25', '2026-07-25'),
  ('פרדו', 'vacation', 'חופשה', '2026-08-12', '2026-08-21'),
  ('שמעון זעפרני', 'vacation', 'חופשה', '2026-07-13', '2026-07-14'),
  ('שמעון זעפרני', 'vacation', 'חופשה', '2026-07-26', '2026-07-30'),
  ('שמעון זעפרני', 'weekend', 'ללא סופ״ש', NULL, NULL),
  ('שרוני', 'bilu', 'בילו', NULL, NULL),
  ('רמי', 'bilu', 'בילו', NULL, NULL),
  ('רמי', 'reserve', 'מילואים', '2026-07-12', '2026-09-29');
