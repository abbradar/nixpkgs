# Matomo {#module-services-matomo}

Matomo is a real-time web analytics application. This module configures
php-fpm as backend for Matomo, optionally configuring MariaDB database and an
nginx vhost as well.

An automatic setup is not supported by Matomo, so you need to configure Matomo
itself in the browser-based Matomo setup.

## Archive Processing {#module-services-matomo-archive-processing}

This module comes with the systemd service
`matomo-archive-processing.service` and a timer that
automatically triggers archive processing every hour. This means that you
can safely
[disable browser triggers for Matomo archiving](
https://matomo.org/docs/setup-auto-archiving/#disable-browser-triggers-for-matomo-archiving-and-limit-matomo-reports-to-updating-every-hour
) at
`Administration > System > General Settings`.

With automatic archive processing, you can now also enable to
[delete old visitor logs](https://matomo.org/docs/privacy/#step-2-delete-old-visitors-logs)
at `Administration > System > Privacy`, but make sure that you run `systemctl start
matomo-archive-processing.service` at least once without errors if
you have already collected data before, so that the reports get archived
before the source data gets deleted.

## Backup {#module-services-matomo-backups}

You only need to take backups of your MySQL database and the
{file}`/var/lib/matomo/config/config.ini.php` file. Use a user
in the `matomo` group or root to access the file. For more
information, see
<https://matomo.org/faq/how-to-install/faq_138/>.

## Issues {#module-services-matomo-issues}

  - Matomo will warn you that the JavaScript tracker is not writable. This is
    because it's located in the read-only nix store. You can safely ignore
    this, unless you need a plugin that needs JavaScript tracker access.

## Using other Web Servers than nginx {#module-services-matomo-other-web-servers}

You can use other web servers by forwarding calls for
{file}`index.php` and {file}`piwik.php` to the
[`services.phpfpm.pools.<name>.socket`](#opt-services.phpfpm.pools._name_.socket)
fastcgi unix socket. You can use
the nginx configuration in the module code as a reference to what else
should be configured.
