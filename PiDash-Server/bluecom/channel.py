

class Channel:
    def __init__(self, channel_id, server):
        self.channel_id = channel_id
        self.server = server

    def send_data(self, data):
        self.server.send_data(self.channel_id, data)

    def handle_data(self, data):
        print(data)
        self.send_data(data)

    def handle_close(self):
        print("Channel " + str(self.channel_id) + " closed")

