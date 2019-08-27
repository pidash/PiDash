from bluecom.messages.clientbound.message import ClientboundMessage
from bluecom.messages.types import Boolean


class LoginResponse(ClientboundMessage):
    def __init__(self, login_succeeded):
        ClientboundMessage.__init__(self, 0)
        self.login_succeeded = login_succeeded

    def serialize_data(self, file_object):
        Boolean.write(self.login_succeeded, file_object)
