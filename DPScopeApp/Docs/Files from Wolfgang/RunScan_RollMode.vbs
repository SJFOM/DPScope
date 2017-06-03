Public Sub RunScan_RollMode()

    Dim i As Long, i_row As Long, i_col As Long

    Dim i_col_start As Long, i_col_end As Long
    Dim d_dummy As Double
    
    Dim s_Data As String
    
    Dim OffsetCH1_old As Long, OffsetCH2_old As Long
    Dim ScaleFactorY_CH1 As Double, ScaleFactorY_CH2 As Double, ScaleFactorY As Double
    Dim SampleRateIdx_old As Long
    
    Dim RecordLength As Long

        
    Dim FirstLoop As Boolean
    Dim SetupChanged As Boolean
    Dim FirstAcq As Boolean
    
    Dim ADC1_Val As Double, ADC2_Val As Double
    Dim LA_Val As Long
    Dim GndPosCH1 As Double, GndPosCH2 As Double
    Dim GndPosCH1_scaled As Double, GndPosCH2_scaled As Double
    
    Dim SampleCounter As Long
    
    Dim TicksGoal As Long
    
    ' force setting of values in first pass
    GainCH1_old = -1
    GainCH2_old = -1
    OffsetCH1_old = -1
    OffsetCH2_old = -1
    SampleRateIdx_old = 1000

        
    ' disable all "dangerous" controls
    Call LockDisplayControls(True)
    
    ScanRunning = True
    FirstLoop = True
    FirstAcq = True
    
    SampleCounter = 0
    
    Call ClearData_Click
        
    While ScanRunning
                         
        CommandTimeout = False
        
        SetupChanged = False
        
        SampleRateIdx = TimeBase.ListIndex
        
        If (SampleRateIdx_old <> SampleRateIdx) Then
                                                                    
            SampleRateIdx_old = SampleRateIdx
            
            SetupChanged = True
            
            Call ClearData_Click
            FirstAcq = True
            
            time_max_idx = NO_OF_UNITS ' 10 points per div
            Call scale_x_axis(time_min_idx, time_max_idx)
            Call scale_y_axis

                                
            For i_row = 1 To FULL_RECORD_LENGTH
                DataBuffer(i_row, 1) = i_row - 1
                DataBuffer(i_row, 3) = i_row - 1
                DataBuffer(i_row, 5) = i_row - 1
                DataBuffer(i_row, 7) = i_row - 1
                DataBuffer(i_row, 9) = i_row - 1
            Next i_row
                    
            RecordLength = FULL_READBACK_LENGTH
        
            ' keep track when next sample shall be acquired
            TicksGoal = GetTickCount()
        
        End If
                        
        DoEvents
        
        If FirstLoop Then
            
            'Call Playground.ADCTimerStart

            
            FirstLoop = False
            SetupChanged = False
        
        End If
                    
        If ScanRunning = False Then
            GoTo RollmodeEnd
        End If
                                    
        'ADCS = 2 ' 5 (FOSC/16) is the fastest that seems to work (outside spec!); maybe use 2 (FOSC/32) instead (still a bit outside spec)
        'ACQT = 5 ' minimal valid values: >= 3 for FOSC/64; >=5 (12 Tad) for FOSC/32; 7 (20 Tad) for FOSC/16
        
        ' Fosc=48 MHz, ADCS 6 = FOSC/64, ACQT 3 =  6 Tad --> Tacq_min = 64 * (11 +  6 + 2) / 48 = 25.33 us
        ' Fosc=48 MHz, ADCS 2 = FOSC/32, ACQT 5 = 12 Tad --> Tacq_min = 32 * (11 + 12 + 2) / 48 = 16.67 us
        ' Fosc=48 MHz, ADCS 5 = FOSC/16, ACQT 7 = 20 Tad --> Tacq_min = 16 * (11 + 20 + 2) / 48 = 11.00 us
            
        HID_WriteData(1) = CMD_READADC
    
        HID_WriteData(2) = adc_chan_ch1 ' CH1, gain 1 or gain 10
        HID_WriteData(3) = adc_chan_ch2 ' CH2, gain 1 or gain 10
        
        HID_WriteData(4) = 128 + ACQT * 8 + ADCS ' ADC acquisition parameters
        
        Call HID_Write_And_Read
        
        ADC1_Val = 256 * HID_ReadData(1) + HID_ReadData(2)
        ADC2_Val = 256 * HID_ReadData(3) + HID_ReadData(4)
                
        For i_row = 2 To RecordLength
            DataBuffer(i_row - 1, 2) = DataBuffer(i_row, 2) ' CH1
            DataBuffer(i_row - 1, 4) = DataBuffer(i_row, 4) ' CH2
            DataBuffer(i_row - 1, 10) = DataBuffer(i_row, 10) ' LA
        Next i_row

        DataBuffer(RecordLength, 2) = (ADC1_Val - 511) * DatalogScale_CH1
        DataBuffer(RecordLength, 4) = (ADC2_Val - 511) * DatalogScale_CH2

        DataBuffer(RecordLength + 1, 2) = DataBuffer(RecordLength, 2)
        DataBuffer(RecordLength + 1, 4) = DataBuffer(RecordLength, 4)
        
        ' read back logi analyzer state
        HID_WriteData(1) = CMD_READ_LA
        Call HID_Write_And_Read
        LA_Val = HID_ReadData(1)
        DataBuffer(RecordLength, 10) = LA_Val
        DataBuffer(RecordLength + 1, 10) = LA_Val
        
        Call UpdatePlot
        
        If LogToFile = vbChecked Then Call LogDataToFile(SampleCounter, DataBuffer(RecordLength, 2), DataBuffer(RecordLength, 4), LA_Val)
        
        ' determine appropriate time to acquire next sample
        TicksGoal = TicksGoal + IntervalInTicks
        SampleCounter = SampleCounter + 1
        
        If TicksGoal < GetTickCount() Then TicksGoal = GetTickCount()
        
        While ScanRunning And (GetTickCount() < TicksGoal)
            DoEvents
        Wend
        
    Wend
        
RollmodeEnd:


    ' re-enable all "dangerous" controls
    Call LockDisplayControls(False)
    
End Sub
