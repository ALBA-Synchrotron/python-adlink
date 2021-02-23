cimport d2kdask
from d2kdask import U8, U16, U32, I16, U16
from libc.stdlib cimport malloc, free
import logging
from enum import Enum

class AdlinkException(Exception):
    pass

class InvalidCardNumber(AdlinkException):
    pass

class CardNotRegistered(AdlinkException):
    pass

class FunctionalityNotSupported(AdlinkException):
    pass

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


cdef class Buffer:
    cdef unsigned short* buffer
    cdef public d2kdask.U16 buffer_id
    cdef public int card_id


    def __cinit__(self, int card_id, int n_samples = 4000):
        self.card_id = card_id
        self.buffer = <unsigned short *> malloc(n_samples * sizeof(unsigned short))
        err = d2kdask.D2K_AI_ContBufferSetup(card_id, self.buffer, n_samples, &self.buffer_id)
    
    def __dealloc__(self):
        free(self.buffer)
        d2kdask.D2K_AI_ContBufferReset(self.card_id)
        logging.info("Dealocating buffer {}".format(self.buffer_id))



cdef class D200X:
    def __cinit__(self, int card_type, int card_num):
        self.card_id = d2kdask.D2K_Register_Card(card_type, card_num)
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
                    middle_or_delay_scans: int,
                    m_counter: int,
                    re_trigger_counter: int,
                    auto_reset_buf: bool):
        cdef int err = d2kdask.D2K_AI_Config(self.card_id, config_control, trigger_control, 
                            middle_or_delay_scans, m_counter, re_trigger_counter, auto_reset_buf)
        
        if err == d2kdask.NoError:
            return d2kdask.NoError
        elif err == d2kdask.ErrorInvalidCardNumber:
            raise InvalidCardNumber()
        elif err == d2kdask.ErrorCardNotRegistered:
            raise CardNotRegistered()
        elif err == d2kdask.ErrorFuncNotSupport:
            raise FunctionalityNotSupported()

