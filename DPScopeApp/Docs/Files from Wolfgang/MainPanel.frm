VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "ComDlg32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.1#0"; "MSCOMCTL.OCX"
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomct2.ocx"
Begin VB.Form MainPanel 
   BorderStyle     =   0  'None
   Caption         =   "DPScope SE"
   ClientHeight    =   7950
   ClientLeft      =   150
   ClientTop       =   540
   ClientWidth     =   13395
   FillColor       =   &H000000FF&
   FillStyle       =   0  'Solid
   Icon            =   "MainPanel.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   7950
   ScaleWidth      =   13395
   StartUpPosition =   2  'CenterScreen
   Visible         =   0   'False
   Begin VB.Timer DisplayUpdateTimer 
      Enabled         =   0   'False
      Interval        =   200
      Left            =   0
      Top             =   5520
   End
   Begin VB.Frame LA_Trigger_Frame 
      Caption         =   "Logic Trigger"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1575
      Left            =   5910
      TabIndex        =   77
      Top             =   6000
      Width           =   3465
      Begin VB.Frame LA_Trigger_Chan_Frame 
         BorderStyle     =   0  'None
         Caption         =   "Source"
         Height          =   375
         Left            =   870
         TabIndex        =   81
         Top             =   360
         Width           =   2440
         Begin VB.OptionButton LA_Trigger_CH4 
            Caption         =   "4"
            Height          =   375
            Left            =   2040
            TabIndex        =   88
            ToolTipText     =   "Trigger automatically (forces immediate start of acquisition, regardless of channel 1 and 2 signal)"
            Top             =   0
            Width           =   420
         End
         Begin VB.OptionButton LA_Trigger_CH3 
            Caption         =   "3"
            Height          =   375
            Left            =   1590
            TabIndex        =   87
            ToolTipText     =   "Trigger automatically (forces immediate start of acquisition, regardless of channel 1 and 2 signal)"
            Top             =   0
            Width           =   420
         End
         Begin VB.OptionButton LA_Trigger_CH2 
            Caption         =   "2"
            Height          =   375
            Left            =   1140
            TabIndex        =   86
            ToolTipText     =   "Trigger automatically (forces immediate start of acquisition, regardless of channel 1 and 2 signal)"
            Top             =   0
            Width           =   420
         End
         Begin VB.OptionButton LA_Trigger_CH1 
            Caption         =   "1"
            Height          =   375
            Left            =   690
            TabIndex        =   85
            ToolTipText     =   "Trigger automatically (forces immediate start of acquisition, regardless of channel 1 and 2 signal)"
            Top             =   0
            Width           =   420
         End
         Begin VB.OptionButton LA_Trigger_Auto 
            Caption         =   "Auto"
            Height          =   375
            Left            =   0
            TabIndex        =   82
            ToolTipText     =   "Trigger automatically (forces immediate start of acquisition)"
            Top             =   0
            Width           =   660
         End
      End
      Begin VB.Frame LA_Trigger_Polarity_Frame 
         BorderStyle     =   0  'None
         Caption         =   "Polarity"
         Height          =   375
         Left            =   870
         TabIndex        =   78
         Top             =   1000
         Width           =   1800
         Begin VB.OptionButton LA_Trigger_Rising 
            Caption         =   "Rising"
            Height          =   375
            Left            =   0
            TabIndex        =   80
            ToolTipText     =   "Trigger on rising edge (signal crossing trigger level from below)"
            Top             =   0
            Width           =   900
         End
         Begin VB.OptionButton LA_Trigger_Falling 
            Caption         =   "Falling"
            Height          =   375
            Left            =   930
            TabIndex        =   79
            ToolTipText     =   "Trigger on falling edge (signal crossing trigger level from above)"
            Top             =   0
            Width           =   900
         End
      End
      Begin VB.Shape AcqIndicatorLA 
         FillColor       =   &H00008000&
         Height          =   255
         Left            =   2880
         Shape           =   3  'Circle
         Top             =   1200
         Width           =   255
      End
      Begin VB.Label LabelACQ2 
         Alignment       =   2  'Center
         Caption         =   "Trig'd"
         Height          =   255
         Left            =   2640
         TabIndex        =   91
         Top             =   900
         Width           =   735
      End
      Begin VB.Label LA_Lbl_Source 
         Caption         =   "Source:"
         Height          =   255
         Left            =   180
         TabIndex        =   84
         Top             =   420
         Width           =   615
      End
      Begin VB.Label LA_Lbl_Polarity 
         Caption         =   "Polarity:"
         Height          =   255
         Left            =   180
         TabIndex        =   83
         Top             =   1080
         Width           =   735
      End
      Begin VB.Line LA_Line 
         BorderColor     =   &H80000010&
         X1              =   120
         X2              =   3360
         Y1              =   840
         Y2              =   840
      End
   End
   Begin VB.Frame Frame6 
      Caption         =   "Mode"
      ClipControls    =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1580
      Left            =   11400
      TabIndex        =   70
      Top             =   6000
      Width           =   1935
      Begin VB.OptionButton LAMode 
         Caption         =   "Logic Analyzer"
         Height          =   255
         Left            =   120
         TabIndex        =   73
         ToolTipText     =   "Turn on logic analyzer mode "
         Top             =   1180
         Width           =   1703
      End
      Begin VB.OptionButton RollMode 
         Caption         =   "Datalogger"
         Height          =   260
         Left            =   120
         TabIndex        =   72
         ToolTipText     =   "Turn on roll mode (log data as it comes in, scroll screen to the left)"
         Top             =   770
         Width           =   1703
      End
      Begin VB.OptionButton ScopeMode 
         Caption         =   "Oscilloscope"
         Height          =   255
         Left            =   120
         TabIndex        =   71
         ToolTipText     =   "Turn on scope mode (acquire full records)"
         Top             =   360
         Value           =   -1  'True
         Width           =   1695
      End
   End
   Begin VB.Frame Frame4 
      Caption         =   "Vertical"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1575
      Left            =   3000
      TabIndex        =   60
      Top             =   6000
      Width           =   2820
      Begin VB.CheckBox ProbeAtten10_CH2 
         Caption         =   "1:10"
         Height          =   255
         Left            =   2040
         TabIndex        =   93
         Top             =   1050
         Width           =   615
      End
      Begin VB.CheckBox ProbeAtten10_CH1 
         Caption         =   "1:10"
         Height          =   255
         Left            =   2040
         TabIndex        =   92
         Top             =   480
         Width           =   615
      End
      Begin VB.ComboBox GainCH1 
         BackColor       =   &H00C0C0FF&
         ForeColor       =   &H000000FF&
         Height          =   315
         ItemData        =   "MainPanel.frx":0442
         Left            =   720
         List            =   "MainPanel.frx":0444
         Style           =   2  'Dropdown List
         TabIndex        =   63
         ToolTipText     =   "Selects vertical (voltage) scale factor for channel 1"
         Top             =   480
         Width           =   1200
      End
      Begin VB.ComboBox GainCH2 
         BackColor       =   &H00FFC0C0&
         ForeColor       =   &H00FF0000&
         Height          =   315
         ItemData        =   "MainPanel.frx":0446
         Left            =   720
         List            =   "MainPanel.frx":0448
         Style           =   2  'Dropdown List
         TabIndex        =   62
         ToolTipText     =   "Selects vertical (voltage) scale factor for channel 2"
         Top             =   1020
         Width           =   1200
      End
      Begin MSComCtl2.UpDown UpDownGainCH1 
         Height          =   315
         Left            =   480
         TabIndex        =   61
         Top             =   480
         Width           =   255
         _ExtentX        =   450
         _ExtentY        =   556
         _Version        =   393216
         Max             =   5
         Enabled         =   -1  'True
      End
      Begin MSComCtl2.UpDown UpDownGainCH2 
         Height          =   315
         Left            =   480
         TabIndex        =   64
         Top             =   1020
         Width           =   255
         _ExtentX        =   450
         _ExtentY        =   556
         _Version        =   393216
         Max             =   5
         Enabled         =   -1  'True
      End
      Begin VB.Label Label5 
         Caption         =   "CH1:"
         ForeColor       =   &H000000FF&
         Height          =   255
         Left            =   90
         TabIndex        =   66
         Top             =   540
         Width           =   375
      End
      Begin VB.Label Label6 
         Caption         =   "CH2:"
         ForeColor       =   &H00FF0000&
         Height          =   255
         Left            =   90
         TabIndex        =   65
         Top             =   1080
         Width           =   375
      End
   End
   Begin VB.TextBox TrigLvl 
      Height          =   285
      Left            =   6840
      TabIndex        =   59
      Text            =   "0"
      Top             =   5760
      Visible         =   0   'False
      Width           =   735
   End
   Begin VB.PictureBox Plot_Display 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   4862
      Left            =   600
      ScaleHeight     =   4860
      ScaleWidth      =   8175
      TabIndex        =   49
      Top             =   600
      Width           =   8175
      Begin VB.PictureBox PictVertCursor2 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   5000
         Left            =   1200
         ScaleHeight     =   4995
         ScaleWidth      =   15
         TabIndex        =   54
         Top             =   0
         Visible         =   0   'False
         Width           =   15
      End
      Begin VB.PictureBox PictHorCursor2 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   15
         Left            =   0
         ScaleHeight     =   15
         ScaleMode       =   0  'User
         ScaleWidth      =   13379.5
         TabIndex        =   57
         Top             =   1000
         Visible         =   0   'False
         Width           =   8175
      End
      Begin VB.PictureBox PictHorCursor1 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   15
         Left            =   0
         ScaleHeight     =   15
         ScaleMode       =   0  'User
         ScaleWidth      =   13379.5
         TabIndex        =   56
         Top             =   500
         Visible         =   0   'False
         Width           =   8175
      End
      Begin VB.PictureBox PictVertCursor1 
         Appearance      =   0  'Flat
         BackColor       =   &H0000C000&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   5000
         Left            =   800
         ScaleHeight     =   4995
         ScaleWidth      =   15
         TabIndex        =   55
         Top             =   0
         Visible         =   0   'False
         Width           =   15
      End
   End
   Begin VB.Timer RollModeTimer 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   9000
      Top             =   5640
   End
   Begin VB.TextBox FrameRate 
      Alignment       =   2  'Center
      Enabled         =   0   'False
      Height          =   375
      Left            =   7800
      TabIndex        =   47
      Text            =   "0"
      Top             =   5760
      Visible         =   0   'False
      Width           =   615
   End
   Begin VB.Timer FrameTimer 
      Interval        =   5000
      Left            =   9000
      Top             =   0
   End
   Begin VB.Frame Frame5 
      Caption         =   "Position/Level"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   5055
      Left            =   9480
      TabIndex        =   36
      Top             =   2520
      Width           =   1815
      Begin VB.CommandButton CenterOffsetTrig 
         BackColor       =   &H0080FF80&
         Caption         =   "x"
         Height          =   247
         Left            =   1320
         Style           =   1  'Graphical
         TabIndex        =   69
         ToolTipText     =   "Reset Trigger Level to Center (0V)"
         Top             =   640
         Width           =   247
      End
      Begin VB.CommandButton CenterOffsetCH2 
         BackColor       =   &H00FF8080&
         Caption         =   "x"
         Height          =   247
         Left            =   762
         Style           =   1  'Graphical
         TabIndex        =   68
         ToolTipText     =   "Reset CH2 Offset to Center"
         Top             =   640
         Width           =   247
      End
      Begin VB.CommandButton CenterOffsetCH1 
         BackColor       =   &H008080FF&
         Caption         =   "x"
         Height          =   247
         Left            =   234
         MaskColor       =   &H000000FF&
         Style           =   1  'Graphical
         TabIndex        =   67
         ToolTipText     =   "Reset CH1 Offset to Center"
         Top             =   640
         UseMaskColor    =   -1  'True
         Width           =   247
      End
      Begin VB.VScrollBar TriggerLevel 
         Height          =   3990
         LargeChange     =   10
         Left            =   1320
         Max             =   255
         TabIndex        =   21
         Top             =   936
         Width           =   255
      End
      Begin VB.VScrollBar OffsetCH2 
         Height          =   3990
         LargeChange     =   50
         Left            =   762
         Max             =   1000
         SmallChange     =   5
         TabIndex        =   20
         Top             =   936
         Width           =   255
      End
      Begin VB.VScrollBar OffsetCH1 
         Height          =   3990
         LargeChange     =   50
         Left            =   240
         Max             =   1000
         SmallChange     =   5
         TabIndex        =   19
         Top             =   936
         Width           =   255
      End
      Begin VB.Label Label10 
         Alignment       =   2  'Center
         Caption         =   "Trig"
         ForeColor       =   &H00008000&
         Height          =   255
         Left            =   1200
         TabIndex        =   39
         ToolTipText     =   "Trigger level (indicated by green pointer on left display edge)"
         Top             =   345
         Width           =   420
      End
      Begin VB.Label Label9 
         Alignment       =   2  'Center
         Caption         =   "CH2"
         ForeColor       =   &H00FF0000&
         Height          =   260
         Left            =   645
         TabIndex        =   38
         ToolTipText     =   "Channel 2 offset (moves channel 2 waveform vertically)"
         Top             =   364
         Width           =   494
      End
      Begin VB.Label Label4 
         Alignment       =   2  'Center
         Caption         =   "CH1"
         ForeColor       =   &H000000FF&
         Height          =   260
         Left            =   117
         TabIndex        =   37
         ToolTipText     =   "Channel 1 offset (moves channel 1 waveform vertically)"
         Top             =   364
         Width           =   481
      End
   End
   Begin VB.Frame TimeBaseFrame 
      Caption         =   "Horizontal"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1575
      Left            =   120
      TabIndex        =   34
      Top             =   6000
      Width           =   2775
      Begin VB.HScrollBar LA_Hor_Pos 
         Height          =   300
         LargeChange     =   200
         Left            =   120
         Max             =   640
         SmallChange     =   10
         TabIndex        =   76
         Top             =   1080
         Width           =   2535
      End
      Begin VB.ComboBox TimeBase 
         Height          =   315
         ItemData        =   "MainPanel.frx":044A
         Left            =   600
         List            =   "MainPanel.frx":044C
         Style           =   2  'Dropdown List
         TabIndex        =   15
         ToolTipText     =   "Selects time base (number of samples per second)"
         Top             =   360
         Width           =   1695
      End
      Begin MSComCtl2.UpDown UpDownTimeBase 
         Height          =   315
         Left            =   360
         TabIndex        =   42
         Top             =   360
         Width           =   255
         _ExtentX        =   450
         _ExtentY        =   556
         _Version        =   393216
         Max             =   18
         Enabled         =   -1  'True
      End
      Begin VB.Label SampleRate 
         Alignment       =   2  'Center
         Caption         =   "2 MSa/sec ET"
         Height          =   255
         Left            =   240
         TabIndex        =   35
         Top             =   720
         Width           =   2175
      End
   End
   Begin VB.Frame Frame3 
      Caption         =   "Acquisition"
      ClipControls    =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3345
      Left            =   11400
      TabIndex        =   32
      Top             =   2520
      Width           =   1935
      Begin VB.Timer AcqNotificationTimer 
         Enabled         =   0   'False
         Interval        =   200
         Left            =   1440
         Top             =   2880
      End
      Begin VB.CheckBox LogToFile 
         Caption         =   "Log to file"
         Enabled         =   0   'False
         Height          =   375
         Left            =   240
         TabIndex        =   48
         ToolTipText     =   "Write roll mode data into log file in real time"
         Top             =   2760
         Width           =   1455
      End
      Begin VB.ComboBox AcqAvg 
         Height          =   315
         ItemData        =   "MainPanel.frx":044E
         Left            =   480
         List            =   "MainPanel.frx":0468
         Style           =   2  'Dropdown List
         TabIndex        =   4
         ToolTipText     =   "Selects the number of averages"
         Top             =   1980
         Width           =   1215
      End
      Begin VB.CommandButton RunScan 
         Caption         =   "Run"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   345
         Left            =   240
         TabIndex        =   0
         ToolTipText     =   "Starts and stops the acquisition"
         Top             =   360
         Width           =   1455
      End
      Begin VB.Frame Frame1 
         BorderStyle     =   0  'None
         Height          =   615
         Left            =   240
         TabIndex        =   33
         Top             =   1260
         Width           =   1215
         Begin VB.OptionButton RunCont 
            Caption         =   "continuous"
            Height          =   375
            Left            =   0
            TabIndex        =   2
            ToolTipText     =   "Sets acquisition to continuous (acquire over and over)"
            Top             =   0
            Value           =   -1  'True
            Width           =   1455
         End
         Begin VB.OptionButton RunSingle 
            Caption         =   "single shot"
            Height          =   255
            Left            =   0
            TabIndex        =   3
            ToolTipText     =   "Sets acquisition to single shot, i.e. acquires one data set and then stops (use Run button to acquire again)"
            Top             =   360
            Width           =   1425
         End
      End
      Begin VB.CommandButton ClearData 
         Caption         =   "Clear"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   350
         Left            =   240
         TabIndex        =   1
         ToolTipText     =   "Clears (initializes) the data"
         Top             =   840
         Width           =   1455
      End
      Begin MSComCtl2.UpDown UpDownAcqAvg 
         Height          =   315
         Left            =   240
         TabIndex        =   43
         Top             =   1980
         Width           =   255
         _ExtentX        =   450
         _ExtentY        =   556
         _Version        =   393216
         Max             =   6
         Enabled         =   -1  'True
      End
      Begin VB.Label AcqCount 
         Alignment       =   1  'Right Justify
         Caption         =   "---"
         Height          =   285
         Left            =   960
         TabIndex        =   41
         ToolTipText     =   "Shows the number of accumulated acquisitions"
         Top             =   2460
         Width           =   495
      End
      Begin VB.Label Label2 
         Caption         =   "Acqs:"
         Height          =   255
         Left            =   240
         TabIndex        =   40
         Top             =   2460
         Width           =   615
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "Display"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2415
      Left            =   9477
      TabIndex        =   31
      Top             =   0
      Width           =   3855
      Begin VB.CheckBox ClockOutput 
         BackColor       =   &H8000000D&
         Caption         =   "Clk"
         Height          =   255
         Left            =   1680
         TabIndex        =   89
         Top             =   1080
         Visible         =   0   'False
         Width           =   735
      End
      Begin VB.CheckBox ShowLA 
         Caption         =   "Logic Channels"
         ForeColor       =   &H00800080&
         Height          =   315
         Left            =   180
         TabIndex        =   75
         ToolTipText     =   "Turns the display of the four logic channels on and off "
         Top             =   1080
         Value           =   1  'Checked
         Width           =   1680
      End
      Begin VB.CheckBox LinesBold 
         Caption         =   "bold"
         Height          =   255
         Left            =   3000
         TabIndex        =   58
         Top             =   540
         Width           =   795
      End
      Begin VB.CheckBox Persistence 
         Caption         =   "Persist"
         Height          =   255
         Left            =   2760
         TabIndex        =   53
         ToolTipText     =   "Don't clear screen between acquisitions, keep all traces"
         Top             =   1200
         Width           =   975
      End
      Begin VB.CheckBox DisplayVectors 
         Caption         =   "Lines"
         Height          =   255
         Left            =   2760
         TabIndex        =   52
         ToolTipText     =   "Display vectors (join data points with lines)"
         Top             =   240
         Value           =   1  'Checked
         Width           =   855
      End
      Begin VB.CheckBox DisplayDots 
         Caption         =   "Dots"
         Height          =   255
         Left            =   2760
         TabIndex        =   51
         ToolTipText     =   "Display data points as dots"
         Top             =   840
         Width           =   975
      End
      Begin VB.CheckBox DisplayLevels 
         Caption         =   "Levels"
         Height          =   225
         Left            =   2760
         TabIndex        =   50
         ToolTipText     =   "Shows trigger level & position, and waveform level offsets"
         Top             =   1560
         Width           =   975
      End
      Begin VB.CommandButton FFTSetup 
         Caption         =   "Setup"
         Height          =   315
         Left            =   2160
         TabIndex        =   46
         ToolTipText     =   "Set up options for frequency display (FFT)"
         Top             =   1980
         Width           =   832
      End
      Begin VB.CheckBox DoFFT 
         Caption         =   "Frequency Spectrum"
         Height          =   360
         Left            =   180
         TabIndex        =   11
         ToolTipText     =   "Switch between normal display and frequency domain display"
         Top             =   1980
         Width           =   2055
      End
      Begin VB.OptionButton CursorCH2 
         Caption         =   "CH2"
         ForeColor       =   &H00008000&
         Height          =   255
         Left            =   1800
         TabIndex        =   14
         ToolTipText     =   "Cursors refer to channel 2 for voltage scaling"
         Top             =   1560
         Width           =   650
      End
      Begin VB.OptionButton CursorCH1 
         Caption         =   "CH1"
         ForeColor       =   &H00008000&
         Height          =   255
         Left            =   1080
         TabIndex        =   13
         ToolTipText     =   "Cursors refer to channel 1 for voltage scaling"
         Top             =   1560
         Width           =   855
      End
      Begin VB.CheckBox Cursors 
         Caption         =   "Cursors"
         ForeColor       =   &H00008000&
         Height          =   255
         Left            =   180
         TabIndex        =   12
         ToolTipText     =   "Turn waveform cursors on/off"
         Top             =   1560
         Width           =   1215
      End
      Begin VB.CheckBox ShowCH1 
         Caption         =   "CH1"
         ForeColor       =   &H000000FF&
         Height          =   315
         Left            =   180
         TabIndex        =   5
         ToolTipText     =   "Turns the display of scope channel 1 on and off"
         Top             =   300
         Value           =   1  'Checked
         Width           =   765
      End
      Begin VB.CheckBox ShowCH2 
         Caption         =   "CH2"
         ForeColor       =   &H00FF0000&
         Height          =   315
         Left            =   180
         TabIndex        =   6
         ToolTipText     =   "Turns the display of scope channel 2 on and off"
         Top             =   700
         Value           =   1  'Checked
         Width           =   715
      End
      Begin VB.CheckBox ShowRef1 
         Caption         =   "REF1"
         ForeColor       =   &H008080FF&
         Height          =   315
         Left            =   1680
         TabIndex        =   9
         ToolTipText     =   "Turns the display of reference waveform 1 on and off"
         Top             =   300
         Width           =   840
      End
      Begin VB.CheckBox ShowRef2 
         Caption         =   "REF2"
         ForeColor       =   &H00FF8080&
         Height          =   315
         Left            =   1680
         TabIndex        =   10
         ToolTipText     =   "Turns the display of reference waveform 2 on and off"
         Top             =   700
         Width           =   840
      End
      Begin VB.CommandButton SaveToRef1 
         BackColor       =   &H00C0C0FF&
         Caption         =   "--->"
         Height          =   255
         Left            =   960
         Style           =   1  'Graphical
         TabIndex        =   7
         ToolTipText     =   "Copy scope channel 1 waveform into reference waveform 1"
         Top             =   330
         Width           =   533
      End
      Begin VB.CommandButton SaveToRef2 
         BackColor       =   &H00FFC0C0&
         Caption         =   "--->"
         Height          =   255
         Left            =   960
         Style           =   1  'Graphical
         TabIndex        =   8
         ToolTipText     =   "Copy scope channel 2 waveform into reference waveform 2"
         Top             =   720
         Width           =   533
      End
      Begin VB.Line Line4 
         BorderColor     =   &H80000010&
         X1              =   120
         X2              =   3720
         Y1              =   1890
         Y2              =   1890
      End
      Begin VB.Line Line2 
         BorderColor     =   &H80000010&
         X1              =   120
         X2              =   2520
         Y1              =   1440
         Y2              =   1440
      End
      Begin VB.Line Line1 
         BorderColor     =   &H80000010&
         X1              =   2520
         X2              =   2520
         Y1              =   240
         Y2              =   1920
      End
   End
   Begin VB.Frame TriggerFrame 
      Caption         =   "Trigger"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1575
      Left            =   5910
      TabIndex        =   27
      Top             =   6000
      Width           =   3465
      Begin VB.Frame TriggerPolarityFrame 
         BorderStyle     =   0  'None
         Caption         =   "Polarity"
         Height          =   375
         Left            =   840
         TabIndex        =   29
         Top             =   1000
         Width           =   1924
         Begin VB.OptionButton TriggerFalling 
            Caption         =   "Falling"
            Height          =   375
            Left            =   960
            TabIndex        =   18
            ToolTipText     =   "Trigger on falling edge (signal crossing trigger level from above)"
            Top             =   0
            Width           =   900
         End
         Begin VB.OptionButton TriggerRising 
            Caption         =   "Rising"
            Height          =   375
            Left            =   120
            TabIndex        =   17
            ToolTipText     =   "Trigger on rising edge (signal crossing trigger level from below)"
            Top             =   0
            Width           =   900
         End
      End
      Begin VB.Frame TriggerSourceFrame 
         BorderStyle     =   0  'None
         Caption         =   "Source"
         Height          =   375
         Left            =   840
         TabIndex        =   28
         Top             =   360
         Width           =   2565
         Begin VB.OptionButton TriggerExt 
            Caption         =   "Ext."
            ForeColor       =   &H00008000&
            Height          =   375
            Left            =   1800
            TabIndex        =   74
            ToolTipText     =   "Trigger on external trigger input signal"
            Top             =   0
            Width           =   735
         End
         Begin VB.OptionButton TriggerCH1 
            Caption         =   "CH1"
            ForeColor       =   &H000000FF&
            Height          =   375
            Left            =   960
            TabIndex        =   44
            ToolTipText     =   "Trigger on channel 1 signal"
            Top             =   0
            Width           =   735
         End
         Begin VB.OptionButton TriggerAuto 
            Caption         =   "Auto"
            Height          =   375
            Left            =   120
            TabIndex        =   16
            ToolTipText     =   "Trigger automatically (forces immediate start of acquisition, regardless of channel 1 and 2 signal)"
            Top             =   0
            Width           =   900
         End
      End
      Begin VB.Shape AcqIndicator 
         FillColor       =   &H00008000&
         Height          =   255
         Left            =   2880
         Shape           =   3  'Circle
         Top             =   1200
         Width           =   255
      End
      Begin VB.Label Label3 
         Alignment       =   2  'Center
         Caption         =   "Trig'd"
         Height          =   255
         Left            =   2640
         TabIndex        =   90
         Top             =   900
         Width           =   735
      End
      Begin VB.Line Line3 
         BorderColor     =   &H80000010&
         X1              =   120
         X2              =   3360
         Y1              =   840
         Y2              =   840
      End
      Begin VB.Label Label12 
         Caption         =   "Polarity:"
         Height          =   255
         Left            =   180
         TabIndex        =   45
         Top             =   1080
         Width           =   855
      End
      Begin VB.Label Label1 
         Caption         =   "Source:"
         Height          =   255
         Left            =   180
         TabIndex        =   30
         Top             =   420
         Width           =   855
      End
   End
   Begin MSComctlLib.StatusBar StatusBar 
      Align           =   2  'Align Bottom
      Height          =   375
      Left            =   0
      TabIndex        =   26
      ToolTipText     =   "Status line displays cursor information"
      Top             =   7575
      Width           =   13395
      _ExtentX        =   23627
      _ExtentY        =   661
      Style           =   1
      ShowTips        =   0   'False
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
      EndProperty
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   0
      Top             =   0
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSComCtl2.FlatScrollBar HorCursorScrollbar1 
      Height          =   5250
      Left            =   120
      TabIndex        =   25
      ToolTipText     =   "Use this slider to move the first horizontal display cursor (green line)."
      Top             =   360
      Width           =   255
      _ExtentX        =   450
      _ExtentY        =   9260
      _Version        =   393216
      Orientation     =   1572864
   End
   Begin MSComCtl2.FlatScrollBar VertCursorScrollbar2 
      Height          =   255
      Left            =   360
      TabIndex        =   24
      ToolTipText     =   "Use this slider to move the second vertical display cursor (green line)."
      Top             =   5640
      Width           =   8655
      _ExtentX        =   15266
      _ExtentY        =   450
      _Version        =   393216
      Arrows          =   65536
      Orientation     =   1572865
   End
   Begin MSComCtl2.FlatScrollBar HorCursorScrollbar2 
      Height          =   5250
      Left            =   9000
      TabIndex        =   23
      ToolTipText     =   "Use this slider to move the second horizontal display cursor (green line)."
      Top             =   360
      Width           =   255
      _ExtentX        =   450
      _ExtentY        =   9260
      _Version        =   393216
      Orientation     =   1572864
   End
   Begin MSComCtl2.FlatScrollBar VertCursorScrollbar1 
      Height          =   260
      Left            =   364
      TabIndex        =   22
      ToolTipText     =   "Use this slider to move the first vertical display cursor (green line)."
      Top             =   117
      Width           =   8658
      _ExtentX        =   15266
      _ExtentY        =   450
      _Version        =   393216
      Arrows          =   65536
      Orientation     =   1572865
   End
   Begin VB.Shape Shape3 
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   5370
      Left            =   360
      Top             =   360
      Width           =   8655
   End
   Begin VB.Menu menuFile 
      Caption         =   "&File"
      Begin VB.Menu menuLoadSetup 
         Caption         =   "Load Setup"
         Shortcut        =   ^L
      End
      Begin VB.Menu menuSaveSetupAs 
         Caption         =   "Save Setup As"
         Shortcut        =   ^S
      End
      Begin VB.Menu menuSep1 
         Caption         =   "-"
      End
      Begin VB.Menu menuExportData 
         Caption         =   "Export Data"
         Shortcut        =   ^E
      End
      Begin VB.Menu menuSep2 
         Caption         =   "-"
      End
      Begin VB.Menu menuExit 
         Caption         =   "Exit"
      End
   End
   Begin VB.Menu menuCalibration 
      Caption         =   "&Utilities"
      Begin VB.Menu menuMeasurements 
         Caption         =   "Measurements"
      End
      Begin VB.Menu menuDMM_Display 
         Caption         =   "DMM Display"
      End
      Begin VB.Menu menuSep4 
         Caption         =   "-"
      End
      Begin VB.Menu menuCheckSupplyVoltage 
         Caption         =   "Check USB Supply"
      End
   End
   Begin VB.Menu menuHelp 
      Caption         =   "&Help"
      Begin VB.Menu menuAbout 
         Caption         =   "About"
      End
   End
End
Attribute VB_Name = "MainPanel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private FrameCount As Long

Private FirstAcq As Boolean

Private ScanRunning As Boolean
Private ComboEvent As Boolean

Private CommandTimeout As Boolean

Private sample_shift_ch1 As Long, sample_shift_ch2 As Long
Private sample_subtract_ch1 As Long, sample_subtract_ch2 As Long
Private sample_subtract_delta_ch1 As Long, sample_subtract_delta_ch2 As Long
Private adc_chan_ch1 As Byte, adc_chan_ch2 As Byte
Private comp_input_chan As Byte

Public ChangeOfTimebase As Boolean
Public TimeBaseListIndex_old As Long
Public TriggerCH1_old As Boolean, TriggerExt_old As Boolean, TriggerAuto_old As Boolean

Private DatalogScale_CH1 As Double, DatalogScale_CH2 As Double

Private LA_DrawGrid

Private DraggingHorCur1 As Boolean
Private DraggingHorCur2 As Boolean
Private DraggingVertCur1 As Boolean
Private DraggingVertCur2 As Boolean

Public Sub ShowAcqIndicator()

    AcqNotificationTimer.Enabled = False
    AcqIndicator.FillStyle = 0 ' solid fill
    AcqIndicatorLA.FillStyle = 0 ' solid fill
    'AcqIndicator.Visible = True
    AcqNotificationTimer.Enabled = True
    DoEvents

End Sub

Private Sub AcqNotificationTimer_Timer()

    AcqIndicator.FillStyle = 1 ' transparent fill
    AcqIndicatorLA.FillStyle = 1 ' transparent fill
    'AcqIndicator.Visible = False
    AcqNotificationTimer.Enabled = False

End Sub

Private Sub CursorCH1_Click()

    Call UpdatePlot

    Call Draw_Cursors
    
End Sub

Private Sub CursorCH2_Click()

    Call UpdatePlot

    Call Draw_Cursors
    
End Sub

Private Sub DisplayDots_Click()

    If DisplayVectors = vbUnchecked And DisplayDots = vbUnchecked Then DisplayVectors = vbChecked
    
    Call UpdatePlot
    
End Sub

Private Sub DisplayLevels_Click()

    Call UpdatePlot
    
End Sub

Private Sub DisplayUpdateTimer_Timer()

    'TrigLvl = Val(TrigLvl) + 1
    Call UpdatePlot
    
End Sub

Private Sub DisplayVectors_Click()

    If DisplayVectors = vbUnchecked And DisplayDots = vbUnchecked Then DisplayDots = vbChecked
    
    Call UpdatePlot
    
End Sub

Private Sub LA_Hor_Pos_Change()

    Call UpdatePlot
    
End Sub

Private Sub LinesBold_Click()

    Call UpdatePlot
    
End Sub

Private Sub menuDMM_Display_Click()

    Call DMM_Display.Show
    
End Sub

Private Sub ProbeAtten10_CH1_Click()

    ComboEvent = True

    If ProbeAtten10_CH1 = vbChecked Then
        sample_subtract_delta_ch1 = PROBE_1_TO_10_DELTA
        If GainCH1.ListIndex > 2 Then GainCH1.ListIndex = 2
        UpDownGainCH1.Max = 2
    Else
        sample_subtract_delta_ch1 = 0
        UpDownGainCH1.Max = 5
    End If
    
    ComboEvent = False
    
    Call InitGainCH1_Combo
    
    Call GainCH1_Click
    
End Sub

Private Sub ProbeAtten10_CH2_Click()

    ComboEvent = True
    
    If ProbeAtten10_CH2 = vbChecked Then
        sample_subtract_delta_ch2 = PROBE_1_TO_10_DELTA
        If GainCH2.ListIndex > 2 Then GainCH2.ListIndex = 2
        UpDownGainCH2.Max = 2
    Else
        sample_subtract_delta_ch2 = 0
        UpDownGainCH2.Max = 5
    End If

    ComboEvent = False

    Call InitGainCH2_Combo
    
    Call Gainch2_Click
    
End Sub

Public Sub runScan_Click()

    If ScanRunning Then
    
        ScanRunning = False
            
        RunScan.Caption = "Run"
        DoEvents
        
        If Not RollMode And (TimeBase.ListIndex >= 6) Then DoFFT.Enabled = True
        
'        If Not LAMode Then
'            ShowCH1.Enabled = True
'            ShowCH2.Enabled = True
'            ShowRef2.Enabled = True
'            SaveToRef2.Enabled = True
'            ShowRef2.Enabled = True
'            SaveToRef2.Enabled = True
'            Cursors.Enabled = True
    
        If LogToFile = vbChecked Then LogToFile = vbUnchecked
        
        Call LockDisplayControls(False)
    
    Else
    
        RunScan.Caption = "Stop"
        DoEvents
        
        Plot_Display.Visible = True
        
        If ScopeMode Then
            Call RunScan_ScopeMode
        ElseIf RollMode Then
            Call RunScan_RollMode
        Else
            Call RunScan_LogicAnalyzer
        End If
    
        ' make sure caption reverts to run after acquisition is finished (important for single shot mode)
        RunScan.Caption = "Run"
    
    End If
    
End Sub

Public Sub RunScan_LogicAnalyzer()

    Dim ACQ_Done As Byte
    Dim i_Block As Long
    Dim i_Counter As Long
    Dim i_Block_max As Long
    
    Dim i As Long, i_row As Long, i_col As Long, i_chan As Long, i_row_target As Long
    Dim i_col_start As Long, i_col_end As Long
    
    Dim SampleRateIdx_old As Long
    Dim SetupChanged As Boolean
    
    Dim s_Data As String
    
    ' disable all "dangerous" controls
    Call LockDisplayControls(True)
    
    ScanRunning = True
    LA_DrawGrid = True
    
    SampleRateIdx_old = TimeBase.ListIndex - 1
        
    Call ClearData_Click
            
    For i_row = 1 To FULL_RECORD_LENGTH_LA
        DataBuffer(i_row, 9) = i_row - 1
    Next i_row
    
    While ScanRunning
    
        Call UpdateSampleRate_LA(SampleRateIdx_old, SetupChanged)
        Call AcquireSamples_LA(TimerPreloadHigh, TimerPreloadLow, PrescalerBypass, PrescalerSelection)
            
        ' acquisition loop - repeat until full record is acquired; meanwhile update parameters whenever they change
        Do
            DoEvents
            Sleep 5
            HID_WriteData(1) = CMD_DONE
            Call HID_Write_And_Read
            ACQ_Done = HID_ReadData(1)
                        
        Loop Until (ACQ_Done > 0) Or (ScanRunning = False)
            
        If ScanRunning = False Then
            Exit Sub
        End If
        
        HID_WriteData(1) = CMD_READBACK
            
        ' full ADC range is 255 steps (8 bit) and covers 5V; we are using only slightly less than half range for display,
        ' i.e. 12 units out of possible 25 --> factor 25/12
        ' full range is 255 and we have want to scale values 0...100 for full screen height --> 100/255 = 1/2.55
        ' scope is trimmed so 0V results in ADC value 128 (mid scale), which on screen should be scaled at 50
        
        i_Counter = 1
        i_Block_max = 6 ' total of 7 blocks (0...6)
        
        ' with BLOCK_LEN = 64, total number of bytes is 64 * 7 = 448, i.e. a bit more than the real number of samples (remainder is garbage - disregard)
        For i_Block = 0 To i_Block_max
        
            ' read back blocks of data
            HID_WriteData(2) = i_Block
            Call HID_Write_And_Read
        
            Call ShowAcqIndicator
            
            ' store data in upper nibble to stay compatible with datalogger mode (can then use same display routine)
            For i = 1 To BLOCK_LEN
                DataBuffer(i_Counter, 10) = (HID_ReadData(i) And &HF) * 16 ' lower nibble
                i_Counter = i_Counter + 1
                DataBuffer(i_Counter, 10) = HID_ReadData(i) And &HF0 ' upper nibble
                i_Counter = i_Counter + 1
            Next i
    
        Next i_Block
            
        ' plot latest data (especially important since logic analyer mode always does a single shot acquisition)
        Call UpdatePlot
    
        LA_DrawGrid = False
        
        If RunSingle Then ScanRunning = False
        
    Wend ' scan_running
    
    ScanRunning = False
    
    ' re-enable all "dangerous" controls
    Call LockDisplayControls(False)
    
End Sub

Private Sub AcquireSamples_LA(TimerPreloadHigh As Long, TimerPreloadLow As Long, PrescalerBypass As Long, PrescalerSelection As Long)

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
    HID_WriteData(5) = TimerPreloadHigh ' timer 0 preload high
    HID_WriteData(6) = TimerPreloadLow ' timer 0 preload low
    
    ' timer prescaler
    HID_WriteData(7) = PrescalerBypass ' prescaler bypass
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
    Dim AlreadyDrawn As Boolean
    Dim AcqComplete As Boolean
    
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
                        Call AcquireSamples(adc_chan_ch1, adc_chan_ch1, TimerPreloadHigh, TimerPreloadLow, PrescalerBypass, PrescalerSelection, _
                                            sample_shift_ch1, sample_shift_ch1, _
                                            sample_subtract_ch1 + sample_subtract_delta_ch1, sample_subtract_ch1 + sample_subtract_delta_ch1, _
                                            SamplingMode, SampleInterval, comp_input_chan)
                    Else
                        Call AcquireSamples(adc_chan_ch2, adc_chan_ch2, TimerPreloadHigh, TimerPreloadLow, PrescalerBypass, PrescalerSelection, _
                                            sample_shift_ch2, sample_shift_ch2, _
                                            sample_subtract_ch2 + sample_subtract_delta_ch2, sample_subtract_ch2 + sample_subtract_delta_ch2, _
                                            SamplingMode, SampleInterval, comp_input_chan)
                    End If
                    
                Else
                
                    Call AcquireSamples(adc_chan_ch1, adc_chan_ch2, TimerPreloadHigh, TimerPreloadLow, PrescalerBypass, PrescalerSelection, _
                                        sample_shift_ch1, sample_shift_ch2, _
                                        sample_subtract_ch1 + sample_subtract_delta_ch1, sample_subtract_ch2 + sample_subtract_delta_ch2, _
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
        DisplayUpdateTimer.Enabled = True ' update screen in any case if not otherwise done in the next 200 msec
        
        ' make sure first data set gets plotted right away, especially for slow timebase settings
        If FirstAcq Or TimeAxisScale >= 0.01 Then
            FirstAcq = False
            AlreadyDrawn = True
            Call UpdatePlot
        Else
            AlreadyDrawn = False
        End If
                        
        ' only alternate acquisition with both channels turned on needs two repeats per full acquisition
        If (SampleRateIdx_old <> SAMPLE_RATE_50k) Then
           AcqComplete = True
        ElseIf (ShowCH1 = vbUnchecked) Or (ShowCH2 = vbUnchecked) Or (FFT_Channel = 2) Then ' acquired all activated channels
            AcqComplete = True
        Else
            AcqComplete = False
        End If
              
        If AcqComplete Then
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

Private Sub AcquireSamples(adc_chan_ch1 As Byte, adc_chan_ch2 As Byte, _
                           TimerPreloadHigh As Long, TimerPreloadLow As Long, PrescalerBypass As Long, PrescalerSelection As Long, _
                           sample_shift_ch1 As Long, sample_shift_ch2 As Long, sample_subtract_ch1 As Long, sample_subtract_ch2 As Long, _
                           SamplingMode As Long, SampleInterval As Long, comp_input_chan As Byte)

    Dim TrigVal As Long
    
    ' ARM parameters (watch out, VB array is 1-based, MikroC array is 0-based)
    '  1: command
    '  2: first channel to acquire
    '  3: second channel to acquire
    '  4: acquisition parameters (sample clock divider, acquisition time)
    '  5: timer 0 preload high
    '  6: timer 0 preload low
    '  7: timer 0 prescaler bypass (0 = use prescaler, 1 = bypass prescaler)
    '  8: timer 0 prescaler as power of 2 (7=div256, 0=div2): divide = 2^(PS+1)
    
    HID_WriteData(1) = CMD_ARM
    
    'HID_WriteData(2) = 10 ' AN10
    'HID_WriteData(3) = 15 ' FVR = 4096mV
    
    HID_WriteData(2) = adc_chan_ch1 ' ADC channel to use for CH1 (selects gain 1 or 10, respectively)
    HID_WriteData(3) = adc_chan_ch2 ' ADC channel to use for CH2 (selects gain 1 or 10, respectively)
    
    HID_WriteData(4) = 128 + ACQT * 8 + ADCS ' ADC acquisition parameters
    
    ' timer preload determines sample rate
    HID_WriteData(5) = TimerPreloadHigh ' timer 0 preload high
    HID_WriteData(6) = TimerPreloadLow ' timer 0 preload low
    
    ' timer prescaler
    HID_WriteData(7) = PrescalerBypass ' prescaler bypass
    HID_WriteData(8) = PrescalerSelection ' prescaler selection
    
    ' parameter for "software gain": (shift,subtract) = (2,0), (1,128), or (0,192) for gain 1, 2, 4
    HID_WriteData(9) = sample_shift_ch1 ' sample shift CH1
    HID_WriteData(10) = sample_shift_ch2 ' sample shift CH2
    
    HID_WriteData(11) = sample_subtract_ch1 '+ sample_subtract_delta_ch1 ' sample subtract CH1
    HID_WriteData(12) = sample_subtract_ch2 '+ sample_subtract_delta_ch2 ' sample subtract CH2
    
    ' trigger mode (triggered or free running); note: trigger input pin is defined later below (WriteData(20))
    If TriggerAuto Then
        HID_WriteData(13) = 0
    Else ' trigger on CH1 or external trigger
        HID_WriteData(13) = 1
    End If
    
    ' trigger polarity
    If (TriggerRising = True) Then
        HID_WriteData(14) = 1 ' trigger on rising edge
    Else
        HID_WriteData(14) = 0 ' trigger on falling edge
    End If
    
    ' trigger level (reserve two bytes so we can use the full 10 bit PWM value if needed
    If TriggerExt Then ' external trigger uses fixed threshold of approx. 1.5V (compatible with TTL, 5V CMOS and 3.3V CMOS)
        HID_WriteData(15) = 0
        HID_WriteData(16) = (1.5 / 5#) * 256
    Else ' adjustable trigger threshold if triggering on channel 1
        TrigVal = 256 - TriggerLevel + sample_subtract_delta_ch1 / 2
        ' avoid runtime error due to underflow or overflow
        If TrigVal < 0 Then TrigVal = 0
        If TrigVal > 255 Then TrigVal = 255
        HID_WriteData(15) = 0
        HID_WriteData(16) = TrigVal
    End If
    
    HID_WriteData(17) = SamplingMode  ' sampling mode: 0 = real time, 1 = equivalent time
    HID_WriteData(18) = SampleInterval  ' equivalent time sample interval in 0.5usec increments
    HID_WriteData(19) = SampleInterval / 2 ' equivalent time trigger stability check period
    
    ' select correct comparator input for trigger (must be CH1 gain 1 or gain 10 path, respectively, or external trigger)
    If TriggerExt Then
        HID_WriteData(20) = 3 ' external trigger input (pin RC3)
    Else
        HID_WriteData(20) = comp_input_chan ' CH1 gain 1 or CH1 gain 10 input
    End If
    
    ' set arm parameters and arm scope
    Call HID_Write_And_Read

End Sub

Public Function ReadADC(ADC_Chan) As Long

    HID_WriteData(1) = CMD_READADC
    
    HID_WriteData(2) = ADC_Chan
    HID_WriteData(3) = ADC_Chan ' dummy
    
    HID_WriteData(4) = 128 + ACQT * 8 + ADCS ' ADC acquisition parameters
    
    Call HID_Write_And_Read
    
    ReadADC = 256 * HID_ReadData(1) + HID_ReadData(2)
    'ReadADC = 256 * HID_ReadData(3) + HID_ReadData(4)

End Function

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

Public Sub LockDisplayControls(LockFlag As Boolean)

    If Not ScopeMode Then ScopeMode.Enabled = Not LockFlag
    If Not LAMode Then LAMode.Enabled = Not LockFlag
    If Not RollMode Then RollMode.Enabled = Not LockFlag
        
    If LAMode Then
        LA_Trigger_Auto.Enabled = Not LockFlag
        LA_Trigger_CH1.Enabled = Not LockFlag
        LA_Trigger_CH2.Enabled = Not LockFlag
        LA_Trigger_CH3.Enabled = Not LockFlag
        LA_Trigger_CH4.Enabled = Not LockFlag
        LA_Trigger_Rising.Enabled = Not LockFlag
        LA_Trigger_Falling.Enabled = Not LockFlag
        TimeBase.Enabled = Not LockFlag
        UpDownTimeBase.Enabled = Not LockFlag
    End If
    
End Sub
 
Public Sub Draw_Cursors()

    Dim i_row As Long, i_col As Long
    
    Dim Gain As Double, Offset As Double
    
    Dim HorCursor1_in_V As Double
    Dim HorCursor2_in_V As Double
    Dim HorCursorDelta_in_V As Double
    Dim VertCursor1_in_sec As Double
    Dim VertCursor2_in_sec As Double
    Dim VertCursorDelta_in_sec As Double
    Dim VertCursorFreq_in_Hz As Double
    Dim VertCursor1_in_Hz As Double
    Dim VertCursor2_in_Hz As Double
    Dim VertCursorDelta_in_Hz As Double
    
    Dim HorCursor1_txt As String
    Dim HorCursor2_txt As String
    Dim HorCursorDelta_txt As String
    Dim VertCursor1_txt As String
    Dim VertCursor2_txt As String
    Dim VertCursorDelta_txt As String
    Dim VertCursorFreq_txt As String
    
    If init_flag = True Then Exit Sub
       
    ' x

    If Cursors = vbChecked Then
        
        If DoFFT = vbChecked Then
        
            VertCursor1_in_Hz = VertCursor1 * FreqAxisScale
            VertCursor2_in_Hz = VertCursor2 * FreqAxisScale
            VertCursorDelta_in_Hz = Abs(VertCursor1_in_Hz - VertCursor2_in_Hz)
            
            If VertCursor1_in_Hz >= 1000000 Then
                VertCursor1_txt = Format(VertCursor1_in_Hz / 1000000, "0.000") & " MHz"
            ElseIf VertCursor1_in_Hz >= 100000 Then
                VertCursor1_txt = Format(VertCursor1_in_Hz / 1000, "0.0") & " kHz"
            ElseIf VertCursor1_in_Hz >= 10000 Then
                VertCursor1_txt = Format(VertCursor1_in_Hz / 1000, "0.00") & " kHz"
            ElseIf VertCursor1_in_Hz >= 1000 Then
                VertCursor1_txt = Format(VertCursor1_in_Hz / 1000, "0.000") & " kHz"
            ElseIf VertCursor1_in_Hz >= 100 Then
                VertCursor1_txt = Format(VertCursor1_in_Hz, "0.0") & " Hz"
            ElseIf VertCursor1_in_Hz >= 10 Then
                VertCursor1_txt = Format(VertCursor1_in_Hz, "0.00") & " Hz"
            ElseIf VertCursor1_in_Hz >= 1 Then
                VertCursor1_txt = Format(VertCursor1_in_Hz, "0.000") & " Hz"
            Else
                VertCursor1_txt = Format(VertCursor1_in_Hz * 1000, "0.0") & " mHz"
            End If
            
            If VertCursor2_in_Hz >= 1000000 Then
                VertCursor2_txt = Format(VertCursor2_in_Hz / 1000000, "0.000") & " MHz"
            ElseIf VertCursor2_in_Hz >= 100000 Then
                VertCursor2_txt = Format(VertCursor2_in_Hz / 1000, "0.0") & " kHz"
            ElseIf VertCursor2_in_Hz >= 10000 Then
                VertCursor2_txt = Format(VertCursor2_in_Hz / 1000, "0.00") & " kHz"
            ElseIf VertCursor2_in_Hz >= 1000 Then
                VertCursor2_txt = Format(VertCursor2_in_Hz / 1000, "0.000") & " kHz"
            ElseIf VertCursor2_in_Hz >= 100 Then
                VertCursor2_txt = Format(VertCursor2_in_Hz, "0.0") & " Hz"
            ElseIf VertCursor2_in_Hz >= 10 Then
                VertCursor2_txt = Format(VertCursor2_in_Hz, "0.00") & " Hz"
            ElseIf VertCursor2_in_Hz >= 1 Then
                VertCursor2_txt = Format(VertCursor2_in_Hz, "0.000") & " Hz"
            Else
                VertCursor2_txt = Format(VertCursor2_in_Hz * 1000, "0.0") & " mHz"
            End If

            If FFTScaleVal = FFTScaleVal_LINEAR Then
                Gain = 20# / 100#
                Offset = 0
            
                HorCursor1_in_V = HorCursor1 * Gain - Offset
                HorCursor2_in_V = HorCursor2 * Gain - Offset
            
                If HorCursor1 = 0 And HorCursor2 = 0 Then
                    HorCursorDelta_txt = "--- %"
                ElseIf HorCursor1_in_V < HorCursor2_in_V Then
                    HorCursorDelta_txt = Format((100# * Abs(HorCursor1_in_V / HorCursor2_in_V)), "0.0") & " %"
                Else
                    HorCursorDelta_txt = Format((100# * Abs(HorCursor2_in_V / HorCursor1_in_V)), "0.0") & " %"
                End If
            
            Else ' logarithmic
                
                If FFTSetupPanel.FFTmag Then
                    Gain = 5# * NO_OF_UNITS_Y / 100#    ' always 5dB per div for logarithmic voltage scaling
                    Offset = -5# * NO_OF_UNITS_Y  ' 12 units * 5 dB/unit (top is 0 dB)
                Else ' power --> 10dB/unit
                    Gain = 10# * NO_OF_UNITS_Y / 100#    ' always 5dB per div for logarithmic voltage scaling
                    Offset = -10# * NO_OF_UNITS_Y  ' 12 units * 5 dB/unit (top is 0 dB)
                End If
                
                HorCursor1_in_V = HorCursor1 * Gain - Offset
                HorCursor2_in_V = HorCursor2 * Gain - Offset
            
                HorCursorDelta_txt = Format(Abs(HorCursor1_in_V - HorCursor2_in_V), "0.00") & " dB"
            
            End If
                
            StatusBar.SimpleText = "Cursors: level ratio: " & HorCursorDelta_txt & _
                "      f1: " & VertCursor1_txt & "      f2: " & VertCursor2_txt
            
        Else ' time domain display
        
            If CursorCH1 Then
                Gain = GetGain(1) ' gain in V/div (there are 12 vertical divisions)
                Offset = GetOffset(1) ' offset as a fraction of the screen height
            Else ' CursorCH2
                Gain = GetGain(2)
                Offset = GetOffset(2)
            End If
    
            HorCursor1_in_V = (HorCursor1 / 100 - Offset) * NO_OF_UNITS_Y * Gain
            HorCursor2_in_V = (HorCursor2 / 100 - Offset) * NO_OF_UNITS_Y * Gain
            
            HorCursor1_txt = Format(HorCursor1_in_V, "0.000") & " V"
            HorCursor2_txt = Format(HorCursor2_in_V, "0.000") & " V"
            HorCursorDelta_txt = Format(Abs(HorCursor1_in_V - HorCursor2_in_V), "0.000") & " V"
            
            VertCursor1_in_sec = VertCursor1 * TimeAxisScale
            VertCursor2_in_sec = VertCursor2 * TimeAxisScale
            VertCursorDelta_in_sec = Abs(VertCursor1_in_sec - VertCursor2_in_sec)
        
            If VertCursorDelta_in_sec >= 1000 Then
                VertCursorDelta_txt = Format(VertCursorDelta_in_sec, "0") & " s"
            ElseIf VertCursorDelta_in_sec >= 100 Then
                VertCursorDelta_txt = Format(VertCursorDelta_in_sec, "0.0") & " s"
            ElseIf VertCursorDelta_in_sec >= 10 Then
                VertCursorDelta_txt = Format(VertCursorDelta_in_sec, "0.00") & " s"
            ElseIf VertCursorDelta_in_sec >= 1 Then
                VertCursorDelta_txt = Format(VertCursorDelta_in_sec, "0.000") & " s"
            ElseIf VertCursorDelta_in_sec >= 0.1 Then
                VertCursorDelta_txt = Format(VertCursorDelta_in_sec * 1000#, "0.0") & " ms"
            ElseIf VertCursorDelta_in_sec >= 0.01 Then
                VertCursorDelta_txt = Format(VertCursorDelta_in_sec * 1000#, "0.00") & " ms"
            ElseIf VertCursorDelta_in_sec >= 0.001 Then
                VertCursorDelta_txt = Format(VertCursorDelta_in_sec * 1000#, "0.000") & " ms"
            ElseIf VertCursorDelta_in_sec >= 0.0001 Then
                VertCursorDelta_txt = Format(VertCursorDelta_in_sec * 1000000#, "0.0") & " us"
            ElseIf VertCursorDelta_in_sec >= 0.00001 Then
                VertCursorDelta_txt = Format(VertCursorDelta_in_sec * 1000000#, "0.00") & " us"
            Else
                VertCursorDelta_txt = Format(VertCursorDelta_in_sec * 1000000#, "0.000") & " us"
            End If
            
            If Abs(VertCursorDelta_in_sec) >= 0.00000000099 Then
                
                VertCursorFreq_in_Hz = 1# / VertCursorDelta_in_sec
                
                If VertCursorFreq_in_Hz >= 1000000 Then
                    VertCursorFreq_txt = Format(VertCursorFreq_in_Hz / 1000000, "0.000") & " MHz"
                ElseIf VertCursorFreq_in_Hz >= 100000 Then
                    VertCursorFreq_txt = Format(VertCursorFreq_in_Hz / 1000, "0.0") & " kHz"
                ElseIf VertCursorFreq_in_Hz >= 10000 Then
                    VertCursorFreq_txt = Format(VertCursorFreq_in_Hz / 1000, "0.00") & " kHz"
                ElseIf VertCursorFreq_in_Hz >= 1000 Then
                    VertCursorFreq_txt = Format(VertCursorFreq_in_Hz / 1000, "0.000") & " kHz"
                ElseIf VertCursorFreq_in_Hz >= 100 Then
                    VertCursorFreq_txt = Format(VertCursorFreq_in_Hz, "0.0") & " Hz"
                ElseIf VertCursorFreq_in_Hz >= 10 Then
                    VertCursorFreq_txt = Format(VertCursorFreq_in_Hz, "0.00") & " Hz"
                ElseIf VertCursorFreq_in_Hz >= 1 Then
                    VertCursorFreq_txt = Format(VertCursorFreq_in_Hz, "0.000") & " Hz"
                ElseIf VertCursorFreq_in_Hz >= 0.1 Then
                    VertCursorFreq_txt = Format(VertCursorFreq_in_Hz * 1000#, "0.0") & " mHz"
                ElseIf VertCursorFreq_in_Hz >= 0.01 Then
                    VertCursorFreq_txt = Format(VertCursorFreq_in_Hz * 1000#, "0.00") & " mHz"
                ElseIf VertCursorFreq_in_Hz >= 0.001 Then
                    VertCursorFreq_txt = Format(VertCursorFreq_in_Hz * 1000#, "0.000") & " mHz"
                ElseIf VertCursorFreq_in_Hz >= 0.0001 Then
                    VertCursorFreq_txt = Format(VertCursorFreq_in_Hz * 1000000#, "0.0") & " uHz"
                ElseIf VertCursorFreq_in_Hz >= 0.00001 Then
                    VertCursorFreq_txt = Format(VertCursorFreq_in_Hz * 1000000#, "0.00") & " uHz"
                ElseIf VertCursorFreq_in_Hz >= 0.000001 Then
                    VertCursorFreq_txt = Format(VertCursorFreq_in_Hz * 1000000#, "0.000") & " uHz"
                End If
            Else
                VertCursorFreq_txt = "---"
            End If
            
            If Not LAMode Then
                StatusBar.SimpleText = "Cursors: dV: " & HorCursorDelta_txt & _
                                       "   (" & HorCursor1_txt & ") (" & HorCursor2_txt & _
                                       ")      dt: " & VertCursorDelta_txt & "      1/dt: " & VertCursorFreq_txt
            Else ' voltage display would not make sense in logic analyzer mode
                StatusBar.SimpleText = "Cursors:    dt: " & VertCursorDelta_txt & "      1/dt: " & VertCursorFreq_txt
            
            End If
        
        End If
            
    Else
        
        StatusBar.SimpleText = ""
        
    End If
    
End Sub

Public Sub AcqAvg_Change()

    If AcqAvg.ListIndex = 0 Then
        Label2.Visible = False
        AcqCount.Visible = False
    Else
        Label2.Visible = True
        AcqCount.Visible = True
    End If

    ComboEvent = True
    UpDownAcqAvg = 6 - AcqAvg.ListIndex
    ComboEvent = False

End Sub

Public Sub AcqAvg_Click()
    
    If AcqAvg.ListIndex = 0 Then
        Label2.Visible = False
        AcqCount.Visible = False
    Else
        Label2.Visible = True
        AcqCount.Visible = True
    End If

    ComboEvent = True
    UpDownAcqAvg = 6 - AcqAvg.ListIndex
    ComboEvent = False

End Sub

Public Sub InitGainCH1_Combo()

    Dim CurrentSelection As Long
    
    CurrentSelection = GainCH1.ListIndex
    
    GainCH1.Clear
    
    If ProbeAtten10_CH1 = vbChecked Then ' 1:10 probe gain
    
        If CurrentSelection > 2 Then CurrentSelection = 2
        
        GainCH1.AddItem ("20 V/div")
        GainCH1.AddItem ("10 V/div")
        GainCH1.AddItem ("5 V/div")
    
    Else
    
        GainCH1.AddItem ("2 V/div")
        GainCH1.AddItem ("1 V/div")
        GainCH1.AddItem ("0.5 V/div")
        GainCH1.AddItem ("0.2 V/div")
        GainCH1.AddItem ("0.1 V/div")
        GainCH1.AddItem ("50 mV/div")
            
    End If
    
    GainCH1.ListIndex = CurrentSelection

End Sub

Public Sub InitGainCH2_Combo()

    Dim CurrentSelection As Long
    
    CurrentSelection = GainCH2.ListIndex
    
    GainCH2.Clear
    
    If ProbeAtten10_CH2 = vbChecked Then ' 1:10 probe gain
    
        If CurrentSelection > 2 Then CurrentSelection = 2
        
        GainCH2.AddItem ("20 V/div")
        GainCH2.AddItem ("10 V/div")
        GainCH2.AddItem ("5 V/div")
    
    Else
    
        GainCH2.AddItem ("2 V/div")
        GainCH2.AddItem ("1 V/div")
        GainCH2.AddItem ("0.5 V/div")
        GainCH2.AddItem ("0.2 V/div")
        GainCH2.AddItem ("0.1 V/div")
        GainCH2.AddItem ("50 mV/div")
            
    End If
            
    GainCH2.ListIndex = CurrentSelection

End Sub

Private Sub CenterOffsetCH1_Click()

    OffsetCH1 = (OffsetCH1.Max + OffsetCH1.Min) / 2
    
End Sub

Private Sub CenterOffsetCH2_Click()

    OffsetCH2 = (OffsetCH2.Max + OffsetCH2.Min) / 2

End Sub

Private Sub CenterOffsetTrig_Click()

    TriggerLevel = (TriggerLevel.Max + TriggerLevel.Min) / 2

End Sub

Public Sub ClearData_Click()

    Dim i_row As Long
    Dim Persistence_Saved As Long
    
    AcqCount = 0
    
    For i_row = 1 To DATA_ARRAY_SIZE
        DataBuffer(i_row, 2) = -1000 ' CH1
        DataBuffer(i_row, 4) = -1000 ' CH2
        DataBuffer(i_row, 10) = 0 ' LA
    Next i_row
    
    Persistence_Saved = Persistence
    Persistence = vbUnchecked
    DoEvents
    Call UpdatePlot
    Persistence = Persistence_Saved
    
    If ScanRunning Then FirstAcq = True ' make sure next acquisition gets plotted right away
    
End Sub

Public Sub ClearRef(iref As Long)  ' iref can be 1 (REF1) or 2 (REF2)

    Dim i_row As Long, i_col As Long
    
    If iref = 1 Then
        i_col = 6
    Else
        i_col = 8
    End If
    
    For i_row = 1 To DATA_ARRAY_SIZE
        DataBuffer(i_row, i_col) = -1000
    Next i_row
    
    Call UpdatePlot

End Sub

Public Sub DoFFT_Click()

    ShowRef1 = vbUnchecked
    ShowRef2 = vbUnchecked
    
    If DoFFT = vbChecked Then
        SetHorAxisUnits (HOR_UNITS_FREQ)
    Else
        SetHorAxisUnits (HOR_UNITS_TIME)
    End If
    
    Call TimeBase_Click
    
    If DoFFT = vbChecked And Measurements.Visible Then Call Measurements.ClearMeasurements
    
End Sub

Public Sub FFTSetup_Click()
    FFTSetupPanel.Show
End Sub

Public Sub Form_Unload(Cancel As Integer)

    If RollModeLogFilename <> "" Then
        Close #2
    End If
    
    FFTSetupPanel.Hide
    
    End
    
End Sub

Public Sub scale_x_axis(time_min_idx As Long, time_max_idx As Long)

    VertCursorScrollbar1.Min = time_min_idx * 500
    VertCursorScrollbar1.Max = time_max_idx * 500
    VertCursorScrollbar2.Min = time_min_idx * 500
    VertCursorScrollbar2.Max = time_max_idx * 500
        
    If VertCursorScrollbar1 < VertCursorScrollbar1.Min Then VertCursorScrollbar1 = VertCursorScrollbar1.Min
    If VertCursorScrollbar1 > VertCursorScrollbar1.Max Then VertCursorScrollbar1 = VertCursorScrollbar1.Max
    
    If VertCursorScrollbar2 < VertCursorScrollbar2.Min Then VertCursorScrollbar2 = VertCursorScrollbar2.Min
    If VertCursorScrollbar2 > VertCursorScrollbar2.Max Then VertCursorScrollbar2 = VertCursorScrollbar2.Max
    
    VertCursorScrollbar1.LargeChange = (VertCursorScrollbar1.Max - VertCursorScrollbar1.Min) / 50
    VertCursorScrollbar2.LargeChange = (VertCursorScrollbar2.Max - VertCursorScrollbar2.Min) / 50
    
    Call VertCursorScrollbar1_Change
    Call VertCursorScrollbar2_Change
    
    Call UpdatePlot

End Sub

Public Sub scale_y_axis()

    Dim i As Long
    Dim major_divs As Long, minor_divs As Long, idx_span As Long
    
    update_flag = True
    
    MainPanel.HorCursorScrollbar1.Min = val_max * 100
    MainPanel.HorCursorScrollbar1.Max = val_min * 100
    MainPanel.HorCursorScrollbar2.Min = val_max * 100
    MainPanel.HorCursorScrollbar2.Max = val_min * 100
    
    If HorCursorScrollbar1 > HorCursorScrollbar1.Min Then HorCursorScrollbar1 = HorCursorScrollbar1.Min
    If HorCursorScrollbar1 < HorCursorScrollbar1.Max Then HorCursorScrollbar1 = HorCursorScrollbar1.Max
    
    If HorCursorScrollbar2 > HorCursorScrollbar2.Min Then HorCursorScrollbar2 = HorCursorScrollbar2.Min
    If HorCursorScrollbar2 < HorCursorScrollbar2.Max Then HorCursorScrollbar2 = HorCursorScrollbar2.Max
    
    If (HorCursorScrollbar1.Min <> HorCursorScrollbar1.Max) Then
        HorCursorScrollbar1.LargeChange = (HorCursorScrollbar1.Min - HorCursorScrollbar1.Max) / 50
        HorCursorScrollbar2.LargeChange = (HorCursorScrollbar2.Min - HorCursorScrollbar2.Max) / 50
    Else
        HorCursorScrollbar1.LargeChange = 20
        HorCursorScrollbar2.LargeChange = 20
    End If
    
    Call HorCursorScrollbar1_Change
    Call HorCursorScrollbar2_Change
    
    Call UpdatePlot

    update_flag = False

End Sub

Public Sub Cursors_Click()

    If ScopeMode Or RollMode Then
    
        If Cursors = vbChecked Then
        
            CursorCH1.Enabled = True
            CursorCH2.Enabled = True
        
            VertCursorScrollbar1.Enabled = True
            VertCursorScrollbar2.Enabled = True
            HorCursorScrollbar1.Enabled = True
            HorCursorScrollbar2.Enabled = True
            
            PictHorCursor1.Visible = True
            PictHorCursor2.Visible = True
            PictVertCursor1.Visible = True
            PictVertCursor2.Visible = True
            
        Else
            
            CursorCH1.Enabled = False
            CursorCH2.Enabled = False
            
            HorCursor1 = 0
            HorCursor2 = 0
            HorCursorDelta = 0
        
            VertCursor1 = 0
            VertCursor2 = 0
            VertCursorDelta = 0
        
            VertCursorScrollbar1.Enabled = False
            VertCursorScrollbar2.Enabled = False
            HorCursorScrollbar1.Enabled = False
            HorCursorScrollbar2.Enabled = False
        
            PictHorCursor1.Visible = False
            PictHorCursor2.Visible = False
            PictVertCursor1.Visible = False
            PictVertCursor2.Visible = False
        
        End If
        
        Call HorCursorScrollbar1_Change
        Call HorCursorScrollbar2_Change
        
        Call VertCursorScrollbar1_Change
        Call VertCursorScrollbar2_Change
    
    Else ' logic analyzer mode - voltage scale would be meaningless
    
        If Cursors = vbChecked Then
        
            CursorCH1.Enabled = False
            CursorCH2.Enabled = False
        
            VertCursorScrollbar1.Enabled = True
            VertCursorScrollbar2.Enabled = True
            HorCursorScrollbar1.Enabled = False
            HorCursorScrollbar2.Enabled = False
            
            PictVertCursor1.Visible = True
            PictVertCursor2.Visible = True
            PictHorCursor1.Visible = False
            PictHorCursor2.Visible = False
            
        Else
            
            CursorCH1.Enabled = False
            CursorCH2.Enabled = False
            
            HorCursor1 = 0
            HorCursor2 = 0
            HorCursorDelta = 0
        
            VertCursor1 = 0
            VertCursor2 = 0
            VertCursorDelta = 0
        
            VertCursorScrollbar1.Enabled = False
            VertCursorScrollbar2.Enabled = False
            HorCursorScrollbar1.Enabled = False
            HorCursorScrollbar2.Enabled = False
        
            PictHorCursor1.Visible = False
            PictHorCursor2.Visible = False
            PictVertCursor1.Visible = False
            PictVertCursor2.Visible = False
        
        End If
        
        Call VertCursorScrollbar1_Change
        Call VertCursorScrollbar2_Change
    
    End If
    
    Call UpdatePlot

    Call Draw_Cursors
    
End Sub

Public Sub FrameTimer_Timer()

    FrameRate = Format(FrameCount / 5#)
    FrameCount = 0
    
End Sub

Public Sub GainCH1_Click()

    Call UpdatePlot
    
    ComboEvent = True
    
    UpDownGainCH1.value = GainCH1.ListCount - GainCH1.ListIndex - 1
    
    Select Case GainCH1.ListIndex
    
        Case 0:
            sample_shift_ch1 = 2
            sample_subtract_ch1 = 0
            adc_chan_ch1 = 5
            comp_input_chan = 1
            DatalogScale_CH1 = 1# * 100# / 512# * 25# / 24# ' half screen = 50%, ADC maxval = 1024, span 5V but used only 4.8
        Case 1:
            sample_shift_ch1 = 1
            sample_subtract_ch1 = 128
            adc_chan_ch1 = 5
            comp_input_chan = 1
            DatalogScale_CH1 = 2# * 100# / 512# * 25# / 24# ' half screen = 50%, ADC maxval = 1024, span 5V but used only 4.8
        Case 2:
            sample_shift_ch1 = 0
            sample_subtract_ch1 = 192
            adc_chan_ch1 = 5
            comp_input_chan = 1
            DatalogScale_CH1 = 4# * 100# / 512# * 25# / 24# ' half screen = 50%, ADC maxval = 1024, span 5V but used only 4.8
        Case 3:
            sample_shift_ch1 = 2
            sample_subtract_ch1 = 0
            adc_chan_ch1 = 6
            comp_input_chan = 2
            DatalogScale_CH1 = 1# * 100# / 512# * 25# / 24# ' half screen = 50%, ADC maxval = 1024, span 5V but used only 4.8
        Case 4:
            sample_shift_ch1 = 1
            sample_subtract_ch1 = 128
            adc_chan_ch1 = 6
            comp_input_chan = 2
            DatalogScale_CH1 = 2# * 100# / 512# * 25# / 24# ' half screen = 50%, ADC maxval = 1024, span 5V but used only 4.8
        Case 5:
            sample_shift_ch1 = 0
            sample_subtract_ch1 = 192
            adc_chan_ch1 = 6
            comp_input_chan = 2
            DatalogScale_CH1 = 4# * 100# / 512# * 25# / 24# ' half screen = 50%, ADC maxval = 1024, span 5V but used only 2.4
        
    End Select
    
    ' adjust range of trigger threshold
    Select Case GainCH1.ListIndex
    
        Case 0, 3:
            TriggerLevel.Min = 0
            TriggerLevel.Max = 255
            TriggerLevel.LargeChange = 8
        Case 1, 4:
            TriggerLevel.Min = 64
            TriggerLevel.Max = 192
            TriggerLevel.LargeChange = 4
        Case 2, 5:
            TriggerLevel.Min = 96
            TriggerLevel.Max = 160
            TriggerLevel.LargeChange = 2
            
    End Select
        
    Call UpdatePlot
    
    ComboEvent = False

End Sub

Public Sub GainCH1_Change()

    ComboEvent = True
        
    UpDownGainCH1.value = GainCH1.ListCount - GainCH1.ListIndex - 1
    
    ' adjust range of trigger threshold
    Select Case GainCH1.ListIndex
    
        Case 0, 3:
            TriggerLevel.Min = 0
            TriggerLevel.Max = 255
        Case 1, 4:
            TriggerLevel.Min = 64
            TriggerLevel.Max = 192
        Case 2, 5:
            TriggerLevel.Min = 96
            TriggerLevel.Max = 160
            
    End Select
    
    Call UpdatePlot
    
    ComboEvent = False

End Sub

Public Sub Gainch2_Click()

    Call UpdatePlot
    
    ComboEvent = True
    
    UpDownGainCH2.value = GainCH2.ListCount - GainCH2.ListIndex - 1
    
    Select Case GainCH2.ListIndex
    
        Case 0:
            sample_shift_ch2 = 2
            sample_subtract_ch2 = 0
            adc_chan_ch2 = 8
            DatalogScale_CH2 = 1# * 100# / 512# * 25# / 24# ' half screen = 50%, ADC maxval = 1024, span 5V but used only 4.8
        Case 1:
            sample_shift_ch2 = 1
            sample_subtract_ch2 = 128
            adc_chan_ch2 = 8
            DatalogScale_CH2 = 2# * 100# / 512# * 25# / 24# ' half screen = 50%, ADC maxval = 1024, span 5V but used only 4.8
        Case 2:
            sample_shift_ch2 = 0
            sample_subtract_ch2 = 192
            adc_chan_ch2 = 8
            DatalogScale_CH2 = 4# * 100# / 512# * 25# / 24# ' half screen = 50%, ADC maxval = 1024, span 5V but used only 4.8
        Case 3:
            sample_shift_ch2 = 2
            sample_subtract_ch2 = 0
            adc_chan_ch2 = 9
            DatalogScale_CH2 = 1# * 100# / 512# * 25# / 24# ' half screen = 50%, ADC maxval = 1024, span 5V but used only 4.8
        Case 4:
            sample_shift_ch2 = 1
            sample_subtract_ch2 = 128
            adc_chan_ch2 = 9
            DatalogScale_CH2 = 2# * 100# / 512# * 25# / 24# ' half screen = 50%, ADC maxval = 1024, span 5V but used only 4.8
        Case 5:
            sample_shift_ch2 = 0
            sample_subtract_ch2 = 192
            adc_chan_ch2 = 9
            DatalogScale_CH2 = 4# * 100# / 512# * 25# / 24# ' half screen = 50%, ADC maxval = 1024, span 5V but used only 4.8
        
    End Select
    
    ComboEvent = False

End Sub

Public Sub Gainch2_Change()

    ComboEvent = True
        
    Call UpdatePlot
    UpDownGainCH2.value = GainCH2.ListCount - GainCH2.ListIndex - 1
    
    ComboEvent = False

End Sub

Public Sub LogToFile_Click()

    Dim fname As String
    Dim userResult As Integer
    
    Close #2
    
    If LogToFile = vbChecked Then
        
        ' CancelError is True.
        On Error GoTo ErrHandler
        ' Set filters.
        CommonDialog1.Filter = "ASCII Data Files (*.csv)|*.csv"
        ' Specify default filter.
        CommonDialog1.FilterIndex = 1
    
        ' Display the Open dialog box.
        CommonDialog1.ShowSave ' or showopen
       
        fname = CommonDialog1.FileName
        If Format(Right(fname, 4), ">") <> ".CSV" Then ' convert extension to uppercase for comparison
            fname = fname + ".csv"
        End If
       
        ' Check if file already exists
        If (FileExists(fname) = True) Then
            userResult = MsgBox("File " & fname & " already exists! Overwrite?", vbYesNo, "Warning")
            If (userResult <> vbYes) Then
                RollModeLogFilename = ""
                LogToFile = vbUnchecked
                Exit Sub
            End If
        End If
        
        Open fname For Output As #2
        RollModeLogFilename = fname
    
        Write #2, "time(s)", "CH1(V)", "CH2(V)"
    
    Else
    
        RollModeLogFilename = ""
    
    End If
   
    Exit Sub

ErrHandler:

    ' Error, or user pressed Cancel button.
    Call MsgBox("Make sure the file is not already open in another program.", vbOKOnly, "Could not open file!")
    LogToFile = vbUnchecked
    Exit Sub

End Sub

Public Sub menuAbout_Click()
    
    Call frmAbout.Show
    
End Sub

Public Function GetSupplyVoltage(Optional InitPanel As Boolean = True) As Double

    Dim ADC_Val As Double
    Dim Actual_VCC As Double
    Dim i As Long, i_max As Long
    
    i_max = 100
    
    If ScanRunning Then Call runScan_Click
    
    If InitPanel Then Call InitMainpanel
        
    ADC_Val = 0
    
    For i = 1 To i_max
        ADC_Val = ADC_Val + ReadADC(15) ' channel 15 is the fixed voltage reference (FVR), set to 4096mV nominal
        Sleep 1
    Next i
    
    ADC_Val = ADC_Val / i_max
    
    GetSupplyVoltage = NOMINAL_SUPPLY * 1023 / ADC_Val * 4.096 / 5#
    
End Function

Private Sub menuCheckSupplyVoltage_Click()

    Dim SupplyVoltage As Double
    
    If MyDeviceDetected Then
    
        SupplyVoltage = GetSupplyVoltage()
        
        Call MsgBox("The USB supply voltage is " & Format(SupplyVoltage, "0.00") & " V (should be between 4.5 V and 5.5 V).", vbOKOnly, "Check USB Supply Voltage")
    
    Else
    
        Call MsgBox("No instrument connected!", vbOKOnly, "USB Supply Voltage Check")
    
    End If
    
End Sub

Private Sub menuMeasurements_Click()

    Measurements.Show

End Sub

Public Sub menuLoadSetup_Click()

    Dim fname As String
    Dim userResult As Integer
    Dim InputValTitle As Variant
    Dim InputVal As Variant
    
    ' CancelError is True.
    On Error GoTo ErrHandler
    ' Set filters.
    CommonDialog1.Filter = "Setup Files (*.dps)|*.dps"
    ' Specify default filter.
    CommonDialog1.FilterIndex = 1

    ' Display the Open dialog box.
    CommonDialog1.ShowOpen
   
    fname = CommonDialog1.FileName
    If Format(Right(fname, 4), ">") <> ".DPS" Then ' convert extension to uppercase for comparison
        fname = fname + ".dps"
    End If
   
    ' Check if file really exists
    If (FileExists(fname) = False) Then
        Call MsgBox("File " & fname & " does not exists!", vbOKOnly, "Cannot load setup file")
        Exit Sub
    End If
    
    If ScanRunning Then
        Call runScan_Click
    End If
    
    Open fname For Input As #1
    
        Input #1, InputValTitle
        Input #1, InputVal
        ScopeMode.value = InputVal
        Input #1, InputVal
        ScopeMode.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        RollMode.value = InputVal
        Input #1, InputVal
        RollMode.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        LAMode.value = InputVal
        Input #1, InputVal
        LAMode.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        TriggerFrame.Visible = InputVal
    
        Input #1, InputValTitle
        Input #1, InputVal
        LA_Trigger_Frame.Visible = InputVal
    
        Input #1, InputValTitle
        Input #1, InputVal
        RunCont.value = InputVal
        Input #1, InputVal
        RunCont.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        RunSingle.value = InputVal
        Input #1, InputVal
        RunSingle.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        AcqAvg.ListIndex = InputVal
        Input #1, InputVal
        AcqAvg.Enabled = InputVal
    
        Input #1, InputValTitle
        Input #1, InputVal
        ShowCH1.value = InputVal
        Input #1, InputVal
        ShowCH1.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        ShowCH2.value = InputVal
        Input #1, InputVal
        ShowCH2.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        ShowLA.value = InputVal
        Input #1, InputVal
        ShowLA.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        ShowRef1.value = InputVal
        Input #1, InputVal
        ShowRef1.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        ShowRef2.value = InputVal
        Input #1, InputVal
        ShowRef2.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        DoFFT.value = InputVal
        Input #1, InputVal
        DoFFT.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        DisplayVectors.value = InputVal
        Input #1, InputVal
        DisplayVectors.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        DisplayDots.value = InputVal
        Input #1, InputVal
        DisplayDots.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        Persistence.value = InputVal
        Input #1, InputVal
        Persistence.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        DisplayLevels.value = InputVal
        Input #1, InputVal
        DisplayLevels.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        Cursors.value = InputVal
        Input #1, InputVal
        Cursors.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        CursorCH1.value = InputVal
        Input #1, InputVal
        CursorCH1.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        CursorCH2.value = InputVal
        Input #1, InputVal
        CursorCH2.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        HorCursorScrollbar1.value = InputVal
        Input #1, InputVal
        HorCursorScrollbar1.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        HorCursorScrollbar2.value = InputVal
        Input #1, InputVal
        HorCursorScrollbar2.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        VertCursorScrollbar1.value = InputVal
        Input #1, InputVal
        VertCursorScrollbar1.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        VertCursorScrollbar2.value = InputVal
        Input #1, InputVal
        VertCursorScrollbar2.Enabled = InputVal

        Input #1, InputValTitle
        Input #1, InputVal
        GainCH1.ListIndex = InputVal
        Input #1, InputVal
        GainCH1.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        GainCH2.ListIndex = InputVal
        Input #1, InputVal
        GainCH2.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        TimeBase.ListIndex = InputVal
        Input #1, InputVal
        TimeBase.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        TriggerCH1.value = InputVal
        Input #1, InputVal
        TriggerCH1.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        TriggerExt.value = InputVal
        Input #1, InputVal
        TriggerExt.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        TriggerAuto.value = InputVal
        Input #1, InputVal
        TriggerAuto.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        LA_Trigger_Auto.value = InputVal
        Input #1, InputVal
        LA_Trigger_Auto.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        LA_Trigger_CH1.value = InputVal
        Input #1, InputVal
        LA_Trigger_CH1.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        LA_Trigger_CH2.value = InputVal
        Input #1, InputVal
        LA_Trigger_CH2.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        LA_Trigger_CH3.value = InputVal
        Input #1, InputVal
        LA_Trigger_CH3.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        LA_Trigger_CH4.value = InputVal
        Input #1, InputVal
        LA_Trigger_CH4.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        TriggerRising.value = InputVal
        Input #1, InputVal
        TriggerRising.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        TriggerFalling.value = InputVal
        Input #1, InputVal
        TriggerFalling.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        LA_Trigger_Rising.value = InputVal
        Input #1, InputVal
        LA_Trigger_Rising.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        LA_Trigger_Falling.value = InputVal
        Input #1, InputVal
        LA_Trigger_Falling.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        OffsetCH1.Max = InputVal
        Input #1, InputVal
        OffsetCH1.SmallChange = InputVal
        Input #1, InputVal
        OffsetCH1.LargeChange = InputVal
        Input #1, InputVal
        OffsetCH1.value = InputVal
        Input #1, InputVal
        OffsetCH1.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        OffsetCH2.Max = InputVal
        Input #1, InputVal
        OffsetCH2.SmallChange = InputVal
        Input #1, InputVal
        OffsetCH2.LargeChange = InputVal
        Input #1, InputVal
        OffsetCH2.value = InputVal
        Input #1, InputVal
        OffsetCH2.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        TriggerLevel.Max = InputVal
        Input #1, InputVal
        TriggerLevel.SmallChange = InputVal
        Input #1, InputVal
        TriggerLevel.LargeChange = InputVal
        Input #1, InputVal
        TriggerLevel.value = InputVal
        Input #1, InputVal
        TriggerLevel.Enabled = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        FFTScaleVal = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        FFTDisplayVal = InputVal
        
        Input #1, InputValTitle
        Input #1, InputVal
        FFTFilterVal = InputVal
        
        FFTSetupPanel.Hide
        
        Input #1, InputValTitle
        Input #1, InputVal
        
        If InputVal = True Then
            FFTSetupPanel.Show
        End If
        
        Input #1, InputValTitle
        Input #1, InputVal
        LinesBold.value = InputVal
    
        Input #1, InputValTitle
        Input #1, InputVal
        ProbeAtten10_CH1 = InputVal
    
        Input #1, InputValTitle
        Input #1, InputVal
        ProbeAtten10_CH2 = InputVal
    
    Close #1
   
    Call MsgBox("Setup " & fname & " successfully loaded!", vbOKOnly, "Load Setup")
    
    Exit Sub

ErrHandler:
' User pressed Cancel button.
    Close #1
    Call MsgBox("Problem encountered at or after setting " & InputValTitle & "!", vbOKOnly, "Cannot load setup file")
    Exit Sub

End Sub

Public Sub menuSaveSetupAs_Click()

    Dim fname As String
    Dim userResult As Integer

    ' CancelError is True.
    On Error GoTo ErrHandler
    ' Set filters.
    CommonDialog1.Filter = "Setup Files (*.dps)|*.dps"
    ' Specify default filter.
    CommonDialog1.FilterIndex = 1

    ' Display the Open dialog box.
    CommonDialog1.ShowSave
   
    fname = CommonDialog1.FileName
    If Format(Right(fname, 4), ">") <> ".DPS" Then ' convert extension to uppercase for comparison
        fname = fname + ".dps"
    End If
   
    ' Check if file already exists
    If (FileExists(fname) = True) Then
        userResult = MsgBox("File " & fname & " already exists! Overwrite?", vbYesNo, "Warning")
        If (userResult <> vbYes) Then Exit Sub
    End If
    
    If ScanRunning Then
        Call runScan_Click
    End If
    
    Open fname For Output As #1
    
        Write #1, "ScopeMode"
        Write #1, ScopeMode.value
        Write #1, ScopeMode.Enabled
        
        Write #1, "RollMode"
        Write #1, RollMode.value
        Write #1, RollMode.Enabled
        
        Write #1, "LAMode"
        Write #1, LAMode.value
        Write #1, LAMode.Enabled
        
        Write #1, "TriggerFrame"
        Write #1, TriggerFrame.Visible
    
        Write #1, "LA_Trigger_Frame"
        Write #1, LA_Trigger_Frame.Visible
    
        Write #1, "RunCont"
        Write #1, RunCont.value
        Write #1, RunCont.Enabled
        
        Write #1, "RunSingle"
        Write #1, RunSingle.value
        Write #1, RunSingle.Enabled
        
        Write #1, "AcqAvg.ListIndex"
        Write #1, AcqAvg.ListIndex
        Write #1, AcqAvg.Enabled
    
        Write #1, "ShowCH1"
        Write #1, ShowCH1.value
        Write #1, ShowCH1.Enabled
        
        Write #1, "ShowCH2"
        Write #1, ShowCH2.value
        Write #1, ShowCH2.Enabled
        
        Write #1, "ShowLA"
        Write #1, ShowLA.value
        Write #1, ShowLA.Enabled
        
        Write #1, "ShowRef1"
        Write #1, ShowRef1.value
        Write #1, ShowRef1.Enabled
        
        Write #1, "ShowRef2"
        Write #1, ShowRef2.value
        Write #1, ShowRef2.Enabled
        
        Write #1, "DoFFT"
        Write #1, DoFFT.value
        Write #1, DoFFT.Enabled
        
        Write #1, "DisplayVectors"
        Write #1, DisplayVectors.value
        Write #1, DisplayVectors.Enabled
        
        Write #1, "DisplayDots"
        Write #1, DisplayDots.value
        Write #1, DisplayDots.Enabled
        
        Write #1, "Persistence"
        Write #1, Persistence.value
        Write #1, Persistence.Enabled
        
        Write #1, "DisplayLevels"
        Write #1, DisplayLevels.value
        Write #1, DisplayLevels.Enabled
        
        Write #1, "Cursors"
        Write #1, Cursors.value
        Write #1, Cursors.Enabled
        
        Write #1, "CursorCH1"
        Write #1, CursorCH1.value
        Write #1, CursorCH1.Enabled
        
        Write #1, "CursorCH2"
        Write #1, CursorCH2.value
        Write #1, CursorCH2.Enabled
        
        Write #1, "HorCursorScrollbar1"
        Write #1, HorCursorScrollbar1.value
        Write #1, HorCursorScrollbar1.Enabled
        
        Write #1, "HorCursorScrollbar2"
        Write #1, HorCursorScrollbar2.value
        Write #1, HorCursorScrollbar2.Enabled
        
        Write #1, "VertCursorScrollbar1"
        Write #1, VertCursorScrollbar1.value
        Write #1, VertCursorScrollbar1.Enabled
        
        Write #1, "VertCursorScrollbar2"
        Write #1, VertCursorScrollbar2.value
        Write #1, VertCursorScrollbar2.Enabled

        Write #1, "GainCH1.ListIndex"
        Write #1, GainCH1.ListIndex
        Write #1, GainCH1.Enabled
        
        Write #1, "GainCH2.ListIndex"
        Write #1, GainCH2.ListIndex
        Write #1, GainCH2.Enabled
                        
        Write #1, "TimeBase.ListIndex"
        Write #1, TimeBase.ListIndex
        Write #1, TimeBase.Enabled
        
        Write #1, "TriggerCH1"
        Write #1, TriggerCH1.value
        Write #1, TriggerCH1.Enabled
        
        Write #1, "TriggerExt"
        Write #1, TriggerExt.value
        Write #1, TriggerExt.Enabled
        
        Write #1, "TriggerAuto"
        Write #1, TriggerAuto.value
        Write #1, TriggerAuto.Enabled
        
        Write #1, "LA_Trigger_Auto"
        Write #1, LA_Trigger_Auto.value
        Write #1, LA_Trigger_Auto.Enabled
        
        Write #1, "LA_Trigger_CH1"
        Write #1, LA_Trigger_CH1.value
        Write #1, LA_Trigger_CH1.Enabled
        
        Write #1, "LA_Trigger_CH2"
        Write #1, LA_Trigger_CH2.value
        Write #1, LA_Trigger_CH2.Enabled
        
        Write #1, "LA_Trigger_CH3"
        Write #1, LA_Trigger_CH3.value
        Write #1, LA_Trigger_CH3.Enabled
        
        Write #1, "LA_Trigger_CH4"
        Write #1, LA_Trigger_CH4.value
        Write #1, LA_Trigger_CH4.Enabled
        
        Write #1, "TriggerRising"
        Write #1, TriggerRising.value
        Write #1, TriggerRising.Enabled
        
        Write #1, "TriggerFalling"
        Write #1, TriggerFalling.value
        Write #1, TriggerFalling.Enabled

        Write #1, "LA_Trigger_Rising"
        Write #1, LA_Trigger_Rising.value
        Write #1, LA_Trigger_Rising.Enabled
        
        Write #1, "la_Trigger_Falling"
        Write #1, LA_Trigger_Falling.value
        Write #1, LA_Trigger_Falling.Enabled

        Write #1, "OffsetCH1"
        Write #1, OffsetCH1.Max
        Write #1, OffsetCH1.SmallChange
        Write #1, OffsetCH1.LargeChange
        Write #1, OffsetCH1.value
        Write #1, OffsetCH1.Enabled
        
        Write #1, "OffsetCH2"
        Write #1, OffsetCH2.Max
        Write #1, OffsetCH2.SmallChange
        Write #1, OffsetCH2.LargeChange
        Write #1, OffsetCH2.value
        Write #1, OffsetCH2.Enabled
        
        Write #1, "TriggerLevel"
        Write #1, TriggerLevel.Max
        Write #1, TriggerLevel.SmallChange
        Write #1, TriggerLevel.LargeChange
        Write #1, TriggerLevel.value
        Write #1, TriggerLevel.Enabled
                
        Write #1, "FFTScaleVal"
        Write #1, FFTScaleVal
        
        Write #1, "FFTDisplayVal"
        Write #1, FFTDisplayVal
        
        Write #1, "FFTFilterVal"
        Write #1, FFTFilterVal
                
        Write #1, "FFTSetupPanel.Visible"
        Write #1, FFTSetupPanel.Visible
        
        Write #1, "LinesBold"
        Write #1, LinesBold.value
        
        Write #1, "ProbeAtten10_CH1"
        Write #1, ProbeAtten10_CH1
        
        Write #1, "ProbeAtten10_CH2"
        Write #1, ProbeAtten10_CH2
                        
    Close #1
   
    Exit Sub

ErrHandler:
' User pressed Cancel button.
    Close #1
    Exit Sub

End Sub

Public Sub OffsetCH1_Scroll()

    Call UpdatePlot

End Sub

Public Sub OffsetCH1_Change()

    Call UpdatePlot

End Sub

Public Sub OffsetCH2_Scroll()

    Call UpdatePlot

End Sub

Public Sub OffsetCH2_Change()

    Call UpdatePlot

End Sub

Public Sub RollMode_Click()

    Persistence = vbUnchecked
    Persistence.Enabled = False
    DisplayLevels.Enabled = True
        
    DoFFT = vbUnchecked
    DoFFT.Enabled = False
    FFTSetup.Enabled = False
    FFTSetupPanel.Visible = False
    
    RunCont = True
    RunCont.Enabled = False
    RunSingle = False
    RunSingle.Enabled = False
    
    GainCH1.Enabled = True
    GainCH2.Enabled = True
    UpDownGainCH1.Enabled = True
    UpDownGainCH2.Enabled = True
    ProbeAtten10_CH1.Enabled = True
    ProbeAtten10_CH2.Enabled = True
    
    LA_Trigger_Frame.Visible = False
    TriggerFrame.Visible = True
    
    TriggerAuto.Enabled = False
    TriggerCH1.Enabled = False
    TriggerExt.Enabled = False
    TriggerRising.Enabled = False
    TriggerFalling.Enabled = False
        
    TriggerLevel.Enabled = False
    CenterOffsetTrig.Enabled = False
         
    OffsetCH1.Enabled = True
    OffsetCH2.Enabled = True
    CenterOffsetCH1.Enabled = True
    CenterOffsetCH2.Enabled = True
    
    AcqAvg.Enabled = False
    UpDownAcqAvg.Enabled = False
    
    ShowCH1.Enabled = True
    ShowRef1.Enabled = True
    SaveToRef1.Enabled = True
    ShowCH2.Enabled = True
    ShowRef2.Enabled = True
    SaveToRef2.Enabled = True
    ShowLA.Enabled = True
    
    ShowCH1 = vbChecked
    ShowCH2 = vbChecked
    ShowLA = vbChecked
    
    LA_Hor_Pos = 0
    LA_Hor_Pos.Enabled = False
    
    Cursors.Enabled = True
    Call Cursors_Click
    
    UpDownTimeBase.Max = 11
    
    TimeBase.ListIndex = 0

    Call SetHorAxisUnits(HOR_UNITS_TIME)
    
    Call TimeBase_Click

    LogToFile.Enabled = True
    LogToFile = vbUnchecked
    
    Call Draw_Cursors
        
End Sub

Public Sub ScopeMode_Click()

    LogToFile = vbUnchecked
    LogToFile.Enabled = False
    RollModeLogFilename = ""
    
    Persistence.Enabled = True
    DisplayLevels.Enabled = True
        
    DoFFT.Enabled = True
    FFTSetup.Enabled = True
    
    ShowCH1.Enabled = True
    ShowCH2.Enabled = True
    ShowRef1.Enabled = True
    ShowRef2.Enabled = True
    SaveToRef1.Enabled = True
    SaveToRef2.Enabled = True
    
    ShowCH1 = vbChecked
    ShowCH2 = vbChecked
    
    ShowLA.Enabled = False
    ShowLA = vbUnchecked
    
    Cursors.Enabled = True
    Call Cursors_Click
    
    RunCont.Enabled = True
    RunSingle.Enabled = True
    
    GainCH1.Enabled = True
    GainCH2.Enabled = True
    UpDownGainCH1.Enabled = True
    UpDownGainCH2.Enabled = True
    ProbeAtten10_CH1.Enabled = True
    ProbeAtten10_CH2.Enabled = True
    
    TriggerAuto.Enabled = True
    TriggerCH1.Enabled = True
    TriggerExt.Enabled = True
    TriggerRising.Enabled = True
    TriggerFalling.Enabled = True
        
    TriggerLevel.Enabled = True
    CenterOffsetTrig.Enabled = True

    OffsetCH1.Enabled = True
    OffsetCH2.Enabled = True
    CenterOffsetCH1.Enabled = True
    CenterOffsetCH2.Enabled = True
    
    LA_Trigger_Frame.Visible = False
    TriggerFrame.Visible = True
    
    AcqAvg.Enabled = True
    UpDownAcqAvg.Enabled = True

    LA_Hor_Pos = 0
    LA_Hor_Pos.Enabled = False
    
    UpDownTimeBase.Max = 16
    
    TimeBase.ListIndex = 6
    
    Call SetHorAxisUnits(HOR_UNITS_TIME)

    Call TimeBase_Click
    
    Call Draw_Cursors
    
End Sub

Private Sub LAMode_Click()

    LA_DrawGrid = True

    LogToFile = vbUnchecked
    LogToFile.Enabled = False
    RollModeLogFilename = ""
    
    Persistence = vbUnchecked
    Persistence.Enabled = True
    DisplayLevels = vbUnchecked
    DisplayLevels.Enabled = False
    
    DoFFT.Enabled = False
    FFTSetup.Enabled = False
    
    ShowCH1 = vbUnchecked
    ShowCH1.Enabled = False
    ShowCH2 = vbUnchecked
    ShowCH2.Enabled = False
    ShowRef1 = vbUnchecked
    ShowRef1.Enabled = False
    ShowRef2 = vbUnchecked
    ShowRef2.Enabled = False
    SaveToRef1.Enabled = False
    SaveToRef2.Enabled = False
    
    ShowLA.Enabled = True
    ShowLA = vbChecked
    
    RunCont.Enabled = True
    RunSingle.Enabled = True
    RunSingle = True
    
    GainCH1.Enabled = False
    GainCH2.Enabled = False
    UpDownGainCH1.Enabled = False
    UpDownGainCH2.Enabled = False
    ProbeAtten10_CH1.Enabled = False
    ProbeAtten10_CH2.Enabled = False
    
    LA_Trigger_Frame.Visible = True
    TriggerFrame.Visible = False
    
    TriggerAuto.Enabled = False
    TriggerCH1.Enabled = False
    TriggerExt.Enabled = False
    TriggerRising.Enabled = False
    TriggerFalling.Enabled = False
        
    TriggerLevel.Enabled = False
    CenterOffsetTrig.Enabled = False

    OffsetCH1.Enabled = False
    OffsetCH2.Enabled = False
    CenterOffsetCH1.Enabled = False
    CenterOffsetCH2.Enabled = False
    
    AcqAvg.Enabled = False
    UpDownAcqAvg.Enabled = False
    
    LA_Hor_Pos = 0
    LA_Hor_Pos.Enabled = True
    
    Cursors.Enabled = True
    Call Cursors_Click
    
    UpDownTimeBase.Max = 15
    
    TimeBase.ListIndex = 0
    
    Call SetHorAxisUnits(HOR_UNITS_TIME)

    Call TimeBase_Click

    Call Draw_Cursors
    
End Sub

Private Sub ShowLA_Click()

    Call UpdatePlot

End Sub

Private Sub TriggerAuto_Click()

    If TriggerAuto Then
        TriggerCH1 = False
        TriggerExt = False
        TriggerLevel.Enabled = False
        CenterOffsetTrig.Enabled = False
        TriggerRising.Enabled = False
        TriggerFalling.Enabled = False
    End If

End Sub

Private Sub TriggerCH1_Click()

    If TriggerCH1 Then
        TriggerAuto = False
        TriggerExt = False
        TriggerLevel.Enabled = True
        CenterOffsetTrig.Enabled = True
        TriggerRising.Enabled = True
        TriggerFalling.Enabled = True
    End If
    
End Sub

Private Sub TriggerExt_Click()

    If TriggerExt Then
        TriggerAuto = False
        TriggerCH1 = False
        TriggerLevel.Enabled = False
        CenterOffsetTrig.Enabled = False
        TriggerRising.Enabled = True
        TriggerFalling.Enabled = True
    End If

End Sub

Public Sub TriggerLevel_Scroll()

    Call UpdatePlot

End Sub

Public Sub TriggerLevel_Change()

    Call UpdatePlot

End Sub

Public Sub HorCursorScrollbar1_Scroll()
    
    If Cursors = vbChecked Then
        HorCursor1 = HorCursorScrollbar1.value / 100
        HorCursorDelta = Abs(HorCursor1 - HorCursor2)
        Call UpdatePlot
    Else
        HorCursorScrollbar1 = HorCursorScrollbar1.Max
    End If
    
End Sub

Public Sub HorCursorScrollbar2_Scroll()

    If Cursors = vbChecked Then
        HorCursor2 = HorCursorScrollbar2.value / 100
        HorCursorDelta = Abs(HorCursor1 - HorCursor2)
        Call UpdatePlot
    Else
        HorCursorScrollbar2 = HorCursorScrollbar2.Max
    End If

End Sub

Public Sub menuExit_Click()

    Call Form_Unload(0)
    
End Sub

Public Sub menuExportData_Click()
   
    Dim fname As String
    Dim userResult As Integer
    Dim i_row As Long
    Dim RecLen As Long
    
    Dim GainCH1 As Double, GainCH2 As Double
    Dim OffsetCH1 As Double, OffsetCH2 As Double
    
    Dim Time As Double

    Dim Gain As Double
    Dim Offset As Double
    Dim TimeScale As Double
    Dim FreqScale As Double
    
    ' CancelError is True.
    On Error GoTo ErrHandler
    ' Set filters.
    CommonDialog1.Filter = "ASCII Data Files (*.csv)|*.csv"
    ' Specify default filter.
    CommonDialog1.FilterIndex = 1

    ' Display the Open dialog box.
    CommonDialog1.ShowSave ' or showopen
   
    fname = CommonDialog1.FileName
    If Format(Right(fname, 4), ">") <> ".CSV" Then ' convert extension to uppercase for comparison
        fname = fname + ".csv"
    End If
   
    ' Check if file already exists
    If (FileExists(fname) = True) Then
        userResult = MsgBox("File " & fname & " already exists! Overwrite?", vbYesNo, "Warning")
        If (userResult <> vbYes) Then Exit Sub
    End If
    
    Open fname For Output As #1
    
    If DoFFT = vbUnchecked Then ' time domain display
    
        If ScopeMode Then
        
            GainCH1 = GetGain(1) * 5 ' change scaling to "per division"
            GainCH2 = GetGain(2) * 5 ' change scaling to "per division"
            
            OffsetCH1 = GetOffset(1)
            OffsetCH2 = GetOffset(2)
            
            TimeScale = GetTimebase
            
            RecLen = FULL_READBACK_LENGTH
            
            Write #1, "time(s)", "CH1(V)", "REF1(V)", "CH2(V)", "REF2(V)"
        
            For i_row = 1 To RecLen
            
                ' 5# is not a magic number (or the supply voltage, it's simply
                ' the ratio between y-axis full scale (100) and number of y-divisions (20)
                Write #1, (i_row - 1) * TimeScale / 10#, _
                          DataBuffer(i_row, 2) * GainCH1 / 5# - OffsetCH1, _
                          DataBuffer(i_row, 6) * GainCH1 / 5# - OffsetCH1, _
                          DataBuffer(i_row, 4) * GainCH2 / 5# - OffsetCH2, _
                          DataBuffer(i_row, 8) * GainCH2 / 5# - OffsetCH2
                          
            Next i_row
       
        ElseIf LAMode Then
        
            TimeScale = GetTimebase
            
            RecLen = 4 * FULL_READBACK_LENGTH ' LA data uses both channel buffers, and only half a byte per sample
            
            Write #1, "time(s)", "LA_CH1", "LA_CH2", "LA_CH3", "LA_CH4"
            
            For i_row = 1 To RecLen
            
                Write #1, (i_row - 1) * TimeScale / 10#, _
                          (DataBuffer(i_row, 10) And 128) / 128, _
                          (DataBuffer(i_row, 10) And 64) / 64, _
                          (DataBuffer(i_row, 10) And 32) / 32, _
                          (DataBuffer(i_row, 10) And 16) / 16

            Next i_row
                            
        ElseIf RollMode Then
        
            GainCH1 = GetGain(1) * 5 ' change scaling to "per division"
            GainCH2 = GetGain(2) * 5 ' change scaling to "per division"
            
            OffsetCH1 = GetOffset(1)
            OffsetCH2 = GetOffset(2)
            
            TimeScale = GetTimebase
            
            RecLen = FULL_READBACK_LENGTH
            
            Write #1, "time(s)", "CH1(V)", "REF1(V)", "CH2(V)", "REF2(V)", "LA_CH1", "LA_CH2", "LA_CH3", "LA_CH4"
        
            For i_row = 1 To RecLen
            
                ' 5# is not a magic number (or the supply voltage, it's simply
                ' the ratio between y-axis full scale (100) and number of y-divisions (20)
                Write #1, (i_row - 1) * TimeScale / 10#, _
                          DataBuffer(i_row, 2) * GainCH1 / 5# - OffsetCH1, _
                          DataBuffer(i_row, 6) * GainCH1 / 5# - OffsetCH1, _
                          DataBuffer(i_row, 4) * GainCH2 / 5# - OffsetCH2, _
                          DataBuffer(i_row, 8) * GainCH2 / 5# - OffsetCH2, _
                          (DataBuffer(i_row, 10) And 128) / 128, _
                          (DataBuffer(i_row, 10) And 64) / 64, _
                          (DataBuffer(i_row, 10) And 32) / 32, _
                          (DataBuffer(i_row, 10) And 16) / 16
                          
            Next i_row
        
        End If
        
    Else ' frequency spectrum

        RecLen = DATA_ARRAY_SIZE_FFT / 2

        FreqScale = GetFreqScale
        
        If FFTScaleVal = FFTScaleVal_LINEAR Then
        
            Gain = 1 ' 5%/div, i.e. full scale (largest peak) is 100%
            Offset = 0 ' bottom is zero V (or zero Watts), top is 100%
            
            Write #1, "freq(Hz)", "CH1(%)", "REF1(%)", "CH2(%)", "REF2(%)"
            
        Else ' logarithmic
        
            Gain = 1 ' 5 dB/div, and 20 divs are value 100
            Offset = 100 ' top of screen is 0 dB
            
            Write #1, "freq(Hz)", "CH1(dB)", "REF1(dB)", "CH2(dB)", "REF2(dB)"
        
        End If
            
        For i_row = 1 To RecLen
        
            Write #1, DataBuffer(i_row, 1) * FreqScale, _
                      DataBuffer(i_row, 2) * Gain - Offset, _
                      DataBuffer(i_row, 6) * Gain - Offset, _
                      DataBuffer(i_row, 4) * Gain - Offset, _
                      DataBuffer(i_row, 8) * Gain - Offset
                      
        Next i_row
        
    End If
    
    Close #1
   
    Exit Sub

ErrHandler:

'   Error condition - could not open output file
    Call MsgBox("Make sure the file is not already open in another program.", vbOKOnly, "Could not open file!")
    Exit Sub

End Sub

Public Sub TimeBase_Click()
    
    Dim Counts As Long
    Dim Preload As Long
    Dim TSample As Long
    Dim ListIndex As Long
    Dim LocalTimeAxisScale As Double
    
    ChangeOfTimebase = True
    
    ShowRef1 = vbUnchecked
    ShowRef2 = vbUnchecked
    
    ListIndex = TimeBase.ListIndex
    
    If ScopeMode Then
    
        If DoFFT <> vbChecked Then
        
            If ListIndex <= 5 And TimeBaseListIndex_old > 5 Then ' change from real time to equivalent time
                TriggerAuto_old = TriggerAuto
                TriggerCH1_old = TriggerCH1 ' remember old setting so we can restore it when going back to real-time sampling
                TriggerExt_old = TriggerExt ' remember old setting so we can restore it when going back to real-time sampling
                
                If TriggerAuto Then TriggerCH1 = True ' enforce triggered mode in equivalent time mode
                TriggerAuto = False
                TriggerAuto.Enabled = False
            End If
            
            If ListIndex > 5 And TimeBaseListIndex_old <= 5 Then ' change from equivalent time to real time
                TriggerAuto.Enabled = True
                TriggerAuto = TriggerAuto_old
                TriggerCH1 = TriggerCH1_old ' restore setting
                TriggerExt = TriggerExt_old
            End If
            
            Select Case ListIndex
            
                Case 0: ' 5 us/div
                    SamplingMode = SAMPLE_MODE_ET
                    SampleInterval = 1
                    TimeAxisScale = 0.000005
                    FreqAxisScale = 80000
                    SampleRate = "2 MSa/sec ET"
                Case 1: ' 10 us/div
                    SamplingMode = SAMPLE_MODE_ET
                    SampleInterval = 2
                    TimeAxisScale = 0.00001
                    FreqAxisScale = 40000
                    SampleRate = "1 MSa/sec ET"
                Case 2: ' 20 us/div
                    SamplingMode = SAMPLE_MODE_ET
                    SampleInterval = 4
                    TimeAxisScale = 0.00002
                    FreqAxisScale = 20000
                    SampleRate = "500 kSa/sec ET"
                Case 3: ' 50 us/div
                    SamplingMode = SAMPLE_MODE_ET
                    SampleInterval = 10
                    TimeAxisScale = 0.00005
                    FreqAxisScale = 8000
                    SampleRate = "200 kSa/sec ET"
                Case 4: ' 0.1 ms/div
                    SamplingMode = SAMPLE_MODE_ET
                    SampleInterval = 20
                    TimeAxisScale = 0.0001
                    FreqAxisScale = 4000
                    SampleRate = "100 kSa/sec ET"
                Case 5: ' 0.2 ms/div
                    SamplingMode = SAMPLE_MODE_RT ' for the scope it is "real time", but we will alternate between channels
                    SampleInterval = 40
                    TimeAxisScale = 0.0002
                    FreqAxisScale = 2000
                    SampleRate = "50 kSa/sec ALT"
                Case 6: ' 0.5 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.0005 '0.0005
                    FreqAxisScale = 800
                    SampleRate = "20 kSa/sec"
                Case 7: ' 1 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.001
                    FreqAxisScale = 400
                    SampleRate = "10 kSa/sec"
                Case 8: ' 2 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.002
                    FreqAxisScale = 200
                    SampleRate = "5 kSa/sec"
                Case 9: ' 5 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.005
                    FreqAxisScale = 80
                    SampleRate = "2 kSa/sec"
                Case 10: ' 10 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.01
                    FreqAxisScale = 40
                    SampleRate = "1 kSa/sec"
                Case 11: ' 20 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.02
                    FreqAxisScale = 20
                    SampleRate = "500 Sa/sec"
                Case 12: ' 50 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.05
                    FreqAxisScale = 8
                    SampleRate = "200 Sa/sec"
                Case 13: ' 100 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.1
                    FreqAxisScale = 4
                    SampleRate = "100 Sa/sec"
                Case 14: ' 200 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.2
                    FreqAxisScale = 2
                    SampleRate = "50 Sa/sec"
                Case 15: ' 500 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.5
                    FreqAxisScale = 0.8
                    SampleRate = "20 Sa/sec"
                Case 16: ' 1 sec/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 1#
                    FreqAxisScale = 0.4
                    SampleRate = "10 Sa/sec"
            
            End Select
        
        Else ' FFT mode - use different sample rates so the frequency scaling is "nice" (1-2-5 sequence, not 0.8-2-4)
        
            If TimeBase.ListIndex < 6 Then ' at the moment FFT only works with real-time sampling (firmware would need to change for ETS)
                TimeBase.ListIndex = 6 ' launches this function again
                Exit Sub ' prevent yet another execution (which would use wrong - old - list index)
            End If
            
            Select Case ListIndex
            
                Case 6: ' 0.5 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.0004 '0.0005
                    FreqAxisScale = 1000
                    SampleRate = "50 kSa/sec"
                Case 7: ' 1 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.0008
                    FreqAxisScale = 500
                    SampleRate = "25 kSa/sec"
                Case 8: ' 2 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.002
                    FreqAxisScale = 200
                    SampleRate = "10 kSa/sec"
                Case 9: ' 5 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.004
                    FreqAxisScale = 100
                    SampleRate = "5 kSa/sec"
                Case 10: ' 10 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.008
                    FreqAxisScale = 50
                    SampleRate = "2.5 kSa/sec"
                Case 11: ' 20 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.02
                    FreqAxisScale = 20
                    SampleRate = "1 kSa/sec"
                Case 12: ' 50 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.04
                    FreqAxisScale = 10
                    SampleRate = "500 Sa/sec"
                Case 13: ' 100 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.08
                    FreqAxisScale = 5
                    SampleRate = "250 Sa/sec"
                Case 14: ' 200 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.2
                    FreqAxisScale = 2
                    SampleRate = "100 Sa/sec"
                Case 15: ' 500 ms/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.4
                    FreqAxisScale = 1
                    SampleRate = "50 Sa/sec"
                Case 16: ' 1 sec/div
                    SamplingMode = SAMPLE_MODE_RT
                    TimeAxisScale = 0.8
                    FreqAxisScale = 0.5
                    SampleRate = "25 Sa/sec"
            
            End Select
        
        End If
        
        If ListIndex >= 6 Then ' real time sampling uses a timer
        
            ' empirical formula for necessary timer counts
            ' Counts = T_sample(usec) * 6 - 54
            ' preload = 65536 - counts
        
            If TimeAxisScale <= 0.05 Then
                
                PrescalerBypass = 1 ' no prescaler
                PrescalerSelection = 0
    
                TSample = (TimeAxisScale * 1000000#) / 10 ' in usec, but 10 samples/div
                Counts = TSample * 6 - 54
                Preload = 65536 - Counts
                
            Else
                
                PrescalerBypass = 0 ' use prescaler for slow sample rates to prevent overflow
                PrescalerSelection = 6 ' divide by 2^(6+1) = 128 - headroom uo to approx. 10 sec/div
    
                TSample = (TimeAxisScale * 1000000#) / 10 ' in usec, but 10 samples/div
                Counts = (TSample * 6 - 54) / 128
                Preload = 65536 - Counts
                        
            End If
            
        ElseIf ListIndex = SAMPLE_RATE_50k Then ' special case - alternated acquisition at 50 kSa/sec per channel
        
            PrescalerBypass = 1 ' no prescaler
            PrescalerSelection = 0

            TSample = 2 * (TimeAxisScale * 1000000#) / 10 ' in usec, but 10 samples/div
            Counts = TSample * 6 - 54
            Preload = 65536 - Counts
        
        Else
        
            PrescalerBypass = 1
            PrescalerSelection = 0
            TimerPreloadHigh = 255 ' so we don't get accidentally stuck with a super-slow counter
            TimerPreloadLow = 0
            
        End If
        
        TimerPreloadHigh = Preload \ 256
        TimerPreloadLow = Preload Mod 256
        
        ComboEvent = True
        UpDownTimeBase = 16 - TimeBase.ListIndex
        ComboEvent = False
        
        TimeBaseListIndex_old = TimeBase.ListIndex
                    
    ElseIf LAMode Then

        Select Case ListIndex

            Case 0: ' 10 us/div
                TimeAxisScale = 0.00001
                LocalTimeAxisScale = 0.0001
                SampleRate = "1 MSa/sec"
                LA_Sample_Function = LA_SAMPLE_1M
            Case 1: ' 20 us/div
                TimeAxisScale = 0.00002
                LocalTimeAxisScale = 0.0001
                SampleRate = "500 kSa/sec"
                LA_Sample_Function = LA_SAMPLE_500K
            Case 2: ' 50 us/div
                TimeAxisScale = 0.00005
                LocalTimeAxisScale = 0.0001
                SampleRate = "200 kSa/sec"
                LA_Sample_Function = LA_SAMPLE_200K
            Case 3: ' 0.1 ms/div
                TimeAxisScale = 0.0001
                SampleRate = "100 kSa/sec"
                LA_Sample_Function = LA_SAMPLE_SLOW
            Case 4: ' 0.2 ms/div
                TimeAxisScale = 0.0002
                SampleRate = "50 kSa/sec"
                LA_Sample_Function = LA_SAMPLE_SLOW
            Case 5: ' 0.5 ms/div
                TimeAxisScale = 0.0005 '0.0005
                SampleRate = "20 kSa/sec"
                LA_Sample_Function = LA_SAMPLE_SLOW
            Case 6: ' 1 ms/div
                TimeAxisScale = 0.001
                SampleRate = "10 kSa/sec"
                LA_Sample_Function = LA_SAMPLE_SLOW
            Case 7: ' 2 ms/div
                TimeAxisScale = 0.002
                SampleRate = "5 kSa/sec"
                LA_Sample_Function = LA_SAMPLE_SLOW
            Case 8: ' 5 ms/div
                TimeAxisScale = 0.005
                SampleRate = "2 kSa/sec"
                LA_Sample_Function = LA_SAMPLE_SLOW
            Case 9: ' 10 ms/div
                TimeAxisScale = 0.01
                SampleRate = "1 kSa/sec"
                LA_Sample_Function = LA_SAMPLE_SLOW
            Case 10: ' 20 ms/div
                TimeAxisScale = 0.02
                SampleRate = "500 Sa/sec"
                LA_Sample_Function = LA_SAMPLE_SLOW
            Case 11: ' 50 ms/div
                TimeAxisScale = 0.05
                SampleRate = "200 Sa/sec"
                LA_Sample_Function = LA_SAMPLE_SLOW
            Case 12: ' 100 ms/div
                TimeAxisScale = 0.1
                SampleRate = "100 Sa/sec"
                LA_Sample_Function = LA_SAMPLE_SLOW
            Case 13: ' 200 ms/div
                TimeAxisScale = 0.2
                SampleRate = "50 Sa/sec"
                LA_Sample_Function = LA_SAMPLE_SLOW
            Case 14: ' 500 ms/div
                TimeAxisScale = 0.5
                SampleRate = "20 Sa/sec"
                LA_Sample_Function = LA_SAMPLE_SLOW
            Case 15: ' 1 sec/div
                TimeAxisScale = 1#
                SampleRate = "10 Sa/sec"
                LA_Sample_Function = LA_SAMPLE_SLOW

        End Select

        ' empirical formula for necessary timer counts
        ' Counts = T_sample(usec) * 6 - 54
        ' preload = 65536 - counts

        If LA_Sample_Function = LA_SAMPLE_SLOW Then
            LocalTimeAxisScale = TimeAxisScale
        End If
        
        If LocalTimeAxisScale <= 0.025 Then ' instead of 0.05 to take into account factor 2 below

            PrescalerBypass = 1 ' no prescaler
            PrescalerSelection = 0

            TSample = (LocalTimeAxisScale * 1000000#) / 10 ' in usec, but 10 samples/div
            Counts = 2 * (TSample * 6) - 54 ' factor 2 compared to scope mode because LA only acquires one channel (scope interleaves 2 chans)
            Preload = 65536 - Counts

        Else

            PrescalerBypass = 0 ' use prescaler for slow sample rates to prevent overflow
            PrescalerSelection = 6 ' divide by 2^(6+1) = 128 - headroom uo to approx. 10 sec/div

            TSample = (LocalTimeAxisScale * 1000000#) / 10 ' in usec, but 10 samples/div
            Counts = (2 * (TSample * 6) - 54) / 128
            Preload = 65536 - Counts

        End If

        TimerPreloadHigh = Preload \ 256
        TimerPreloadLow = Preload Mod 256

        ComboEvent = True
        UpDownTimeBase = 15 - TimeBase.ListIndex
        ComboEvent = False

        TimeBaseListIndex_old = TimeBase.ListIndex
    
    Else ' roll mode
    
        Select Case TimeBase.ListIndex
        
            Case 0: ' 0.5 sec/div
                TimeAxisScale = 0.5
                SampleRate = "20 Samples/sec"
            
            Case 1: ' 1 sec/div
                TimeAxisScale = 1#
                SampleRate = "10 Samples/sec"
            
            Case 2: ' 2 sec/div
                TimeAxisScale = 2#
                SampleRate = "5 Samples/sec"
            
            Case 3: ' 5 sec/div
                TimeAxisScale = 5#
                SampleRate = "2 Samples/sec"
            
            Case 4: ' 10 sec/div
                TimeAxisScale = 10#
                SampleRate = "1 Sample/sec"
            
            Case 5: ' 20 sec/div
                TimeAxisScale = 20#
                SampleRate = "30 Samples/min"
            
            Case 6: ' 1 min/div
                TimeAxisScale = 60#
                SampleRate = "10 Samples/min"
            
            Case 7: ' 2 min/div
                TimeAxisScale = 120#
                SampleRate = "5 Samples/min"
            
            Case 8: ' 5 min/div
                TimeAxisScale = 300#
                SampleRate = "2 Samples/min"
            
            Case 9: ' 10 min/div
                TimeAxisScale = 600#
                SampleRate = "1 Sample/min"
            
            Case 10: ' 20 min/div
                TimeAxisScale = 1200#
                SampleRate = "30 Samples/hr"
            
            Case 11: ' 1 hr/div
                TimeAxisScale = 3600#
                SampleRate = "10 Samples/hr"
                        
        End Select
        
        IntervalInTicks = TimeAxisScale * 100 ' ticks are msec, and there are 10 samples per division --> total factor 100
        
        ComboEvent = True
        UpDownTimeBase = 11 - TimeBase.ListIndex
        ComboEvent = False
    
    End If
    
    Call UpdatePlot
    
    ChangeOfTimebase = False
    
End Sub

Public Sub UpDownAcqAvg_Change()

    If Not ComboEvent Then AcqAvg.ListIndex = 6 - UpDownAcqAvg.value

End Sub

Public Sub UpDownGainCH1_Change()

    If Not ComboEvent Then GainCH1.ListIndex = GainCH1.ListCount - 1 - UpDownGainCH1.value
    
End Sub

Public Sub UpDownGainCH2_Change()

    If Not ComboEvent Then GainCH2.ListIndex = GainCH2.ListCount - 1 - UpDownGainCH2.value

End Sub

Public Sub UpDownTimeBase_Change()

    If Not ComboEvent Then
        If ScopeMode Then
            TimeBase.ListIndex = 16 - UpDownTimeBase.value
        ElseIf LAMode Then
            TimeBase.ListIndex = 15 - UpDownTimeBase.value
        Else ' roll mode
            TimeBase.ListIndex = 11 - UpDownTimeBase.value
        End If
    End If
    
End Sub

Public Sub VertCursorScrollbar1_Scroll()

    If Cursors = vbChecked Then
        VertCursor1 = VertCursorScrollbar1.value / 500
        VertCursorDelta = Abs(VertCursor1 - VertCursor2)
        Call UpdatePlot
    Else
        VertCursorScrollbar1 = VertCursorScrollbar1.Min
    End If

End Sub

Public Sub VertCursorScrollbar2_Scroll()

    If Cursors = vbChecked Then
        VertCursor2 = VertCursorScrollbar2.value / 500
        VertCursorDelta = Abs(VertCursor1 - VertCursor2)
        Call UpdatePlot
    Else
        VertCursorScrollbar2 = VertCursorScrollbar2.Min
    End If

End Sub

Public Sub HorCursorScrollbar1_Change()

    If Cursors = vbChecked Then
        HorCursor1 = HorCursorScrollbar1.value / 100
        HorCursorDelta = Abs(HorCursor1 - HorCursor2)
        Call UpdatePlot
    Else
        HorCursorScrollbar1 = HorCursorScrollbar1.Max
    End If

End Sub

Public Sub HorCursorScrollbar2_Change()

    If Cursors = vbChecked Then
        HorCursor2 = HorCursorScrollbar2.value / 100
        HorCursorDelta = Abs(HorCursor1 - HorCursor2)
        Call UpdatePlot
    Else
        HorCursorScrollbar2 = HorCursorScrollbar2.Max
    End If

End Sub

Public Sub VertCursorScrollbar1_Change()

    If Cursors = vbChecked Then
        VertCursor1 = VertCursorScrollbar1.value / 500
        VertCursorDelta = Abs(VertCursor1 - VertCursor2)
        Call UpdatePlot
    Else
        VertCursorScrollbar1 = VertCursorScrollbar1.Min
    End If

End Sub

Public Sub VertCursorScrollbar2_Change()

    If Cursors = vbChecked Then
        VertCursor2 = VertCursorScrollbar2.value / 500
        VertCursorDelta = Abs(VertCursor1 - VertCursor2)
        Call UpdatePlot
    Else
        VertCursorScrollbar2 = VertCursorScrollbar2.Min
    End If

End Sub

Public Function FileExists(FileName As String) As Boolean
     FileExists = (Dir(FileName) > "")
End Function

Public Sub LogDataToFile(SampleCounter As Long, ADC1_Val As Double, ADC2_Val As Double, LA_Val As Long)
    
    Dim CH1_Val As Double, CH2_Val As Double
    Dim Time As Double
    
    Time = SampleCounter * GetTimebase / 10#
    
    CH1_Val = ADC1_Val * GetGain(1) * NO_OF_UNITS_Y / 100 ' screen height is 100% or NO_OF_UNITS_Y units
    CH2_Val = ADC2_Val * GetGain(2) * NO_OF_UNITS_Y / 100 ' screen height is 100% or NO_OF_UNITS_Y units
        
    Write #2, Time, CH1_Val, CH2_Val, (LA_Val And 128) / 128, (LA_Val And 64) / 64, (LA_Val And 32) / 32, (LA_Val And 16) / 16

End Sub

Public Sub UpdateAverages(ByRef Averages)

        Select Case AcqAvg.ListIndex
            Case 0: Averages = 1
            Case 1: Averages = 2
            Case 2: Averages = 5
            Case 3: Averages = 10
            Case 4: Averages = 20
            Case 5: Averages = 50
            Case 6: Averages = 100
        End Select
              
End Sub

Public Sub UpdateSampleRate(ByRef SampleRateIdx_old As Long, ByRef DoFFT_old As Long, ByRef ChannelSkew As Double, ByRef SetupChanged As Boolean)

    Dim i_row As Long
    Dim FFTHorScaleFactor As Double
    
    ' 4/3 because of interpolation (blow-up from 384 sample points to 512 points for FFT)
    FFTHorScaleFactor = 384# / 410# * 5# / 4# * 250# / FULL_RECORD_LENGTH / 10#
    
    SampleRateIdx = TimeBase.ListIndex
    
    If (SampleRateIdx_old <> SampleRateIdx) Or (DoFFT <> DoFFT_old) Then
                                    
        SampleRateIdx_old = SampleRateIdx
        DoFFT_old = DoFFT
        
        SetupChanged = True
        
        If DoFFT_old = vbChecked Then
            
            time_max_idx = NO_OF_UNITS_FFT ' 10 points per div
            Call scale_x_axis(time_min_idx, time_max_idx)
            Call scale_y_axis
        
            For i_row = 1 To FULL_RECORD_LENGTH
                
                DataBuffer(i_row, 1) = FFTHorScaleFactor * i_row
                DataBuffer(i_row, 3) = FFTHorScaleFactor * i_row
                DataBuffer(i_row, 5) = FFTHorScaleFactor * i_row
                DataBuffer(i_row, 7) = FFTHorScaleFactor * i_row

            Next i_row
                        
        Else

            time_max_idx = NO_OF_UNITS ' 10 points per div
            Call scale_x_axis(time_min_idx, time_max_idx)
            Call scale_y_axis
                                
            ' deskew channels - real-time samples are interleaved and thus offset by half a sample
            If SampleRateIdx >= 6 Then
                ChannelSkew = 0.05
            Else
                ChannelSkew = 0
            End If
            
            For i_row = 1 To FULL_RECORD_LENGTH
                
                DataBuffer(i_row, 1) = (i_row - 1) - ChannelSkew * 10
                DataBuffer(i_row, 3) = (i_row - 1)
                DataBuffer(i_row, 5) = (i_row - 1) - ChannelSkew * 10
                DataBuffer(i_row, 7) = (i_row - 1)

            Next i_row
            
        End If
            
    End If
                                                
End Sub

Public Sub UpdateSampleRate_LA(ByRef SampleRateIdx_old As Long, ByRef SetupChanged As Boolean)

    Dim i_row As Long
    
    SampleRateIdx = TimeBase.ListIndex
    
    If SampleRateIdx_old <> SampleRateIdx Then
                                    
        SampleRateIdx_old = SampleRateIdx
        SetupChanged = True
        
        time_max_idx = NO_OF_UNITS ' 10 points per div
        Call scale_x_axis(time_min_idx, time_max_idx)
        Call scale_y_axis
                            
    End If
                                                
End Sub


Public Sub UpdateTriggerPolarity(ByRef TriggerRising_old As Boolean, ByRef SetupChanged As Boolean)
            
    If (TriggerRising_old <> TriggerRising) Then
             
        SetupChanged = True
        TriggerRising_old = TriggerRising
             
    End If

End Sub

Public Sub UpdateTriggerSource(ByRef triggerSource_old As Long, ByRef SetupChanged As Boolean)
    
    Dim TriggerSource As Long
    
    If TriggerAuto Then
        TriggerSource = TRIGGER_SOURCE_AUTO
    ElseIf TriggerCH1 Then
        TriggerSource = TRIGGER_SOURCE_CH1
    ElseIf TriggerExt Then
        TriggerSource = TRIGGER_SOURCE_EXT
    End If
    
    If (TriggerSource <> triggerSource_old) Then

        SetupChanged = True
        triggerSource_old = TriggerSource
    
    End If

End Sub

Public Sub UpdateTriggerLevel(ByRef TriggerLevel_old As Long, ByRef SetupChanged As Boolean)

    If (TriggerLevel <> TriggerLevel_old) Then
        
        SetupChanged = True
        TriggerLevel_old = TriggerLevel
        
    End If
                    
End Sub
                        
Public Sub PlotTrace(i_col As Long, i_color As Long, RecordLength As Long, _
                      LengthX As Long, LengthY As Long, DrawScaleX As Double, DrawScaleY As Double, _
                      OffsetY_CH1 As Double, OffsetY_CH2 As Double)

    Dim i_row As Long
    Dim i_col2 As Long
    Dim OffsetY As Double
    
    If DoFFT Then
    
        If DisplayDots = vbChecked Then
        
            Plot_Display.DrawWidth = 1
            
            For i_row = 1 To RecordLength
        
                Plot_Display.Circle (i_row * DrawScaleX, _
                                    LengthY - DrawScaleY * DataBuffer(i_row, i_col)), 25, i_color
        
            Next i_row
        
        End If
        
        If DisplayVectors = vbChecked Then
        
            If LinesBold = vbChecked Then
                Plot_Display.DrawWidth = BOLD_LINE_WIDTH
            Else
                Plot_Display.DrawWidth = 1
            End If
            
            Plot_Display.PSet (DrawScaleX, LengthY - DrawScaleY * DataBuffer(1, i_col)), i_color
            
            For i_row = 2 To RecordLength
        
            Plot_Display.Line -(i_row * DrawScaleX, _
                                LengthY - DrawScaleY * DataBuffer(i_row, i_col)), i_color
        
            Next i_row
        
        End If
    
    Else
    
        If i_col = 2 Or i_col = 6 Then ' CH1 or REF2
            OffsetY = OffsetY_CH1
        Else ' CH2 or REF2
            OffsetY = OffsetY_CH2
        End If
                
        If RollMode Then
    
            If DisplayDots = vbChecked Then
            
                Plot_Display.DrawWidth = 1
                
                For i_row = 1 To RecordLength
            
                    Plot_Display.Circle (DataBuffer(i_row, i_col - 1) * DrawScaleX, _
                                        LengthY - DrawScaleY * (DataBuffer(i_row, i_col) + OffsetY)), 25, i_color
            
                Next i_row
            
            End If
            
            If DisplayVectors = vbChecked Then
            
                If LinesBold = vbChecked Then
                    Plot_Display.DrawWidth = BOLD_LINE_WIDTH
                Else
                    Plot_Display.DrawWidth = 1
                End If
                
                Plot_Display.PSet (DataBuffer(1, i_col - 1) * DrawScaleX, _
                                   LengthY - DrawScaleY * (DataBuffer(1, i_col) + OffsetY)), i_color
                
                For i_row = 2 To RecordLength
            
                    Plot_Display.Line -(DataBuffer(i_row, i_col - 1) * DrawScaleX, _
                                        LengthY - DrawScaleY * (DataBuffer(i_row, i_col) + OffsetY)), i_color
            
                Next i_row
            
            End If
    
        Else
            
            If DisplayDots = vbChecked Then
            
                Plot_Display.DrawWidth = 1
                
                For i_row = 1 To RecordLength
            
                    Plot_Display.Circle (DataBuffer(i_row, i_col - 1) * DrawScaleX, _
                                        LengthY - DrawScaleY * (DataBuffer(i_row, i_col) + OffsetY)), 25, i_color
            
                Next i_row
            
            End If
            
            If DisplayVectors = vbChecked Then
            
                If LinesBold = vbChecked Then
                    Plot_Display.DrawWidth = BOLD_LINE_WIDTH
                Else
                    Plot_Display.DrawWidth = 1
                End If
                
                Plot_Display.PSet (DataBuffer(1, i_col - 1) * DrawScaleX, _
                                   LengthY - DrawScaleY * (DataBuffer(1, i_col) + OffsetY)), i_color
                            
                For i_row = 2 To RecordLength
            
                    Plot_Display.Line -(DataBuffer(i_row, i_col - 1) * DrawScaleX, _
                                        LengthY - DrawScaleY * (DataBuffer(i_row, i_col) + OffsetY)), i_color
            
                Next i_row
            
            End If
    
        End If

    End If
    
End Sub

Public Sub Plot_LA_Trace(i_color As Long, RecordLength As Long, _
                         LengthX As Long, LengthY As Long, DrawScaleX As Double, DrawScaleY As Double)

    Dim i_row As Long
    Dim i_col2 As Long
    Dim OffsetY As Double
    Dim i_col As Long
    Dim LA_bit_val As Long
    Dim i_LA_bit_mask As Long
    Dim i_LA_chan As Long
    
    i_col = 10
    
    If DisplayDots = vbChecked Then
    
        Plot_Display.DrawWidth = 1
        
        i_LA_bit_mask = 16 ' LA chans are PortB bits [7:4]
        OffsetY = LA_TRACE_SPACING
        
        For i_LA_chan = 1 To 4
        
            For i_row = 1 To RecordLength
    
                LA_bit_val = (DataBuffer(i_row + LA_Hor_Pos, i_col) And i_LA_bit_mask) / i_LA_bit_mask ' give binary 1 or 0
                LA_bit_val = LA_bit_val * LA_TRACE_SWING

                Plot_Display.Circle (DataBuffer(i_row, i_col - 1) * DrawScaleX, _
                                    LengthY - DrawScaleY * (LA_bit_val + OffsetY)), 25, i_color
    
            Next i_row
            
            i_LA_bit_mask = i_LA_bit_mask * 2
            OffsetY = OffsetY + LA_TRACE_SPACING
            
        Next i_LA_chan
    
    End If
    
    If DisplayVectors = vbChecked Then
    
        If LinesBold = vbChecked Then
            Plot_Display.DrawWidth = BOLD_LINE_WIDTH
        Else
            Plot_Display.DrawWidth = 1
        End If
        
        i_LA_bit_mask = 16
        OffsetY = LA_TRACE_SPACING
        
        For i_LA_chan = 1 To 4
        
            LA_bit_val = (DataBuffer(1 + LA_Hor_Pos, i_col) And i_LA_bit_mask) / i_LA_bit_mask ' give binary 1 or 0
            LA_bit_val = LA_bit_val * LA_TRACE_SWING
            
            Plot_Display.PSet (DataBuffer(1, i_col - 1) * DrawScaleX, _
                               LengthY - DrawScaleY * (LA_bit_val + OffsetY)), i_color
        
            For i_row = 2 To RecordLength
    
                LA_bit_val = (DataBuffer(i_row + LA_Hor_Pos, i_col) And i_LA_bit_mask) / i_LA_bit_mask ' give binary 1 or 0
                LA_bit_val = LA_bit_val * LA_TRACE_SWING

                Plot_Display.Line -(DataBuffer(i_row, i_col - 1) * DrawScaleX, _
                                    LengthY - DrawScaleY * (LA_bit_val + OffsetY)), i_color
    
            Next i_row
            
            i_LA_bit_mask = i_LA_bit_mask * 2
            OffsetY = OffsetY + LA_TRACE_SPACING
            
        Next i_LA_chan
    
    End If

End Sub

' return position of the ground marker as a fraction of the total y-span
Public Function GetGndPos(ScopeChan As Long) As Double

    If ScopeChan = 1 Then ' CH1
        If GainCH1.ListIndex = 0 Then ' at 1v/div the offset reaches only 12/20th of the screen
            GetGndPos = 1 - 12# / 20# * (1# - (1# * OffsetCH1) / OffsetCH1.Max)
        Else
            GetGndPos = 1 - (1# - (1# * OffsetCH1) / OffsetCH1.Max)
        End If
    Else ' CH2
        If GainCH2.ListIndex = 0 Then ' at 1v/div the offset reaches only 12/20th of the screen
            GetGndPos = 1 - 12# / 20# * (1# - (1# * OffsetCH2) / OffsetCH2.Max)
        Else
            GetGndPos = 1 - (1# - (1# * OffsetCH2) / OffsetCH2.Max)
        End If
    End If
    
End Function

Public Sub UpdatePlot()

    Dim i As Long, i_row As Long, i_col As Long
    Dim f As Double
    Dim X As Long, Y As Long, x_old As Long, y_old As Long
    Dim dummy As Double
    
    Dim LengthX As Long, LengthY As Long
    Dim DrawScaleX As Double, DrawScaleY As Double
    Dim NoOfUnitsX As Long, NoOfUnitsY As Long
        
    Dim OffsetY_CH1 As Double, OffsetY_CH2 As Double
    
    Dim CurrNoOfUnitsX As Long
    Dim CurrNoOfUnitsY As Long
    Dim CurrRecordLength As Long
    
    Dim FFTHorScaleFactor
    
    Dim GndPos As Double, TrigPos As Double
    
    If init_flag Then Exit Sub ' avoid useless delay at startup
    
    DisplayUpdateTimer.Enabled = False ' we are already drawing, don't need another call issued by the timer
    
    LengthX = Plot_Display.Width - 10
    LengthY = Plot_Display.Height - 10
    
    OffsetY_CH1 = (OffsetCH1.Max - OffsetCH1) / 10 ' 0...100% offset
    OffsetY_CH2 = (OffsetCH2.Max - OffsetCH2) / 10 ' 0...100% offset
    
    If DoFFT Then
        FFTHorScaleFactor = 5# / 4# * 250# / FULL_RECORD_LENGTH
        CurrNoOfUnitsX = NO_OF_UNITS_FFT
        CurrNoOfUnitsY = NO_OF_UNITS_Y
        CurrRecordLength = FULL_RECORD_LENGTH
        DrawScaleX = LengthX / CurrNoOfUnitsX
        DrawScaleY = LengthY / NO_OF_UNITS_Y
    Else
        FFTHorScaleFactor = 1
        CurrNoOfUnitsX = NO_OF_UNITS
        CurrNoOfUnitsY = NO_OF_UNITS_Y
        CurrRecordLength = FULL_READBACK_LENGTH
        DrawScaleX = LengthX / CurrNoOfUnitsX
        DrawScaleY = LengthY / NO_OF_UNITS_Y
    End If

    If Persistence = vbUnchecked Then Plot_Display.Cls

    Plot_Display.DrawWidth = 1
    Plot_Display.DrawStyle = vbDot
    Plot_Display.DrawMode = vbCopyPen

    If DoFFT Then
        
        For i = 0 To CurrNoOfUnitsX
            Plot_Display.Line (DrawScaleX * i + 1, 1)-(DrawScaleX * i + 1, LengthY), &HB0B0B0
        Next i
                
        For i = 0 To NO_OF_UNITS_Y
            Plot_Display.Line (1, DrawScaleY * i + 1)-(LengthX, DrawScaleY * i + 1), &HB0B0B0
        Next i
    
    ElseIf (Not LAMode) Or (Persistence = vbUnchecked) Or LA_DrawGrid Then
    
        ' main grid
        Plot_Display.DrawStyle = vbDot
        For i = 0 To CurrNoOfUnitsX / 2 - 1
            Plot_Display.Line (DrawScaleX * i + 1, 1)-(DrawScaleX * i + 1, LengthY), &HB0B0B0
        Next i
                
        ' center line
        Plot_Display.DrawStyle = vbDot 'vbDashDotDot
        Plot_Display.Line (DrawScaleX * (CurrNoOfUnitsX / 2) + 1, 1)-(DrawScaleX * (CurrNoOfUnitsX / 2) + 1, LengthY), &H707070
                
        ' main grid continued
        Plot_Display.DrawStyle = vbDot
        For i = CurrNoOfUnitsX / 2 + 1 To CurrNoOfUnitsX
            Plot_Display.Line (DrawScaleX * i - 1, 1)-(DrawScaleX * i - 1, LengthY), &HB0B0B0
        Next i
        
        ' sub-scaling
        Plot_Display.DrawStyle = vbSolid
        For f = 0 To CurrNoOfUnitsX Step 0.2
            Plot_Display.Line (DrawScaleX * f + 1, LengthY * 0.495)-(DrawScaleX * f + 1, LengthY * 0.505), &H707070
        Next f
        
        ' main grid
        Plot_Display.DrawStyle = vbDot
        For i = 0 To NO_OF_UNITS_Y / 2 - 1
            Plot_Display.Line (1, DrawScaleY * i + 1)-(LengthX, DrawScaleY * i + 1), &HB0B0B0
        Next i
    
        ' center line
        Plot_Display.DrawStyle = vbDot 'vbDashDotDot
        Plot_Display.Line (1, DrawScaleY * (NO_OF_UNITS_Y / 2 + 0#) + 1)-(LengthX, DrawScaleY * (NO_OF_UNITS_Y / 2 + 0#) + 1), &H707070
        
        ' main grid continued
        Plot_Display.DrawStyle = vbDot
        For i = NO_OF_UNITS_Y / 2 + 1 To NO_OF_UNITS_Y
            Plot_Display.Line (1, DrawScaleY * i - 1)-(LengthX, DrawScaleY * i - 1), &HB0B0B0
        Next i
    
        ' sub-scaling
        Plot_Display.DrawStyle = vbSolid
        For f = 0 To NO_OF_UNITS_Y Step 0.2
            Plot_Display.Line (LengthX * 0.495, DrawScaleY * f + 1)-(LengthX * 0.505, DrawScaleY * f + 1), &HB0B0B0
        Next f
    
    End If
    
    DrawScaleX = LengthX / CurrNoOfUnitsX
    DrawScaleY = LengthY / 100
    
    Plot_Display.DrawWidth = 1
    Plot_Display.DrawStyle = vbSolid
    Plot_Display.DrawMode = vbCopyPen
        
    If Cursors Then
        
        Call Draw_Cursors
        
        PictHorCursor1.Top = LengthY - DrawScaleY * HorCursor1
        PictHorCursor2.Top = LengthY - DrawScaleY * HorCursor2
        
        PictVertCursor1.Left = DrawScaleX * VertCursor1
        PictVertCursor2.Left = DrawScaleX * VertCursor2
    
    End If
    
    Plot_Display.DrawStyle = vbSolid
    Plot_Display.DrawMode = vbCopyPen
    
    DrawScaleX = LengthX / CurrNoOfUnitsX / 10 * FFTHorScaleFactor
    DrawScaleY = LengthY / 100
    
    If ShowRef2 Then Call PlotTrace(8, &HFF8080, CurrRecordLength, LengthX, LengthY, DrawScaleX, DrawScaleY, OffsetY_CH1, OffsetY_CH2)
    If ShowRef1 Then Call PlotTrace(6, &H8080FF, CurrRecordLength, LengthX, LengthY, DrawScaleX, DrawScaleY, OffsetY_CH1, OffsetY_CH2)
    If ShowCH2 Then Call PlotTrace(4, vbBlue, CurrRecordLength, LengthX, LengthY, DrawScaleX, DrawScaleY, OffsetY_CH1, OffsetY_CH2)
    If ShowCH1 Then Call PlotTrace(2, vbRed, CurrRecordLength, LengthX, LengthY, DrawScaleX, DrawScaleY, OffsetY_CH1, OffsetY_CH2)
    
    If ShowLA = vbChecked Then Call Plot_LA_Trace(&H800080, CurrRecordLength, LengthX, LengthY, DrawScaleX, DrawScaleY)
    
    If DoFFT = vbUnchecked Then

        If Not RollMode And TriggerLevel.Enabled Then
        
            TrigPos = LengthY * (50# / 24# * (TriggerLevel - 128#) / (1# * TriggerLevel.Max - 1# * TriggerLevel.Min) + (1 - OffsetY_CH1 / 100))

            Plot_Display.DrawWidth = 2
            Plot_Display.DrawStyle = vbSolid
            
            Plot_Display.Line (1, TrigPos)-(LengthX * 0.02, TrigPos), RGB(0, 180, 0) 'vbGreen
            Plot_Display.Line (1, TrigPos + LengthY * 0.004)-(LengthX * 0.02, TrigPos), RGB(0, 180, 0) 'vbGreen
            Plot_Display.Line (1, TrigPos - LengthY * 0.004)-(LengthX * 0.02, TrigPos), RGB(0, 180, 0) 'vbGreen
            Plot_Display.Line (1, TrigPos + LengthY * 0.004)-(1, TrigPos - LengthY * 0.004), RGB(0, 180, 0) 'vbGreen

            If DisplayLevels Then
                Plot_Display.DrawWidth = 1
                Plot_Display.DrawStyle = vbDashDotDot
                Plot_Display.Line (1, TrigPos)-(LengthX, TrigPos), RGB(0, 180, 0) 'vbGreen
            End If
            
        End If
        
        If ShowCH1 = vbChecked Then

            GndPos = LengthY * (1 - OffsetY_CH1 / 100)
            
            Plot_Display.DrawWidth = 2
            Plot_Display.DrawStyle = vbSolid
            
            Plot_Display.Line (1, GndPos)-(LengthX * 0.02, GndPos), vbRed
            Plot_Display.Line (1, GndPos + LengthY * 0.004)-(LengthX * 0.02, GndPos), vbRed
            Plot_Display.Line (1, GndPos - LengthY * 0.004)-(LengthX * 0.02, GndPos), vbRed
            Plot_Display.Line (1, GndPos + LengthY * 0.004)-(1, GndPos - LengthY * 0.004), vbRed

            If DisplayLevels Then
                Plot_Display.DrawWidth = 1
                Plot_Display.DrawStyle = vbDot
                Plot_Display.Line (1, GndPos)-(LengthX, GndPos), vbRed
            End If
        
        End If

        If ShowCH2 = vbChecked Then

            GndPos = LengthY * (1 - OffsetY_CH2 / 100)

            Plot_Display.DrawWidth = 2
            Plot_Display.DrawStyle = vbSolid
            
            Plot_Display.Line (1, GndPos)-(LengthX * 0.02, GndPos), vbBlue
            Plot_Display.Line (1, GndPos + LengthY * 0.004)-(LengthX * 0.02, GndPos), vbBlue
            Plot_Display.Line (1, GndPos - LengthY * 0.004)-(LengthX * 0.02, GndPos), vbBlue
            Plot_Display.Line (1, GndPos + LengthY * 0.004)-(1, GndPos - LengthY * 0.004), vbBlue

            If DisplayLevels Then
                Plot_Display.DrawWidth = 1
                Plot_Display.DrawStyle = vbDot
                Plot_Display.Line (1, GndPos)-(LengthX, GndPos), vbBlue
            End If
        
        End If

    End If

    Plot_Display.AutoRedraw = True

    If DoFFT = vbUnchecked Then
        
        If Measurements.Visible Or DMM_Display.Visible Then Call Measurements.UpdateMeasurements
            
        If Measurements.Visible Then ' plot annotations only when measurement window is visible
    
            Plot_Display.DrawWidth = 1
            Plot_Display.DrawStyle = vbDot
            
            If ShowCH1 = vbChecked And Measurements.AnnotateCH1 = vbChecked Then
                Plot_Display.Line (1, LengthY * (1 - GetOffset(1) - MeasRefLow(2) / 100))-(LengthX, LengthY * (1 - GetOffset(1) - MeasRefLow(2) / 100)), vbRed
                Plot_Display.Line (1, LengthY * (1 - GetOffset(1) - MeasRefMid(2) / 100))-(LengthX, LengthY * (1 - GetOffset(1) - MeasRefMid(2) / 100)), vbRed
                Plot_Display.Line (1, LengthY * (1 - GetOffset(1) - MeasRefHigh(2) / 100))-(LengthX, LengthY * (1 - GetOffset(1) - MeasRefHigh(2) / 100)), vbRed
                
                Plot_Display.Line (DrawScaleX * (MeasEdge1(2) - 1), 1)-(DrawScaleX * (MeasEdge1(2) - 1), LengthY), vbRed
                Plot_Display.Line (DrawScaleX * (MeasEdge2(2) - 1), 1)-(DrawScaleX * (MeasEdge2(2) - 1), LengthY), vbRed
                Plot_Display.Line (DrawScaleX * (MeasEdge3(2) - 1), 1)-(DrawScaleX * (MeasEdge3(2) - 1), LengthY), vbRed
            End If
            
            If ShowCH2 = vbChecked And Measurements.AnnotateCH2 = vbChecked Then
                Plot_Display.Line (1, LengthY * (1 - GetOffset(2) - MeasRefLow(4) / 100))-(LengthX, LengthY * (1 - GetOffset(2) - MeasRefLow(4) / 100)), vbBlue
                Plot_Display.Line (1, LengthY * (1 - GetOffset(2) - MeasRefMid(4) / 100))-(LengthX, LengthY * (1 - GetOffset(2) - MeasRefMid(4) / 100)), vbBlue
                Plot_Display.Line (1, LengthY * (1 - GetOffset(2) - MeasRefHigh(4) / 100))-(LengthX, LengthY * (1 - GetOffset(2) - MeasRefHigh(4) / 100)), vbBlue
            
                Plot_Display.Line (DrawScaleX * (MeasEdge1(4) - 1), 1)-(DrawScaleX * (MeasEdge1(4) - 1), LengthY), vbBlue
                Plot_Display.Line (DrawScaleX * (MeasEdge2(4) - 1), 1)-(DrawScaleX * (MeasEdge2(4) - 1), LengthY), vbBlue
                Plot_Display.Line (DrawScaleX * (MeasEdge3(4) - 1), 1)-(DrawScaleX * (MeasEdge3(4) - 1), LengthY), vbBlue
            End If
        
        End If
        
    End If
    
End Sub

Public Sub SaveToRef1_Click()

    Dim i_row As Long
    
    ShowRef1 = vbChecked
    
    For i_row = 1 To FULL_RECORD_LENGTH
        DataBuffer(i_row, 6) = DataBuffer(i_row, 2)
    Next i_row
    
    For i_row = FULL_RECORD_LENGTH + 1 To DATA_ARRAY_SIZE
        DataBuffer(i_row, 5) = 1000
        DataBuffer(i_row, 6) = -1000
    Next i_row
    
End Sub

Public Sub ShowCH1_Click()

    If ShowCH1 = vbChecked Then
        Measurements.EnableMeasCH1.Enabled = True
    Else
        Measurements.EnableMeasCH1.Enabled = False
    End If
    
    Call UpdatePlot

End Sub

Public Sub ShowCH2_Click()

    If ShowCH2 = vbChecked Then
        Measurements.EnableMeasCH2.Enabled = True
    Else
        Measurements.EnableMeasCH2.Enabled = False
    End If
    
    Call UpdatePlot

End Sub

Public Sub ShowRef1_Click()

    Call UpdatePlot

End Sub

Public Sub ShowRef2_Click()

    Call UpdatePlot

End Sub

Public Sub SaveToRef2_Click()

    Dim i_row As Long
    
    ShowRef2 = vbChecked
    
    For i_row = 1 To FULL_RECORD_LENGTH
        DataBuffer(i_row, 8) = DataBuffer(i_row, 4)
    Next i_row
    
    For i_row = FULL_RECORD_LENGTH + 1 To DATA_ARRAY_SIZE
        DataBuffer(i_row, 7) = 1000
        DataBuffer(i_row, 8) = -1000
    Next i_row
        
End Sub

Public Sub SetHorAxisUnits(units As HOR_UNITS)

    Dim CurrSel As Long
    
    CurrSel = TimeBase.ListIndex
    
    Call TimeBase.Clear

    If ScopeMode Then
    
        If units = HOR_UNITS_TIME Then
            
            TimeBase.AddItem ("5 us/div")
            TimeBase.AddItem ("10 us/div")
            TimeBase.AddItem ("20 us/div")
            TimeBase.AddItem ("50 us/div")
            TimeBase.AddItem ("0.1 ms/div")
            TimeBase.AddItem ("0.2 ms/div")
            TimeBase.AddItem ("0.5 ms/div")
            TimeBase.AddItem ("1 ms/div")
            TimeBase.AddItem ("2 ms/div")
            TimeBase.AddItem ("5 ms/div")
            TimeBase.AddItem ("10 ms/div")
            TimeBase.AddItem ("20 ms/div")
            TimeBase.AddItem ("50 ms/div")
            TimeBase.AddItem ("0.1 s/div")
            TimeBase.AddItem ("0.2 s/div")
            TimeBase.AddItem ("0.5 s/div")
            TimeBase.AddItem ("1 s/div")
        
        Else
        
            TimeBase.AddItem ("-----")
            TimeBase.AddItem ("-----")
            TimeBase.AddItem ("-----")
            TimeBase.AddItem ("-----")
            TimeBase.AddItem ("-----")
            TimeBase.AddItem ("-----")
            TimeBase.AddItem ("1 kHz/div")
            TimeBase.AddItem ("500 Hz/div")
            TimeBase.AddItem ("200 Hz/div")
            TimeBase.AddItem ("100 Hz/div")
            TimeBase.AddItem ("50 Hz/div")
            TimeBase.AddItem ("20 Hz/div")
            TimeBase.AddItem ("10 Hz/div")
            TimeBase.AddItem ("5 Hz/div")
            TimeBase.AddItem ("2 Hz/div")
            TimeBase.AddItem ("1 Hz/div")
            TimeBase.AddItem ("0.5 Hz/div")
        
        End If
        
    ElseIf LAMode Then
    
        TimeBase.AddItem ("10 us/div")
        TimeBase.AddItem ("20 us/div")
        TimeBase.AddItem ("50 us/div")
        TimeBase.AddItem ("0.1 ms/div")
        TimeBase.AddItem ("0.2 ms/div")
        TimeBase.AddItem ("0.5 ms/div")
        TimeBase.AddItem ("1 ms/div")
        TimeBase.AddItem ("2 ms/div")
        TimeBase.AddItem ("5 ms/div")
        TimeBase.AddItem ("10 ms/div")
        TimeBase.AddItem ("20 ms/div")
        TimeBase.AddItem ("50 ms/div")
        TimeBase.AddItem ("0.1 s/div")
        TimeBase.AddItem ("0.2 s/div")
        TimeBase.AddItem ("0.5 s/div")
        TimeBase.AddItem ("1 s/div")
        
    Else ' roll mode (slow timebases)
    
        TimeBase.AddItem ("0.5 s/div")
        TimeBase.AddItem ("1 s/div")
        TimeBase.AddItem ("2 s/div")
        TimeBase.AddItem ("5 s/div")
        TimeBase.AddItem ("10 s/div")
        TimeBase.AddItem ("20 s/div")
        TimeBase.AddItem ("1 min/div")
        TimeBase.AddItem ("2 min/div")
        TimeBase.AddItem ("5 min/div")
        TimeBase.AddItem ("10 min/div")
        TimeBase.AddItem ("20 min/div")
        TimeBase.AddItem ("1 hr/div")
    
    End If
    
    TimeBase.ListIndex = CurrSel
    
End Sub

Private Sub Plot_Display_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If X < 0 Then X = 0
    If X > Plot_Display.ScaleWidth Then X = Plot_Display.ScaleWidth
    If Y < 0 Then Y = 0
    If Y > Plot_Display.ScaleHeight Then Y = Plot_Display.ScaleHeight
    
    If Cursors = vbChecked Then
        If Button = 1 Then
            If DraggingHorCur1 Then
                HorCursorScrollbar1 = HorCursorScrollbar1.Min * (1 - Y / Plot_Display.ScaleHeight)
            ElseIf DraggingHorCur2 Then
                HorCursorScrollbar2 = HorCursorScrollbar2.Min * (1 - Y / Plot_Display.ScaleHeight)
            ElseIf DraggingVertCur1 Then
                VertCursorScrollbar1 = VertCursorScrollbar1.Max * (X / Plot_Display.ScaleWidth)
            ElseIf DraggingVertCur2 Then
                VertCursorScrollbar2 = VertCursorScrollbar2.Max * (X / Plot_Display.ScaleWidth)
            End If
        End If
    End If
    
End Sub

Private Sub Plot_Display_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim CurrHorPos1 As Double, CurrHorPos2 As Double
    Dim CurrVertPos1 As Double, CurrVertPos2 As Double
    Dim HorMousePos As Double, VertMousePos As Double
    
    On Error GoTo ignore
    
    HorMousePos = Y / Plot_Display.ScaleHeight
    VertMousePos = X / Plot_Display.ScaleWidth
    
    CurrVertPos1 = VertCursorScrollbar1 / VertCursorScrollbar1.Max
    CurrVertPos2 = VertCursorScrollbar2 / VertCursorScrollbar2.Max
    CurrHorPos1 = 1 - HorCursorScrollbar1 / HorCursorScrollbar1.Min
    CurrHorPos2 = 1 - HorCursorScrollbar2 / HorCursorScrollbar2.Min

    DraggingHorCur1 = False
    DraggingHorCur2 = False
    DraggingVertCur1 = False
    DraggingVertCur2 = False
    
    If Abs(HorMousePos - CurrHorPos1) <= CURSOR_POS_TOLERANCE Then
        DraggingHorCur1 = True
    ElseIf Abs(HorMousePos - CurrHorPos2) <= CURSOR_POS_TOLERANCE Then
        DraggingHorCur2 = True
    ElseIf Abs(VertMousePos - CurrVertPos1) <= CURSOR_POS_TOLERANCE Then
        DraggingVertCur1 = True
    ElseIf Abs(VertMousePos - CurrVertPos2) <= CURSOR_POS_TOLERANCE Then
        DraggingVertCur2 = True
    End If
    
    Call Plot_Display_MouseMove(Button, Shift, X, Y)

    Exit Sub
    
ignore:

    Exit Sub
    
End Sub

Private Sub Plot_Display_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

    DraggingHorCur1 = False
    DraggingHorCur2 = False
    DraggingVertCur1 = False
    DraggingVertCur2 = False
    
End Sub

