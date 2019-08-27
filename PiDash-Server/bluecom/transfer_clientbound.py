import os
import threading
import time

import dbus

from bluecom.bluezwrapper import Characteristic
from bluecom.bluezwrapper.constants import GATT_CHARACTERISTIC_INTERFACE


class TransferClientboundCharacteristic(Characteristic):
    TRANSFER_CLIENTBOUND_CHARACTERISTIC_UUID = '289698F1-1AB5-4315-915D-F8F0FE5F4EF0'

    def __init__(self, bus, index, service):
        Characteristic.__init__(
                self, bus, index,
                self.TRANSFER_CLIENTBOUND_CHARACTERISTIC_UUID,
                ['notify'],
                service)
        self.notifying = False

    def notify_new_data(self, data):
        self.PropertiesChanged(GATT_CHARACTERISTIC_INTERFACE, {'Value': data}, [])

    def send_data(self, data):
        if not self.notifying:
            return True

        self.notify_new_data([dbus.Byte(d) for d in data])

    def StartNotify(self):
        if self.notifying:
            print('Already notifying, nothing to do')
            return
        print('Notifying')

        self.notifying = True

    @staticmethod
    def restart_advertisement():
        time.sleep(3)
        os.system("hciconfig hci0 leadv 0")

    def StopNotify(self):
        if not self.notifying:
            print('Not notifying, nothing to do')
            return
        print('Stop Notifying')

        thread = threading.Thread(target=self.restart_advertisement)
        thread.daemon = True  # thread dies when main thread (only non-daemon thread) exits.
        thread.start()
        self.notifying = False
