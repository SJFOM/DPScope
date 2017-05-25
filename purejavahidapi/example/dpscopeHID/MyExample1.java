package dpscopeHID;
import java.util.List;

import purejavahidapi.*;

public class MyExample1 {

	final static short VID = (short) 0x04D8;
	final static short PID = (short) 0xF891;

	public static void main(String[] args) {
		try {
			List<HidDeviceInfo> devList = PureJavaHidApi.enumerateDevices();
			for (HidDeviceInfo info : devList) {
				if((short) info.getVendorId() == VID && (short) info.getProductId() == PID){
					System.out.println("DPSCOPE detected!");
					System.out.printf("VID = 0x%04X | PID = 0x%04X | ", //
							"Manufacturer = %s | Product = %s | Path = %s\n", //
							info.getVendorId(), //
							info.getProductId(), //
							info.getManufacturerString(), //
							info.getProductString(), //
							info.getPath());

				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
