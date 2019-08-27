import os

from bluecom.bluecom_manager import BluecomManager
from bluecom.messages.packet_buffer import PacketBuffer
from bluecom.messages.serverbound.open_connection import OpenConnection
from bluecom.messages.types import Byte


class BluecomMangerDelegate:
    def __init__(self):
        self._registered_serverbound_messages = {}

    def did_receive(self, data, transfer_service):
        file_object = PacketBuffer(bytes(data))
        message_id = Byte.read(file_object)
        message_class = self._registered_serverbound_messages.get(message_id)

        if message_class is None:
            print("message id unknown", message_id)
            return

        message = self._registered_serverbound_messages[message_id](file_object)
        message.execute(transfer_service)

    def register_serverbound_message(self, message):
        self._registered_serverbound_messages[message.id] = message


def main():
    # restart bluetooth
    os.system("hciconfig hci0 down")
    os.system("hciconfig hci0 up")

    manager = BluecomManager()
    delegate = BluecomMangerDelegate()
    delegate.register_serverbound_message(OpenConnection)

    manager.register_delegate(delegate)
    manager.run()


if __name__ == '__main__':
    main()
