Public Sub RunScan_ScopeMode()

    Dim ACQ_Done As Byte
    Dim i_Block As Long
    Dim i_Counter As Long
    Dim i_Block_max As Long

    Dim i As Long, i_row As Long, i_col As Long, i_chan As Long, i_row_target As Long
    Dim i_col_start As Long, i_col_end As Long
    Dim d_dummy As Double
    Dim dummy1 As Double, dummy2 As Double, dummy3 As Double, dummy4 As Double, dummy5 As Double

    Dim Averages As Long
    Dim WeightOld As Double, WeightNew As Double

    Dim s_Data As String

    Dim TriggerIdx As Long
    Dim RawIdx As Long, TrueIdx As Long

    Dim FirstLoop As Boolean
    Dim SetupChanged As Boolean
    Dim SomethingToDisplay As Boolean
    Dim FirstAcq As Boolean, AlreadyDrawn As Boolean

    Dim SampleRateIdx_old As Long
    Dim TriggerRising_old As Boolean, triggerSource_old As Long, TriggerLevel_old As Long

    Dim FFTSampleBuffer(DATA_ARRAY_SIZE_FFT) As Double, FFTResultBuffer(DATA_ARRAY_SIZE_FFT) As Double
    Dim FFTMaxValue As Double
    Dim DoFFT_old As Long
    Dim FFT_Channel As Long
    Dim AlternateChannel As Long

    Dim ChannelSkew As Double

    Dim row_incr As Long

    Dim ScaleFactorY As Double, OffsetY As Double

    SomethingToDisplay = False

    DoFFT_old = Not DoFFT
    SampleRateIdx_old = -1

    ' disable all "dangerous" controls
    Call LockDisplayControls(True)

    ScanRunning = True

    FirstAcq = True
    AcqCount = 0
    FFT_Channel = 1
    AlternateChannel = 2

    Call ClearData_Click

    While ScanRunning

        SetupChanged = False

        Call UpdateAverages(Averages)

        FirstLoop = True

        ' acquisition loop - repeat until full record is acquired; meanwhile update parameters whenever they change
        Do
            DoEvents

            If SetupChanged Then TriggerLevel_old = -1

            Call UpdateSampleRate(SampleRateIdx_old, DoFFT_old, ChannelSkew, SetupChanged)
            Call UpdateTriggerPolarity(TriggerRising_old, SetupChanged)
            Call UpdateTriggerSource(triggerSource_old, SetupChanged)
            Call UpdateTriggerLevel(TriggerLevel_old, SetupChanged)

            If FirstLoop Or SetupChanged Then

                ' like for FFT, for 50 kSa sec we can alternate channels (i.e. 1 channel per trigger event) - much faster than equivalent time (1 sample per trigger event)
                If (DoFFT_old = vbChecked) Or (SampleRateIdx_old = SAMPLE_RATE_50k) Then ' for FFT, acquire longer record with double the sample rate, but only one channel

                    If FFT_Channel = 1 Then
                        Call AcquireSamples(adc_chan_ch1, adc_chan_ch1, 
                            TimerPreloadHigh, TimerPreloadLow, 
                            PrescalerBypass, PrescalerSelection,
                            sample_shift_ch1, sample_shift_ch1,
                            sample_subtract_ch1 + sample_subtract_delta_ch1, 
                            sample_subtract_ch1 + sample_subtract_delta_ch1,
                            SamplingMode, SampleInterval, comp_input_chan)
                    Else
                        Call AcquireSamples(adc_chan_ch2, adc_chan_ch2, 
                            TimerPreloadHigh, TimerPreloadLow, 
                            PrescalerBypass, PrescalerSelection,
                            sample_shift_ch2, sample_shift_ch2,
                            sample_subtract_ch2 + sample_subtract_delta_ch2, 
                            sample_subtract_ch2 + sample_subtract_delta_ch2,
                            SamplingMode, SampleInterval, comp_input_chan)
                    End If

                Else

                    Call AcquireSamples(adc_chan_ch1, adc_chan_ch2, 
                                        TimerPreloadHigh, TimerPreloadLow,
                                        PrescalerBypass, PrescalerSelection,
                                        sample_shift_ch1, sample_shift_ch2,
                                        sample_subtract_ch1 + sample_subtract_delta_ch1,
                                        sample_subtract_ch2 + sample_subtract_delta_ch2,
                                        SamplingMode, SampleInterval, comp_input_chan)

                End If

                FirstLoop = False
                SetupChanged = False

            End If

            HID_WriteData(1) = CMD_DONE
            Call HID_Write_And_Read
            ACQ_Done = HID_ReadData(1)

        Loop Until (ACQ_Done > 0) Or (ScanRunning = False)

        If SomethingToDisplay And Not AlreadyDrawn Then Call UpdatePlot

        If ScanRunning = False Then Exit Sub

        Call ShowAcqIndicator

        HID_WriteData(1) = CMD_READBACK

        ' full ADC range is 255 steps (8 bit) and covers 5V; we are using only slightly less than half range for display,
        ' i.e. 12 units out of possible 25 --> factor 25/12
        ' full range is 255 and we have want to scale values 0...100 for full screen height --> 100/255 = 1/2.55
        ' scope is trimmed so 0V results in ADC value 128 (mid scale), which on screen should be scaled at 50

        ScaleFactorY = SupplyVoltageRatio * 25# / 12# / 2.55

        i_Counter = 1

        ' for alternate sampling we need only ~half the acquired points
        If SampleRateIdx_old = SAMPLE_RATE_50k Then
            i_Block_max = 3 ' 4 block x 64 bytes/block = 256 bytes, we only need ~210 anyway
        Else
            i_Block_max = 6 ' total of 7 blocks (0...6)
        End If

        ' with BLOCK_LEN = 64, total number of bytes is 64 * 7 = 448, i.e. a bit more than the real number of samples (remainder is garbage - disregard)
        For i_Block = 0 To i_Block_max

            ' read back blocks of data
            HID_WriteData(2) = i_Block
            Call HID_Write_And_Read

            If DoFFT_old = vbChecked Then

                For i = 1 To BLOCK_LEN
                    FFTSampleBuffer(i_Counter) = ((HID_ReadData(i) - 127) * ScaleFactorY)
                    i_Counter = i_Counter + 1
                Next i

            ElseIf SampleRateIdx_old = SAMPLE_RATE_50k Then

                For i = 1 To BLOCK_LEN
                    DataBuffer_raw(i_Counter, AlternateChannel) = ((HID_ReadData(i) - 127) * ScaleFactorY)
                    i_Counter = i_Counter + 1
                Next i

            Else

                For i = 1 To BLOCK_LEN Step 2

                    DataBuffer_raw(i_Counter, 2) = ((HID_ReadData(i) - 127) * ScaleFactorY)
                    DataBuffer_raw(i_Counter, 4) = ((HID_ReadData(i + 1) - 127) * ScaleFactorY)

                    i_Counter = i_Counter + 1

                Next i

            End If

        Next i_Block

        ' do real-time FFT to get power spectrum
        If DoFFT_old = vbChecked Then

            dummy1 = FFTSampleBuffer(1)
            dummy2 = FFTSampleBuffer(2)
            dummy3 = FFTSampleBuffer(3)
            dummy4 = FFTSampleBuffer(4)
            dummy5 = FFTSampleBuffer(5)

            ' interpolate to blow up array size (410) to a power of 2 (512 in this case)
            i_row = FULL_RECORD_LENGTH_FFT - 4
            i_row_target = DATA_ARRAY_SIZE_FFT - 5

            While (i_row >= 1) And (i_row_target >= 1)

                FFTSampleBuffer(i_row_target + 5) = FFTSampleBuffer(i_row + 4)
                FFTSampleBuffer(i_row_target + 4) = 0.2 * FFTSampleBuffer(i_row + 4) + 0.8 * FFTSampleBuffer(i_row + 3)
                FFTSampleBuffer(i_row_target + 3) = 0.4 * FFTSampleBuffer(i_row + 3) + 0.6 * FFTSampleBuffer(i_row + 2)
                FFTSampleBuffer(i_row_target + 2) = 0.6 * FFTSampleBuffer(i_row + 2) + 0.4 * FFTSampleBuffer(i_row + 1)
                FFTSampleBuffer(i_row_target + 1) = 0.8 * FFTSampleBuffer(i_row + 1) + 0.2 * FFTSampleBuffer(i_row)

                i_row = i_row - 4
                i_row_target = i_row_target - 5

            Wend

            ' make sure all points are filled up, even when record length is not multiple of 4
            ' interpolate to blow up array size (410) to a power of 2 (512 in this case)

            FFTSampleBuffer(6) = dummy5
            FFTSampleBuffer(5) = 0.2 * dummy5 + 0.8 * dummy4
            FFTSampleBuffer(4) = 0.4 * dummy4 + 0.6 * dummy3
            FFTSampleBuffer(3) = 0.6 * dummy3 + 0.4 * dummy2
            FFTSampleBuffer(2) = 0.8 * dummy2 + 0.2 * dummy1
            FFTSampleBuffer(1) = dummy1

            Call RealFFT(FFTSampleBuffer(), FFTResultBuffer(), DATA_ARRAY_SIZE_FFT)

            If FFT_Channel = 1 Then
                i_col = 2
            Else
                i_col = 4
            End If

            ' normalize values so they fit on the screen
            FFTMaxValue = 0

            For i_row = 1 To DATA_ARRAY_SIZE_FFT / 2 - 1
                If FFTResultBuffer(i_row) > FFTMaxValue Then
                    FFTMaxValue = FFTResultBuffer(i_row)
                End If
            Next i_row

            If FFTMaxValue = 0 Then FFTMaxValue = 1

            If FFTScaleVal = FFTScaleVal_LINEAR Then

                ' linear scaling, max is always 100%
                For i_row = 1 To DATA_ARRAY_SIZE_FFT / 2
                    DataBuffer_raw(i_row, i_col) = FFTResultBuffer(i_row) * 100# / FFTMaxValue
                Next i_row

            Else

                ' logarithmic scaling, max is always top
                If FFTDisplayVal = FFTDisplayVal_VOLTAGE Then
                    For i_row = 1 To DATA_ARRAY_SIZE_FFT / 2
                        If FFTResultBuffer(i_row) > 0.0000000001 Then
                            DataBuffer_raw(i_row, i_col) = 100 + 400# / NO_OF_UNITS_Y * Log(FFTResultBuffer(i_row) / FFTMaxValue) / Log(10)
                        Else
                            DataBuffer_raw(i_row, i_col) = 0
                        End If
                    Next i_row
                Else ' power
                    For i_row = 1 To DATA_ARRAY_SIZE_FFT / 2
                        If FFTResultBuffer(i_row) > 0.0000000001 Then
                            DataBuffer_raw(i_row, i_col) = 100 + 200# / NO_OF_UNITS_Y * Log(FFTResultBuffer(i_row) / FFTMaxValue) / Log(10)
                        Else
                            DataBuffer_raw(i_row, i_col) = 0
                        End If
                    Next i_row
                End If

            End If

            ' pad the rest of the record
            DataBuffer_raw(1, i_col) = DataBuffer_raw(2, i_col)

        End If

        ' accumulate trace
        If AcqCount > 0 Then
            WeightOld = (Val(AcqCount) - 1) / Val(AcqCount)
            WeightNew = 1 / Val(AcqCount)
        Else
            WeightOld = 0
            WeightNew = 1
        End If

        For i_col = 2 To 4 Step 2

            For i_row = 1 To FULL_RECORD_LENGTH
                DataBuffer(i_row, i_col) = WeightOld * DataBuffer(i_row, i_col) + WeightNew * DataBuffer_raw(i_row, i_col)
            Next i_row

        Next i_col

        SomethingToDisplay = True

        ' make sure first data set gets plotted right away, especially for slow timebase settings
        If FirstAcq Or TimeAxisScale >= 0.01 Then
            FirstAcq = False
            AlreadyDrawn = True
            Call UpdatePlot
        Else
            AlreadyDrawn = False
        End If

        ' only alternate acquisition with both channels turned on needs two repeats per full acquisition
        If (SampleRateIdx_old <> SAMPLE_RATE_50k) Or (ShowCH1 = vbUnchecked) And (ShowCH2 = vbUnchecked) Or (FFT_Channel = 2) Then
            AcqCount = AcqCount + 1
            FrameCount = FrameCount + 1
        End If

        If AcqCount > Averages Then AcqCount = Averages

        If FFT_Channel = 1 And ShowCH2 = vbChecked Then
            FFT_Channel = 2
            AlternateChannel = 4
        ElseIf FFT_Channel = 2 And ShowCH1 = vbChecked Then
            FFT_Channel = 1
            AlternateChannel = 2
        End If

        ' in FFT mode, acquisition is interleaved, so we have to do at least 2 repeats if both channels are to be displayed
        If (RunCont = False) And (AcqCount >= Averages) And Not _
           ((DoFFT_old = vbChecked Or SampleRateIdx_old = SAMPLE_RATE_50k) And (FFT_Channel = 2) And (ShowCH2 = vbChecked)) Then ScanRunning = False

    Wend

    ' plot latest data (especially important if it was a single shot acquisition)
    Call UpdatePlot ' use serial data transfer time to concurrently draw the previous data
    AlreadyDrawn = True

    ' re-enable all "dangerous" controls
    Call LockDisplayControls(False)

End Sub