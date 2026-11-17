# SENN CLOUD v1.0

Responsive personal cloud storage built with Vite, JavaScript and Supabase.

## Supabase setup
1. Create a Supabase project.
2. Run all SQL in `supabase/schema.sql` using Supabase SQL Editor.
3. Copy Project URL and publishable key (or legacy anon key) from Project Settings > API.
4. Set `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` as environment variables in StackBlitz, or create `.env` locally using `.env.example`.
5. Never use a service_role/secret key in frontend code.
6. Configure Authentication URL settings with local and deployed URLs. Confirm signup email if confirmation is enabled.

## Run
`npm install` then `npm run dev`.

## GitHub Pages
The included GitHub Actions workflow builds and deploys on pushes to `main`. In repository Settings > Pages select **GitHub Actions**. Add repository Actions variables `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`. `vite.config.js` assumes repository name `Senn-Cloud`; adjust `base` if renamed.

## File safety
Files upload to a private Supabase Storage bucket first, then metadata is inserted. If metadata insertion fails, the uploaded object is removed. Wait for the success toast before deleting the original from the phone gallery. The browser app never deletes local gallery files. Trash is a soft-delete in metadata; permanent deletion removes the cloud object and metadata.

## Included in this starter
Email/password auth, multi-file upload, private storage, image/video/audio preview, download, search, recent/media views, trash/restore/permanent delete, per-user RLS and responsive UI. Folder management, sharing links and actual quota enforcement are not implemented yet. Bucket limit defaults to 50 MiB per file; adjust to your plan.
