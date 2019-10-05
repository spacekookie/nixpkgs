{ ... }: {
  services.redshift = {
    enable = true;
    temperatre.night = 3500;
    provider = "geoclue2";
  };
}
