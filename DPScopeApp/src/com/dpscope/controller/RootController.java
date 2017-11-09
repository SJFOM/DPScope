package com.dpscope.controller;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.MenuItem;

public class RootController {

	private MainController tabMainController;
	
    @FXML
    private MenuItem menuItemConnect;

    @FXML
    private MenuItem menuItemDisconnect;

    @FXML
    void connectScope(ActionEvent event) {
    	System.out.println("Root - connect");
    	tabMainController.setupScope();
//    	MainController m = new MainController();
//    	m.setupScope();
    }

    @FXML
    void disconnectScope(ActionEvent event) {
    	System.out.println("Root - disconnect");
    	tabMainController.disconnectScope();
    }

	public void init(MainController mainController) {
		// TODO Auto-generated method stub
		tabMainController = mainController;
	}
}
