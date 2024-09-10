import microbit

microbit.radio.on()
microbit.radio.config(channel = 1, group = 1, queue = 50, length = 64)

while True:
    message = microbit.radio.receive_bytes()
    if message != 'None':
        parts = message.split(":")
        print(parts[0], "\n", parts[1])
    microbit.sleep(1000)

microbit.radio.off()