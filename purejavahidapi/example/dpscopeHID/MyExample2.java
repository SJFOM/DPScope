package dpscopeHID;
import java.io.UnsupportedEncodingException;
import java.util.List;

import purejavahidapi.*;

public class MyExample2 {
	volatile static boolean deviceOpen = false;
	final static short DPSCOPE_VID = (short) 0x04D8;
	final static short DPSCOPE_PID = (short) 0xF891;

	public static void main(String[] args) {
		try {

//			while (true) {
				// System.exit(0);
				HidDeviceInfo devInfo = null;
				if (!deviceOpen) {
					System.out.println("scanning");
					List<HidDeviceInfo> devList = PureJavaHidApi.enumerateDevices();
					for (HidDeviceInfo info : devList) {
						if (info.getVendorId() == DPSCOPE_VID && info.getProductId() == DPSCOPE_PID) {
							devInfo = info;
							break;
						}
					}
					if (devInfo == null) {
						System.out.println("device not found");
						Thread.sleep(1000);
					} else {
						System.out.println("device found");
						if (true) {
							deviceOpen = true;
							final HidDevice dev = PureJavaHidApi.openDevice(devInfo);

							dev.setDeviceRemovalListener(new DeviceRemovalListener() {
								@Override
								public void onDeviceRemoval(HidDevice source) {
									System.out.println("device removed");
									deviceOpen = false;

								}
							});
							dev.setInputReportListener(new InputReportListener() {
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

							byte[] ping = new byte[2];
							ping[0] = 0x02;
							int length = 1;
							int sentBytes = -1;
							
							// CMD_PING (2) - get device name
							sentBytes = dev.setOutputReport((byte) 0,ping,length);
							System.out.printf("%d bytes sent\n", sentBytes);
							
							// CMD_REVISION - get fw version
//							ping[0] = 0x03;
//							sentBytes = dev.setOutputReport((byte) 0,ping,length);
							
							// CMD_STATUS_LED - toggle LED (0 - off, 1 - on)
//							ping[0] = 0x0A;
//							ping[1] = 0x00;
//							length = 2;
//							sentBytes = dev.setOutputReport((byte) 0,ping,length);

//							new Thread(new Runnable() {
//								@Override
//								public void run() {
//									while (true) {
//										byte[] data = new byte[20];
//										data[0] = 1;
//										int len = 0;										
//										if (((len = dev.getFeatureReport(data, data.length)) >= 0) && true) {
//											int Id = data[0];
//											System.out.printf("getFeatureReport: id %d len %d data ", Id, len);
//											for (int i = 0; i < data.length; i++){
//												System.out.printf("%02X ", data[i]);
//											}											
//											
//											System.out.println();
//										}
//
//									}
//
//								}
//							}).start();																	

							Thread.sleep(2000);
							dev.close();
							deviceOpen = false;
						}
					}
				}
//			}
		} catch (Throwable e) {
			e.printStackTrace();
		}

	}
}
