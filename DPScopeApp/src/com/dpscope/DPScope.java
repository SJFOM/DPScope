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

	private enum Command {
		CMD_IDLE, CMD_PING, CMD_REVISION, CMD_ARM, CMD_DONE, CMD_ABORT, CMD_READBACK, CMD_READADC, CMD_STATUS_LED, CMD_WRITE_MEM, CMD_READ_MEM, CMD_WRITE_EEPROM, CMD_READ_EEPROM, CMD_READ_LA, CMD_ARM_LA, CMD_INIT, CMD_SERIAL_INIT, CMD_SERIAL_TX, CMD_CHECK_USB_SUPPLY;
	}

	Command currCmd;

	volatile static boolean deviceOpen;

	byte[] data;
	int length;
	int sentBytes;

	public DPScope() {
		devInfo = null;
		data = new byte[10];
		length = 1;
		sentBytes = -1;
		deviceOpen = false;
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
					public void onInputReport(HidDevice source, byte Id, byte[] data, int len) {
						switch (currCmd) {
						case CMD_IDLE:
							break;
						case CMD_PING:
							try {
								String strData = new String(data, "UTF-8");
								System.out.printf("Ping result: %s", strData.substring(0, 11));
							} catch (UnsupportedEncodingException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							break;
						case CMD_REVISION:
							System.out.printf("Fw version: v%d.%d", data[0], data[1]);
							break;
						case CMD_DONE:
							System.out.printf("Current acquisition%s acquired", (data[0] > 0) ? (" ") : " not");
							break;
						case CMD_ABORT:
							System.out.print("Scope disarmed");
							break;
						case CMD_READBACK:
							System.out.print("Readback data - to be implemented");
							break;
						case CMD_READADC:
							System.out.print("Readback ADC - to be implemented");
							System.out.printf("%d\t%d", (((data[0]) << 8) | data[1]), ((data[0]) << 8) | data[1]);
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
							System.out.print("Read Logic Analyzer pins - to be implemented");
							break;
						case CMD_ARM_LA:
							System.out.print("Arm Logic Analyzer pins - to be implemented");
							break;
						case CMD_CHECK_USB_SUPPLY:
							System.out.print("USB supply voltage - to be implemented\n");
							System.out.printf("%d\t%d", (((data[0]) << 8) | data[1]), (((data[2]) << 8) | data[3]));
							break;
						default:
							break;
						}
						currCmd = Command.CMD_IDLE;
						System.out.println();
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
		data[0] = 0x02;
		length = 1;
		currCmd = Command.CMD_PING;
		waitForReply();
		// System.out.printf("%d bytes sent\n", sentBytes);
	}

	// CMD_REVISION (3) - get fw version
	public void getFwVersion() {
		data[0] = 0x03;
		length = 1;
		currCmd = Command.CMD_REVISION;
		waitForReply();
	}

	// CMD_ARM (5) - Sets all acquisition parameters and arms scope
	public void armScope() {
		data[0] = 0x05;
		length = 1;
		currCmd = Command.CMD_ARM;
		waitForReply();
	}

	// CMD_DONE (6) - Query whether scope has already finished the acquisition
	public void queryIfDone() {
		data[0] = 0x06;
		length = 1;
		currCmd = Command.CMD_DONE;
		waitForReply();
	}
	
	// CMD_ABORT (7) - Disarms the scope, so it's read for a new command
	public void abort() {
		data[0] = 0x07;
		length = 1;
		currCmd = Command.CMD_ABORT;
		waitForReply();
	}

	// CMD_READBACK (8) - Initiates read-back of acquired data record
	public void readBack() {
		data[0] = 0x08;
		length = 1;
		currCmd = Command.CMD_READBACK;
		waitForReply();
	}
	
	// CMD_READADC (9) - Reads back ADC directly (with 10 bit resolution, returns 2 bytes per channel)
	public void readADC(byte ch1, byte ch2, byte params) {
		data[0] = 0x09;
		data[1] = ch1;
		data[2] = ch2;
		data[3] = params;
		length = 4;
		currCmd = Command.CMD_READADC;
		waitForReply();
	}
	

	// CMD_STATUS_LED (10) - toggle LED (0 - off, 1 - on)
	public void toggleLed(boolean onOff) {
		data[0] = 0x0A;
		data[1] = (byte) ((onOff) ? 1 : 0);
		length = 2;
		currCmd = Command.CMD_STATUS_LED;
		waitForReply();
	}
	
	// CMD_WRITE_MEM (11) - Writes a byte to a memory location on the microcontroller's SFR
	// Note: Address range is restricted to Special Function Register (SFR) on the PIC
	public void writeMem(byte addrMSB, byte addrLSB, byte dataSFR) {
		data[0] = 0x0B;
		data[1] = addrMSB;
		data[2] = addrLSB;
		data[3] = dataSFR;
		length = 4;
		currCmd = Command.CMD_WRITE_MEM;
		waitForReply();
	}
	
	// CMD_WRITE_MEM (12) - Reads a memory location on the microcontroller's SFR
	public void readMem(byte addrMSB, byte addrLSB) {
		data[0] = 0x0C;
		data[1] = addrMSB;
		data[2] = addrLSB;
		length = 3;
		currCmd = Command.CMD_READ_MEM;
		waitForReply();
	}
	
	// CMD_WRITE_EEPROM (13) - Writes a memory location on the microcontroller’s data EEPROM
	public void writeEEPROM(byte addrMSB, byte addrLSB, byte dataEEPROM) {
		data[0] = 0x0D;
		data[1] = addrMSB;
		data[2] = addrLSB;
		data[3] = dataEEPROM;
		length = 4;
		currCmd = Command.CMD_WRITE_EEPROM;
		waitForReply();
	}
	
	// CMD_READ_EEPROM (14) - Read a memory location on the microcontroller’s data EEPROM
	public void readEEPROM(byte addrMSB, byte addrLSB) {
		data[0] = 0x0E;
		data[1] = addrMSB;
		data[2] = addrLSB;
		length = 3;
		currCmd = Command.CMD_READ_EEPROM;
		waitForReply();
	}
	
	// CMD_READ_LA (15) - Reads back the state of the logic analyzer pins (port B)
	public void readLogicAnalyzer() {
		data[0] = 0x0F;
		length = 1;
		currCmd = Command.CMD_READ_LA;
		waitForReply();
	}

	// CMD_ARM_LA (16) - Sets logic analyzer acquisition parameters 
	public void armLogicAnalyzer(byte sampleRate, byte triggerCond) {
		data[0] = 0x10;
		data[1] = sampleRate;
		data[2] = triggerCond;
		length = 3;
		currCmd = Command.CMD_ARM_LA;
		waitForReply();
	}
	
	// CMD_INIT (17) - Re-initialize microcontroller
	public void initialize(boolean blinkLED) {
		data[0] = 0x11;
		data[1] = (byte)((blinkLED) ? (0x01) : (0x00));
		length = 2;
		currCmd = Command.CMD_INIT;
		waitForReply();
	}

	// CMD_SERIAL_INIT (18) - Initialize external trigger pin for serial data output
	public void serialInit() {
		data[0] = 0x12;
		length = 1;
		currCmd = Command.CMD_SERIAL_INIT;
		waitForReply();
	}
	
	// CMD_SERIAL_TX (19) - Send one byte over trigger pin at 9600 baud
	public void serialByteTx(byte serialByte) {
		data[0] = 0x13;
		data[1] = serialByte;
		length = 2;
		currCmd = Command.CMD_SERIAL_TX;
		waitForReply();
	}
	
	// CMD_CHECK_USB_SUPPLY - Read ADC channel associated with USB supply voltage
	public void checkUsbSupply() {
		data[0] = 0x09;
		data[1] = (byte) 1;
		data[2] = (byte) 0;
		data[3] = (byte) 158;
		length = 4;
		currCmd = Command.CMD_CHECK_USB_SUPPLY;
		waitForReply();
	}

	
	private void waitForReply() {
		try {
			sentBytes = hidDev.setOutputReport((byte) 0, data, length);
			Thread.sleep(5);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
