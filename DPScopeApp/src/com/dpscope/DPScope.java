package com.dpscope;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;

import purejavahidapi.DeviceRemovalListener;
import purejavahidapi.HidDevice;
import purejavahidapi.HidDeviceInfo;
import purejavahidapi.InputReportListener;
import purejavahidapi.PureJavaHidApi;

public class DPScope {

	final static short VID = (short) 0x04D8;
	final static short PID = (short) 0xF891;

	private static HidDevice hidDev;
	private static HidDeviceInfo devInfo;

	public boolean isDone;

	private enum Command {
		CMD_IDLE, CMD_PING, CMD_REVISION, CMD_ARM, CMD_DONE, CMD_ABORT, CMD_READBACK, CMD_READADC, CMD_STATUS_LED, CMD_WRITE_MEM, CMD_READ_MEM, CMD_WRITE_EEPROM, CMD_READ_EEPROM, CMD_READ_LA, CMD_ARM_LA, CMD_INIT, CMD_SERIAL_INIT, CMD_SERIAL_TX, CMD_CHECK_USB_SUPPLY;
	}

	Command currCmd;

	volatile static boolean deviceOpen;

	byte[] txBuf;
	int length;
	int sentBytes;

	public DPScope() {
		devInfo = null;
		txBuf = new byte[20];
		length = 1;
		sentBytes = -1;
		deviceOpen = false;
		isDone = false;
		currCmd = Command.CMD_IDLE;
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
			try {
				hidDev = PureJavaHidApi.openDevice(devInfo);
				hidDev.setDeviceRemovalListener(new DeviceRemovalListener() {
					@Override
					public void onDeviceRemoval(HidDevice source) {
						System.out.println("device removed");
						deviceOpen = false;
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
							break;
						case CMD_REVISION:
							System.out.printf("Fw version: v%d.%d", rxBuf[0], rxBuf[1]);
							break;
						case CMD_DONE:
							if (rxBuf[0] > 0) {
								System.out.printf("Current acquisition %s acquired\n", (rxBuf[0] > 0) ? ("is now") : "not");
								isDone = true;
							}
							break;
						case CMD_ABORT:
							System.out.print("Scope disarmed");
							break;
						case CMD_READBACK:
							System.out.print("Readback rxBuf - to be implemented\n");
							int ch1 = 0, ch2 = 0;
							for (int idx = 0; idx < 64; idx += 2) {
								// System.out.print(rxBuf[i] - 127 + " ");
								ch1 += rxBuf[idx] - 127;
								ch2 += rxBuf[idx + 1] - 127;
							}
							System.out.println("Channel 1 -> " + ch1 / 64);
							System.out.println("Channel 2 -> " + ch2 / 64);
							break;
						case CMD_READADC:
							// System.out.print("Readback ADC - to be
							// implemented");
//							System.out.printf("CH1: %d\tCH2: %d", rxBuf[0] * 256 + rxBuf[1] - 511,
//									rxBuf[2] * 256 + rxBuf[3] - 511);
							System.out.println("Channel 1 -> " + ((int)(rxBuf[0] * 256 + rxBuf[1]) - 511));
							System.out.println("Channel 2 -> " + ((int)(rxBuf[2] * 256 + rxBuf[3]) - 511));
							break;
						case CMD_WRITE_MEM:
							System.out.print("Write to SFR memory - to be implemented");
							break;
						case CMD_READ_MEM:
							System.out.print("Read from SFR memory - to be implemented");
							break;
						case CMD_WRITE_EEPROM:
							System.out.print("Write to EEPROM memory - to be implemented");
							break;
						case CMD_READ_EEPROM:
							System.out.print("Read from EEPROM memory - to be implemented");
							break;
						case CMD_READ_LA:
							System.out.println("Read Logic Analyzer pins - to be implemented");
							System.out.printf("return byte: 0x%02x -> %d\n", (byte) rxBuf[0], rxBuf[0]);
							int twosCompConvert = (rxBuf[0] < 0) ? (rxBuf[0] + 256) : (rxBuf[0]);					
							System.out.printf("Pin 4: %d\n", (twosCompConvert & 0x10) >> 4);
							System.out.printf("Pin 3: %d\n", (twosCompConvert & 0x20) >> 5);
							System.out.printf("Pin 2: %d\n", (twosCompConvert & 0x40) >> 6);
							System.out.printf("Pin 1: %d\n", (twosCompConvert & 0x80 >> 7));
							break;
						case CMD_ARM_LA:
							System.out.print("Arm Logic Analyzer pins - to be implemented");
							break;
						case CMD_CHECK_USB_SUPPLY:
							System.out.print("USB supply voltage - to be implemented\n");
							System.out.printf("%d\t%d", (((rxBuf[0]) << 8) | rxBuf[1]), (((rxBuf[2]) << 8) | rxBuf[3]));
							break;
						default:
							break;
						}
						currCmd = Command.CMD_IDLE;
//						System.out.println();
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
		hidDev.close();
	}

	// CMD_PING (2) - get device name
	public void ping() {
		txBuf[0] = 0x02;
		length = 1;
		currCmd = Command.CMD_PING;
		waitForReply();
		// System.out.printf("%d bytes sent\n", sentBytes);
	}

	// CMD_REVISION (3) - get fw version
	public void getFwVersion() {
		txBuf[0] = 0x03;
		length = 1;
		currCmd = Command.CMD_REVISION;
		waitForReply();
	}

	// CMD_ARM (5) - Sets all acquisition parameters and arms scope
	public void armScope(byte ch1, byte ch2, byte adcAcq) {
		txBuf[0] = 0x05;
		txBuf[1] = ch1; // channel1
		txBuf[2] = ch2; // channel2
//		txBuf[1] = (byte) 15; //channel1
//		txBuf[2] = (byte) 15; //channel2
		txBuf[3] = (byte) adcAcq;
		txBuf[4] = 0x00; // timer MSB
		txBuf[5] = 0x10; // timer LSB
		txBuf[6] = 0x01; // prescaler bypass (0 = use prescaler, 1 = bypass prescaler)
		txBuf[7] = 0x00; // prescaler selection as power of 2 (7=div256, 0=div2)
		txBuf[8] = (byte) 1; // sample shift first channel
		txBuf[9] = (byte) 2; // sample shift second channel
		txBuf[10] = (byte) 128; // sample subtract first channel
		txBuf[11] = (byte) 0; // sample subtract second channel
		txBuf[12] = 0x00; // trigger source (0 = auto, 1 = triggered)
		txBuf[13] = 0x00; // trigger polarity (0 = falling edge, 1 = rising edge)
		txBuf[14] = 0x00; // trigger level MSB (currently not used)
		txBuf[15] = 0x10; // trigger level LSB (only applicable if triggering on CH1, not for ext. trigger)
		txBuf[16] = 0x00; // sampling mode: (0 = real time, 1 = equivalent time)
		txBuf[17] = 0x10; // equivalent time sample interval in 0.5 usec increments
		txBuf[18] = (byte) (txBuf[17] >> 2); // equivalent time trigger stability check period (half of byte 17 value is a good choice)
		txBuf[19] = 0x01; // trigger channel to use (1 = CH1 gain 1, 2 = CH1
							// gain 10, 3 = ext. trigger)
		length = 20;
		if((ch1 != ((byte)15)) && (ch2 != ((byte)15))){
			currCmd = Command.CMD_ARM;
		} else {
			currCmd = Command.CMD_CHECK_USB_SUPPLY;
		}
		
		waitForReply();
	}

	// CMD_DONE (6) - Query whether scope has already finished the acquisition
	public void queryIfDone() {
		txBuf[0] = 0x06;
		length = 1;
		currCmd = Command.CMD_DONE;
		isDone = false;
		waitForReply();
	}

	// CMD_ABORT (7) - Disarms the scope, so it's read for a new command
	public void abort() {
		txBuf[0] = 0x07;
		length = 1;
		currCmd = Command.CMD_ABORT;
		waitForReply();
	}

	// CMD_READBACK (8) - Initiates read-back of acquired txBuf record
	public void readBack(int block) {
		txBuf[0] = 0x08;
		txBuf[1] = (byte) block;
		length = 2;
		currCmd = Command.CMD_READBACK;
		waitForReply();
	}

	// CMD_READADC (9) - Reads back ADC directly (with 10 bit resolution,
	// returns 2 bytes per channel)
	public void readADC(byte ch1, byte ch2, byte adcAcq) {
		txBuf[0] = 0x09;
		txBuf[1] = ch1;
		txBuf[2] = ch2;
		txBuf[3] = adcAcq;
		length = 4;
		currCmd = Command.CMD_READADC;
		waitForReply();
	}

	// CMD_STATUS_LED (10) - toggle LED (0 - off, 1 - on)
	public void toggleLed(boolean onOff) {
		txBuf[0] = 0x0A;
		txBuf[1] = (byte) ((onOff) ? 1 : 0);
		length = 2;
		currCmd = Command.CMD_STATUS_LED;
		waitForReply();
	}

	// CMD_WRITE_MEM (11) - Writes a byte to a memory location on the
	// microcontroller's SFR
	// Note: Address range is restricted to Special Function Register (SFR) on
	// the PIC
	public void writeMem(byte addrMSB, byte addrLSB, byte dataSFR) {
		txBuf[0] = 0x0B;
		txBuf[1] = addrMSB;
		txBuf[2] = addrLSB;
		txBuf[3] = dataSFR;
		length = 4;
		currCmd = Command.CMD_WRITE_MEM;
		waitForReply();
	}

	// CMD_WRITE_MEM (12) - Reads a memory location on the microcontroller's SFR
	public void readMem(byte addrMSB, byte addrLSB) {
		txBuf[0] = 0x0C;
		txBuf[1] = addrMSB;
		txBuf[2] = addrLSB;
		length = 3;
		currCmd = Command.CMD_READ_MEM;
		waitForReply();
	}

	// CMD_WRITE_EEPROM (13) - Writes a memory location on the microcontroller’s
	// txBuf EEPROM
	public void writeEEPROM(byte addrMSB, byte addrLSB, byte dataEEPROM) {
		txBuf[0] = 0x0D;
		txBuf[1] = addrMSB;
		txBuf[2] = addrLSB;
		txBuf[3] = dataEEPROM;
		length = 4;
		currCmd = Command.CMD_WRITE_EEPROM;
		waitForReply();
	}

	// CMD_READ_EEPROM (14) - Read a memory location on the microcontroller’s
	// txBuf EEPROM
	public void readEEPROM(byte addrMSB, byte addrLSB) {
		txBuf[0] = 0x0E;
		txBuf[1] = addrMSB;
		txBuf[2] = addrLSB;
		length = 3;
		currCmd = Command.CMD_READ_EEPROM;
		waitForReply();
	}

	// CMD_READ_LA (15) - Reads back the state of the logic analyzer pins (port
	// B)
	public void readLogicAnalyzer() {
		txBuf[0] = 0x0F;
		txBuf[1] = 0x05;
		txBuf[2] = 0x08;
		txBuf[3] = (byte) 158;
		length = 4;
		currCmd = Command.CMD_READ_LA;
		waitForReply();
	}

	// CMD_ARM_LA (16) - Sets logic analyzer acquisition parameters
	public void armLogicAnalyzer(byte sampleRate, byte triggerCond) {
		txBuf[0] = 0x10;
		txBuf[1] = sampleRate;
		txBuf[2] = triggerCond;
		length = 3;
		currCmd = Command.CMD_ARM_LA;
		waitForReply();
	}

	// CMD_INIT (17) - Re-initialize microcontroller
	public void initialize(boolean blinkLED) {
		txBuf[0] = 0x11;
		txBuf[1] = (byte) ((blinkLED) ? (0x01) : (0x00));
		length = 2;
		currCmd = Command.CMD_INIT;
		waitForReply();
	}

	// CMD_SERIAL_INIT (18) - Initialize external trigger pin for serial txBuf
	// output
	public void serialInit() {
		txBuf[0] = 0x12;
		length = 1;
		currCmd = Command.CMD_SERIAL_INIT;
		waitForReply();
	}

	// CMD_SERIAL_TX (19) - Send one byte over trigger pin at 9600 baud
	public void serialByteTx(byte serialByte) {
		txBuf[0] = 0x13;
		txBuf[1] = serialByte;
		length = 2;
		currCmd = Command.CMD_SERIAL_TX;
		waitForReply();
	}

	// CMD_CHECK_USB_SUPPLY - Read ADC channel associated with USB supply
	// voltage
	public void checkUsbSupply() {
		armScope((byte) 15, (byte) 15, (byte) 158);
		waitForReply();
	}

	private void waitForReply() {
		try {
			sentBytes = hidDev.setOutputReport((byte) 0, txBuf, length);
			Thread.sleep(5);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
