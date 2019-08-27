from bluecom.messages.serverbound.message import ServerboundMessage
from bluecom.messages.types import Integer


class CloseChannelServerbound(ServerboundMessage):
    id = 3

    def __init__(self, file_object):
        self.channel_id = Integer.read(file_object)

    def execute(self, server_manager):
        server_manager.handle_close_channel_serverbound(self.channel_id)
