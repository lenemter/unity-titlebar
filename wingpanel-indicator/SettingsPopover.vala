// TODO: copyright and namespace

public class Aboba.SettingsPopover: Gtk.Popover {
    construct {
        var label = new Gtk.Label ("Hello, World!");
        label.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);
        child = label;
    }
}