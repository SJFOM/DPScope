Attribute VB_Name = "DPScope_Startup"
Option Explicit

Public Const VERSIONTEXT = "Version 1.0.10 (Build 2015-01-02)"

Public Const DEFAULT_DPI = 96

Public Const CURSOR_POS_TOLERANCE As Double = 0.02

Public Const NOMINAL_SUPPLY As Double = 5#
Public ActualSupplyVoltage As Double
Public SupplyVoltageRatio As Double

Enum SCOPE_COMMAND
    
    CMD_PING = 2            ' requests echo from controller
    CMD_REVISION = 3        ' requests firmware revision number from controller
    
    CMD_ARM = 5             ' sets all acquisition parameters and starts acquisition
    CMD_DONE = 6            ' query whether scope has alreadye finished the acquisition
    CMD_ABORT = 7           ' disarms the scope, so it's read for a new command
    CMD_READBACK = 8        ' initiates readback of acquired record
    CMD_READADC = 9         ' reads back ADC directly (with 10 bit resolution, returns 2 bytes per channel)
    
    CMD_STATUS_LED = 10     ' turn the status LED on the front panel on/off
    
    CMD_WRITE_MEM = 11      ' restrict to SFR (don't allow program memory access)
    CMD_READ_MEM = 12       ' restrict to SFR (don't allow program memory access)
    
    CMD_WRITE_EEPROM = 13   ' writes one byte to the EEPROM
    CMD_READ_EEPROM = 14    ' reads one byte from the EEPROM

    CMD_READ_LA = 15        ' reads back logic analyzer pins directly
    CMD_ARM_LA = 16         ' sets logic analyzer acquisition parameters (sample rate, trigger condition)
    
    CMD_INIT = 17           ' re-initialize scope
    
    CMD_CLOCK = 18          ' set up external trigger input as a clock output
    
End Enum

Enum LA_SAMPLE_FUNC

    LA_SAMPLE_SLOW = 0
    LA_SAMPLE_200K = 1
    LA_SAMPLE_500K = 2
    LA_SAMPLE_1M = 3

End Enum

Enum TRIGGER_SOURCE

    TRIGGER_SOURCE_AUTO = 0
    TRIGGER_SOURCE_CH1 = 1
    TRIGGER_SOURCE_EXT = 2
    
End Enum

Enum TRIGGER_POLARITY
    TRIGGER_RISING = 0
    TRIGGER_FALLING = 1
End Enum

Enum LA_TRIGGER_POLARITY
    LA_TRIG_FALLING = 0
    LA_TRIG_RISING = 1
    LA_TRIG_AUTO = 2
End Enum

Enum HOR_UNITS

    HOR_UNITS_TIME = 1
    HOR_UNITS_FREQ = 2
    
End Enum

Enum MEAS_TYPE

    MEAS_TYPE_LOW = 0
    MEAS_TYPE_HIGH = 1
    MEAS_TYPE_MID = 2
    MEAS_TYPE_DC_MEAN = 3
    MEAS_TYPE_AMPLITUDE = 4
    MEAS_TYPE_AC_RMS = 5
    MEAS_TYPE_RISE_TIME = 6
    MEAS_TYPE_FALL_TIME = 7
    MEAS_TYPE_PERIOD = 8
    MEAS_TYPE_FREQUENCY = 9
    MEAS_TYPE_DUTY_CYCLE = 10
    MEAS_TYPE_POS_WIDTH = 11
    MEAS_TYPE_NEG_WIDTH = 12
    
End Enum

Enum MEAS_UPDATE_RATE

    MEAS_UPDATE_MAX = 0
    MEAS_UPDATE_5_Hz = 1
    MEAS_UPDATE_2_Hz = 2
    MEAS_UPDATE_1_Hz = 3
    
End Enum

Public Const SAMPLE_MODE_RT As Byte = 0
Public Const SAMPLE_MODE_ET As Byte = 1

Public Const SAMPLE_RATE_50k As Long = 5

Public Const LA_TRIGGER_MASK_CH1 As Long = 128
Public Const LA_TRIGGER_MASK_CH2 As Long = 64
Public Const LA_TRIGGER_MASK_CH3 As Long = 32
Public Const LA_TRIGGER_MASK_CH4 As Long = 16

Public Const PI__ As Double = 3.14159265358979

Public Const PROBE_1_TO_10_DELTA As Long = 25 ' real value would be 12.5, but we have to live with integer steps

' ADC acquisition parameters
Public Const ADCS As Long = 2 ' 5 (FOSC/16) is the fastest that seems to work (outside spec!); maybe use 2 (FOSC/32) instead (still a bit outside spec)
Public Const ACQT As Long = 5 ' minimal valid values: >= 3 for FOSC/64; >=5 (12 Tad) for FOSC/32; 7 (20 Tad) for FOSC/16
                              ' Fosc=48 MHz, ADCS 6 = FOSC/64, ACQT 3 =  6 Tad --> Tacq_min = 64 * (11 +  6 + 2) / 48 = 25.33 us
                              ' Fosc=48 MHz, ADCS 2 = FOSC/32, ACQT 5 = 12 Tad --> Tacq_min = 32 * (11 + 12 + 2) / 48 = 16.67 us
                              ' Fosc=48 MHz, ADCS 5 = FOSC/16, ACQT 7 = 20 Tad --> Tacq_min = 16 * (11 + 20 + 2) / 48 = 11.00 us

Public Const FFTScaleVal_LINEAR As Long = 1
Public Const FFTScaleVal_LOGARITHMIC As Long = 2

Public Const FFTDisplayVal_VOLTAGE As Long = 1
Public Const FFTDisplayVal_POWER As Long = 2

Public Const FFTFilterVal_NONE As Long = 1
Public Const FFTFilterVal_HAMMING As Long = 2
Public Const FFTFilterVal_HANNING As Long = 3
Public Const FFTFilterVal_BLACKMAN As Long = 4

Public Const MIN_EDGE_SEPARATION As Long = 3

Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Declare Function GetTickCount Lib "kernel32" () As Long

Public Const BLOCK_LEN As Long = 64 ' USB HID packet size
Public Const FULL_RECORD_LENGTH As Long = 256
Public Const FULL_RECORD_LENGTH_LA As Long = 1024
Public Const FULL_RECORD_LENGTH_FFT As Long = 410 ' could now go up to 410
'Public Const FULL_READBACK_LENGTH As Long = 194 ' 19 units @ 10 samples each, plus end point
Public Const FULL_READBACK_LENGTH As Long = 205 ' 20 units @ 10 samples each, plus end point & some spares
Public Const DATA_ARRAY_SIZE = 10000
Public Const DATA_ARRAY_SIZE_FFT As Long = 512
'Public Const NO_OF_UNITS = 19
Public Const NO_OF_UNITS = 20
Public Const NO_OF_UNITS_FFT = 25
Public Const NO_OF_UNITS_Y = 12
Public Const LA_TRACE_SPACING = 100 / NO_OF_UNITS_Y
Public Const LA_TRACE_SWING = LA_TRACE_SPACING * 0.7

Public Const INPUT_ATTENUATION As Double = 0.25
Public Const OFFSET_SCALE_FACTOR As Double = 3#

Public Const val_min As Long = 0
Public Const val_max As Long = 100

Public Const BOLD_LINE_WIDTH As Long = 3

' signal records; odd columns are x-axis, even columns are y-axis (CH1, CH2, REF1, REF2, logic analyzer)
Public DataBuffer(1 To DATA_ARRAY_SIZE, 1 To 10) As Double
Public DataBuffer_raw(1 To DATA_ARRAY_SIZE, 1 To 10) As Double
    
Public time_min_idx As Long, time_max_idx As Long
Public level_min_idx As Long, level_max_idx As Long

Public init_flag As Boolean
Public update_flag As Boolean
Public eeprom_access As Boolean
Public plot_updates_enabled As Boolean

Public VertCursor1 As Double, VertCursor2 As Double, HorCursor1 As Double, HorCursor2 As Double
Public VertCursorDelta As Double, HorCursorDelta As Double

Public SampleRateIdx As Long
Public TimeAxisScale As Double, FreqAxisScale As Double

Public FFTScaleVal As Long, FFTDisplayVal As Long, FFTFilterVal As Long

Public GainCH1_old As Long, GainCH2_old As Long

Public IntervalInTicks As Long

Public RollModeLogFilename As String

Public FirmwareRevisionMajor As Long, FirmwareRevisionMinor As Long
Public FirmwareRevision As Long ' hold revision as single number
Public FirmwareRevisionText As String

Public MeasRefLow(8) As Double, MeasRefHigh(8) As Double, MeasRefMid(8) As Double
Public MeasEdge1(8) As Double, MeasEdge2(8) As Double, MeasEdge3(8) As Double

Public SamplingMode As Long
Public SampleInterval As Long
Public PrescalerBypass As Long
Public PrescalerSelection As Long
Public TimerPreloadHigh As Long
Public TimerPreloadLow As Long
Public LA_Sample_Function As Long

Public Sub Main()

    Dim i As Long

    frmAbout.lblVersion = VERSIONTEXT
    
    init_flag = True
    update_flag = False
    plot_updates_enabled = True
    
    Call open_comm_port
    
    Call InitMainpanel
    
    
'    While True
'        Call MainPanel.SendCommand(CMD_SERIAL_TX, &H55)
'        DoEvents
'        Call MainPanel.SendCommand(CMD_SERIAL_TX, &HAA)
'        DoEvents
'    Wend

'Playground.Show
'DMM_Display.Show

    MainPanel.Show
    
End Sub

Public Sub InitMainpanel()

    DMM_Display.DMM_Measurement_ListIndex = MEAS_TYPE_DC_MEAN
    DMM_Display.DMM_UpdateRate_ListIndex = MEAS_UPDATE_2_Hz
    DMM_Display.DMM_Chan = 1
    
    With MainPanel
    
        Call .UpdatePlot
        Call .InitGainCH1_Combo
        Call .InitGainCH2_Combo
        
        .HorCursorScrollbar1.SmallChange = 50
        .HorCursorScrollbar1.LargeChange = 250
        .HorCursorScrollbar2.SmallChange = 50
        .HorCursorScrollbar2.LargeChange = 250
        
        .VertCursorScrollbar1.SmallChange = 50
        .VertCursorScrollbar1.LargeChange = 200
        .VertCursorScrollbar2.SmallChange = 50
        .VertCursorScrollbar2.LargeChange = 200
        
        time_min_idx = 0
        time_max_idx = NO_OF_UNITS ' 10 points per div
                
        .AcqAvg.ListIndex = 0
        .AcqCount = 0
        
        .CursorCH1 = True
        .CursorCH2 = False
        .Cursors = 0
        
        .TriggerAuto = True
        .TriggerRising = True
        
        .LA_Trigger_Auto = True
        .LA_Trigger_Rising = True
        
        Call .SetHorAxisUnits(HOR_UNITS_TIME)
        
        .TimeBase.ListIndex = 6 ' 20 kSamples/sec
        
        .GainCH1.ListIndex = 0 ' gain = 1 ==> 1V/div, 20V range
        .GainCH2.ListIndex = 0 ' gain = 1 ==> 1V/div, 20V range
        
        GainCH1_old = .GainCH1.ListIndex
        GainCH2_old = .GainCH2.ListIndex
        
        .OffsetCH1 = .OffsetCH1.Max / 2 ' puts it in center
        .OffsetCH2 = .OffsetCH2.Max / 2 ' puts it in center
        
        .TriggerLevel = (.TriggerLevel.Max - .TriggerLevel.Min) / 2
        
        .DoFFT = vbUnchecked
        
        Call .scale_x_axis(time_min_idx, time_max_idx)
        Call .scale_y_axis
        
        .TriggerAuto_old = True
        .TriggerCH1_old = False
        .TriggerExt_old = False
        .ChangeOfTimebase = False
        
    End With

    FFTScaleVal = FFTScaleVal_LINEAR
    FFTDisplayVal = FFTDisplayVal_VOLTAGE
    FFTFilterVal = FFTFilterVal_HAMMING
    
    init_flag = False
    
    Call MainPanel.ScopeMode_Click
    
    Call MainPanel.Cursors_Click
    
    Call MainPanel.UpdatePlot

    RollModeLogFilename = ""

    ' determine actual USB supply voltage (to use it for correction of offset values and possibly scaling)
    ' do this only for firmware V2.1 or later (otherwise user would always have to disconnect probes at startup)
    ActualSupplyVoltage = NOMINAL_SUPPLY
    
    If FirmwareRevision >= 201 Then
        ActualSupplyVoltage = MainPanel.GetSupplyVoltage(False)
        If ActualSupplyVoltage < 0 Then ActualSupplyVoltage = NOMINAL_SUPPLY
    End If
        
    SupplyVoltageRatio = ActualSupplyVoltage / NOMINAL_SUPPLY
    
    MainPanel.TimeBaseListIndex_old = MainPanel.TimeBase.ListIndex
    
    MainPanel.TriggerAuto = True
    
    ' do a silent re-init of the scope
    'HID_WriteData(1) = CMD_INIT
    'Call HID_Write_And_Read
    'Sleep 10
    
End Sub

Public Sub open_comm_port()

    Dim response_len As Long
    Dim response As String
        
    Dim sValues As String
    Dim sHandle As String
    Dim iPos As Long
    Dim OldLatency As Long
    Dim success As Long
    Dim i As Long
    
    
    MyDeviceDetected = FindTheHid
    
    If MyDeviceDetected Then
        
        ' read back firmware revision
        FirmwareRevisionMajor = 1 ' default
        FirmwareRevisionMinor = 0 ' default
            
        HID_WriteData(1) = CMD_REVISION
        Call HID_Write_And_Read
        FirmwareRevisionMajor = HID_ReadData(1)
        FirmwareRevisionMinor = HID_ReadData(2)
            
'        .Output = Chr(CMD_REVISION)
'
'        Sleep 30
'        response_len = .InBufferCount
'
'        If response_len > 0 Then
'            .InputLen = response_len
'            response = .Input
'
'            If response_len = 2 Then ' early scope versions return only command acknowledgement
'                FirmwareRevisionMajor = Asc(Mid(response, 1, 1))
'                FirmwareRevisionMinor = Asc(Mid(response, 2, 1))
'            End If
'
'        End If
            
        frmAbout.LblScopeFirmware = "Scope Firmware Version V" & FirmwareRevisionMajor & "." & FirmwareRevisionMinor
        FirmwareRevisionText = frmAbout.LblScopeFirmware
        
    Else
            
        Call Close_the_HID
        
        MsgBox ("Could not find any instrument attached to the computer. Please make sure the unit is turned on and connected to the computer.")
            
        MainPanel.RunScan.Enabled = False
        
        FirmwareRevisionMajor = 0
        FirmwareRevisionMinor = 0
        
        frmAbout.LblScopeFirmware = "Scope Firmware Version n/a"
        FirmwareRevisionText = frmAbout.LblScopeFirmware
            
    End If
                  
    FirmwareRevision = 100 * FirmwareRevisionMajor + FirmwareRevisionMinor
    
End Sub


