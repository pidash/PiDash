from bluecom.messages.clientbound.message import ClientboundMessage
from bluecom.messages.types import Integer, Data


class ChannelDataClientbound(ClientboundMessage):
    def __init__(self, channel_id, data):
        ClientboundMessage.__init__(self, 1)
        self.channel_id = channel_id
        self.data = data

    def serialize_data(self, file_object):
        Integer.write(self.channel_id, file_object)
        Data.write(self.data, file_object)
