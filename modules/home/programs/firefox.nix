{ inputs, pkgs, ... }:

let
  firefox-addons =
    inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.rycee.firefox-addons;
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
      DisablePasswordManager = true;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableFormHistory = true;
      SearchBar = "unified";
      Homepage = {
        StartPage = "none";
        Locked = true;
      };
      NewTabPage = false;
      NoDefaultBookmarks = true;
      DisableFirstRunPage = true;
      OverrideFirstRunPage = "";
      DisableProfileImport = true;

      ExtensionSettings = {
        "*".installation_mode = "blocked";
        "uBlock0@raymondhill.net" = {
          default_area = "navbar";
          installation_mode = "force_installed";
        };
        "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
          # NoScript
          default_area = "navbar";
          installation_mode = "force_installed";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          # Bitwarden
          default_area = "navbar";
          installation_mode = "force_installed";
        };
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          # Vimium-FF (philc/vimium port, NUR pname "vimium")
          default_area = "navbar";
          installation_mode = "force_installed";
        };
        "{34daeb50-c2d2-4f14-886a-7160b24d66a4}" = {
          # YouTube Shorts Block
          default_area = "menupanel";
          installation_mode = "force_installed";
        };
        "zotero@chnm.gmu.edu" = {
          # Zotero Connector
          default_area = "menupanel";
          installation_mode = "force_installed";
        };
      };

      # toolbar order: back, forward, reload, [spacer], search bar, [spacer], downloads, NoScript, uBlock, Vimium-FF, Bitwarden, puzzle piece
      # hide everything else
      Preferences = {
        "browser.uiCustomization.state" = {
          Status = "locked";
          Value = ''
            {"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["_34daeb50-c2d2-4f14-886a-7160b24d66a4_-browser-action","zotero_chnm_gmu_edu-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","customizableui-special-spring1","urlbar-container","customizableui-special-spring2","downloads-button","_73a6fe31-595d-460b-a920-fcc0f8843232_-browser-action","ublock0_raymondhill_net-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["ublock0_raymondhill_net-browser-action","_73a6fe31-595d-460b-a920-fcc0f8843232_-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"],"dirtyAreaCache":["nav-bar"],"currentVersion":99,"newElementCount":0}
          '';
        };
      };
    };

    profiles.waynee95 = {
      id = 0;
      name = "waynee95";
      isDefault = true;

      extensions.packages = with firefox-addons; [
        bitwarden
        noscript
        ublock-origin
        vimium
        youtube-shorts-block
        zotero-connector
      ];

      settings = {
        # hide account button
        "identity.fxaccounts.toolbar.enabled" = false;
        # blank start page
        "browser.startup.page" = 0;

        # remove welcome splash screen on first startup
        "browser.aboutwelcome.enabled" = false;
        "startup.homepage_welcome_url" = "";
        "startup.homepage_welcome_url.additional" = "";
        "trailhead.firstrun.didSeeAboutWelcome" = true;

        # no bookmarks bar
        "browser.toolbars.bookmarks.visibility" = "never";

        # disable picture-in-picture toggle button on videos
        "media.videocontrols.picture-in-picture.video-toggling.enabled" = false;

        # disable translation popup
        "browser.translations.enable" = false;
        "browser.translations.automaticallyPopup" = false;

        # no search suggestions
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.quicksuggest.enabled" = false;
        "browser.urlbar.quicksuggest.sponsored" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;

        # clear history on shutdown
        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.clearOnShutdown.cache" = true;
        "privacy.clearOnShutdown.cookies" = true;
        "privacy.clearOnShutdown.formdata" = true;
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.offlineApps" = true;
        "privacy.clearOnShutdown.sessions" = true;

        # allow DRM conten
        "media.eme.enabled" = true;
        "media.eme.require-app-approval" = false;

        # no password saving or autofill
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "signon.formlessCapture.enabled" = false;
        "signon.management.page.breach-alerts.enabled" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.available" = false;
        "browser.formfill.enable" = false;
        "dom.payments.request.enabled" = false;

        # disable data collection
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "network.allow-experiments" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.discovery.enabled" = false;

        "browser.uidensity" = 1;
        "extensions.autoDisableScopes" = 0;
        "browser.download.useDownloadDir" = true;
        "browser.download.dir" = "$HOME/Downloads";
      };

      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "https://nixos.org/favicon.ico";
            definedAliases = [ "@np" ];
          };
          "NixOS Wiki" = {
            urls = [
              { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }
            ];
            icon = "https://wiki.nixos.org/favicon.ico";
            definedAliases = [ "@nw" ];
          };
          "bing".metaData.hidden = true;
          "google".metaData.hidden = true;
        };
      };
    };
  };
}
