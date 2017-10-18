package com.dpscope;

import java.util.LinkedHashMap;
import java.util.Observable;
import java.util.Observer;

import com.dpscope.DPScope.Command;

public class TestApp {

	// private static LinkedHashMap<Command, float[]> parsedMap;

	private static DPScope myScope;
	
	private static float[] lastData = new float[1];
	private static float[] scopeBuffer = new float[448];

	private static boolean isDone = false;
	private static boolean isArmed = false;

	private static long timeCapture = 0l;
	private static long timeElapsed = 0l;

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		myScope = new DPScope();
		if (myScope.isDevicePresent()) {
			myScope.connect();
			myScope.addObserver(new Observer() {
				@Override
				public void update(Observable o, Object arg) {
					// TODO Auto-generated method stub
					LinkedHashMap<Command, float[]> parsedMap = (LinkedHashMap<Command, float[]>) arg;
					if (parsedMap.containsKey(Command.CMD_READADC)) {
						lastData[0] = parsedMap.get(Command.CMD_READADC)[0];
					} else if (parsedMap.containsKey(Command.CMD_CHECK_USB_SUPPLY)) {
						System.out.println("TestApp - USB supply: " + parsedMap.get(Command.CMD_CHECK_USB_SUPPLY)[0] + " Volts");
					} else if (parsedMap.containsKey(Command.CMD_READBACK)) {
						// for (int i = 1; i < scopeBuffer.length; i += 2) {
						// System.out.println(i + " - " + scopeBuffer[i]);
						// }
						timeElapsed = System.nanoTime() - timeCapture;
						System.out.println("TestApp - CMD_READBACK - all blocks read");
					} else if (parsedMap.containsKey(Command.CMD_DONE)) {
						isDone = true;
					} else if (parsedMap.containsKey(Command.CMD_ARM)) {
						isArmed = true;
					}
				}
			});

			try {
				// for (int i = 0; i < 1; i++) {
				// myScope.checkUsbSupply();
				// }
				// myScope.checkUsbSupply();
				
				timeCapture = System.nanoTime();
				runScan_ScopeMode();
//				Thread.sleep(5000);
//				runScan_ScopeMode();
				
//				runScan_ScopeMode();
				
				Thread.sleep(500);

			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			myScope.disconnect();
			System.out.println("TestApp - Time elapsed: " + (timeElapsed / 1e9) + " seconds");
			System.out.println("TestApp - Equivalent refresh rate: " + (1e9/timeElapsed) + " Hz");
		} else {
			System.out.println("TestApp - No device present");
		}
	}
	
	private static void runScan_ScopeMode() {
		try {
			myScope.armScope(DPScope.CH1_1, DPScope.CH2_1);

			// must query scope if its ready for readback
			while (!isArmed) {
				Thread.sleep(10);
				// gives enough time to re-check and for readBack
				System.out.println("TestApp - not armed - wait...");
			}
			isArmed = false;
			System.out.println("TestApp - Scope Armed");
			myScope.queryIfDone();
			while (!isDone) {
				Thread.sleep(5);
				// gives enough time to re-check and for readBack
				System.out.println("TestApp - not ready - wait...");
			}
			isDone = false;
//			myScope.actionQueue.clear();

			System.out.println("TestApp - Ready for read!");

			for (int i = 0; i < DPScope.ALL_BLOCKS; i++) {
				myScope.readBack(i);
			}
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
