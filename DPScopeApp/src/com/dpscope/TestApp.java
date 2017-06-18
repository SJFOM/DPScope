package com.dpscope;

public class TestApp {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		DPScope myScope = new DPScope();
		if (myScope.isDevicePresent()) {
			myScope.connect();
			float avgVolts = 0.0f;
			int i = 0;
			for (i = 0; i < 100; i++) {
				avgVolts += myScope.checkUsbSupply();
			}
			System.out.println("Batt voltage: " + avgVolts / i);
			myScope.disconnect();
		} else {
			System.out.println("No device present");
		}
	}
}
