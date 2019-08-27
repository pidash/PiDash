from io import BytesIO


class PacketBuffer(object):
    def __init__(self, values=None):
        self.bytes = BytesIO(values)

    def write(self, values):
        self.bytes.write(values)

    def write_array(self, values):
        self.write(bytes(values))

    def read(self, length=None):
        return self.bytes.read(length)

    def read_array(self, length=None):
        return [d for d in self.read(length)]

    def reset_cursor(self):
        self.bytes.seek(0)
