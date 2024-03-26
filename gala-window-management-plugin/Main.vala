// TODO: Copyright

public class WindowManagementPlugin.Main : Gala.Plugin {
    private const string DBUS_NAME = "io.elementary.gala.UnityWindowManagement";
    private const string DBUS_PATH = "/io/elementary/gala/UnityWindowManagement";

    static unowned Meta.Display display;

    private DBusConnection? dbus_connection = null;

    public override void initialize (Gala.WindowManager wm) {
        display = wm.get_display ();

        Bus.own_name (
            BusType.SESSION,
            DBUS_NAME,
            BusNameOwnerFlags.NONE,
            on_bus_aquired,
            null,
            () => warning ("Acquiring %s failed.", DBUS_NAME)
        );
    }

    public override void destroy () {
        try {
            if (dbus_connection != null) {
                dbus_connection.close_sync ();
            }
        } catch (Error e) {
            warning ("Closing DBus service failed: %s", e.message);
        }
    }

    private void on_bus_aquired (DBusConnection connection) {
        try {
            var server = new DBusServer (display);
            connection.register_object (DBUS_PATH, server);

            debug ("DBus service registered.");
        } catch (Error e) {
            warning ("Registering DBus service failed: %s", e.message);
        }
    }
}

public Gala.PluginInfo register_plugin () {
    return Gala.PluginInfo () {
        name = "Unity Window Management",
        author = "lenemter <lenemter@gmail.com>",
        plugin_type = typeof (WindowManagementPlugin.Main),
        provides = Gala.PluginFunction.ADDITION,
        load_priority = Gala.LoadPriority.IMMEDIATE
    };
}
