import dbus

from bluecom.bluezwrapper.constants import BLUEZ_SERVICE_NAME,\
                                           DBUS_OBJECT_MANAGER_INTERFACE,\
                                           LE_ADVERTISING_MANAGER_INTERFACE
from bluecom.bluezwrapper.advertisement import Advertisement


class TransmitAdvertisement(Advertisement):
    def __init__(self, bus, index):
        Advertisement.__init__(self, bus, index, 'peripheral')
        self.add_service_uuid('FD792B42-90F7-4D24-9E8D-096D6EFBC31C')
        self.add_local_name('TransmitAdvertisement')
        self.include_tx_power = True


class AdvertisementManager:
    def __init__(self, mainloop, bus):
        self.mainloop = mainloop

        adapter = self.find_adapter(bus)
        if not adapter:
            print('LEAdvertisingManager1 interface not found')
            return

        adapter_props = dbus.Interface(bus.get_object(BLUEZ_SERVICE_NAME, adapter), "org.freedesktop.DBus.Properties")
        adapter_props.Set("org.bluez.Adapter1", "Powered", dbus.Boolean(1))
        ad_manager = dbus.Interface(bus.get_object(BLUEZ_SERVICE_NAME, adapter), LE_ADVERTISING_MANAGER_INTERFACE)
        advertisement = TransmitAdvertisement(bus, 0)

        ad_manager.RegisterAdvertisement(advertisement.get_path(), {},
                                         reply_handler=self.registration_succeeded,
                                         error_handler=self.registration_failed)

    @staticmethod
    def find_adapter(bus):
        remote_om = dbus.Interface(bus.get_object(BLUEZ_SERVICE_NAME, '/'), DBUS_OBJECT_MANAGER_INTERFACE)
        objects = remote_om.GetManagedObjects()

        for o, props in objects.items():
            if LE_ADVERTISING_MANAGER_INTERFACE in props:
                return o
        return None

    @staticmethod
    def registration_succeeded():
        print('advertisement registration succeeded')

    def registration_failed(self, error):
        print('advertisement registration failed')
        print(error)
        self.mainloop.quit()
