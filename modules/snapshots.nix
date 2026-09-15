{...}: {
  services.snapper = {
    # If a scheduled snapshot was missed while the laptop was off,
    # run it after the next boot.
    persistentTimer = true;

    snapshotInterval = "hourly";
    cleanupInterval = "1d";

    configs.home = {
      SUBVOLUME = "/home";
      FSTYPE = "btrfs";

      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;

      # Keep recent history useful without retaining large amounts
      # of browser / Steam / cache churn forever.
      TIMELINE_LIMIT_HOURLY = 6;
      TIMELINE_LIMIT_DAILY = 7;
      TIMELINE_LIMIT_WEEKLY = 4;
      TIMELINE_LIMIT_MONTHLY = 3;
      TIMELINE_LIMIT_QUARTERLY = 0;
      TIMELINE_LIMIT_YEARLY = 0;
    };
  };
}
