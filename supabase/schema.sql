-- Prosfora.cy optional Supabase schema (NO OpenAI required)
create extension if not exists pgcrypto;
create table if not exists public.retailers(id uuid primary key default gen_random_uuid(),slug text unique not null,name text not null,website text not null,created_at timestamptz not null default now());
create table if not exists public.branches(id uuid primary key default gen_random_uuid(),retailer_id uuid not null references public.retailers(id) on delete cascade,name text not null,city text not null,address text not null,map_query text not null,created_at timestamptz not null default now());
create table if not exists public.offers(id text primary key,retailer_id uuid not null references public.retailers(id) on delete cascade,product text not null,category text not null,size text,new_price numeric(10,2) not null check(new_price>=0),old_price numeric(10,2) not null check(old_price>new_price),valid_from date,valid_until date not null,source_url text not null,image_url text,note text,updated_at timestamptz not null default now());
create table if not exists public.source_runs(id bigint generated always as identity primary key,retailer_id uuid references public.retailers(id) on delete cascade,checked_at timestamptz not null default now(),status text not null check(status in('ok','stale','error','directory')),message text);
alter table public.retailers enable row level security;alter table public.branches enable row level security;alter table public.offers enable row level security;alter table public.source_runs enable row level security;
create policy "public read retailers" on public.retailers for select using(true);
create policy "public read branches" on public.branches for select using(true);
create policy "public read active offers" on public.offers for select using(valid_until>=current_date);
create policy "public read source status" on public.source_runs for select using(true);
-- Intentionally NO public INSERT/UPDATE/DELETE policies. Server-side service role only.
create index if not exists offers_valid_until_idx on public.offers(valid_until);
create index if not exists offers_category_idx on public.offers(category);
create index if not exists branches_city_idx on public.branches(city);