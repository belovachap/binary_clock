using Gtk;

public class BinaryDigitWidget : DrawingArea {

    private int _digit = 0;
    public int digit { get { return this._digit; } 
                       set { this.foo(value); }}
    
    public BinaryDigitWidget () {
        // Set favored widget size
        set_size_request (50, 200);
    }
    
    private void foo(int num)
        requires(num >= 0 && num <= 9)
    {
        if (num != this._digit) {
            this._digit = num;
            this.redraw_canvas();
        }
    }   
    
    private void redraw_canvas () {
        var window = get_window ();
        if (null == window) {
            return;
        }

        var region = window.get_clip_region ();
        // redraw the cairo canvas completely by exposing it
        window.invalidate_region (region, true);
        window.process_updates (true);
    }
    
    /* Widget is asked to draw itself */
    public override bool draw (Cairo.Context cr) {
    
        int width = get_allocated_width ();
        int height = get_allocated_height ();
        
        // Black background
        cr.save();
        cr.set_source_rgba(0.0, 0.0, 0.0, 1.0);
        cr.rectangle(0, 0, width, height);
        cr.fill();
        cr.restore();
        
        // Draw each LED
        
        // Lowest LED, calculate center, radius, and decide whether it's on or off.
        cr.save();
        switch (this.digit) {
            case 1:
            case 3:
            case 5:
            case 7:
            case 9:
                cr.set_source_rgba(0.0, 1.0, 0.0, 1.0);
                break;
            default:
                cr.set_source_rgba(0.0, 1.0, 0.0, 0.2);
                break;
        }
        cr.arc(25, 125, 10, 0, 2 * Math.PI);
        cr.fill();
        cr.restore();
        
        cr.save();
        switch (this.digit) {
            case 2:
            case 3:
            case 6:
            case 7:
                cr.set_source_rgba(0.0, 1.0, 0.0, 1.0);
                break;
            default:
                cr.set_source_rgba(0.0, 1.0, 0.0, 0.2);
                break;
        }
        cr.arc(25, 100, 10, 0, 2 * Math.PI);
        cr.fill();
        cr.restore();
        
        cr.save();
        switch (this.digit) {
            case 4:
            case 5:
            case 6:
            case 7:
                cr.set_source_rgba(0.0, 1.0, 0.0, 1.0);
                break;
            default:
                cr.set_source_rgba(0.0, 1.0, 0.0, 0.2);
                break;
        }
        cr.arc(25, 75, 10, 0, 2 * Math.PI);
        cr.fill();
        cr.restore();
        
        cr.save();
        switch (this.digit) {
            case 8:
            case 9:
                cr.set_source_rgba(0.0, 1.0, 0.0, 1.0);
                break;
            default:
                cr.set_source_rgba(0.0, 1.0, 0.0, 0.2);
                break;
        }
        cr.arc(25, 50, 10, 0, 2 * Math.PI);
        cr.fill();
        cr.restore();

        return false;
    }
}

class App : GLib.Object {

    private BinaryDigitWidget seconds_1;
    private BinaryDigitWidget seconds_2;
    private BinaryDigitWidget minutes_1;
    private BinaryDigitWidget minutes_2;
    private BinaryDigitWidget hours_1;
    private BinaryDigitWidget hours_2;

    public App (string[] args) {
        Gtk.init (ref args);
        
        var window = new Window ();
        var hbox = new HBox(true, 0);
        
        seconds_1 = new BinaryDigitWidget ();
        seconds_2 = new BinaryDigitWidget ();
        minutes_1 = new BinaryDigitWidget ();
        minutes_2 = new BinaryDigitWidget ();
        hours_1   = new BinaryDigitWidget ();
        hours_2   = new BinaryDigitWidget ();

        hbox.add(hours_1);
        hbox.add(hours_2);
        hbox.add(minutes_1);
        hbox.add(minutes_2);        
        hbox.add(seconds_1);
        hbox.add(seconds_2);
        
        window.add (hbox);
        
        window.destroy.connect (Gtk.main_quit);
        
        this.update_display();
        
        window.show_all ();
        
        Timeout.add(250, update_display);
        
        Gtk.main ();
    }
    
    private bool update_display() {
        // Get the current time
        var now = new DateTime.now_local();
        int hour = now.get_hour();
        int minute = now.get_minute();
        int second = now.get_second();
        
        // Update the binary digit displays
        hours_1.digit = hour / 10;
        hours_2.digit = hour % 10;
    
        minutes_1.digit = minute / 10;
        minutes_2.digit = minute % 10;
    
        seconds_1.digit = second / 10;
        seconds_2.digit = second % 10;
    
        return true;
    }

}

int main (string[] args) {

    new App (args);

    return 0;
}
