from d2kdask import D200X, Buffer, BufferType
import matplotlib.pyplot as plt
import d2kdask
from time import time


def main():

    largest_channel = 3
    v_range = d2kdask.VoltageRange.AD_B_10_V.value
    read_count = 400000
    BASETIME = 40000000
    SCAN_INTERVAL = 160
    sample_rate = BASETIME / SCAN_INTERVAL
    file_name = b"2005d"

    print(
        "This program inputs {} data from CH-0 to CH-{} of DAQ-2005/2206 in {} Hz".format(
            read_count, largest_channel, sample_rate))
    print("Output file set to: %s.\n\n" % file_name)
    print("Press any key to start the operation...")

    card_type = int(
        input("Card Type: (0) DAQ_2005 or (1) DAQ2006 or (2) DAQ2016 ? "))

    card_num = int(input("Please input a card number: "))

    if card_type == 0:
        card_type = d2kdask.Card.DAQ_2005
    elif card_type == 1:
        card_type = d2kdask.Card.DAQ_2006
    elif card_type == 2:
        card_type = d2kdask.Card.DAQ_2016
    else:
        print("Wrong card number")
        return -1

    card = D200X(card_type, card_num)

    buffer = Buffer(card.id_, n_samples=read_count,
                    buffer_type=BufferType.AnalogInput)

    for i in range(4):
        card.ai_channel_config(i, v_range)

    card.ai_config(config_control=d2kdask.ADConversionSourceSelection.Internal,
                   trigger_control=d2kdask.Trigger.Source.Software,
                   middle_or_delay_scans=0,
                   m_counter=0,
                   re_trigger_counter=0,
                   auto_reset_buf=True)

    card.ai_continuous_scan_to_file(
        filename=file_name, largest_channel=largest_channel, buffer=buffer,
        read_scans=read_count / (largest_channel + 1),
        scan_interval=SCAN_INTERVAL, sample_interval=SCAN_INTERVAL)

    t0 = time()
    buffer_data = buffer.get_data()
    t1 = time()

    print("Data accessed in: {} seconds".format(t1-t0))
    plt.plot(buffer.get_data()[0:][::4])
    plt.show()

if __name__ == "__main__":
    main()
