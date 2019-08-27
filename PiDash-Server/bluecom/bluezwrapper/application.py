import dbus

from bluecom.bluezwrapper.constants import DBUS_OBJECT_MANAGER_INTERFACE


class Application(dbus.service.Object):
    """
    org.bluez.GattApplication1 interface implementation
    """
    def __init__(self, bus):
        self.path = '/'
        self.services = []
        dbus.service.Object.__init__(self, bus, self.path)

    def get_path(self):
        return dbus.ObjectPath(self.path)

    def add_service(self, service):
        self.services.append(service)

    @dbus.service.method(DBUS_OBJECT_MANAGER_INTERFACE, out_signature='a{oa{sa{sv}}}')
    def GetManagedObjects(self):
        response = {}

        for service in self.services:
            response[service.get_path()] = service.get_properties()
            characteristics = service.get_characteristics()
            for characteristic in characteristics:
                response[characteristic.get_path()] = characteristic.get_properties()
                descriptors = characteristic.get_descriptors()
                for descriptor in descriptors:
                    response[descriptor.get_path()] = descriptor.get_properties()

        return response
