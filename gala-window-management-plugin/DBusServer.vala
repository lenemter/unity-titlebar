// TODO: Copyright

[DBus (name = "io.elementary.gala.UnityWindowManagement")]
public class WindowManagementPlugin.DBusServer : Object {
    [DBus (visible = false)]
    public Meta.Display display { get; construct; }
    private Meta.Window? current_focus_window = null;
    private ulong maximized_vertically_id = 0;
    private ulong maximized_horizontally_id = 0;

    [DBus (visible = false)]
    public DBusServer (Meta.Display display) {
        Object (display: display);

        display.notify["focus-window"].connect (() => {
            unowned var new_focus_window = display.focus_window;
            var win_type = (new_focus_window != null) ? new_focus_window.window_type : Meta.WindowType.NORMAL;
            if (win_type != NORMAL && win_type != DIALOG && win_type != MODAL_DIALOG) {
                return;
            }

            emit_focus_window_state_changed ();

            if (current_focus_window != null) {
                current_focus_window.disconnect (maximized_vertically_id);
                current_focus_window.disconnect (maximized_horizontally_id);
            }

            current_focus_window = display.get_focus_window ();
            if (current_focus_window != null) {
                maximized_vertically_id = current_focus_window.notify["maximized-vertically"].connect (
                    emit_focus_window_state_changed
                );
                maximized_horizontally_id = current_focus_window.notify["maximized-horizontally"].connect (
                    emit_focus_window_state_changed
                );
            }
        });
    }

    private void emit_focus_window_state_changed () {
        try {
            focus_window_state_changed (get_focus_window_state ());
        } catch (Error e) {
            focus_window_state_changed (false);
        }
    }

    public signal void focus_window_state_changed (bool is_maximized);

    public bool get_focus_window_state () throws GLib.Error {
        unowned var focus_window = display.get_focus_window ();
        if (focus_window == null) {
            return false;
        }

        return focus_window.maximized_horizontally || focus_window.maximized_vertically;
    }

    public void close_focus_window () throws GLib.Error {
        unowned var focus_window = display.get_focus_window ();
        if (focus_window != null && focus_window.can_close ()) {
            focus_window.@delete (display.get_current_time ());
        }
    }

    public void maximize_focused_window () throws GLib.Error {
        unowned var focus_window = display.get_focus_window ();
        if (focus_window != null && focus_window.can_maximize ()) {
            focus_window.maximize (Meta.MaximizeFlags.BOTH);
        }
    }

    public void unmaximize_focused_window () throws GLib.Error {
        unowned var focus_window = display.get_focus_window ();
        if (focus_window != null) {
            focus_window.unmaximize (Meta.MaximizeFlags.BOTH);
        }
    }

    public void minimize_focused_window () throws GLib.Error {
        unowned var focus_window = display.get_focus_window ();
        if (focus_window != null && focus_window.can_minimize ()) {
            focus_window.minimize ();
        }
    }
 }
