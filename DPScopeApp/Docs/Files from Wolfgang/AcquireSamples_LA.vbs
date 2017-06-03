Sub AcquireSamples_LA(TimerPreloadHigh As Long, TimerPreloadLow As Long, PrescalerBypass As Long, PrescalerSelection As Long)

    ' ARM parameters (watch out, VB array is 1-based, MikroC array is 0-based)
    '  1: command
    '  5: timer 0 preload high
    '  6: timer 0 preload low
    '  7: timer 0 prescaler bypass (0 = use prescaler, 1 = bypass prescaler)
    '  8: timer 0 prescaler as power of 2 (7=div256, 0=div2): divide = 2^(PS+1)
    '
    HID_WriteData(1) = CMD_ARM_LA
    
    ' use interrupt based sampling or hard loop
    HID_WriteData(4) = LA_Sample_Function

    ' timer preload determines sample rate
    HID_WriteData(5) = TimerPreloadHigh   ' timer 0 preload high
    HID_WriteData(6) = TimerPreloadLow    ' timer 0 preload low
    
    ' timer prescaler
    HID_WriteData(7) = PrescalerBypass    ' prescaler bypass
    HID_WriteData(8) = PrescalerSelection ' prescaler selection
    
    ' Logic analyzer trigger polarity and trigger source
    If LA_Trigger_Auto Then
        
        HID_WriteData(9) = LA_TRIG_AUTO ' polarity (0 = falling, 1 = rising, 2 = force/auto)
        HID_WriteData(10) = 0 ' channel mask (0bxxxx0000) for "interrupt on change", PORTB pins [7:4]
    
    Else ' triggered acquisition
        
        If LA_Trigger_Rising Then
            HID_WriteData(9) = LA_TRIG_RISING ' polarity (0 = falling, 1 = rising, 2 = force/auto)
        Else
            HID_WriteData(9) = LA_TRIG_FALLING ' polarity (0 = falling, 1 = rising, 2 = force/auto)
        End If
        
        If LA_Trigger_CH1 Then
            HID_WriteData(10) = LA_TRIGGER_MASK_CH1 ' channel mask (0bxxxx0000) for "interrupt on change", PORTB pins [7:4]
        ElseIf LA_Trigger_CH2 Then
            HID_WriteData(10) = LA_TRIGGER_MASK_CH2 ' channel mask (0bxxxx0000) for "interrupt on change", PORTB pins [7:4]
        ElseIf LA_Trigger_CH3 Then
            HID_WriteData(10) = LA_TRIGGER_MASK_CH3 ' channel mask (0bxxxx0000) for "interrupt on change", PORTB pins [7:4]
        Else ' CH4
            HID_WriteData(10) = LA_TRIGGER_MASK_CH4 ' channel mask (0bxxxx0000) for "interrupt on change", PORTB pins [7:4]
        End If
        
    End If
    
    ' set arm parameters and arm scope
    Call HID_Write_And_Read

End Sub

