from bluecom.bluezwrapper import Service
from bluecom.transfer_clientbound import TransferClientboundCharacteristic
from bluecom.transfer_serverbound import TransferServerboundCharacteristic


class TransferService(Service):
    TRANSFER_SERVICE_UUID = 'FD792B42-90F7-4D24-9E8D-096D6EFBC31C'

    def __init__(self, bus, index):
        Service.__init__(self, bus, index, self.TRANSFER_SERVICE_UUID, True)

        # configure clientbound
        self.clientbound = TransferClientboundCharacteristic(bus, 0, self)
        self.add_characteristic(self.clientbound)

        # configure serverbound
        self.serverbound = TransferServerboundCharacteristic(bus, 1, self)
        self.add_characteristic(self.serverbound)

    def send_data(self, data):
        self.clientbound.send_data(data)

    def register_received_data_callback(self, callback):
        self.serverbound.register_received_data_callback(callback)
