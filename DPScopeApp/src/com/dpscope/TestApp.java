package com.dpscope;

public class TestApp {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		DPScope myScope = new DPScope();
		if (myScope.isDevicePresent()) {
			myScope.connect();
//			int ACQT = 3;
//			int ADCS = 6;
//			byte adcAcq = (byte) (128 + ACQT * 8 + ADCS);
//			myScope.armScope(ch1_1, ch2_1, adcAcq);
			myScope.checkUsbSupply();
			
			while(!myScope.isDone){
				myScope.queryIfDone();
			}
			
//			for(int i = 0; i <= 6; i++){
//				myScope.readBack(i, false);
//			}
			myScope.readBack(0, true);
//			while(ADCS < 1000){
//				myScope.readLogicAnalyzer();
//				try {
//					Thread.sleep(500);
//				} catch (InterruptedException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
//				ADCS++;
//			}
//			myScope.readADC(ch1_1, ch2_1, adcAcq);
//			myScope.checkUsbSupply();
			myScope.disconnect();
		} else {
			System.out.println("No device present");
		}
	}
}
