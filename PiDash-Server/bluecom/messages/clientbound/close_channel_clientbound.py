from bluecom.messages.clientbound.message import ClientboundMessage
from bluecom.messages.types import Integer, String


class ChannelDataClientbound(ClientboundMessage):
    def __init__(self, channel_id, error):
        ClientboundMessage.__init__(self, 2)
        self.channel_id = channel_id
        self.error = error

    def serialize_data(self, file_object):
        Integer.write(self.channel_id, file_object)
        String.write(self.error, file_object)
