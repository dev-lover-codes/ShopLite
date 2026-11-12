-- Migration: create the favourites table with Row Level Security.
-- Running this twice will fail on the CREATE TABLE statement because the
-- table already exists. See README for how to avoid applying it twice.

create table public.favourites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  product_id integer not null,
  created_at timestamptz not null default now(),
  unique (user_id, product_id)
);

alter table public.favourites enable row level security;

create policy "Users read own favourites" on public.favourites
  for select using (auth.uid() = user_id);
create policy "Users add own favourites" on public.favourites
  for insert with check (auth.uid() = user_id);
create policy "Users delete own favourites" on public.favourites
  for delete using (auth.uid() = user_id);
