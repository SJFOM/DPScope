package com.dpscope.view;

import javafx.fxml.FXML;
import javafx.scene.chart.LineChart;
import javafx.scene.control.Button;

public class SampleController {
	@FXML
	private Button start_stop;
	
	@FXML
	private Button speed;
	
	@FXML
	private Button getVusb;
	
	@FXML
	private Button readScope;
	
	@FXML
	private LineChart<Double, Double> ScopeChart;
}
