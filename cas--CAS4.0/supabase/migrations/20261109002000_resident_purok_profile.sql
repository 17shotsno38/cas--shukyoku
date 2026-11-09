alter table public.profiles
  add column if not exists purok text;

alter table public.profiles
  drop constraint if exists profiles_purok_check;

alter table public.profiles
  add constraint profiles_purok_check
  check (purok is null or purok in ('1', '2', '3', '4', '5', '6', '7', '8', '9', '10'));
