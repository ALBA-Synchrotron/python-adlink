cimport d2kdask
from d2kdask cimport U8, U16, U32, I16, U16
from libc.stdlib cimport malloc, free
from libcpp cimport bool
import logging
from enum import Enum

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

cdef class Buffer:
    cdef unsigned short* buffer
    cdef public d2kdask.U16 _id
    cdef public int card_id


    def __cinit__(self, int card_id, int n_samples = 4000):
        self.card_id = card_id
        self.buffer = <unsigned short *> malloc(n_samples * sizeof(unsigned short))
        cdef int err = d2kdask.D2K_AI_ContBufferSetup(card_id, self.buffer, n_samples, &self._id)
        error(err)
    
    def __dealloc__(self):
        free(self.buffer)
        d2kdask.D2K_AI_ContBufferReset(self.card_id)
        logging.info("Dealocating buffer {}".format(self._id))



cdef class D200X:
    cdef int card_id
    cdef Buffer buffer

    def __cinit__(self, int card_type, int card_num):
        self.card_id = d2kdask.D2K_Register_Card(card_type, card_num)
        if self.card_id < 0:
            raise AdlinkException("Error registering card: {}".format(self.card_id))
        self.buffer = Buffer(self.card_id)

    def __dealloc__(self):
        logging.info("Dealocating D200X card {}".format(self.card_id))
        d2kdask.D2K_Release_Card(self.card_id)


    def ai_channel_config(self, int channel, int range):
        cdef int err = d2kdask.D2K_AI_CH_Config(self.card_id, channel, range)
        if err != d2kdask.NoError:
            raise AdlinkException("Error configuring channel {}: {}".format(channel, err))
    
    def ai_config(self, 
                    config_control: ADConversionSourceSelection,
                    trigger_control: Trigger,
                    int middle_or_delay_scans,
                    int m_counter,
                    int re_trigger_counter,
                    d2kdask.BOOLEAN auto_reset_buf):
        cdef int err = d2kdask.D2K_AI_Config(self.card_id, config_control.value, trigger_control.value, 
                            middle_or_delay_scans, m_counter, re_trigger_counter, auto_reset_buf)
        
        error(err)

    def ai_continuous_scan_to_file(self, filename: str, int largest_channel, int read_scans, int scan_interval, int sample_interval):
        err = d2kdask.D2K_AI_ContScanChannelsToFile(self.card_id, largest_channel, self.buffer._id, filename, read_scans, scan_interval, sample_interval, d2kdask.SYNCH_OP)
        if err == d2kdask.NoError:
            return d2kdask.NoError
        else:
            raise AdlinkException("Error in ai_continuous_scan_to_file")


    def ao_channel_config(self, channel: OutputChannel, output_polarity: Polarity, reference: Reference, ref_voltage: float):
        err = d2kdask.D2K_AO_CH_Config(self.card_id, channel.value, output_polarity.value, reference.value, ref_voltage)
        error(err)


    def ao_voltage_write_channel(self, channel: OutputChannel, voltage: float):
        err = d2kdask.D2K_AO_VWriteChannel(self.card_id, channel.value, voltage)
        error(err)

        
        
