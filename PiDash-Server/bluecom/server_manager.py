import dbus

from bluecom.bluezwrapper.constants import BLUEZ_SERVICE_NAME, DBUS_OBJECT_MANAGER_INTERFACE, GATT_MANAGER_INTERFACE
from bluecom.bluezwrapper import Application
from bluecom.channel import Channel
from bluecom.messages.clientbound.channel_data_clientbound import ChannelDataClientbound
from bluecom.messages.clientbound.login_response import LoginResponse
from bluecom.messages.packet_buffer import PacketBuffer
from bluecom.messages.serverbound.channel_data_serverbound import ChannelDataServerbound
from bluecom.messages.serverbound.close_channel_serverbound import CloseChannelServerbound
from bluecom.messages.serverbound.open_channel import OpenChannel
from bluecom.messages.serverbound.open_connection import OpenConnection
from bluecom.messages.types import Byte
from bluecom.transfer_service import TransferService


class ServerManager:
    def __init__(self, mainloop, bus):
        self.mainloop = mainloop
        self.channels = {}
        self._registered_serverbound_messages = {}

        self._register_serverbound_message(OpenConnection)
        self._register_serverbound_message(OpenChannel)
        self._register_serverbound_message(ChannelDataServerbound)
        self._register_serverbound_message(CloseChannelServerbound)

        adapter = self.find_adapter(bus)
        if not adapter:
            print('GattManager1 interface not found')
            return

        service_manager = dbus.Interface(bus.get_object(BLUEZ_SERVICE_NAME, adapter), GATT_MANAGER_INTERFACE)

        self.transfer_service = TransferService(bus, 0)
        self.transfer_service.register_received_data_callback(self._receive_data)
        self.delegate = None

        app = Application(bus)
        app.add_service(self.transfer_service)

        service_manager.RegisterApplication(app.get_path(), {},
                                            reply_handler=self.registration_succeeded,
                                            error_handler=self.registration_failed)

    def register_delegate(self, delegate):
        self.delegate = delegate

    def _register_serverbound_message(self, message):
        self._registered_serverbound_messages[message.id] = message

    def _receive_data(self, data):
        file_object = PacketBuffer(bytes(data))
        message_id = Byte.read(file_object)
        message_class = self._registered_serverbound_messages.get(message_id)

        if message_class is None:
            print("message id unknown", message_id)
            return

        message = message_class(file_object)
        message.execute(self)

    @staticmethod
    def registration_succeeded():
        print('GATT application registration succeeded')

    def registration_failed(self, error):
        print('GATT application registration failed')
        print(error)
        self.mainloop.quit()

    def open_connection(self, shared_secret):
        print("login with " + shared_secret)
        self._send_message(LoginResponse(True))

    def open_channel(self, channel_id, module_id):
        channel = Channel(channel_id, self)
        self.channels[channel_id] = channel
        if self.delegate is not None:
            self.delegate.handle_new_channel(channel, module_id)

    def handle_channel_data_serverbound(self, channel_id, data):
        channel = self.channels[channel_id]
        if channel is not None:
            channel.handle_data(data)

    def handle_close_channel_serverbound(self, channel_id):
        channel = self.channels[channel_id]
        if channel is not None:
            del self.channels[channel_id]
            channel.handle_close()

    def send_data(self, channel_id, data):
        message = ChannelDataClientbound(channel_id, data)
        self._send_message(message)

    def _send_message(self, message):
        self.transfer_service.send_data(message.serialize())

    @staticmethod
    def find_adapter(bus):
        remote_om = dbus.Interface(bus.get_object(BLUEZ_SERVICE_NAME, '/'), DBUS_OBJECT_MANAGER_INTERFACE)
        objects = remote_om.GetManagedObjects()

        for o, props in objects.items():
            if GATT_MANAGER_INTERFACE in props.keys():
                return o

        return None
