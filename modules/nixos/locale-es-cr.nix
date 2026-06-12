{
  den,
  ...
}:
{
  den.aspects.locale-es-cr.nixos = {
    time.timeZone = "America/Costa_Rica";
    i18n = {
      defaultLocale = "es_MX.UTF-8";
      extraLocaleSettings = {
	LC_ADDRESS = "es_CR.UTF-8";
	LC_IDENTIFICATION = "es_CR.UTF-8";
	LC_MEASUREMENT = "es_CR.UTF-8";
	LC_MONETARY = "es_CR.UTF-8";
	LC_NAME = "es_CR.UTF-8";
	LC_NUMERIC = "es_CR.UTF-8";
	LC_PAPER = "es_CR.UTF-8";
	LC_TELEPHONE = "es_CR.UTF-8";
	LC_TIME = "es_CR.UTF-8";
      };
    };

    console = {
      #font = "JetBrainsMono";
      keyMap = "la-latin1";
    };
  };
}
