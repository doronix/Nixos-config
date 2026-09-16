{...}: {
  sops = {
    defaultSopsFile = ../secrets/r9000p.yaml;

    age = {
      keyFile = "/home/charles/.config/sops/age/keys.txt";
      generateKey = false;
    };

    secrets."restic-local-password" = {
      owner = "charles";
      mode = "0400";
    };
  };
}
