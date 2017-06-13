Attribute VB_Name = "GlobalFunctions"
Option Explicit

Public Function FormatValueAndUnit(value As Double, Unit As String) As String

    Dim AbsValue As Double
    
    AbsValue = Abs(value)
    
    If AbsValue > 105000000# Then
        FormatValueAndUnit = Format(value / 1000000#, "0") & " M" & Unit
    ElseIf AbsValue > 10500000# Then
        FormatValueAndUnit = Format(value / 1000000#, "0.0") & " M" & Unit
    ElseIf AbsValue > 1050000# Then
        FormatValueAndUnit = Format(value / 1000000#, "0.00") & " M" & Unit
    ElseIf AbsValue > 105000# Then
        FormatValueAndUnit = Format(value / 1000#, "0") & " k" & Unit
    ElseIf AbsValue > 10500# Then
        FormatValueAndUnit = Format(value / 1000#, "0.0") & " k" & Unit
    ElseIf AbsValue > 1050# Then
        FormatValueAndUnit = Format(value / 1000#, "0.00") & " k" & Unit
    ElseIf AbsValue > 105# Then
        FormatValueAndUnit = Format(value, "0") & " " & Unit
    ElseIf AbsValue > 10.5 Then
        FormatValueAndUnit = Format(value, "0.0") & " " & Unit
    ElseIf AbsValue > 1.05 Then
        FormatValueAndUnit = Format(value, "0.00") & " " & Unit
    ElseIf AbsValue > 0.105 Then
        FormatValueAndUnit = Format(value * 1000#, "0") & " m" & Unit
    ElseIf AbsValue > 0.0105 Then
        FormatValueAndUnit = Format(value * 1000#, "0.0") & " m" & Unit
    ElseIf AbsValue > 0.00105 Then
        FormatValueAndUnit = Format(value * 1000#, "0.00") & " m" & Unit
    ElseIf AbsValue > 0.000105 Then
        FormatValueAndUnit = Format(value * 1000000#, "0") & " u" & Unit
    ElseIf AbsValue > 0.0000105 Then
        FormatValueAndUnit = Format(value * 1000000#, "0.0") & " u" & Unit
    ElseIf AbsValue > 0.00000105 Then
        FormatValueAndUnit = Format(value * 1000000#, "0.00") & " u" & Unit
    ElseIf AbsValue > 0.000000105 Then
        FormatValueAndUnit = Format(value * 1000000000#, "0") & " n" & Unit
    ElseIf AbsValue > 0.0000000105 Then
        FormatValueAndUnit = Format(value * 1000000000#, "0.0") & " n" & Unit
    Else
        FormatValueAndUnit = Format(value * 1000000000#, "0.00") & " n" & Unit
    End If
    
End Function

Public Function GetGain(Channel As Long) As Double

    If Channel = 1 Then
    
        Select Case MainPanel.GainCH1.ListIndex
            Case 0: GetGain = 2#    ' 2 V/div
            Case 1: GetGain = 1#    ' 1 V/div
            Case 2: GetGain = 0.5   ' 0.5 V/div
            Case 3: GetGain = 0.2   ' 0.2 V/div
            Case 4: GetGain = 0.1  ' 0.1 V/div
            Case 5: GetGain = 0.05  ' 50 mV/div
        End Select
        
        If MainPanel.ProbeAtten10_CH1 = vbChecked Then GetGain = GetGain * 10
        
    ElseIf Channel = 2 Then
    
        Select Case MainPanel.GainCH2.ListIndex
            Case 0: GetGain = 2#    ' 2 V/div
            Case 1: GetGain = 1#    ' 1 V/div
            Case 2: GetGain = 0.5   ' 0.5 V/div
            Case 3: GetGain = 0.2   ' 0.2 V/div
            Case 4: GetGain = 0.1  ' 0.1 V/div
            Case 5: GetGain = 0.05  ' 50 mV/div
        End Select
        
        If MainPanel.ProbeAtten10_CH2 = vbChecked Then GetGain = GetGain * 10
        
    End If

End Function

Public Function GetOffset(Channel As Long) As Double

    If Channel = 1 Then
        GetOffset = 1 - MainPanel.OffsetCH1 / MainPanel.OffsetCH1.Max
    ElseIf Channel = 2 Then
        GetOffset = 1 - MainPanel.OffsetCH2 / MainPanel.OffsetCH2.Max
    Else
        GetOffset = 0
    End If

End Function

Public Function GetTimebase() As Double

    If MainPanel.ScopeMode Then
    
        Select Case MainPanel.TimeBase.ListIndex
            Case 0: GetTimebase = 0.000005 ' 5us/div
            Case 1: GetTimebase = 0.00001 ' 10us/div
            Case 2: GetTimebase = 0.00002 ' 20us/div
            Case 3: GetTimebase = 0.00005 ' 50us/div
            Case 4: GetTimebase = 0.0001 ' 0.1ms/div
            Case 5: GetTimebase = 0.0002 ' 0.2ms/div
            Case 6: GetTimebase = 0.0005 ' 0.5ms/div
            Case 7: GetTimebase = 0.001 ' 1ms/div
            Case 8: GetTimebase = 0.002 ' 2ms/div
            Case 9: GetTimebase = 0.005 ' 5ms/div
            Case 10: GetTimebase = 0.01 ' 10ms/div
            Case 11: GetTimebase = 0.02 ' 20ms/div
            Case 12: GetTimebase = 0.05 ' 50ms/div
            Case 13: GetTimebase = 0.1 ' 0.1s/div
            Case 14: GetTimebase = 0.2 ' 0.2s/div
            Case 15: GetTimebase = 0.5 ' 0.5s/div
        End Select

    ElseIf MainPanel.LAMode Then
    
        Select Case MainPanel.TimeBase.ListIndex
            Case 0: GetTimebase = 0.00001 ' 10us/div
            Case 1: GetTimebase = 0.00002 ' 20us/div
            Case 2: GetTimebase = 0.00005 ' 50us/div
            Case 3: GetTimebase = 0.0001 ' 0.1ms/div
            Case 4: GetTimebase = 0.0002 ' 0.2ms/div
            Case 5: GetTimebase = 0.0005 ' 0.5ms/div
            Case 6: GetTimebase = 0.001 ' 1ms/div
            Case 7: GetTimebase = 0.002 ' 2ms/div
            Case 8: GetTimebase = 0.005 ' 5ms/div
            Case 9: GetTimebase = 0.01 ' 10ms/div
            Case 10: GetTimebase = 0.02 ' 20ms/div
            Case 11: GetTimebase = 0.05 ' 50ms/div
            Case 12: GetTimebase = 0.1 ' 0.1s/div
            Case 13: GetTimebase = 0.2 ' 0.2s/div
            Case 14: GetTimebase = 0.5 ' 0.5s/div
            Case 15: GetTimebase = 1 ' 1s/div
        End Select
    
    Else
    
        Select Case MainPanel.TimeBase.ListIndex
            Case 0: GetTimebase = 0.5 ' 0.5 s/div
            Case 1: GetTimebase = 1 ' 1 s/div
            Case 2: GetTimebase = 2 ' 2 s/div
            Case 3: GetTimebase = 5 ' 5 s/div
            Case 4: GetTimebase = 10 ' 10 s/div
            Case 5: GetTimebase = 20 ' 20 s/div
            Case 6: GetTimebase = 60 ' 1 min/div
            Case 7: GetTimebase = 120 ' 2 min/div
            Case 8: GetTimebase = 300 ' 5 min/div
            Case 9: GetTimebase = 600 ' 10 min/div
            Case 10: GetTimebase = 1200 ' 20 min/div
            Case 11: GetTimebase = 3600 ' 1 hr/div
        End Select
        
    End If
    
End Function

Public Function GetFreqScale() As Double

    GetFreqScale = 0
    
    Select Case MainPanel.TimeBase.ListIndex
        Case 0: GetFreqScale = 40000#
        Case 1: GetFreqScale = 20000#
        Case 2: GetFreqScale = 10000#
        Case 3: GetFreqScale = 4000#
        Case 4: GetFreqScale = 2000#
        Case 5: GetFreqScale = 1000#
        Case 6: GetFreqScale = 400#
        Case 7: GetFreqScale = 200#
        Case 8: GetFreqScale = 100#
        Case 9: GetFreqScale = 40#
        Case 10: GetFreqScale = 20#
        Case 11: GetFreqScale = 10#
        Case 12: GetFreqScale = 4#
        Case 13: GetFreqScale = 2#
        Case 14: GetFreqScale = 1#
        Case 15: GetFreqScale = 0.4
        Case 16: GetFreqScale = 0.2
    End Select

    GetFreqScale = GetFreqScale
    
End Function

