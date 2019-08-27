import dbus

from bluecom.bluezwrapper.constants import GATT_SERVICE_INTERFACE, DBUS_PROPERTIES_INTERFACE
from bluecom.bluezwrapper.exceptions import InvalidArgsException


class Service(dbus.service.Object):
    """
    org.bluez.GattService1 interface implementation
    """
    PATH_BASE = '/org/bluez/example/service'

    def __init__(self, bus, index, uuid, primary):
        self.path = self.PATH_BASE + str(index)
        self.bus = bus
        self.uuid = uuid
        self.primary = primary
        self.characteristics = []
        dbus.service.Object.__init__(self, bus, self.path)

    def get_properties(self):
        return {
            GATT_SERVICE_INTERFACE: {
                'UUID': self.uuid,
                'Primary': self.primary,
                'characteristics': dbus.Array(self.get_characteristic_paths(), signature='o')
            }
        }

    def get_path(self):
        return dbus.ObjectPath(self.path)

    def add_characteristic(self, characteristic):
        self.characteristics.append(characteristic)

    def get_characteristic_paths(self):
        result = []
        for characteristic in self.characteristics:
            result.append(characteristic.get_path())
        return result

    def get_characteristics(self):
        return self.characteristics

    @dbus.service.method(DBUS_PROPERTIES_INTERFACE, in_signature='s', out_signature='a{sv}')
    def GetAll(self, interface):
        if interface != GATT_SERVICE_INTERFACE:
            raise InvalidArgsException()

        return self.get_properties()[GATT_SERVICE_INTERFACE]
