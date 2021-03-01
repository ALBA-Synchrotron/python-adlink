cdef extern from "d2kdask.h":
    ctypedef short I16
    ctypedef unsigned short U16
    ctypedef unsigned char U8
    ctypedef unsigned long U32
    ctypedef double F64
    ctypedef enum BOOLEAN: TRUE, FALSE

    I16  D2K_Register_Card (U16 CardType, U16 card_num)
    I16  D2K_AI_CH_Config (U16 wCardNumber, U16 wChannel, U16 wAdRange_RefGnd)
    I16  D2K_Release_Card  (U16 CardNumber)
    I16  D2K_AI_Config (U16 wCardNumber, U16 ConfigCtrl, U32 TrigCtrl, U32 MidOrDlyScans, U16 MCnt, U16 ReTrgCnt, BOOLEAN AutoResetBuf)
    I16  D2K_AI_ContBufferSetup (U16 wCardNumber, void*  pwBuffer, U32 dwReadCount, U16* BufferId)
    I16  D2K_AI_ContScanChannelsToFile (U16 CardNumber, U16 Channel, U16 BufId,
               U8* FileName, U32 ScanCount, U32 ScanIntrv, U32 SampIntrv, U16 SyncMode)
    I16  D2K_AI_ContBufferReset (U16 wCardNumber)
    I16  D2K_AI_ContReadChannelToFile (U16 CardNumber, U16 Channel, U16 BufId,
               U8 *FileName, U32 ScanCount, U32 ScanIntrv, U32 SampIntrv, U16 SyncMode)

    I16 D2K_AO_Config (U16 wCardNumber, U16 ConfigCtrl, U16 TrigCtrl, U16 ReTrgCnt, U16 DLY1Cnt, U16 DLY2Cnt, BOOLEAN AutoResetBuf);
    # Analog output functions
    I16 D2K_AO_CH_Config (U16 wCardNumber, U16 wChannel, U16 wOutputPolarity, U16 wIntOrExtRef, F64 refVoltage)
    I16 D2K_AO_VWriteChannel (U16 CardNumber, U16 Channel, F64 Voltage)
    I16 D2K_AO_ContBufferSetup (U16 CardNumber, void *Buffer, U32 WriteCount, U16 *BufferId)
    I16 D2K_AO_ContWriteChannel (U16 CardNumber, U16 Channel, U16 BufId, U32 UpdateCount, U32 Iterations, U32 CHUI, U16 definite, U16 SyncMode)
    I16 D2K_AO_Group_Setup (U16 wCardNumber, U16 group, U16 wNumChans, U16 *pwChans)

    I16 D2K_AO_AsyncCheck (U16 CardNumber, BOOLEAN *Stopped, U32 *AccessCnt)
    I16 D2K_AO_AsyncClear (U16 CardNumber, U32 *AccessCnt, U16 stop_mode)

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

    # Synch/Asynch Operation Modes
    cdef int SYNCH_OP
    cdef int ASYNCH_OP

    # Return Codes
    cdef int NoError
    cdef int ErrorInvalidCardNumber
    cdef int ErrorCardNotRegistered
    cdef int ErrorFuncNotSupport
    cdef int ErrorTransferCountTooLarge
    cdef int ErrorContIoNotAllowed
    cdef int ErrorInvalidDaRefVoltage
    cdef int ErrorDaVoltageOutOfRange

    # Reference
    cdef int DAQ2K_DA_Int_REF
    cdef int DAQ2K_DA_Ext_REF

    # AD Ranges
    cdef int AD_B_10_V    
    cdef int AD_B_5_V     
    cdef int AD_B_2_5_V   
    cdef int AD_B_1_25_V  
    cdef int AD_B_0_625_V 
    cdef int AD_B_0_3125_V
    cdef int AD_B_0_5_V   
    cdef int AD_B_0_05_V  
    cdef int AD_B_0_005_V 
    cdef int AD_B_1_V     
    cdef int AD_B_0_1_V   
    cdef int AD_B_0_01_V  
    cdef int AD_B_0_001_V 
    cdef int AD_U_20_V    
    cdef int AD_U_10_V    
    cdef int AD_U_5_V     
    cdef int AD_U_2_5_V   
    cdef int AD_U_1_25_V  
    cdef int AD_U_1_V     
    cdef int AD_U_0_1_V   
    cdef int AD_U_0_01_V  
    cdef int AD_U_0_001_V 
    cdef int AD_B_2_V     
    cdef int AD_B_0_25_V  
    cdef int AD_B_0_2_V   
    cdef int AD_U_4_V     
    cdef int AD_U_2_V     
    cdef int AD_U_0_5_V   
    cdef int AD_U_0_4_V

    # Cards
    cdef int DAQ_2010
    cdef int DAQ_2205
    cdef int DAQ_2206
    cdef int DAQ_2005
    cdef int DAQ_2204
    cdef int DAQ_2006
    cdef int DAQ_2501
    cdef int DAQ_2502
    cdef int DAQ_2208
    cdef int DAQ_2213 
    cdef int DAQ_2214 
    cdef int DAQ_2016 
    cdef int DAQ_2020 
    cdef int DAQ_2022 

    # Output polarity
    cdef int DAQ2K_DA_BiPolar
    cdef int DAQ2K_DA_UniPolar

    # Terminate modes
    cdef int DAQ2K_DA_TerminateImmediate
    cdef int DAQ2K_DA_TerminateUC
    cdef int DAQ2K_DA_TerminateIC

################################################################################
# AO Config
################################################################################

    # D/A R/W Source selection
    cdef int DAQ2K_DA_WRSRC_Int
    cdef int DAQ2K_DA_WRSRC_AFI0
    cdef int DAQ2K_DA_WRSRC_AFI1
    cdef int DAQ2K_DA_WRSRC_SSI

    # DA Group Selection
    cdef int DA_Group_A
    cdef int DA_Group_B
    cdef int DA_Group_AB

    # D/A Trigger delay Counter Source Selection
    cdef int DAQ2K_DA_TDSRC_Int
    cdef int DAQ2K_DA_TDSRC_AFI0
    cdef int DAQ2K_DA_TDSRC_GPTC0
    cdef int DAQ2K_DA_TDSRC_GPTC1

    # D/A Break delay Counter Source Selection
    cdef int DAQ2K_DA_BDSRC_Int
    cdef int DAQ2K_DA_BDSRC_AFI0
    cdef int DAQ2K_DA_BDSRC_GPTC0
    cdef int DAQ2K_DA_BDSRC_GPTC1

    # Trigger Source Selection
    cdef int DAQ2K_DA_TRGSRC_SOFT
    cdef int DAQ2K_DA_TRGSRC_ANA
    cdef int DAQ2K_DA_TRGSRC_ExtD
    cdef int DAQ2K_DA_TRSRC_SSI

    # Trigger Mode Selection
    cdef int DAQ2K_DA_TRGMOD_POST
    cdef int DAQ2K_DA_TRGMOD_DELAY

    # Re-Trigger Mode Enable
    cdef int DAQ2K_DA_ReTrigEn

    # Delay2 (Break delay) Mode Enable
    cdef int DAQ2K_DA_DLY2En

    # Delay1 Source Selection
    cdef int DAQ2K_DA_Dly1InUI
    cdef int DAQ2K_DA_Dly1InTimebase

    # Delay2 Source Selection
    cdef int DAQ2K_DA_Dly2InUI
    cdef int DAQ2K_DA_Dly2InTimebase

    # External digital trigger polarity
    cdef int DAQ2K_DA_TrgPositive
    cdef int DAQ2K_DA_TrgNegative
