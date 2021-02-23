cdef extern from "d2kdask.h":
    ctypedef short I16
    ctypedef unsigned short U16
    ctypedef unsigned char U8
    ctypedef unsigned long U32
    ctypedef enum BOOLEAN: TRUE, FALSE

    I16  D2K_Register_Card (U16 CardType, U16 card_num)
    I16  D2K_AI_CH_Config (U16 wCardNumber, U16 wChannel, U16 wAdRange_RefGnd)
    I16  D2K_Release_Card  (U16 CardNumber)
    I16  D2K_AI_Config (U16 wCardNumber, U16 ConfigCtrl, U32 TrigCtrl, U32 MidOrDlyScans, U16 MCnt, U16 ReTrgCnt, BOOLEAN AutoResetBuf)
    I16  D2K_AI_ContBufferSetup (U16 wCardNumber, void*  pwBuffer, U32 dwReadCount, U16* BufferId)
    I16  D2K_AI_ContScanChannelsToFile (U16 CardNumber, U16 Channel, U16 BufId,
               U8* FileName, U32 ScanCount, U32 ScanIntrv, U32 SampIntrv, U16 SyncMode)
    I16  D2K_AI_ContBufferReset (U16 wCardNumber)

    # A/D Conversion Source Selection
    cdef int DAQ2K_AI_ADCONVSRC_Int
    cdef int DAQ2K_AI_ADCONVSRC_AFI0
    cdef int DAQ2K_AI_ADCONVSRC_SSI

    # Trigger Source Selection
    cdef int DAQ2K_AI_TRGSRC_SOFT
    cdef int DAQ2K_AI_TRGSRC_ANA
    cdef int DAQ2K_AI_TRGSRC_ExtD
    cdef int DAQ2K_AI_TRSRC_SSI

    # Trigger Mode Selection
    cdef int DAQ2K_AI_TRGMOD_POST
    cdef int DAQ2K_AI_TRGMOD_DELAY
    cdef int DAQ2K_AI_TRGMOD_PRE
    cdef int DAQ2K_AI_TRGMOD_MIDL

    # Delay Source Selection
    cdef int DAQ2K_AI_Dly1InSamples
    cdef int DAQ2K_AI_Dly1InTimebase

    # Re-Trigger Mode Enable
    cdef int DAQ2K_AI_ReTrigEn

    # MCounter Enable
    cdef int DAQ2K_AI_MCounterEn

    # External Trigger Polarity
    cdef int DAQ2K_AI_TrgPositive
    cdef int DAQ2K_AI_TrgNegative

    # Return Codes
    cdef int NoError
    cdef int ErrorInvalidCardNumber
    cdef int ErrorCardNotRegistered
    cdef int ErrorFuncNotSupport