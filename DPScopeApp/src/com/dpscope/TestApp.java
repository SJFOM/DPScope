package com.dpscope;

public class TestApp {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		DPScope myScope = new DPScope();
		if (myScope.isDevicePresent()) {
			myScope.connect();
			// myScope.checkUsbSupply(5);
			long currTime = System.nanoTime();
			System.out.println("Starting");
			int i = 0;
			for (; i < 5000; i++) {
				myScope.readADC(DPScope.CH1_1, DPScope.CH2_1);
				currTime = System.nanoTime();
				while (!myScope.isReady);
//				System.out.println("Ch1: " + myScope.getSignalCh1());
//				System.out.println("Ch2: " + myScope.getSignalCh2());
//				System.out.println(System.nanoTime() - currTime);
			}

			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			double elapsedTimeInSeconds = (double)((System.nanoTime() - currTime)/1_000_000_000.0);
			System.out.format("Time elapsed: %f seconds\n", elapsedTimeInSeconds);
			System.out.format("Sampling rate: %f Hz\n", i/elapsedTimeInSeconds);
			System.out.println("Closing up");
			myScope.disconnect();
		} else {
			System.out.println("No device present");
		}
	}
}
