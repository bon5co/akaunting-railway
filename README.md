# akaunting-railway

Railway wrapper images for [Akaunting](https://github.com/akaunting/akaunting) 3.1.21.

* `ghcr.io/bon5co/akaunting-railway:3.1.21` — the official `-v` image plus a Railway entrypoint:
  populates a volume-mounted `/var/www/html`, makes Apache listen on Railway's injected `$PORT`,
  runs `php artisan install` exactly once behind a marker on the volume, and runs
  `php artisan schedule:run` **in the same container** so it reads the installed `.env`.
* `ghcr.io/bon5co/akaunting-railway-mariadb:11.8.2` — MariaDB with the database name and user baked
  in, so the Railway deploy form asks for neither.

Why the scheduler must share the container: `Console\Kernel::schedule()` returns early unless
`config('app.installed')` is true, and `APP_INSTALLED=true` is written by the installer into
`/var/www/html/.env` on the volume. A separate scheduler service that cannot see that file
registers zero Akaunting jobs — no recurring invoices, no due-date reminders — and still exits 0.
