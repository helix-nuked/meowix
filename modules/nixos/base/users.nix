{pkgs, ...}: {
  users = {
    mutableUsers = false;
    users = {
      "root" = {
        isSystemUser = true;
        hashedPassword = "$6$rx4JIYoJUSzq3v0l$8cevGhPZrNTw0ou/XjmVcki/sfD5.2J9Wub8H2Pt65IjC3xEwdNw5Lfo41bsx3AiMCQbYAeJ0IgKKAGZjtByL1";
      };
      # Define a user account.
      "monyx" = {
        hashedPassword = "$6$oIE5OhKIdKQ8Iazs$qgd2Tfc5wwmsutOeRFXpb/yzwChYR/EEHtLhKViTQbz.cxAINqdYIq6sFRVot1nfYU2mGlgI4yidyCl9C39cD1";
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager" "video" "audio" "input"]; # Enable ‘sudo’ for the user.
        packages = with pkgs; [
          tree
        ];
      };
    };
  };
}
