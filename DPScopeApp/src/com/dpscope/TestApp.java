package com.dpscope;

public class TestApp {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		DPScope myScope = new DPScope();
		if (!myScope.isDevicePresent()) {
//			myScope.connect();
			float avgVolts = 0.0f;
			int i = 0;
			myScope.checkUsbSupply(5);
//			for (i = 0; i < 1; i++) {			
//				myScope.checkUsbSupply();
////				while(!myScope.isReady);
//				avgVolts += myScope.getUSBVoltage();
//			}
//			while(!myScope.isReady);
			System.out.println("Batt voltage: " + avgVolts / i);
			myScope.disconnect();
		} else {
			System.out.println("No device present");
		}
	}
}
