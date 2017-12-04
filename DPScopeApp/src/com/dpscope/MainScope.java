package com.dpscope;

import java.util.LinkedHashMap;
import java.util.Observable;
import java.util.Observer;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;

import com.dpscope.DPScope.Command;
import com.jfoenix.controls.JFXButton;

import javafx.animation.AnimationTimer;
import javafx.application.Application;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.Event;
import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Control;
import javafx.scene.control.MenuButton;
import javafx.scene.control.MenuItem;
import javafx.scene.control.Spinner;
import javafx.scene.control.SpinnerValueFactory;
import javafx.scene.control.SplitPane;
import javafx.scene.control.Tab;
import javafx.scene.control.TabPane;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.FlowPane;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;

public class MainScope extends Application {

	/*
	 * Scope controls
	 */
	private static DPScope myScope;
	private static LinkedHashMap<Command, float[]> parsedMap;

	private volatile static boolean readBackDone = false;
	private volatile static boolean isDone = false;
	private volatile static boolean isArmed = false;
	private volatile static boolean scopeRead = false;
	private volatile static boolean nextScopeData = false;

	// offset found by measuring P & G pins at rear of scope
	private static float vUsbOffset = -0.008f;

	/*
	 * Scope reading variables
	 */
	private static float[] lastData = new float[1];
	private static float actualSupplyVoltage = 0.0f;
	private static float supplyVoltageRatio = 0.0f;
	private static float scaleFactorY = 0.0f;

	/*
	 * Testing variables
	 */
	private static boolean nextTestData = false;

	/*
	 * Elapsed time testing
	 */
	private static long timeCapture = 0l;
	private static long timeElapsed = 0l;

	/*
	 * JavaFX layout controls
	 */
	private static final int MAX_DATA_POINTS = 500;
	private int xSeriesData = 0;
	private XYChart.Series<Number, Number> series1 = new XYChart.Series<>();
	private ExecutorService executor;
	private ConcurrentLinkedQueue<Number> dataQ1 = new ConcurrentLinkedQueue<>();

	private NumberAxis xAxis;
	private NumberAxis yAxis;

	/*
	 * Main body of code
	 */

	private void init(Stage primaryStage) {

		xAxis = new NumberAxis(0, DPScope.MAX_DATA_PER_CHANNEL, DPScope.MAX_DATA_PER_CHANNEL / 10);
		xAxis.setForceZeroInRange(false);
		xAxis.setAutoRanging(false);
		xAxis.setTickLabelsVisible(false);
		xAxis.setTickMarkVisible(false);
		xAxis.setMinorTickVisible(false);

		yAxis = new NumberAxis(-20, 20, 4);
		// yAxis.setAutoRanging(true);
		// yAxis.setUpperBound(20);
		// yAxis.setLowerBound(0);

		// Create a LineChart
		final LineChart<Number, Number> lineChart = new LineChart<Number, Number>(xAxis, yAxis) {
			// Override to remove symbols on each data point
			@Override
			protected void dataItemAdded(Series<Number, Number> series, int itemIndex, Data<Number, Number> item) {
			}
		};

		lineChart.setAnimated(false);
		lineChart.setLegendVisible(false);
		lineChart.setVerticalGridLinesVisible(true);
		lineChart.setHorizontalGridLinesVisible(true);
		// lineChart.setTitle("Animated Line Chart");
		lineChart.setHorizontalGridLinesVisible(true);

		// Set Name for Series
		series1.setName("Series 1");

		// Add Chart Series
		lineChart.getData().add(series1);

		SplitPane spltPane = new SplitPane();
		spltPane.setDividerPosition(0, 0.3);
		spltPane.setMinWidth(Control.USE_PREF_SIZE);

		spltPane.getItems().addAll(tabPaneControls(), lineChart);

		BorderPane bpaneRoot = new BorderPane();

		JFXButton btnConnect = new JFXButton("Connect".toUpperCase());

		btnConnect.setStyle("-fx-background-color: #f64863;");

		btnConnect.setOnAction(new EventHandler<ActionEvent>() {
			@Override
			public void handle(ActionEvent e) {

				if (btnConnect.getText().equals("Connect".toUpperCase())) {
					myScope = new DPScope();
					if (myScope.isDevicePresent()) {
						btnConnect.setText("Disconnect".toUpperCase());
						myScope.connect();
						myScope.addObserver(new Observer() {
							@Override
							public void update(Observable o, Object arg) {
								// TODO Auto-generated method stub
								parsedMap = (LinkedHashMap<Command, float[]>) arg;
								if (parsedMap.containsKey(Command.CMD_READADC)) {
									lastData[0] = parsedMap.get(Command.CMD_READADC)[0];
								} else if (parsedMap.containsKey(Command.CMD_CHECK_USB_SUPPLY)) {
									actualSupplyVoltage = (float) (parsedMap.get(Command.CMD_CHECK_USB_SUPPLY)[0]
											+ vUsbOffset);
									supplyVoltageRatio = actualSupplyVoltage / DPScope.NOMINAL_SUPPLY;
									scaleFactorY = (float) (supplyVoltageRatio * 25 / 12 / 2.55);
									System.out.println("USB supply voltage: " + actualSupplyVoltage + " Volts");
									System.out.println("supplyVoltageRatio: " + supplyVoltageRatio);
									System.out.println("scaleFactorY: " + scaleFactorY);
								} else if (parsedMap.containsKey(Command.CMD_READBACK)) {
									readBackDone = true;
								} else if (parsedMap.containsKey(Command.CMD_DONE)) {
									isDone = true;
								} else if (parsedMap.containsKey(Command.CMD_ARM)) {
									isArmed = true;
								} else if (parsedMap.containsKey(Command.EVT_DEVICE_REMOVED)) {
									disconnectScope();
								}
								parsedMap.clear();
							}
						});
						btnConnect.setStyle("-fx-background-color: #99ffcc;");
						myScope.checkUsbSupply();
					} else {
						System.out.println("SampleController - No device present");
						myScope = null;
					}
				} else {
					btnConnect.setText("Connect".toUpperCase());
					disconnectScope();
					btnConnect.setStyle("-fx-background-color: #f64863;");
				}
			}
		});

		bpaneRoot.setTop(btnConnect);
		bpaneRoot.setCenter(spltPane);

		primaryStage.setScene(new Scene(bpaneRoot));
	}

	@Override
	public void start(Stage stage) {
		stage.setTitle("DPScope");
		stage.setMinWidth(700);
		stage.setMinHeight(400);
		stage.setWidth(800);
		stage.setHeight(500);
		init(stage);
		stage.show();

		executor = Executors.newCachedThreadPool(new ThreadFactory() {
			@Override
			public Thread newThread(Runnable r) {
				Thread thread = new Thread(r);
				// ensures thread is shutdown when application exits
				thread.setDaemon(true);
				return thread;
			}
		});

		// AddRandomDataToQueue addRandomDataToQueue = new AddRandomDataToQueue();
		// executor.execute(addRandomDataToQueue);

		AddTestDataToQueue addTestDataToQueue = new AddTestDataToQueue();
		executor.execute(addTestDataToQueue);

		// AddScopeDataToQueue addScopeDataToQueue = new AddScopeDataToQueue();
		// executor.execute(addScopeDataToQueue);

		// -- Prepare Timeline
		prepareTimeline();
	}

	private class AddScopeDataToQueue implements Runnable {
		public void run() {
			try {
				if (nextScopeData) {
					nextScopeData = false;
					myScope.armScope(DPScope.CH1_1, DPScope.CH2_1);

					// must query scope if its ready for readback
					while (!isArmed) {
						// TODO: Should be able to remove/reduce this timeout - test
						// Thread.sleep(10);
						Thread.sleep(0);
						// gives enough time to re-check and for readBack
						// System.out.println("TestApp - not armed - wait...");
					}
					isArmed = false;
					// System.out.println("TestApp - Scope Armed");
					myScope.queryIfDone();
					while (!isDone) {
						// TODO: Should be able to remove/reduce this timeout - test
						// Thread.sleep(5);
						Thread.sleep(0);
						// gives enough time to re-check and for readBack
					}
					isDone = false;

					// System.out.println("TestApp - Ready for read!");

					for (int i = 0; i < DPScope.ALL_BLOCKS; i++) {
						myScope.readBack(i);
					}
				}

				executor.execute(this);
			} catch (InterruptedException ex) {
				ex.printStackTrace();
			}
		}
	}

	private class AddRandomDataToQueue implements Runnable {
		public void run() {
			try {
				// add a item of random data to queue
				dataQ1.add(Math.random());
				// dataQ1.add(timeElapsed);

				Thread.sleep(10);
				executor.execute(this);
			} catch (InterruptedException ex) {
				ex.printStackTrace();
			}
		}
	}

	private class AddTestDataToQueue implements Runnable {
		public void run() {
			try {
				Thread.sleep(10);
				nextTestData = true;
				executor.execute(this);
			} catch (InterruptedException ex) {
				ex.printStackTrace();
			}
		}
	}

	private void addScopeDataToSeries() {
		if (scopeRead && readBackDone) {
			readBackDone = false;
			series1.getData().clear();

			int j = 0;
			for (int i = 1; i < DPScope.MAX_READABLE_SIZE; i += 2) {
				series1.getData().add(new XYChart.Data<>(j++, myScope.scopeBuffer[i]));
			}
			nextScopeData = true;
		}
	}

	private void addTestDataToSeries() {
		if (scopeRead && nextTestData) {
			series1.getData().clear();
			nextTestData = false;
			for (int i = 0; i < DPScope.MAX_READABLE_SIZE; i++) {
				series1.getData().add(new XYChart.Data<>(i, Math.random()));
			}
			nextTestData = true;
		}
	}

	private void addRandomDataToSeries() {
		if (scopeRead) {
			for (int i = 0; i < 20; i++) { // -- add 20 numbers to the plot+
				if (dataQ1.isEmpty())
					break;
				series1.getData().add(new XYChart.Data<>(xSeriesData++, dataQ1.remove()));
			}
			// remove points to keep us at no more than MAX_DATA_POINTS
			if (series1.getData().size() > MAX_DATA_POINTS) {
				series1.getData().remove(0, series1.getData().size() - MAX_DATA_POINTS);
			}
			// update
			xAxis.setLowerBound(xSeriesData - MAX_DATA_POINTS);
			xAxis.setUpperBound(xSeriesData - 1);
		}
	}

	// -- Timeline gets called in the JavaFX Main thread
	private void prepareTimeline() {
		// Every frame to take any data from queue and add to chart
		new AnimationTimer() {
			@Override
			public void handle(long now) {
				// timeCapture = System.nanoTime();

				// addRandomDataToSeries();
				addTestDataToSeries();
				// addScopeDataToSeries();

				// timeElapsed = (long) (1.0e6/(System.nanoTime() -
				// timeCapture));
			}
		}.start();
	}

	private TabPane tabPaneControls() {

		/*
		 * TIME control panel
		 */
		Pane paneTimeControls = new Pane();

		Tab tabTime = new Tab("Time");
		tabTime.setClosable(false);
		tabTime.setContent(paneTimeControls);

		final Button btnStart = new Button("Start".toUpperCase());
		final Button btnClear = new Button("Clear".toUpperCase());
		btnStart.setMinWidth(50);
		btnClear.setMinWidth(Control.USE_PREF_SIZE);

		btnStart.setOnAction(new EventHandler<ActionEvent>() {
			@Override
			public void handle(ActionEvent e) {
				if (btnStart.getText().equals("Start".toUpperCase())) {
					btnStart.setText("Stop".toUpperCase());
					scopeRead = true;
					if (myScope != null) {
						nextScopeData = true;
					}
				} else {
					btnStart.setText("Start".toUpperCase());
					scopeRead = false;
					nextScopeData = true;
				}
			}
		});

		btnClear.setOnAction(new EventHandler<ActionEvent>() {
			@Override
			public void handle(ActionEvent e) {
				if (!series1.getData().isEmpty()) {
					series1.getData().clear();
				}
				if (!dataQ1.isEmpty()) {
					dataQ1.clear();
				}
			}
		});

		// Division scaling controls
		ObservableList<String> listDivisionsText = FXCollections.observableArrayList(//
				DPScope.DIV_TWO_V, DPScope.DIV_ONE_V, DPScope.DIV_FIVE_HUNDRED_MV, DPScope.DIV_TWENTY_MV,
				DPScope.DIV_TEN_MV, DPScope.DIV_FIVE_MV);

		SpinnerValueFactory<String> valueFactoryVoltageDiv = //
				new SpinnerValueFactory.ListSpinnerValueFactory<String>(listDivisionsText);
		valueFactoryVoltageDiv.setValue("2 V/div");

		final Spinner<String> spinVoltageScale = new Spinner<String>();
		spinVoltageScale.setValueFactory(valueFactoryVoltageDiv);

		spinVoltageScale.valueProperty().addListener((obs, oldValue, newValue) -> {
			// System.out.println("New value: " + newValue);
			switch (newValue) {
			case DPScope.DIV_TWO_V:
				yAxis.setUpperBound(20);
				yAxis.setLowerBound(-20);
				yAxis.setTickUnit(4);
				break;
			case DPScope.DIV_ONE_V:
				yAxis.setUpperBound(10);
				yAxis.setLowerBound(-10);
				yAxis.setTickUnit(2);
				break;
			case DPScope.DIV_FIVE_HUNDRED_MV:
				yAxis.setUpperBound(5);
				yAxis.setLowerBound(-5);
				yAxis.setTickUnit(1);
				break;
			default:
				break;
			}
		});

		BorderPane brdrVoltageControls = new BorderPane();
		brdrVoltageControls.setCenter(spinVoltageScale);
		brdrVoltageControls.setStyle("-fx-border-color: red");

		FlowPane flowPaneControls = new FlowPane();
		flowPaneControls.setHgap(10);
		flowPaneControls.setVgap(20);
		flowPaneControls.setPadding(new Insets(15, 15, 15, 15));
		flowPaneControls.setPrefWidth(200);
		flowPaneControls.setMaxWidth(200);

		flowPaneControls.getChildren().addAll(btnStart, btnClear, spinVoltageScale);
		paneTimeControls.getChildren().add(flowPaneControls);

		/*
		 * FFT control panel
		 */
		Pane paneFFTControls = new Pane();

		Tab tabFFT = new Tab("FFT");
		tabFFT.setClosable(false);
		tabFFT.setContent(paneFFTControls);

		final MenuButton menuFiltering = new MenuButton();
		menuFiltering.setText("Filter type");

		menuFiltering.getItems().add(new MenuItem("None"));
		menuFiltering.getItems().add(new MenuItem("Hamming"));
		menuFiltering.getItems().add(new MenuItem("Hanning"));

		BorderPane bpaneFFT = new BorderPane();
		bpaneFFT.setPadding(new Insets(15, 15, 15, 15));
		bpaneFFT.setTop(menuFiltering);
		bpaneFFT.prefWidthProperty().bind(paneFFTControls.widthProperty());
		bpaneFFT.prefHeightProperty().bind(paneFFTControls.heightProperty());

		paneFFTControls.getChildren().add(bpaneFFT);

		/*
		 * Options control panel
		 */
		Pane paneOptions = new Pane();

		Tab tabOptions = new Tab("Options");
		tabOptions.setClosable(false);
		tabOptions.setContent(paneOptions);

		final CheckBox chkAnimation = new CheckBox("Animation");
		chkAnimation.setText("Animation");
		chkAnimation.setAlignment(Pos.CENTER);
		chkAnimation.setPadding(new Insets(15, 15, 15, 15));

		paneOptions.getChildren().add(chkAnimation);
		// paneTimeControls.setStyle("-fx-background-color: #f64863;");
		// http://www.color-hex.com/color-palettes/

		final TabPane tbpControls = new TabPane();
		tbpControls.getTabs().addAll(tabTime, tabFFT, tabOptions);
		tbpControls.setMinWidth(Control.USE_PREF_SIZE);

		return tbpControls;

	}

	private boolean disconnectScope() {
		if (myScope != null) {
			myScope.disconnect();
			myScope.deleteObservers();
			myScope = null;
			scopeRead = false;
			nextScopeData = false;
			return true;
		}
		return false;
	}

	@Override
	public void stop() {
		// System.out.println("App is closing");
		if (disconnectScope()) {
			System.out.println("Disconnecting scope...");
		}
	}

	public static void main(String[] args) {
		launch(args);
	}
}