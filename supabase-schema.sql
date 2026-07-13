create extension if not exists pgcrypto;

create table if not exists public.routines (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid(),
  slug text not null unique,
  title text not null,
  client_name text,
  data jsonb not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.routines enable row level security;

drop policy if exists "routine owners can read" on public.routines;
drop policy if exists "routine owners can insert" on public.routines;
drop policy if exists "routine owners can update" on public.routines;
drop policy if exists "routine owners can delete" on public.routines;

create policy "routine owners can read"
on public.routines
for select
to authenticated
using (owner_id = auth.uid());

create policy "routine owners can insert"
on public.routines
for insert
to authenticated
with check (owner_id = auth.uid());

create policy "routine owners can update"
on public.routines
for update
to authenticated
using (owner_id = auth.uid())
with check (owner_id = auth.uid());

create policy "routine owners can delete"
on public.routines
for delete
to authenticated
using (owner_id = auth.uid());

create or replace function public.touch_routine_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists routines_touch_updated_at on public.routines;

create trigger routines_touch_updated_at
before update on public.routines
for each row
execute function public.touch_routine_updated_at();

create or replace function public.get_routine_by_slug(p_slug text)
returns table (
  id uuid,
  slug text,
  title text,
  client_name text,
  data jsonb,
  is_active boolean,
  updated_at timestamptz
)
language sql
security definer
set search_path = public
as $$
  select
    routines.id,
    routines.slug,
    routines.title,
    routines.client_name,
    routines.data,
    routines.is_active,
    routines.updated_at
  from public.routines
  where routines.slug = p_slug
    and routines.is_active = true
  limit 1;
$$;

grant execute on function public.get_routine_by_slug(text) to anon, authenticated;
