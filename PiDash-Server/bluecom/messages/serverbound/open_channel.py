from bluecom.messages.serverbound.message import ServerboundMessage
from bluecom.messages.types import Integer, String


class OpenChannel(ServerboundMessage):
    id = 1

    def __init__(self, file_object):
        self.channel_id = Integer.read(file_object)
        self.module_id = String.read(file_object)

    def execute(self, server_manager):
        server_manager.open_channel(self.channel_id, self.module_id)
