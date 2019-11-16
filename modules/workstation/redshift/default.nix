{ ... }: {
  services.redshift = {
    enable = true;
    temperature.night = 3500;
  };

  location.provider = "geoclue2";
}
