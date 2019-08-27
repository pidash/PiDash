from bluecom.messages.serverbound.message import ServerboundMessage
from bluecom.messages.types import String


class OpenConnection(ServerboundMessage):
    id = 0

    def __init__(self, file_object):
        self.shared_secret = String.read(file_object)

    def execute(self, server_manager):
        server_manager.open_connection(self.shared_secret)
