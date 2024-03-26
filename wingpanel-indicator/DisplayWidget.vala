// TODO: Copyright and rename namespace

public class Aboba.DisplayWidget : Gtk.Box {
    [DBus (name = "io.elementary.gala.UnityWindowManagement")]
    private interface GalaWindowManagement : GLib.Object {
        public abstract signal void focus_window_state_changed (bool is_maximized);

        public abstract bool get_focus_window_state () throws GLib.Error;
        public abstract void close_focus_window () throws GLib.Error;
        public abstract void maximize_focused_window () throws GLib.Error;
        public abstract void unmaximize_focused_window () throws GLib.Error;
        public abstract void minimize_focused_window () throws GLib.Error;
    }

    // Wingpanel adds `composited-indicator` class to the widget
    private const int STYLE_CLASS_PADDING = 6;
    private const int SPACING = 12;
    private const int HALF_SPACING = SPACING / 2;

    private Gtk.Image separator_image;
    private Gtk.Image minimize_image;
    private Gtk.Image unmaximize_image;
    private Gtk.Image maximize_image;
    private Gtk.Image close_image;
    private Gtk.Stack maximize_stack;

    private GalaWindowManagement? gala_window_management = null;
    private ulong gala_window_management_id = 0;

    private bool is_focus_window_maximized {
        set {
            if (value) {
                maximize_stack.visible_child = unmaximize_image;
            } else {
                maximize_stack.visible_child = maximize_image;
            }
        }
    }

    construct {
        separator_image = new Gtk.Image () {
            icon_name = "separator-symbolic"
        };

        minimize_image = new Gtk.Image () {
            icon_name = "go-bottom-symbolic"
        };
        unmaximize_image = new Gtk.Image () {
            icon_name = "view-restore-symbolic"
        };
        maximize_image = new Gtk.Image () {
            icon_name = "view-fullscreen-symbolic"
        };
        close_image = new Gtk.Image () {
            icon_name = "window-close-symbolic"
        };

        maximize_stack = new Gtk.Stack () {
            transition_type = CROSSFADE
        };
        maximize_stack.add (maximize_image);
        maximize_stack.add (unmaximize_image);

        var buttons_box = new Gtk.Box (HORIZONTAL, SPACING);
        buttons_box.add (minimize_image);
        buttons_box.add (maximize_stack);
        buttons_box.add (close_image);

        add (separator_image);
        add (buttons_box);
        show_all ();

        Bus.watch_name (SESSION, "io.elementary.gala.UnityWindowManagement", NONE, on_watch, on_unwatch);

        minimize_image.button_release_event.connect (() => {
            if (gala_window_management != null) {
                try {
                    gala_window_management.minimize_focused_window ();
                } catch (Error e) {
                    critical (e.message);
                }
            }
        });

        maximize_image.button_release_event.connect (() => {
            if (gala_window_management != null) {
                try {
                    gala_window_management.maximize_focused_window ();
                } catch (Error e) {
                    critical (e.message);
                }
            }
        });

        unmaximize_image.button_release_event.connect (() => {
            if (gala_window_management != null) {
                try {
                    gala_window_management.unmaximize_focused_window ();
                } catch (Error e) {
                    critical (e.message);
                }
            }
        });

        close_image.button_release_event.connect (() => {
            if (gala_window_management != null) {
                try {
                    gala_window_management.close_focus_window ();
                } catch (Error e) {
                    critical (e.message);
                }
            }
        });
    }

    private void on_watch (GLib.DBusConnection connection) {
        connection.get_proxy.begin<GalaWindowManagement> (
            "io.elementary.gala.UnityWindowManagement", "/io/elementary/gala/UnityWindowManagement", NONE, null,
            (obj, res) => {
                try {
                    gala_window_management = ((GLib.DBusConnection) obj).get_proxy.end<GalaWindowManagement> (res);

                    is_focus_window_maximized = gala_window_management.get_focus_window_state ();
                    gala_window_management_id = gala_window_management.focus_window_state_changed.connect (
                        (is_maximized) => {
                            is_focus_window_maximized = is_maximized;
                        }
                    );
                } catch (Error e) {
                    critical (e.message);
                    gala_window_management = null;
                }
            }
        );
    }

    private void on_unwatch (GLib.DBusConnection connection) {
        if (gala_window_management_id != 0) {
            gala_window_management.disconnect (gala_window_management_id);
            gala_window_management_id = 0;
        }
        gala_window_management = null;
        critical ("Lost connection to io.elementary.gala.UnityWindowManagement");
    }

    public override bool button_release_event (Gdk.EventButton event) {
        if (event.button != Gdk.BUTTON_PRIMARY) {
            return Gdk.EVENT_PROPAGATE;
        }

        var min_bounds = STYLE_CLASS_PADDING + separator_image.get_allocated_width () - HALF_SPACING;
        
        if (event.x <= min_bounds) {
            return Gdk.EVENT_PROPAGATE;
        }

        var minimize_button_bounds = min_bounds + minimize_image.get_allocated_width () + SPACING;
        var maximize_stack_bounds = minimize_button_bounds + maximize_stack.get_allocated_width () + SPACING;

        if (event.x < minimize_button_bounds) {
            minimize_image.button_release_event (event);
        } else if (event.x < maximize_stack_bounds) {
            maximize_stack.visible_child.button_release_event (event);
        } else {
            close_image.button_release_event (event);
        }

        return Gdk.EVENT_PROPAGATE;
    }
}
