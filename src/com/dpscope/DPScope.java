package com.dpscope;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Observable;
import java.util.Queue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import purejavahidapi.DeviceRemovalListener;
import purejavahidapi.HidDevice;
import purejavahidapi.HidDeviceInfo;
import purejavahidapi.InputReportListener;
import purejavahidapi.PureJavaHidApi;

public class DPScope extends Observable {

	private final static short VID = (short) 0x04D8;
	private final static short PID = (short) 0xF891;

	public final static byte CH1_1 = (byte) 5;
	public final static byte CH1_10 = (byte) 6;
	public final static byte CH2_1 = (byte) 8;
	public final static byte CH2_10 = (byte) 9;
	public final static byte CH_BATTERY = (byte) 15;

	public final static float NOMINAL_SUPPLY = 5.0f;

	// Voltage divisions
	protected final static String DIV_2_V = "2 V/div";
	protected final static String DIV_1_V = "1 V/div";
	protected final static String DIV_500_MV = "500 mV/div";
	protected final static String DIV_200_MV = "200 mV/div";
	protected final static String DIV_100_MV = "100 mV/div";
	protected final static String DIV_50_MV = "50 mV/div";
	
	public final static LinkedHashMap<String, Double> mapVoltageDivs;
	static {
		mapVoltageDivs = new LinkedHashMap<String, Double>(6);
		mapVoltageDivs.put(DIV_50_MV, 0.125);
		mapVoltageDivs.put(DIV_100_MV, 0.25);
		mapVoltageDivs.put(DIV_200_MV, 0.5);
		mapVoltageDivs.put(DIV_500_MV, 1.25);
		mapVoltageDivs.put(DIV_1_V, 2.5);
		mapVoltageDivs.put(DIV_2_V, 5.0);
	}
	
	// Timing divisions
	protected final static String DIV_1_S = "1 s/div";
	protected final static String DIV_500_MS = "500 ms/div";
	protected final static String DIV_200_MS = "200 ms/div";
	protected final static String DIV_100_MS = "100 ms/div";
	protected final static String DIV_50_MS = "50 ms/div";
	protected final static String DIV_20_MS = "20 ms/div";
	protected final static String DIV_10_MS = "10 ms/div";
	protected final static String DIV_5_MS = "5 ms/div";
	protected final static String DIV_2_MS = "2 ms/div";
	protected final static String DIV_1_MS = "1 ms/div";
	protected final static String DIV_500_US = "500 us/div";
	protected final static String DIV_200_US = "200 us/div";
	protected final static String DIV_100_US = "100 us/div";
	protected final static String DIV_50_US = "50 us/div";
	protected final static String DIV_20_US = "20 us/div";
	protected final static String DIV_10_US = "10 us/div";
	protected final static String DIV_5_US = "5 us/div";
	
	public final static LinkedHashMap<String, Double> mapTimeDivs;
	static {
		mapTimeDivs = new LinkedHashMap<String, Double>(17);
		mapTimeDivs.put(DIV_1_S, 1.0);     mapTimeDivs.put(DIV_500_MS, 1.0);
		mapTimeDivs.put(DIV_200_MS, 1.0);  mapTimeDivs.put(DIV_100_MS, 1.0);
		mapTimeDivs.put(DIV_50_MS, 1.0);   mapTimeDivs.put(DIV_20_MS, 1.0);
		mapTimeDivs.put(DIV_10_MS, 1.0);   mapTimeDivs.put(DIV_5_MS, 1.0);
		mapTimeDivs.put(DIV_2_MS, 1.0);    mapTimeDivs.put(DIV_1_MS, 1.0);
		mapTimeDivs.put(DIV_500_US, 1.0);  mapTimeDivs.put(DIV_200_US, 1.0);
		mapTimeDivs.put(DIV_100_US, 1.0);  mapTimeDivs.put(DIV_50_US, 1.0);
		mapTimeDivs.put(DIV_20_US, 1.0);   mapTimeDivs.put(DIV_10_US, 1.0);
		mapTimeDivs.put(DIV_5_US, 1.0); 
	}
	
	// Timing division sampling rates
	public final static String DIV_10_SA = "10 Sa/sec";
	public final static String DIV_20_SA = "20 Sa/sec";
	public final static String DIV_50_SA = "50 Sa/sec";
	public final static String DIV_100_SA = "100 Sa/sec";
	public final static String DIV_200_SA = "200 Sa/sec";
	public final static String DIV_500_SA = "500 Sa/sec";
	public final static String DIV_1_KSA = "1 kSa/sec";
	public final static String DIV_2_KSA = "2 kSa/sec";
	public final static String DIV_5_KSA = "5 kSa/sec";
	public final static String DIV_10_KSA = "10 kSa/sec";
	public final static String DIV_20_KSA = "20 kSa/sec";
	public final static String DIV_50_KSA = "50 kSa/sec ALT";;
	public final static String DIV_100_KSA = "100 kSa/sec ET";
	public final static String DIV_200_KSA = "200 kSa/sec ET";
	public final static String DIV_500_KSA = "500 kSa/sec ET";
	public final static String DIV_1_MSA = "1 MSa/sec ET";
	public final static String DIV_2_MSA = "2 MSa/sec ET";
	
	public final static LinkedHashMap<String, String> mapSamplingRates;
	static {
		mapSamplingRates = new LinkedHashMap<String, String>(17);
		mapSamplingRates.put(DIV_1_S, DIV_10_SA);     mapSamplingRates.put(DIV_500_MS, DIV_20_SA);
		mapSamplingRates.put(DIV_200_MS, DIV_50_SA);  mapSamplingRates.put(DIV_100_MS, DIV_100_SA);
		mapSamplingRates.put(DIV_50_MS, DIV_200_SA);   mapSamplingRates.put(DIV_20_MS, DIV_500_SA);
		mapSamplingRates.put(DIV_10_MS, DIV_1_KSA);   mapSamplingRates.put(DIV_5_MS, DIV_2_KSA);
		mapSamplingRates.put(DIV_2_MS, DIV_5_KSA);    mapSamplingRates.put(DIV_1_MS, DIV_10_KSA);
		mapSamplingRates.put(DIV_500_US, DIV_20_KSA);  mapSamplingRates.put(DIV_200_US, DIV_50_KSA);
		mapSamplingRates.put(DIV_100_US, DIV_100_KSA);  mapSamplingRates.put(DIV_50_US, DIV_200_KSA);
		mapSamplingRates.put(DIV_20_US, DIV_500_KSA);   mapSamplingRates.put(DIV_10_US, DIV_1_MSA);
		mapSamplingRates.put(DIV_5_US, DIV_2_MSA); 
	}

	public final static int ALL_BLOCKS = 7;

	// First 422 (of 448) bytes are valid in readBack - rest is junk
	public final static int MAX_READABLE_SIZE = 422;
	public final static int MAX_DATA_PER_CHANNEL = 211;

	/*
	 * ARM parameters (watch out, VB array is 1-based, MikroC array is 0-based)
	 * 1: command
	 * 2: first channel to acquire
	 * 3: second channel to acquire
	 * 4: acquisition parameters (sample clock divider, acquisition time)
	 * 5: timer 0 pre-load high
	 * 6: timer 0 preload low
	 * 7: timer 0 prescaler bypass (0 = use prescaler, 1 = bypass prescaler)
	 * 8: timer 0 prescaler as power of 2 (7=div256, 0=div2): divide = 2^(PS+1)
	 */
	
	private final static int ADCS = 2;
	private final static int ACQT = 5;

	private final static byte ADC_ACQ = (byte) ((128 + ACQT * 8 + ADCS) & 0xff);
	
	protected byte channel_1				= CH1_1;
	protected byte channel_2				= CH2_1;
	protected byte timerPreloadHigh 	 	= (byte) 255; // timer MSB - TimerPreloadHigh
	protected byte timerPreloadLow 	 	= (byte) 10;  // timer MSB - TimerPreloadHigh
	protected byte prescalerBypass 	 	= (byte) 1;   // prescaler bypass: 0 = use prescaler, 1 = bypass prescaler
	protected byte prescalerSelection 	= (byte) 0;   // prescaler selection as power of 2 (7=div256, 0=div2)
	
	/*
	 *  parameter for "software gain": 
	 *  (shift,subtract) = (2,0), (1,128), or (0,192) for gain 1, 2, 4
	 */
	protected byte sample_shift_ch1 	 	= (byte) 2;   // sample shift first channel
	protected byte sample_shift_ch2 	 	= (byte) 2;   // sample shift second channel
	
	protected byte sample_subtract_ch1 	= (byte) 0;   // sample subtract CH1
	protected byte sample_subtract_ch2 	= (byte) 0;   // sample subtract CH2
	
	protected byte sample_subtract_delta_ch1 = (byte) 0; // 0 if probe attenuation false, else PROBE_1_TO_10_DELTA
	protected byte sample_subtract_delta_ch2 = (byte) 0; // 0 if probe attenuation false, else PROBE_1_TO_10_DELTA
	
	// trigger mode (triggered or free running)
	protected byte triggerAuto 			= (byte) 0;   // 0 = ch1 or ext. trigger, 1 = free running
	protected byte triggerRising 		= (byte) 0;   // trigger polarity: 0 = falling edge, 1 = rising edge
	protected boolean triggerExt 		= false;   	  // false = internal, true = external trigger
	protected byte triggerLevel			= (byte) 255; // range of trigger threshold
	
	protected static byte SAMPLE_MODE_RT	= (byte) 0;	  // sampling mode Real Time
	protected static byte SAMPLE_MODE_ET	= (byte) 1;   // sampling mode Equivalent Time
	protected byte samplingMode 			= SAMPLE_MODE_RT;   // 0 = real time, 1 = equivalent time
	
	// TODO: Put these values in a list
	protected double timeAxisScale		= 1.0d; 		  // value for scaling time axis
	
	protected byte sampleInterval 		= (byte) 0;   // equivalent time sample interval in 0.5usec increments
	protected byte comp_input_chan 		= (byte) 1;   // trigger channel to use (1 = CH1 gain 1, 2 = CH1 gain 10, 3 = ext. trigger)
	
	private static float usbSupplyVoltage = 5.0f; // nominal voltage

	private HidDevice hidDev;
	private HidDeviceInfo devInfo;

	protected boolean isDone = false;
	protected boolean isReady = false;

	private Command currCmd;

	volatile static boolean deviceOpen = false;

	private volatile byte[] txBuf = new byte[20];
	private int length = 0;

	private volatile int signalCh1;
	private volatile int signalCh2;

	protected Queue<BootAction> actionQueue = new LinkedList<BootAction>();
	private ExecutorService pool;

	private float[] channels = new float[2];
	private boolean run_RollMode = false;

	public float[] scopeBuffer = new float[448];
	private static int currBlock = 0;

	public long currTime = 0;

	public int callCount = 0;

	private byte ch1 = 0;
	private byte ch2 = 0;

	public static enum Command {
		CMD_IDLE,
		CMD_PING,
		CMD_REVISION,
		CMD_ARM,
		CMD_DONE,
		CMD_ABORT,
		CMD_READBACK,
		CMD_READADC,
		CMD_STATUS_LED,
		CMD_WRITE_MEM,
		CMD_READ_MEM,
		CMD_WRITE_EEPROM,
		CMD_READ_EEPROM,
		CMD_READ_LA,
		CMD_ARM_LA,
		CMD_INIT,
		CMD_SERIAL_INIT,
		CMD_SERIAL_TX,
		CMD_CHECK_USB_SUPPLY,
		EVT_DEVICE_REMOVED;
	}

	private HashMap<Command, float[]> mapOfArguments = new LinkedHashMap<Command, float[]>();

	public DPScope() {
		devInfo = null;
		currCmd = Command.CMD_IDLE;
		signalCh1 = 0;
		signalCh2 = 0;
	}

	public boolean isDevicePresent() {
		try {
			List<HidDeviceInfo> devList = PureJavaHidApi.enumerateDevices();
			for (HidDeviceInfo info : devList) {
				if (((short) info.getVendorId() == VID) && ((short) info.getProductId() == PID)) {
					System.out.println("DPSCOPE detected!");
					System.out.printf("VID = 0x%04X | PID = 0x%04X | Manufacturer = %s | Product = %s | Path = %s\n", //
							info.getVendorId(), //
							info.getProductId(), //
							info.getManufacturerString(), //
							info.getProductString(), //
							info.getPath());
					devInfo = info;
					return true;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public void connect() {
		if (devInfo != null) {
			deviceOpen = true;
			isReady = true;
			pool = Executors.newSingleThreadExecutor();

			try {
				hidDev = PureJavaHidApi.openDevice(devInfo);
				hidDev.setDeviceRemovalListener(new DeviceRemovalListener() {
					@Override
					public void onDeviceRemoval(HidDevice source) {
						/* TODO: If scope is plotting and device is removed be able to handle it properly
						 * App crashes if it happens currently
						 */
						 
						System.out.println("device removed");
						deviceOpen = false;
						isReady = false;
						mapOfArguments.put(Command.EVT_DEVICE_REMOVED, null);
						setChanged();
						notifyObservers(mapOfArguments);
					}
				});
				hidDev.setInputReportListener(new InputReportListener() {
					@Override
					public void onInputReport(HidDevice source, byte Id, byte[] rxBuf, int len) {
						switch (currCmd) {
						case CMD_IDLE:
							break;
						case CMD_PING:
							try {
								String strData = new String(rxBuf, "UTF-8");
								System.out.printf("Ping result: %s", strData.substring(0, 11));
							} catch (UnsupportedEncodingException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							// isReady = true;
							break;
						case CMD_REVISION:
							System.out.printf("Fw version: v%d.%d", rxBuf[0], rxBuf[1]);
							// isReady = true;
							break;
						case CMD_ARM:
							// System.out.println("Scope Armed...");
							isReady = true;
							mapOfArguments.put(Command.CMD_ARM, null);
							setChanged();
							notifyObservers(mapOfArguments);
							break;
						case CMD_DONE:
							if (rxBuf[0] > 0) {
								isDone = true;
								mapOfArguments.put(Command.CMD_DONE, null);
								setChanged();
								notifyObservers(mapOfArguments);
							} else {
								queryIfDone();
							}
							isReady = true;
							break;
						case CMD_ABORT:
							System.out.print("Scope disarmed");
							// isReady = true;
							break;
						case CMD_READBACK:
							// read back each block of 64 bytes
							// First 422 bytes (of 448) are good - rest is junk
							int buffOffset = ((int) txBuf[1]) * 64;
							// TODO: Read back 38 bytes (instead of 64) if
							// currBlock = 6
							for (int idx = 0; idx < 64; idx++) {
								// scopeBuffer[idx + buffOffset] = (int)
								// ((rxBuf[idx] & 0xFF) - 127);
								scopeBuffer[idx + buffOffset] = (int) ((rxBuf[idx] & 0xFF) - 128);
							}

							if (currBlock == 6) {
								// all blocks read from
								// System.out.println("CMD_READBACK - all blocks
								// read");
								// mapOfArguments.put(Command.CMD_READBACK,
								// scopeBuffer);
								mapOfArguments.put(Command.CMD_READBACK, null);
								setChanged();
								notifyObservers(mapOfArguments);
							}
							isReady = true;
							// isDone = false;
							break;
						case CMD_READADC:
							signalCh1 = ((int) (((rxBuf[0] & 0xFF) * 256 + (rxBuf[1] & 0xFF)) & 0xFF) - 511);
							signalCh2 = ((int) (((rxBuf[2] & 0xFF) * 256 + (rxBuf[3] & 0xFF)) & 0xff) - 511);
							channels[0] = signalCh1;
							channels[1] = signalCh2;
							mapOfArguments.put(Command.CMD_READADC, channels);
							setChanged();
							notifyObservers(mapOfArguments);
							isReady = true;
							callCount = 0;
							break;
						case CMD_WRITE_MEM:
							System.out.print("Write to SFR memory - to be implemented");
							// isReady = true;
							break;
						case CMD_READ_MEM:
							System.out.print("Read from SFR memory - to be implemented");
							// isReady = true;
							break;
						case CMD_WRITE_EEPROM:
							System.out.print("Write to EEPROM memory - to be implemented");
							// isReady = true;
							break;
						case CMD_READ_EEPROM:
							System.out.print("Read from EEPROM memory - to be implemented");
							// isReady = true;
							break;
						case CMD_READ_LA:
							System.out.println("Read Logic Analyzer pins - to be implemented");
							System.out.printf("return byte: 0x%02x -> %d\n", (byte) rxBuf[0], rxBuf[0]);
							int twosCompConvert = (rxBuf[0] < 0) ? (rxBuf[0] + 256) : (rxBuf[0]);
							System.out.printf("Pin 4: %d\n", (twosCompConvert & 0x10) >> 4);
							System.out.printf("Pin 3: %d\n", (twosCompConvert & 0x20) >> 5);
							System.out.printf("Pin 2: %d\n", (twosCompConvert & 0x40) >> 6);
							System.out.printf("Pin 1: %d\n", (twosCompConvert & 0x80) >> 7);
							// isReady = true;
							break;
						case CMD_ARM_LA:
							System.out.print("Arm Logic Analyzer pins - to be implemented");
							// isReady = true;
							break;
						case CMD_CHECK_USB_SUPPLY:
							usbSupplyVoltage = (float) 4.096 * 1023
									/ ((int) (rxBuf[0] & 0xFF) * 256 + (rxBuf[1] & 0xFF));
							channels[0] = usbSupplyVoltage;
							// channels[0] = avgVolts / count;
							// System.out.printf("USB voltage: %.3f\n", avgVolts
							// / count);
							mapOfArguments.put(Command.CMD_CHECK_USB_SUPPLY, channels);
							setChanged();
							notifyObservers(mapOfArguments);
							isReady = true;
							break;
						default:
							break;
						}
						currCmd = Command.CMD_IDLE;
						// isReady = true;
					}
				});

			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		} else {
			System.out.println("DPScope not found");
		}
	}

	public void disconnect() {
		deviceOpen = false;
		isReady = false;
		this.deleteObservers();
		actionQueue.clear();
		if (pool != null) {
			pool.shutdown();
		}
		if (hidDev != null) {
			hidDev.close();
		}
	}

	// CMD_PING (2) - get device name
	public void ping() {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x02;
				length = 1;
				currCmd = Command.CMD_PING;
				return false;
			}
		});
	}

	// CMD_REVISION (3) - get fw version
	public void getFwVersion() {
		actionQueue.add(new BootAction() {

			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x03;
				length = 1;
				currCmd = Command.CMD_REVISION;
				return false;
			}
		});
	}

	// CMD_ARM (5) - Sets all acquisition parameters and arms scope
	public void armScope() {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x05;
				txBuf[1] = channel_1;
				txBuf[2] = channel_2;
				txBuf[3] = ADC_ACQ;
				txBuf[4] = timerPreloadHigh;
				txBuf[5] = timerPreloadLow;
				txBuf[6] = prescalerBypass;
				txBuf[7] = prescalerSelection;
				txBuf[8] = sample_shift_ch1;
				txBuf[9] = sample_shift_ch2;
				txBuf[10] = (byte) (sample_subtract_ch1 + sample_subtract_delta_ch1);
				txBuf[11] = (byte) (sample_subtract_ch2 + sample_subtract_delta_ch2);
				txBuf[12] = triggerAuto;
				txBuf[13] = triggerRising;
				txBuf[14] = 0x00; // trigger level MSB (currently not used)
				
				/*
				 *  trigger level LSB (only applicable if triggering on CH1,
				 *  not for ext. trigger)
				 */
				if(triggerExt) {
					/*
					 *  external trigger uses fixed threshold of approx. 1.5V
					 *  (compatible with TTL, 5V CMOS and 3.3V CMOS) 
					 */
					txBuf[15] = (byte) ((1.5 / 5.0) * 256);
				} else {
					double trigVal = 256 - triggerLevel + sample_subtract_delta_ch1 / 2.0;
					trigVal = (trigVal < 0) ? 0 : trigVal;
					trigVal = (trigVal > 255) ? 255 : trigVal;
					txBuf[15] = (byte) ((byte)trigVal & 0xff);
				}

				
				txBuf[16] = samplingMode;   // sampling mode: 0 = real time, 1 = equivalent time
				txBuf[17] = sampleInterval; // equivalent time sample interval in 0.5usec increments
				txBuf[18] = (byte) (txBuf[17] >> 1); // equivalent time trigger
													// stability check period (half
													// of byte 17 value is a good
													// choice)
				txBuf[19] = comp_input_chan; 
				length = 20;
				currCmd = Command.CMD_ARM;
				sendNoWait();
				return false;
			}
		});
		startQueueIfStopped();
	}

	// CMD_DONE (6) - Query whether scope has already finished the acquisition
	public void queryIfDone() {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x06;
				length = 1;
				currCmd = Command.CMD_DONE;
				isDone = false;
				sendNoWait();
				return false;
			}
		});
		startQueueIfStopped();
	}

	// CMD_ABORT (7) - Disarms the scope, so it's ready for a new command
	public void abort() {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x07;
				length = 1;
				currCmd = Command.CMD_ABORT;
				sendNoWait();
				return false;
			}
		});
	}

	// CMD_READBACK (8) - Initiates read-back of acquired txBuf record
	public void readBack(int block) {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x08;
				txBuf[1] = (byte) block;
				isDone = false;
				length = 2;
				currCmd = Command.CMD_READBACK;
				currBlock = block;
				// sendAndWait();
				sendNoWait();
				return false;
			}
		});
		startQueueIfStopped();
	}

	// CMD_READADC (9) - Reads back ADC directly (with 10 bit resolution,
	// returns 2 bytes per channel)
	public void readADC(byte ch1, byte ch2) {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				buildCmdReadAdc(ch1, ch2);
				sendNoWait();
				return false;
			}
		});
		startQueueIfStopped();
	}

	public void readADCDirect(byte ch1, byte ch2) {
		buildCmdReadAdc(ch1, ch2);
		hidDev.setOutputReport((byte) 0, txBuf, length);
	}

	private void buildCmdReadAdc(byte ch1, byte ch2) {
		txBuf[0] = 0x09;
		txBuf[1] = ch1;
		txBuf[2] = ch2;
		txBuf[3] = ADC_ACQ;
		length = 4;
		currCmd = Command.CMD_READADC;
		if (ch1 == CH_BATTERY || ch2 == CH_BATTERY) {
			currCmd = Command.CMD_CHECK_USB_SUPPLY;
		}
	}

	// CMD_STATUS_LED (10) - toggle LED (0 - off, 1 - on)
	public void toggleLed(boolean onOff) {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x0A;
				txBuf[1] = (byte) ((onOff) ? 1 : 0);
				length = 2;
				currCmd = Command.CMD_STATUS_LED;
				sendNoWait();
				return false;
			}
		});
		startQueueIfStopped();
	}

	// CMD_WRITE_MEM (11) - Writes a byte to a memory location on the
	// microcontroller's SFR
	// Note: Address range is restricted to Special Function Register (SFR) on
	// the PIC
	public void writeMem(byte addrMSB, byte addrLSB, byte dataSFR) {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x0B;
				txBuf[1] = addrMSB;
				txBuf[2] = addrLSB;
				txBuf[3] = dataSFR;
				length = 4;
				currCmd = Command.CMD_WRITE_MEM;
				sendNoWait();
				return false;
			}
		});
	}

	// CMD_WRITE_MEM (12) - Reads a memory location on the microcontroller's SFR
	public void readMem(byte addrMSB, byte addrLSB) {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x0C;
				txBuf[1] = addrMSB;
				txBuf[2] = addrLSB;
				length = 3;
				currCmd = Command.CMD_READ_MEM;
				sendAndWait();
				return false;
			}
		});
	}

	// CMD_WRITE_EEPROM (13) - Writes a memory location on the
	// microcontroller’s
	// txBuf EEPROM
	public void writeEEPROM(byte addrMSB, byte addrLSB, byte dataEEPROM) {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x0D;
				txBuf[1] = addrMSB;
				txBuf[2] = addrLSB;
				txBuf[3] = dataEEPROM;
				length = 4;
				currCmd = Command.CMD_WRITE_EEPROM;
				sendNoWait();
				return false;
			}
		});
	}

	// CMD_READ_EEPROM (14) - Read a memory location on the microcontroller’s
	// txBuf EEPROM
	public void readEEPROM(byte addrMSB, byte addrLSB) {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x0E;
				txBuf[1] = addrMSB;
				txBuf[2] = addrLSB;
				length = 3;
				currCmd = Command.CMD_READ_EEPROM;
				sendAndWait();
				return false;
			}
		});
	}

	// CMD_READ_LA (15) - Reads back the state of the logic analyzer pins (port
	// B)
	public void readLogicAnalyzer() {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x0F;
				txBuf[1] = 0x05;
				txBuf[2] = 0x08;
				txBuf[3] = ADC_ACQ;
				length = 4;
				currCmd = Command.CMD_READ_LA;
				sendAndWait();
				return false;
			}
		});
	}

	// CMD_ARM_LA (16) - Sets logic analyzer acquisition parameters
	public void armLogicAnalyzer(byte sampleRate, byte triggerCond) {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x10;
				txBuf[1] = sampleRate;
				txBuf[2] = triggerCond;
				length = 3;
				currCmd = Command.CMD_ARM_LA;
				sendAndWait();
				return false;
			}
		});
	}

	// CMD_INIT (17) - Re-initialize microcontroller
	public void initialize(boolean blinkLED) {
		txBuf[0] = 0x11;
		txBuf[1] = (byte) ((blinkLED) ? (0x01) : (0x00));
		length = 2;
		currCmd = Command.CMD_INIT;
		sendNoWait();
	}

	// CMD_SERIAL_INIT (18) - Initialize external trigger pin for serial txBuf
	// output
	public void serialInit() {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x12;
				length = 1;
				currCmd = Command.CMD_SERIAL_INIT;
				sendAndWait();
				return false;
			}
		});
	}

	// CMD_SERIAL_TX (19) - Send one byte over trigger pin at 9600 baud
	public void serialByteTx(byte serialByte) {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x13;
				txBuf[1] = serialByte;
				length = 2;
				currCmd = Command.CMD_SERIAL_TX;
				sendAndWait();
				return false;
			}
		});
	}

	public void checkUsbSupply(int count) {
		// actionQueue.clear();
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				float avgVolts = 0.0f;
				for (int i = 0; i < count; i++) {
					// readADCDirect(CH_BATTERY, CH_BATTERY);
					buildCmdReadAdc(CH_BATTERY, CH_BATTERY);
					sendAndWait(); // either one works for one-off reads: wait vs no-wait
//					sendNoWait();
					avgVolts += getUSBVoltage();
				}
				actionQueue.remove();
				channels[0] = 0;
				channels[0] = avgVolts / count;
				System.out.printf("USB voltage: %.3f\n", avgVolts / count);
				mapOfArguments.put(Command.CMD_CHECK_USB_SUPPLY, channels);
				setChanged();
				notifyObservers(mapOfArguments);
				return false;
			}
		});
		startQueueIfStopped();
	}

	private synchronized void startQueueIfStopped() {
		pool.execute((Runnable) processAction);
	}

	// CMD_CHECK_USB_SUPPLY - Read ADC channel associated with USB supply
	// voltage
	public void checkUsbSupply() {
		readADC(CH_BATTERY, CH_BATTERY);
		// return getUSBVoltage();
	}

	public void runScan_RollMode(byte ch1, byte ch2) {
		run_RollMode = true;
		startQueueIfStopped();
		readADC(ch1, ch2);
	}

	public void stopScan_RollMode() {
		run_RollMode = false;
		actionQueue.clear();
	}

	Thread processAction = new Thread() {

		public void run() {
			try {
				BootAction bootItem = null;
				isReady = true;
				while (deviceOpen) {
					if (isReady && (actionQueue.size() > 0)) {
						isReady = false;
						try {
							bootItem = actionQueue.poll();
							if (bootItem != null) {
								bootItem.go();
							} else {
								System.out.println("Error - Empty actionQueue!");
								break;
							}

						} catch (Exception e) {
							e.printStackTrace();
						}

					} else {
						// Shouldn't enter here if pending tasks
						// are updated faster than this timeout..
						Thread.sleep(10);
					}
				}
				// if scope not/no longer connected
				actionQueue.clear();
				// pool.shutdown();
				return;
			} catch (InterruptedException v) {
				System.out.println(v);
			}
		}
	};

	private void waitForResponse() {
		int loopCount = 0;
		int interval = 5;
		final int loopCountTotal = (int) Math.ceil(((double) 100) / ((double) interval));
		while (true) {
			// if (isReady) {
			// break;
			// }

			if (loopCount++ >= loopCountTotal) {
				break;
			}

			try {
				Thread.sleep(interval);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	// private void waitForReply() {
	// try {
	// hidDev.setOutputReport((byte) 0, txBuf, length);
	// Thread.sleep(5);
	// } catch (InterruptedException e) {
	// // TODO Auto-generated catch block
	// e.printStackTrace();
	// }
	// }

	private void sendAndWait() {
		isReady = false;
		hidDev.setOutputReport((byte) 0, txBuf, length);
		waitForResponse();
	}

	private void sendNoWait() {
		hidDev.setOutputReport((byte) 0, txBuf, length);
	}
	
	/***********
	 * Setters *
	 ***********/
	

	
	/***********
	 * Getters *
	 ***********/

	public int getSignalCh1() {
		return signalCh1;
	}

	public int getSignalCh2() {
		return signalCh2;
	}

	public float getUSBVoltage() {
		return usbSupplyVoltage;
	}

	protected boolean isDeviceConnected() {
		if (devInfo != null) {
			return true;
		} else {
			return false;
		}
	}
}
