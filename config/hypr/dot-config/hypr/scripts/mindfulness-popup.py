#!/usr/bin/env python3
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, GLib
import signal
import sys

class MindfulnessReminder(Gtk.Window):
    def __init__(self):
        Gtk.Window.__init__(self, title="Mindfulness Reminder")
        
        # Make it fullscreen
        self.fullscreen()
        self.set_keep_above(True)
        
        # Use a dark background
        # self.override_background_color(Gtk.StateFlags.NORMAL, Gtk.RGBA(0.1, 0.1, 0.1, 0.9))
        
        # Create a vertical box to hold our content
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=20)
        vbox.set_margin_top(100)
        vbox.set_margin_bottom(100)
        vbox.set_margin_start(100)
        vbox.set_margin_end(100)
        self.add(vbox)
        
        # Add the main message
        q1 = Gtk.Label()
        q1.set_markup("<span font='20' color='#cc241d'>How did this make me feel?</span>")
        vbox.pack_start(q1, True, True, 0)
        
        a1 = Gtk.Label()
        a1.set_markup("<span font='18' color='#ebdbb2'>Neutral (is there something else I could be doing\n that would make you feel something?)\nPositive (what else could I be doing that would a\nlso make you feel that way?)\nNegative (is there a useful way for me to harness\n this negative energy or is it draining me?)</span>")
        vbox.pack_start(a1, True, True, 0)


        # Add the main message
        q2 = Gtk.Label()
        q2.set_markup("<span font='20' color='#cc241d'>Was this a good use of my time?</span>")
        vbox.pack_start(q2, True, True, 0)

        a2 = Gtk.Label()
        a2.set_markup("<span font='18' color='#ebdbb2'>Did it: \nbring me closer to others,\nupdate understanding of world,\nor calm/relax me so I can do something else later)</span>")
        vbox.pack_start(a2, True, True, 0)
        
        # Add a dismiss button
        button = Gtk.Button.new_with_label("Close")
        button.connect("clicked", self.on_button_clicked)
        button.set_size_request(200, 50)
        
        # Center the button
        button_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        button_box.pack_start(Gtk.Label(), True, True, 0)  # Spacer
        button_box.pack_start(button, False, False, 0)
        button_box.pack_start(Gtk.Label(), True, True, 0)  # Spacer
        
        vbox.pack_start(button_box, False, False, 0)
        
    def on_button_clicked(self, widget):
        Gtk.main_quit()

def main():
    # Handle Ctrl+C
    signal.signal(signal.SIGINT, signal.SIG_DFL)
    
    window = MindfulnessReminder()
    window.connect("destroy", Gtk.main_quit)
    window.show_all()
    Gtk.main()

if __name__ == "__main__":
    main()
