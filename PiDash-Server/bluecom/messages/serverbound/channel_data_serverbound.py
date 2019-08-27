from bluecom.messages.serverbound.message import ServerboundMessage
from bluecom.messages.types import Integer, Data


class ChannelDataServerbound(ServerboundMessage):
    id = 2

    def __init__(self, file_object):
        self.channel_id = Integer.read(file_object)
        self.data = Data.read(file_object)

    def execute(self, server_manager):
        server_manager.handle_channel_data_serverbound(self.channel_id, self.data)
