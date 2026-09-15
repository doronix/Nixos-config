{pkgs, ...}: {
  home.packages = with pkgs; [
    # Backup / remote storage
    restic
    rclone

    # Secrets / encryption
    age
    sops
  ];
}
