// TODO: Copyright and rename namespace

public class Aboba.Indicator : Wingpanel.Indicator {
    private Aboba.DisplayWidget display_widget;
    private Aboba.SettingsPopover popover_widget;

    public Indicator () {
        Object (
            code_name : "unity",
            visible: true,
            position: Wingpanel.Indicator.Position.FORCE_RIGHT
        );
    }

    construct {
        // TODO: Setup translations
        //  GLib.Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.LOCALEDIR);
        //  GLib.Intl.bind_textdomain_codeset (Config.GETTEXT_PACKAGE, "UTF-8");
    }

    public override Gtk.Widget get_display_widget () {
        if (display_widget == null) {
            // Prevent a race that skips automatic resource loading
            // https://github.com/elementary/wingpanel-indicator-bluetooth/issues/203
            Gtk.IconTheme.get_default ().add_resource_path ("/org/elementary/wingpanel/icons");

            display_widget = new Aboba.DisplayWidget ();
        }

        return display_widget;
    }

    public override Gtk.Widget? get_widget () {
        //  if (popover_widget == null) {
        //      popover_widget = new SettingsPopover ();
        //  }

        //  return popover_widget;
        return null;
    }

    public override void opened () {}

    public override void closed () {}
}

public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION) {
        return null;
    }

    return new Aboba.Indicator ();
}
