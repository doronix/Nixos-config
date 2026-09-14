_: {
#------------- 录制辨识 ------------#
  home.file.".config/waybar/scripts/wf-recorder-status.sh" = {
    source = ./wf-recorder-status.sh;
    executable = true; # ✅ 正确设置可执行权限
  };

  #---------壁纸切换脚本--------#
  home.file.".config/wallpaper/script/awww-rofi.sh" = {
    source = ./awww-rofi.sh;
    executable = true;
  };
}
