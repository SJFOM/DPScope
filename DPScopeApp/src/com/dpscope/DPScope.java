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

	volatile static boolean deviceOpen;

	byte[] data;
	int length;
	int sentBytes;

	public DPScope(){
		devInfo = null;
		data = new byte[10];
		length = 1;
		sentBytes = -1;
		deviceOpen = false;
	}

	public boolean isDevicePresent(){
		try {
			List<HidDeviceInfo> devList = PureJavaHidApi.enumerateDevices();
			for (HidDeviceInfo info : devList) {
				if(((short) info.getVendorId() == VID) && ((short) info.getProductId() == PID)){
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

	public void connect(){
		if (devInfo != null){
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
						for (int i = 0; i < len; i++)
							System.out.printf("%02X ", data[i]);
						try {
							String strData = new String(data, "UTF-8");
							System.out.printf("\nReceived: %s", strData.substring(0,11));
						} catch (UnsupportedEncodingException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
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
	public void ping(){
		data[0] = 0x02;
		length = 1;
		sentBytes = hidDev.setOutputReport((byte) 0, data, length);
		//		System.out.printf("%d bytes sent\n", sentBytes);	
	}

	// CMD_REVISION - get fw version
	public void getFwVersion(){
		data[0] = 0x03;
		length = 1;
		sentBytes = hidDev.setOutputReport((byte) 0, data, length);
	}

	// CMD_STATUS_LED - toggle LED (0 - off, 1 - on)
	public void toggleLed(boolean onOff){
		data[0] = 0x0A;
		data[1] = (byte) ((onOff) ? 1: 0);
		length = 2;
		sentBytes = hidDev.setOutputReport((byte) 0, data, length);
	}

}
