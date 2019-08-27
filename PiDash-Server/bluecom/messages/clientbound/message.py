from bluecom.messages.packet_buffer import PacketBuffer
from bluecom.messages.types import Byte


class ClientboundMessage:
    def __init__(self, message_id):
        self.message_id = message_id

    def serialize(self):
        buffer = PacketBuffer()
        Byte.write(self.message_id, buffer)
        self.serialize_data(buffer)
        buffer.reset_cursor()
        return [d for d in buffer.read()]

    def serialize_data(self, file_object):
        pass
