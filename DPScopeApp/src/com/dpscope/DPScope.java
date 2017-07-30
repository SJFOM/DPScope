package com.dpscope;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Observable;
import java.util.Observer;
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

	protected final static byte CH1_1 = (byte) 5;
	protected final static byte CH1_10 = (byte) 6;
	protected final static byte CH2_1 = (byte) 8;
	protected final static byte CH2_10 = (byte) 9;
	protected final static byte CH_BATTERY = (byte) 15;

	private final static int ADCS = 2;
	private final static int ACQT = 5;

	private final static byte ADC_ACQ = (byte) ((128 + ACQT * 8 + ADCS) & 0xff);

	private static float usbSupplyVoltage = 0.0f;

	private HidDevice hidDev;
	private HidDeviceInfo devInfo;

	public boolean isDone = false;
	public boolean isReady = false;

	private Command currCmd;

	volatile static boolean deviceOpen = false;

	private volatile byte[] txBuf = new byte[20];
	private int length = 0;

	private volatile int signalCh1;
	private volatile int signalCh2;

	public List<BootAction> actionList = new ArrayList<BootAction>();
	public Queue<BootAction> actionQueue = new LinkedList<BootAction>();
	private final ExecutorService pool;

	private float[] channels = new float[2];
	private boolean run_RollMode = false;
	
	private static float[] scopeBuffer = new float[448];
	private static int currBlock = 0;

	public long currTime = 0;

	public int callCount = 0;

	private byte ch1;
	private byte ch2;

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
		CMD_CHECK_USB_SUPPLY;
	}

	private HashMap<Command, float[]> mapOfArguments = new LinkedHashMap<Command, float[]>();

	public DPScope() {
		devInfo = null;
		currCmd = Command.CMD_IDLE;
		signalCh1 = 0;
		signalCh2 = 0;
		pool = Executors.newSingleThreadExecutor();
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
			this.addObserver(new Observer() {

				@Override
				public void update(Observable o, Object arg) {
					// TODO Auto-generated method stub
					// actionQueue.remove();
					if (run_RollMode) {
						readADC(ch1, ch2);
					}
					// System.out.println("List size: " + actionQueue.size());
					// System.out.format("%f\n", (double) (System.nanoTime() - currTime) /
					// 1_000_000_000.0);
					// currTime = System.nanoTime();
					// callCount++;
					// System.out.println(callCount + " times");
				}
			});

			try {
				hidDev = PureJavaHidApi.openDevice(devInfo);
				hidDev.setDeviceRemovalListener(new DeviceRemovalListener() {
					@Override
					public void onDeviceRemoval(HidDevice source) {
						System.out.println("device removed");
						deviceOpen = false;
						isReady = false;
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
							System.out.println("Scope Armed...");
//							break;
						case CMD_DONE:
							if (rxBuf[0] > 0) {
								System.out.printf("Current acquisition %s acquired\n",
										(rxBuf[0] > 0) ? ("is now") : "not");
								
								for (int i = 0; i < 7; i++) {
									readBack(i);
								}
								isDone = true;
								isReady = true;
							}
							break;
						case CMD_ABORT:
							System.out.print("Scope disarmed");
							// isReady = true;
							break;
						case CMD_READBACK:
							System.out.print("Readback rxBuf - block " + currBlock + "\n");
//							int ch1 = 0, ch2 = 0;
							for (int idx = 0; idx < 64; idx++) {
								// System.out.print(rxBuf[idx] - 127 + " ");
								// if(rxBuf[ids
//								ch1 += (int) ((rxBuf[idx] & 0xFF) << 2) - 127 * 0;
//								ch2 += (int) ((rxBuf[idx + 1] & 0xFF) << 2) - 127 * 0;
								scopeBuffer[idx + ((int)txBuf[1]) * 64] = (int) ((rxBuf[idx] & 0xFF) << 2);
							}
//							signalCh1 = ch1 / 32;
//							signalCh2 = ch2 / 32;
//							System.out.println("Channel 1 -> " + signalCh1);
//							System.out.println("Channel 2 -> " + signalCh2);
							if(currBlock == 6) {
								mapOfArguments.put(Command.CMD_READBACK, scopeBuffer);
								setChanged();
								notifyObservers(mapOfArguments);
							}
							isReady = true;
//							isDone = false;
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
							System.out.printf("Pin 1: %d\n", (twosCompConvert & 0x80 >> 7));
							// isReady = true;
							break;
						case CMD_ARM_LA:
							System.out.print("Arm Logic Analyzer pins - to be implemented");
							// isReady = true;
							break;
						case CMD_CHECK_USB_SUPPLY:
							usbSupplyVoltage = (float) 4.096 * 1023
									/ ((int) (rxBuf[0] & 0xFF) * 256 + (rxBuf[1] & 0xFF));
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
		hidDev.close();
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
	public void armScope(byte ch1, byte ch2) {
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				// TODO Auto-generated method stub
				txBuf[0] = 0x05;
				txBuf[1] = ch1; // channel1
				txBuf[2] = ch2; // channel2
				txBuf[3] = ADC_ACQ;
				txBuf[4] = 0x00; // timer MSB
				txBuf[5] = 0x10; // timer LSB
				txBuf[6] = 0x01; // prescaler bypass (0 = use prescaler, 1 =
									// bypass
									// prescaler)
				txBuf[7] = 0x00; // prescaler selection as power of 2 (7=div256,
									// 0=div2)
				txBuf[8] = (byte) 2; // sample shift first channel
				txBuf[9] = (byte) 2; // sample shift second channel
				txBuf[10] = (byte) 0; // sample subtract first channel
				txBuf[11] = (byte) 0; // sample subtract second channel
				txBuf[12] = 0x00; // trigger source (0 = auto, 1 = triggered)
				txBuf[13] = 0x00; // trigger polarity (0 = falling edge, 1 =
									// rising
									// edge)
				txBuf[14] = 0x00; // trigger level MSB (currently not used)
				txBuf[15] = 0x10; // trigger level LSB (only applicable if
									// triggering on
				// CH1, not for ext. trigger)
				txBuf[16] = 0x00; // sampling mode: (0 = real time, 1 =
									// equivalent time)
				txBuf[17] = 0x10; // equivalent time sample interval in 0.5 usec
				// increments
				txBuf[18] = (byte) (txBuf[17] >> 2); // equivalent time trigger
				// stability check period (half
				// of byte 17 value is a good
				// choice)
				txBuf[19] = 0x01; // trigger channel to use (1 = CH1 gain 1, 2 =
									// CH1
				// gain 10, 3 = ext. trigger)
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
				sendAndWait();
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
				sendAndWait();
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
		// startQueueIfStopped();
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
		actionQueue.clear();
		actionQueue.add(new BootAction() {
			@Override
			public boolean go() throws Exception {
				float avgVolts = 0.0f;
				for (int i = 0; i < count; i++) {
					// readADCDirect(CH_BATTERY, CH_BATTERY);
					buildCmdReadAdc(CH_BATTERY, CH_BATTERY);
					sendAndWait();
					avgVolts += getUSBVoltage();
				}
				actionQueue.remove();
				channels[0] = avgVolts / count;
				System.out.printf("Batt voltage: %.3f\n", avgVolts / count);
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
		setChannelsInUse(ch1, ch2);
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
				while (deviceOpen) {
					if ((isReady && (actionQueue.size() > 1)) || (actionQueue.size() == 1)) {
						isReady = false;
						try {
//							actionQueue.element().go();
//							if (actionQueue.size() > 10) {
//								actionQueue.remove();
//							}
							actionQueue.element().go();
							actionQueue.remove();
							
						} catch (Exception e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}

					} else {
						Thread.sleep(5);
						// if (actionQueue.size() > 0) {
						// actionQueue.remove();
						// }
					}

					if (actionQueue.size() == 0) {
						break;
					}
				}
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
		int interval = 20;
		int loopCountTotal = (int) Math.ceil(((double) 100) / ((double) interval));

		boolean flag = true;
		while (flag) {
			if (isReady) {
				break;
			}

			loopCount += 1;
			if (loopCount >= loopCountTotal) {
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

	public int getSignalCh1() {
		return signalCh1;
	}

	public int getSignalCh2() {
		return signalCh2;
	}

	public float getUSBVoltage() {
		return usbSupplyVoltage;
	}

	private void setChannelsInUse(byte ch1, byte ch2) {
		this.ch1 = ch1;
		this.ch2 = ch2;
	}

	protected boolean isDeviceConnected() {
		if (devInfo != null) {
			return true;
		} else {
			return false;
		}
	}
}
