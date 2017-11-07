package com.dpscope.view;

import java.net.URL;
import java.util.ResourceBundle;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.XYChart;
import javafx.scene.control.Button;

public class SampleController implements Initializable {

	@FXML
	private Button start_stop;

	@FXML
	private Button speed;

	@FXML
	private Button getVusb;

	@FXML
	private Button readScope;

	@FXML
	private LineChart<?, ?> ScopeChart;

	@FXML
	void fillChart(ActionEvent event) {
		// Graph Series
		XYChart.Series series = new XYChart.Series();
		series.getData().add(new XYChart.Data("1", 23));
		series.getData().add(new XYChart.Data("2", 50));
		series.getData().add(new XYChart.Data("3", 30));
		series.getData().add(new XYChart.Data("4", 80));
		series.getData().add(new XYChart.Data("5", 10));
		series.getData().add(new XYChart.Data("6", -5));

		ScopeChart.getData().addAll(series);
	}

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		// TODO Auto-generated method stub
	}
}
