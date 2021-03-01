from d2kdask import D200X, Buffer
from d2kdask import BufferType, OutputChannel, Definite, SyncMode, StopMode
import d2kdask
import numpy as np
import matplotlib.pyplot as plt
from time import sleep


def cos_wave(freq, time):
    return np.sin(2*np.pi * freq * time)


def generate_wave(freq, seconds, sample_rate=44100, amplitude=1):
    wave = [
        amplitude * cos_wave(freq, t)
        for t in np.linspace(0, seconds, sample_rate * seconds)]
    wave = np.array(wave)
    wave *= 32767
    wave += 32766
    return wave.astype(np.uint16)


def main():
    BASETIME = 40000000
    SCAN_INTERVAL = 160
    largest_channel = 3
    read_count = 40000
    file_name = b"2005d"

    sample_rate = BASETIME / SCAN_INTERVAL

    wave = np.arange(1, int(65535/2 - 1))

    card = D200X(d2kdask.Card.DAQ_2005, 0)
    buffer_output = Buffer(card.id_, n_samples=4000,
                           buffer_type=BufferType.AnalogOutput)
    buffer_input = Buffer(card.id_, n_samples=40000,
                          buffer_type=BufferType.AnalogInput)

    buffer_output.set_data(wave)

    for i in range(4):
        card.ai_channel_config(i, d2kdask.VoltageRange.AD_B_10_V.value)

    card.ai_config(config_control=d2kdask.ADConversionSourceSelection.Internal,
                   trigger_control=d2kdask.Trigger.Source.Software,
                   middle_or_delay_scans=0,
                   m_counter=0,
                   re_trigger_counter=0,
                   auto_reset_buf=True)

    card.ao_cont_write_channel(
        OutputChannel.Zero, buffer_output, 30, SCAN_INTERVAL, SCAN_INTERVAL,
        SyncMode.Asynchronous)

    card.ai_continuous_scan_to_file(
        filename=file_name, largest_channel=largest_channel,
        buffer=buffer_input, read_scans=read_count / (largest_channel + 1),
        scan_interval=SCAN_INTERVAL, sample_interval=SCAN_INTERVAL)

    while True:
        stopped, writeCount = card.ao_async_check()
        print("Write count: ", writeCount)
        sleep(0.1)
        if stopped:
            break

    card.ao_async_clear(StopMode.NextCounterUpdate)


if __name__ == "__main__":
    main()
