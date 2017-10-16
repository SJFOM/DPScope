package com.dpscope;

import java.util.LinkedHashMap;
import java.util.Observable;
import java.util.Observer;

import com.dpscope.DPScope.Command;

public class TestApp {

//	private static LinkedHashMap<Command, float[]> parsedMap;

	private static float[] lastData = new float[1];
	private static float[] scopeBuffer = new float[448];
	
	private static boolean isDone = false;

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		DPScope myScope = new DPScope();
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
						System.out.println("USB supply: " + parsedMap.get(Command.CMD_CHECK_USB_SUPPLY)[0] + " Volts");
					} else if (parsedMap.containsKey(Command.CMD_READBACK)) {
//						for (int i = 1; i < scopeBuffer.length; i += 2) {
//							System.out.println(i + " - " + scopeBuffer[i]);
//						}
						System.out.println("CMD_READBACK - all blocks read");
					} else if (parsedMap.containsKey(Command.CMD_DONE)){
						isDone = true;
					}
				}
			});

			try {
//			for (int i = 0; i < 1; i++) {
//				myScope.checkUsbSupply();				
//			}
//			myScope.checkUsbSupply();
			myScope.armScope(DPScope.CH1_1, DPScope.CH2_1);						
			
			long timeOut = 15;
			int timeOutText = (int) ((int) 1000*448/timeOut);
			System.out.println(timeOutText + " samples/sec");
			
			// not sure if isDone is returned every time or not..
			while(!isDone);
			isDone = false;
//			Thread.sleep(50);
			System.out.println("Ready for read");
			
			for (int i = 0; i < 7; i++) {
				myScope.readBack(i);
			}
			
			
				Thread.sleep(timeOut);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			myScope.disconnect();
			
		} else {
			System.out.println("No device present");
		}
	}
}
