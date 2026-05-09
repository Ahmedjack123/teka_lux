-- Use Firebase Auth ID tokens for Supabase PostgREST access.
-- This removes the temporary anon write path and only allows an authenticated
-- Firebase user to read, insert, or update their own users row.

begin;

grant usage on schema public to authenticated;
grant select, insert, update on table public.users to authenticated;

revoke all on table public.users from anon;

create or replace function public.is_teka_luxe_auth_jwt()
returns boolean
language sql
stable
as $$
  select
    auth.jwt() ->> 'iss' = 'https://ciitrkesjdhwzzysmpjn.supabase.co/auth/v1'
    or (
      auth.jwt() ->> 'iss' = 'https://securetoken.google.com/teka-luxe'
      and auth.jwt() ->> 'aud' = 'teka-luxe'
    );
$$;

drop policy if exists "Anon can read profile for upsert" on public.users;
drop policy if exists "Anon can create user profile during signup" on public.users;
drop policy if exists "Anon can update user profile during signup" on public.users;
drop policy if exists "Restrict users access to Teka Luxe auth" on public.users;

create policy "Restrict users access to Teka Luxe auth"
on public.users
as restrictive
to authenticated
using ((select public.is_teka_luxe_auth_jwt()) is true)
with check ((select public.is_teka_luxe_auth_jwt()) is true);

drop policy if exists "Users can read own profile" on public.users;
create policy "Users can read own profile"
on public.users
for select
to authenticated
using ((auth.jwt() ->> 'sub') = id);

drop policy if exists "Users can insert own profile" on public.users;
create policy "Users can insert own profile"
on public.users
for insert
to authenticated
with check (
  (auth.jwt() ->> 'sub') = id
  and email is not null
  and position('@' in email) > 1
  and coalesce(role, 'customer'::public.user_role) in (
    'customer'::public.user_role,
    'user'::public.user_role
  )
);

drop policy if exists "Users can update own profile" on public.users;
create policy "Users can update own profile"
on public.users
for update
to authenticated
using ((auth.jwt() ->> 'sub') = id)
with check (
  (auth.jwt() ->> 'sub') = id
  and email is not null
  and position('@' in email) > 1
  and coalesce(role, 'customer'::public.user_role) in (
    'customer'::public.user_role,
    'user'::public.user_role
  )
);

commit;
