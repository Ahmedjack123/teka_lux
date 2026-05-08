-- Teka Luxe users table.
-- This schema matches the Flutter client-side upsert payload:
-- id, email, full_name, phone_number, role, created_at, updated_at.

begin;

do $$
begin
  if not exists (
    select 1
    from pg_type
    where typnamespace = 'public'::regnamespace
      and typname = 'user_role'
  ) then
    create type public.user_role as enum ('customer', 'user', 'admin');
  end if;
end
$$;

alter type public.user_role add value if not exists 'customer';
alter type public.user_role add value if not exists 'user';
alter type public.user_role add value if not exists 'admin';

create table if not exists public.users (
  id text primary key,
  email varchar not null,
  full_name varchar,
  phone_number varchar,
  role public.user_role not null default 'customer',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

alter table public.users
  alter column id type text using id::text,
  alter column email set not null,
  alter column role set default 'customer',
  alter column role set not null,
  alter column created_at set default timezone('utc', now()),
  alter column created_at set not null,
  alter column updated_at set default timezone('utc', now()),
  alter column updated_at set not null;

alter table public.users
  add column if not exists full_name varchar,
  add column if not exists phone_number varchar;

create unique index if not exists users_email_unique_idx
  on public.users (email);

create or replace function public.update_updated_at_column()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

drop trigger if exists set_users_updated_at on public.users;

create trigger set_users_updated_at
before update on public.users
for each row
execute function public.update_updated_at_column();

alter table public.users enable row level security;

-- Safe policies for Supabase Auth or custom JWT integrations where auth.uid()
-- resolves to the Firebase UID stored in users.id.
drop policy if exists "Users can read own profile" on public.users;
create policy "Users can read own profile"
on public.users
for select
to authenticated
using (auth.uid()::text = id);

drop policy if exists "Users can insert own profile" on public.users;
create policy "Users can insert own profile"
on public.users
for insert
to authenticated
with check (auth.uid()::text = id);

drop policy if exists "Users can update own profile" on public.users;
create policy "Users can update own profile"
on public.users
for update
to authenticated
using (auth.uid()::text = id)
with check (auth.uid()::text = id);

-- Current Flutter uses Firebase Auth and the Supabase anon key directly.
-- Supabase cannot verify a Firebase UID from an anon request, so this scoped
-- policy allows the client-side signup upsert to work. Replace it with the
-- authenticated policies above once Firebase ID tokens are integrated with
-- Supabase Auth/custom JWT.
drop policy if exists "Anon can create user profile during signup" on public.users;
create policy "Anon can create user profile during signup"
on public.users
for insert
to anon
with check (
  id is not null
  and length(id) >= 8
  and email is not null
  and position('@' in email) > 1
);

drop policy if exists "Anon can update user profile during signup" on public.users;
create policy "Anon can update user profile during signup"
on public.users
for update
to anon
using (
  id is not null
  and email is not null
)
with check (
  id is not null
  and length(id) >= 8
  and email is not null
  and position('@' in email) > 1
);

commit;
