{config, pkgs, ...}: {
  # Backup disk is LUKS encrypted.
  # We unlock it manually after boot instead of storing the LUKS key
  # on the unencrypted system disk.
  environment.systemPackages = [
    pkgs.cryptsetup

    (pkgs.writeShellScriptBin "backup-unlock" ''
      set -euo pipefail

      mapper="/dev/mapper/nvme0-backup"
      mountpoint="/mnt/restic-local"

      if [[ ! -e "$mapper" ]]; then
        echo "Unlocking backup SSD..."
        ${pkgs.cryptsetup}/bin/cryptsetup open           /dev/nvme0n1p2           nvme0-backup
      else
        echo "Backup SSD already unlocked."
      fi

      if ! ${pkgs.util-linux}/bin/mountpoint -q "$mountpoint"; then
        echo "Mounting backup filesystem..."
        ${pkgs.util-linux}/bin/mount "$mountpoint"
      else
        echo "Backup filesystem already mounted."
      fi

      echo "Starting Restic backup..."
      ${pkgs.systemd}/bin/systemctl start         restic-backups-local-home.service

      echo
      echo "Backup completed."
      ${pkgs.systemd}/bin/systemctl status         restic-backups-local-home.service         --no-pager -l || true
    '')
  ];

  # Btrfs backup subvolume on the secondary Micron SSD.
  fileSystems."/mnt/restic-local" = {
    device = "/dev/mapper/nvme0-backup";
    fsType = "btrfs";
    options = [
      "subvol=@backup"
      "noauto"
      "nofail"
    ];
  };

  services.restic.backups.local-home = {
    user = "charles";

    repository = "/mnt/restic-local/r9000p";
    passwordFile = config.sops.secrets."restic-local-password".path;

    paths = [
      "/home/charles"
    ];

    exclude = [
      # Local Btrfs snapshots are not part of the off-disk backup.
      "/home/.snapshots"

      # Restic password itself must not enter the repository.
      "/home/charles/.config/restic/local.pass"
      "/home/charles/.config/sops/age"

      # Rebuildable caches.
      "/home/charles/.cache"
      "/home/charles/.npm"
      "/home/charles/.bun"

      # Large rebuildable application data.
      "/home/charles/.local/share/Steam"

      # Project environments / build artifacts.
      "**/.venv"
      "**/node_modules"
      "**/target"
      "**/__pycache__"
      "**/.pytest_cache"
      "**/.ruff_cache"
    ];

    extraBackupArgs = [
      "--one-file-system"
    ];

    # Retention policy.
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];

    # Do not allow the laptop to sleep halfway through a backup.
    inhibitsSleep = false;

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };
  };

  # If the encrypted backup disk is not mounted, skip safely.
  #
  # This prevents Restic from accidentally writing its repository into
  # the empty /mnt/restic-local directory on the main SSD.
  systemd.services.restic-backups-local-home.unitConfig = {
    ConditionPathIsMountPoint = "/mnt/restic-local";
  };
}
