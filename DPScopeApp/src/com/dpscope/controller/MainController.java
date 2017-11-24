package com.dpscope.controller;

import java.net.URL;
import java.util.LinkedHashMap;
import java.util.Observable;
import java.util.Observer;
import java.util.ResourceBundle;
import java.util.concurrent.ConcurrentLinkedQueue;

import com.dpscope.DPScope;
import com.dpscope.DPScope.Command;

import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;

public class MainController implements Initializable {

	private static DPScope myScope;

	private static LinkedHashMap<Command, float[]> parsedMap;

	private static float[] lastData = new float[1];
	// private static float[] scopeBuffer = new float[448];

	private static boolean isDone = false;
	private static boolean isArmed = false;

	private static long timeCapture = 0l;
	private static long timeElapsed = 0l;

	// private static ObservableList<XYChart.Data<Number, Number>> data =
	// FXCollections.<XYChart.Data<Number, Number>>observableArrayList();
	private static ConcurrentLinkedQueue<Number> data = new ConcurrentLinkedQueue<>();
	private static XYChart.Series<Number, Number> series = new XYChart.Series<>();

	@FXML
	private Button start_stop;

	@FXML
	private NumberAxis x_axis;

	@FXML
	private NumberAxis y_axis;

	@FXML
	private Button speed;

	@FXML
	private Button getVusb;

	@FXML
	private Button readScope;

	@FXML
	private Button btnClear;

	@FXML
	private CheckBox toggleAnimation;

	@FXML
	private LineChart<Number, Number> ScopeChart;

	protected volatile static boolean taskReadScope = false;

	protected volatile static boolean readBackDone = false;

	@FXML
	void fillChart(ActionEvent event) {
		// scopeTask.start();
		// scopeTask.interrupt();

		if (myScope != null) {
			if (start_stop.getText().equals("Start")) {
				start_stop.setText("Stop");
				taskReadScope = true;
				// scopeTask.start();

				if (taskReadScope) {
					series.getData().clear();
					data.clear();
					runScan_ScopeMode();

					while (readBackDone == false)
						;
					readBackDone = false;
					int j = 0;
					for (int i = 1; i < DPScope.MAX_READABLE_SIZE; i += 2) {
						// System.out.println(i + " - " +
						// myScope.scopeBuffer[i]);
						// System.out.println(myScope.scopeBuffer[i]);
						series.getData().add(new XYChart.Data<>(j++, myScope.scopeBuffer[i]));
						// data.add(scopeBuffer[i]);
					}

					try {
						Thread.sleep(200);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}

			} else {
				taskReadScope = false;
				// scopeTask.interrupt();
				start_stop.setText("Start");
			}
		} else {
			// fill with random data
			if (true) {
				// ScopeChart.getData().clear();
				// data.clear();
				for (int i = 0; i < 1000; i++)
					series.getData().add(new XYChart.Data<>(i, Math.random()));
				System.out.println("No scope connected");
				// try {
				// Thread.sleep(2000);
				// } catch (InterruptedException e) {
				// // TODO Auto-generated catch block
				// e.printStackTrace();
				// }
			}
		}
	}

	@FXML
	void clearChart(ActionEvent event) {
		series.getData().clear();
		data.clear();
	}

	@FXML
	void setChartAnimation(ActionEvent event) {
		if (toggleAnimation.isSelected()) {
			ScopeChart.setAnimated(true);
		} else {
			ScopeChart.setAnimated(false);
		}
	}

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		// TODO Auto-generated method stub
		System.out.println("Application started!");

		x_axis.setForceZeroInRange(false);
		x_axis.setAutoRanging(false);
		x_axis.setTickLabelsVisible(false);
		x_axis.setTickMarkVisible(false);
		x_axis.setMinorTickVisible(false);

		ScopeChart.setLegendVisible(false);

		ScopeChart.setAnimated(false);
		ScopeChart.setTitle("Animated Line Chart");
		ScopeChart.setHorizontalGridLinesVisible(true);

		// Set Name for Series
		series.setName("Series 1");

		// Add Chart Series
		ScopeChart.getData().add(series);

	}

	public static void setupScope() {
		myScope = new DPScope();
		if (myScope.isDevicePresent()) {
			myScope.connect();
			myScope.addObserver(new Observer() {
				@Override
				public void update(Observable o, Object arg) {
					// TODO Auto-generated method stub
					parsedMap = (LinkedHashMap<Command, float[]>) arg;
					if (parsedMap.containsKey(Command.CMD_READADC)) {
						lastData[0] = parsedMap.get(Command.CMD_READADC)[0];
					} else if (parsedMap.containsKey(Command.CMD_CHECK_USB_SUPPLY)) {
						System.out.println(
								"TestApp - USB supply: " + parsedMap.get(Command.CMD_CHECK_USB_SUPPLY)[0] + " Volts");
					} else if (parsedMap.containsKey(Command.CMD_READBACK)) {
						int j = 0;
						for (int i = 1; i < DPScope.MAX_READABLE_SIZE; i += 2) {
							// System.out.println(i + " - " +
							// myScope.scopeBuffer[i]);
							// System.out.println(myScope.scopeBuffer[i]);
							// series.getData().add(new XYChart.Data<>(j++, scopeBuffer[i]));
							// data.add(scopeBuffer[i]);
						}
						readBackDone = true;
						// timeElapsed = System.nanoTime() - timeCapture;
						// System.out.println("SampleController - CMD_READBACK - all blocks read");
					} else if (parsedMap.containsKey(Command.CMD_DONE)) {
						isDone = true;
					} else if (parsedMap.containsKey(Command.CMD_ARM)) {
						isArmed = true;
					}
					parsedMap.clear();
				}
			});
		} else {
			System.out.println("SampleController - No device present");
			myScope = null;
		}
	}

	public static boolean disconnectScope() {
		if (myScope != null) {
			myScope.disconnect();
			myScope.deleteObservers();
			myScope = null;
			return true;
		}
		return false;
	}

	private static void runScan_ScopeMode() {
		// TODO: tweak timings to optimize speed
		try {
			myScope.armScope(DPScope.CH1_1, DPScope.CH2_1);

			// must query scope if its ready for readback
			while (!isArmed) {
				Thread.sleep(10);
				// gives enough time to re-check and for readBack
				// System.out.println("TestApp - not armed - wait...");
			}
			isArmed = false;
			// System.out.println("TestApp - Scope Armed");
			myScope.queryIfDone();
			while (!isDone) {
				Thread.sleep(5);
				// gives enough time to re-check and for readBack
				// System.out.println("TestApp - not ready - wait...");
			}
			isDone = false;

			// System.out.println("TestApp - Ready for read!");

			for (int i = 0; i < DPScope.ALL_BLOCKS; i++) {
				myScope.readBack(i);
			}
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	Thread scopeTask = new Thread() {
		public void run() {
			Platform.runLater(new Runnable() {
				public void run() {
					if (myScope != null) {
						if (start_stop.getText().equals("Start")) {
							start_stop.setText("Stop");
							taskReadScope = true;
							// scopeTask.start();

							if (taskReadScope) {
								ScopeChart.getData().clear();
								data.clear();
								runScan_ScopeMode();

								while (readBackDone == false)
									;
								readBackDone = false;

								// XYChart.Series series = new XYChart.Series(data);
								// ScopeChart.getData().add(series);
							}

						} else {
							taskReadScope = false;
							// scopeTask.interrupt();
							start_stop.setText("Start");
						}
					} else {
						// fill with random data
						if (true) {
							// ScopeChart.getData().clear();
							// data.clear();
							for (int i = 0; i < 100; i++)
								series.getData().add(new XYChart.Data<>(i, Math.random()));
							System.out.println("No scope connected");
							// XYChart.Series series = new XYChart.Series(data);
							// ScopeChart.getData().add(series);
							try {
								Thread.sleep(2000);
							} catch (InterruptedException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
					}
				}
			});
		}
	};
}
