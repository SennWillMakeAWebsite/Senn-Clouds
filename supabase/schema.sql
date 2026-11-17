-- Run this complete script in Supabase SQL Editor.
create extension if not exists pgcrypto;
create table if not exists public.files(
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 name text not null,
 storage_path text not null unique,
 mime_type text not null default 'application/octet-stream',
 size bigint not null default 0 check(size>=0),
 created_at timestamptz not null default now(),
 deleted_at timestamptz
);
alter table public.files enable row level security;
drop policy if exists "own files select" on public.files;
create policy "own files select" on public.files for select using(auth.uid()=user_id);
drop policy if exists "own files insert" on public.files;
create policy "own files insert" on public.files for insert with check(auth.uid()=user_id and storage_path like auth.uid()::text||'/%');
drop policy if exists "own files update" on public.files;
create policy "own files update" on public.files for update using(auth.uid()=user_id) with check(auth.uid()=user_id);
drop policy if exists "own files delete" on public.files;
create policy "own files delete" on public.files for delete using(auth.uid()=user_id);
insert into storage.buckets(id,name,public,file_size_limit) values('senn-files','senn-files',false,52428800) on conflict(id) do update set public=false,file_size_limit=52428800;
drop policy if exists "own storage upload" on storage.objects;
create policy "own storage upload" on storage.objects for insert to authenticated with check(bucket_id='senn-files' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists "own storage read" on storage.objects;
create policy "own storage read" on storage.objects for select to authenticated using(bucket_id='senn-files' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists "own storage update" on storage.objects;
create policy "own storage update" on storage.objects for update to authenticated using(bucket_id='senn-files' and (storage.foldername(name))[1]=auth.uid()::text) with check(bucket_id='senn-files' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists "own storage delete" on storage.objects;
create policy "own storage delete" on storage.objects for delete to authenticated using(bucket_id='senn-files' and (storage.foldername(name))[1]=auth.uid()::text);
