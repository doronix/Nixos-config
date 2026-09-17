{ pkgs, ... }:

{
  # notify-send
  home.packages = [
    pkgs.libnotify
  ];

  # ============================================================
  # 久坐提醒：登录 50 分钟后第一次提醒，此后每 50 分钟提醒一次
  # ============================================================
  systemd.user.services.stand-up-reminder = {
    Unit = {
      Description = "Stand up and take a break";
    };

    Service = {
      Type = "oneshot";

      ExecStart = ''
        ${pkgs.libnotify}/bin/notify-send \
          --urgency=critical \
          --expire-time=15000 \
          "🧍 该站起来了" \
          "已经坐了约 50 分钟。离开椅子 5–10 分钟：喝水、走动、看看远处。"
      '';
    };
  };

  systemd.user.timers.stand-up-reminder = {
    Unit = {
      Description = "Remind Charles to stand up every 50 minutes";
    };

    Timer = {
      OnStartupSec = "50min";
      OnUnitActiveSec = "50min";
      Unit = "stand-up-reminder.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  # ============================================================
  # 每晚生活记录提醒
  # ============================================================
  systemd.user.services.life-journal-reminder = {
    Unit = {
      Description = "Daily life journal reminder";
    };

    Service = {
      Type = "oneshot";

      ExecStart = ''
        ${pkgs.libnotify}/bin/notify-send \
          --urgency=normal \
          --expire-time=20000 \
          "📖 今天留下一句话吧" \
          "发生了什么？现在是什么情绪？今天有什么值得记住？一句话也算完成。"
      '';
    };
  };

  systemd.user.timers.life-journal-reminder = {
    Unit = {
      Description = "Daily life journal reminder";
    };

    Timer = {
      OnCalendar = "*-*-* 21:30:00";
      Unit = "life-journal-reminder.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
