import dbus
import dbus.exceptions
import dbus.mainloop.glib
import dbus.service

from gi.repository import GObject

from bluecom.advertisement_manager import AdvertisementManager
from bluecom.server_manager import ServerManager


class BluecomManager:
    def __init__(self):
        self.delegate = None

        dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
        bus = dbus.SystemBus()

        self.mainloop = GObject.MainLoop()

        self.advertisement_manager = AdvertisementManager(self.mainloop, bus)
        self.gatt_server_manager = ServerManager(self.mainloop, bus)

    def register_delegate(self, delegate):
        self.gatt_server_manager.register_delegate(delegate)

    def run(self):
        self.mainloop.run()
