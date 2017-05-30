package com.dpscope;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
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
		CMD_IDLE, CMD_PING, CMD_REVISION, CMD_ARM, CMD_DONE, CMD_ABORT, CMD_READBACK, CMD_READADC, CMD_STATUS_LED, CMD_WRITE_MEM, CMD_READ_MEM, CMD_WRITE_EEPROM, CMD_READ_EEPROM, CMD_READ_LA, CMD_ARM_LA, CMD_INIT, CMD_SERIAL_INIT, CMD_SERIAL_TX;
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
						System.out.printf("onInputReport: id %d len %d data ", Id, len);
						for (int i = 0; i < len; i++) {
							System.out.printf("%02X ", data[i]);
						}
						switch (currCmd) {
						case CMD_IDLE:
						case CMD_PING:
							try {
								String strData = new String(data, "UTF-8");
								System.out.printf("\nPing result: %s", strData.substring(0, 11));
							} catch (UnsupportedEncodingException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						case CMD_REVISION:
							System.out.printf("\nFw version: v%d.%d", data[0], data[1]);
						default:
							break;
						}
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

	// CMD_PING (2) - get device name
	public void ping() {
		data[0] = 0x02;
		length = 1;
		currCmd = Command.CMD_PING;
		sentBytes = hidDev.setOutputReport((byte) 0, data, length);
		// System.out.printf("%d bytes sent\n", sentBytes);
	}

	// CMD_REVISION (3) - get fw version
	public void getFwVersion() {
		data[0] = 0x03;
		currCmd = Command.CMD_REVISION;
		sentBytes = hidDev.setOutputReport((byte) 0, data, length);
	}

	// CMD_STATUS_LED - toggle LED (0 - off, 1 - on)
	public void toggleLed(boolean onOff) {
		data[0] = 0x0A;
		data[1] = (byte) ((onOff) ? 1 : 0);
		length = 2;
		currCmd = Command.CMD_STATUS_LED;
		sentBytes = hidDev.setOutputReport((byte) 0, data, length);
	}

}
