package com.dpscope;

public class TestApp {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		DPScope myScope = new DPScope();
        if(myScope.isDevicePresent()){
        	myScope.connect();
        	myScope.ping();
//        	myScope.toggleLed(true);
        	myScope.getFwVersion();
        } else {
        	System.out.println("No device present");
        }
	}
}
