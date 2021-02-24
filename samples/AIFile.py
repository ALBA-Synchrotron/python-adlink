from adlink import D200X
import adlink


def main():

    largest_channel = 3
    v_range = adlink.VoltageRange.AD_B_10_V
    read_count = 4000
    BASETIME = 40000000
    SCAN_INTERVAL = 160
    sample_rate = BASETIME / SCAN_INTERVAL
    file_name = "2005d.dat"

    print(
        "This program inputs {} data from CH-0 to CH-{} of DAQ-2005/2206 in {} Hz".format(
            read_count, largest_channel, sample_rate))
    print("Output file set to: %s.\n\n" % file_name)
    print("Press any key to start the operation...")

    card_type = int(
        input("Card Type: (0) DAQ_2005 or (1) DAQ2006 or (2) DAQ2016 ? "))

    card_num = int(input("Please input a card number: "))

    if card_type == 0:
        card_type = adlink.Card.DAQ_2005.value
    elif card_type == 1:
        card_type = adlink.Card.DAQ_2006.value
    elif card_type == 2:
        card_type = adlink.Card.DAQ_2016.value
    else:
        print("Wrong card number")
        return -1

    card = D200X(card_type, card_num)

    for i in range(4):
        card.ai_channel_config(i, v_range)

    card.ai_config(config_control=adlink.DAQ2K_AI_ADCONVSRC_Int,
                   trigger_control=adlink.DAQ2K_AI_TRGSRC_SOFT,
                   middle_or_delay_scans=0,
                   m_counter=0,
                   re_trigger_counter=0,
                   auto_reset_buf=True)

    card.ai_continous_scan_to_file(
        filename=file_name, largest_channel=largest_channel,
        read_scans=read_count / (largest_channel + 1),
        scan_interval=SCAN_INTERVAL, sample_interval=SCAN_INTERVAL)


if __name__ == "__main__":
    main()
