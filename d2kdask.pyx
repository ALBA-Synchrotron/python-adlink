cimport d2kdask
from d2kdask cimport U8, U16, U32, I16, U16
from libc.stdlib cimport malloc, free
from libcpp cimport bool
import logging
from enum import Enum
cimport numpy as cnp
import numpy as np

class AdlinkException(Exception):
    pass

cpdef error(int error_code):
    if error_code == d2kdask.NoError:
        return
    elif error_code == d2kdask.ErrorInvalidCardNumber:
        raise AdlinkException("ErrorInvalidCardNumber")
    elif error_code == d2kdask.ErrorCardNotRegistered:
        raise AdlinkException("CardNotRegistered")
    elif error_code == d2kdask.ErrorFuncNotSupport:
        raise AdlinkException("FunctionalityNotSupported")
    elif error_code == d2kdask.ErrorTransferCountTooLarge:
        raise AdlinkException("TransferCountTooLarge")
    elif error_code == d2kdask.ErrorContIoNotAllowed:
        raise AdlinkException("ErrorContIoNotAllowed")
    elif error_code == d2kdask.ErrorInvalidDaRefVoltage:
        raise AdlinkException("ErrorInvalidDaRefVoltage")
    elif error_code == d2kdask.ErrorDaVoltageOutOfRange:
        raise AdlinkException("ErrorDaVoltageOutOfRange")
    else:
        raise AdlinkException("Unknown error.")


class Card(Enum):
    DAQ_2010= d2kdask.DAQ_2010
    DAQ_2205= d2kdask.DAQ_2205
    DAQ_2206= d2kdask.DAQ_2206
    DAQ_2005= d2kdask.DAQ_2005
    DAQ_2204= d2kdask.DAQ_2204
    DAQ_2006= d2kdask.DAQ_2006
    DAQ_2501= d2kdask.DAQ_2501
    DAQ_2502= d2kdask.DAQ_2502
    DAQ_2208= d2kdask.DAQ_2208
    DAQ_2213= d2kdask.DAQ_2213
    DAQ_2214= d2kdask.DAQ_2214
    DAQ_2016= d2kdask.DAQ_2016
    DAQ_2020= d2kdask.DAQ_2020
    DAQ_2022= d2kdask.DAQ_2022

class ADConversionSourceSelection(Enum):
    Internal = d2kdask.DAQ2K_AI_ADCONVSRC_Int
    AFI0_pin = d2kdask.DAQ2K_AI_ADCONVSRC_AFI0
    SSI = d2kdask.DAQ2K_AI_ADCONVSRC_SSI

class Trigger:
    class Source(Enum):
        Software = d2kdask.DAQ2K_AI_TRGSRC_SOFT
        AnalogPin = d2kdask.DAQ2K_AI_TRGSRC_ANA
        ExternalDigitalPin = d2kdask.DAQ2K_AI_TRGSRC_ExtD
        SSI = d2kdask.DAQ2K_AI_TRSRC_SSI

    class Mode(Enum):
        Post = d2kdask.DAQ2K_AI_TRGMOD_POST
        Delay = d2kdask.DAQ2K_AI_TRGMOD_DELAY
        Pre = d2kdask.DAQ2K_AI_TRGMOD_PRE
        Middle = d2kdask.DAQ2K_AI_TRGMOD_MIDL

    class Delay(Enum):
        InSamples = d2kdask.DAQ2K_AI_Dly1InSamples
        InTimeBase = d2kdask.DAQ2K_AI_Dly1InTimebase

    class Polarity(Enum):
        Positive = d2kdask.DAQ2K_AI_TrgPositive
        Negative = d2kdask.DAQ2K_AI_TrgNegative
    
class VoltageRange(Enum):
    # AD Ranges
    AD_B_10_V     = d2kdask.AD_B_10_V    
    AD_B_5_V      = d2kdask.AD_B_5_V     
    AD_B_2_5_V    = d2kdask.AD_B_2_5_V   
    AD_B_1_25_V   = d2kdask.AD_B_1_25_V  
    AD_B_0_625_V  = d2kdask.AD_B_0_625_V 
    AD_B_0_3125_V = d2kdask.AD_B_0_3125_V
    AD_B_0_5_V    = d2kdask.AD_B_0_5_V   
    AD_B_0_05_V   = d2kdask.AD_B_0_05_V  
    AD_B_0_005_V  = d2kdask.AD_B_0_005_V 
    AD_B_1_V      = d2kdask.AD_B_1_V     
    AD_B_0_1_V    = d2kdask.AD_B_0_1_V   
    AD_B_0_01_V   = d2kdask.AD_B_0_01_V  
    AD_B_0_001_V  = d2kdask.AD_B_0_001_V 
    AD_U_20_V     = d2kdask.AD_U_20_V    
    AD_U_10_V     = d2kdask.AD_U_10_V    
    AD_U_5_V      = d2kdask.AD_U_5_V     
    AD_U_2_5_V    = d2kdask.AD_U_2_5_V   
    AD_U_1_25_V   = d2kdask.AD_U_1_25_V  
    AD_U_1_V      = d2kdask.AD_U_1_V     
    AD_U_0_1_V    = d2kdask.AD_U_0_1_V   
    AD_U_0_01_V   = d2kdask.AD_U_0_01_V  
    AD_U_0_001_V  = d2kdask.AD_U_0_001_V 
    AD_B_2_V      = d2kdask.AD_B_2_V     
    AD_B_0_25_V   = d2kdask.AD_B_0_25_V  
    AD_B_0_2_V    = d2kdask.AD_B_0_2_V   
    AD_U_4_V      = d2kdask.AD_U_4_V     
    AD_U_2_V      = d2kdask.AD_U_2_V     
    AD_U_0_5_V    = d2kdask.AD_U_0_5_V   
    AD_U_0_4_V = d2kdask.AD_U_0_4_V


class Polarity(Enum):
    Bipolar = d2kdask.DAQ2K_DA_BiPolar
    Unipolar = d2kdask.DAQ2K_DA_UniPolar


class Reference(Enum):
    Internal = d2kdask.DAQ2K_DA_Int_REF
    External = d2kdask.DAQ2K_DA_Ext_REF

class OutputChannel(Enum):
    Zero = 0
    One = 1
    All = -1

class BufferType(Enum):
    AnalogInput = 0
    AnalogOutput = 1
    DigitalInput = 2
    DigitalOutput = 3

class SyncMode(Enum):
    Synchronous = d2kdask.SYNCH_OP
    Asynchronous = d2kdask.ASYNCH_OP

class Definite(Enum):
    Indefinite = 0
    Definite = 1

class StopMode(Enum):
    Immediate = d2kdask.DAQ2K_DA_TerminateImmediate
    NextCounterUpdate = d2kdask.DAQ2K_DA_TerminateUC
    IterationCount = d2kdask.DAQ2K_DA_TerminateIC


cdef class Buffer:
    cdef unsigned short* data
    cdef public d2kdask.U16 id_
    cdef public int card_id
    cdef public int length


    def __cinit__(self, int card_id, int n_samples = 4000, buffer_type: BufferType = BufferType.AnalogInput):
        self.card_id = card_id
        self.length = n_samples
        self.data = <unsigned short *> malloc(n_samples * sizeof(unsigned short))

        if buffer_type == BufferType.AnalogInput:
            err = d2kdask.D2K_AI_ContBufferSetup(card_id, self.data, n_samples, &self.id_)
        elif buffer_type == BufferType.AnalogOutput:
            err = d2kdask.D2K_AO_ContBufferSetup(card_id, self.data, n_samples, &self.id_)        
        error(err)
    
    cpdef set_data(self, new_data):
        copy_size = min(len(new_data), self.length)
        for i in range(copy_size):
            self.data[i] = new_data[i]

    cpdef get_data(self):
        cdef unsigned short[::1] arr = <unsigned short [:self.length]> self.data
        return np.asarray(arr)

    def __dealloc__(self):
        free(self.data)
        d2kdask.D2K_AI_ContBufferReset(self.card_id)
        logging.info("Dealocating buffer {}".format(self.id_))



cdef class D200X:
    cdef public int id_

    def __cinit__(self, card_type, int card_num):
        self.id_ = d2kdask.D2K_Register_Card(card_type.value, card_num)
        if self.id_ < 0:
            raise AdlinkException("Error registering card: {}".format(self.id_))

    def __dealloc__(self):
        logging.info("Dealocating D200X card {}".format(self.id_))
        d2kdask.D2K_Release_Card(self.id_)


    def ai_channel_config(self, int channel, int range):
        cdef int err = d2kdask.D2K_AI_CH_Config(self.id_, channel, range)
        if err != d2kdask.NoError:
            raise AdlinkException("Error configuring channel {}: {}".format(channel, err))
    
    def ai_config(self, 
                    config_control: ADConversionSourceSelection,
                    trigger_control: Trigger,
                    int middle_or_delay_scans,
                    int m_counter,
                    int re_trigger_counter,
                    d2kdask.BOOLEAN auto_reset_buf):
        cdef int err = d2kdask.D2K_AI_Config(self.id_, config_control.value, trigger_control.value, 
                            middle_or_delay_scans, m_counter, re_trigger_counter, auto_reset_buf)
        
        error(err)

    def ai_continuous_scan_to_file(self, filename: str, int largest_channel, buffer, int read_scans, int scan_interval, int sample_interval):
        err = d2kdask.D2K_AI_ContScanChannelsToFile(self.id_, largest_channel, buffer.id_, filename, read_scans, scan_interval, sample_interval, d2kdask.SYNCH_OP)
        if err == d2kdask.NoError:
            return d2kdask.NoError
        else:
            raise AdlinkException("Error in ai_continuous_scan_to_file")


    def ao_channel_config(self, channel: OutputChannel, output_polarity: Polarity, reference: Reference, float ref_voltage):
        err = d2kdask.D2K_AO_CH_Config(self.id_, channel.value, output_polarity.value, reference.value, ref_voltage)
        error(err)


    def ao_voltage_write_channel(self, channel: OutputChannel, float voltage):
        err = d2kdask.D2K_AO_VWriteChannel(self.id_, channel.value, voltage)
        error(err)

    def ao_write_channel(self, channel: OutputChannel, I16 value):
        err = d2kdask.D2K_AO_VWriteChannel(self.id_, channel, value)
        error(err)

    def ao_simultanious_write_channel(self, int num_channels, buffer: Buffer):
        """
        This function writes the content of the buffer to the channels.
        """
        err = d2kdask.D2K_AO_SimuWriteChannel(self.id_, num_channels, buffer.data)
        error(err)

    def ao_cont_write_channel(self, channel: OutputChannel, buffer: Buffer, 
                int iterations, int channel_update_interval, definite, 
                sync_mode: SyncMode):

        err = d2kdask.D2K_AO_ContWriteChannel(self.id_, channel.value, 
                buffer.id_, buffer.length, iterations, channel_update_interval, 
                definite, sync_mode.value)
        error(err)

    

################################################################################
# Asynchronous functions
################################################################################
    cpdef ao_async_check(self):
        cdef BOOLEAN stopped
        cdef U32 writeCount
        err = d2kdask.D2K_AO_AsyncCheck(self.id_, &stopped, &writeCount)
        error(err)

        return stopped, writeCount

    cpdef ao_async_clear(self, stop_mode: StopMode):
        cdef U32 updateCount
        err = d2kdask.D2K_AO_AsyncClear(self.id_, &updateCount, stop_mode.value)
        error(err)

        return updateCount

