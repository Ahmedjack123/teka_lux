-- Allow the current Firebase Auth + Supabase anon-key client-side signup flow
-- to upsert user profiles through PostgREST.

begin;

grant usage on schema public to anon, authenticated;
grant select, insert, update on table public.users to anon, authenticated;

drop policy if exists "Anon can read profile for upsert" on public.users;
create policy "Anon can read profile for upsert"
on public.users
for select
to anon
using (
  id is not null
  and email is not null
);

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
  and coalesce(role, 'customer'::public.user_role) in (
    'customer'::public.user_role,
    'user'::public.user_role
  )
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
  and coalesce(role, 'customer'::public.user_role) in (
    'customer'::public.user_role,
    'user'::public.user_role
  )
);

commit;
