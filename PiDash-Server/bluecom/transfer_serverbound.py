from bluecom.bluezwrapper import Characteristic


class TransferServerboundCharacteristic(Characteristic):
    TRANSFER_SERVERBOUND_CHARACTERISTIC_UUID = 'DCADFB92-3B54-4024-8F0E-8CCE686DD24D'

    def __init__(self, bus, index, service):
        Characteristic.__init__(
                self, bus, index,
                self.TRANSFER_SERVERBOUND_CHARACTERISTIC_UUID,
                ['write'],
                service)

        self.callback = None

    def register_received_data_callback(self, callback):
        self.callback = callback

    def WriteValue(self, value, options):
        if self.callback is not None:
            self.callback([int(byte) for byte in value])
