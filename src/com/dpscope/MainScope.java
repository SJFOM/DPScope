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
import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.geometry.Orientation;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.Control;
import javafx.scene.control.RadioButton;
import javafx.scene.control.Separator;
import javafx.scene.control.Spinner;
import javafx.scene.control.SpinnerValueFactory;
import javafx.scene.control.SplitPane;
import javafx.scene.control.Tab;
import javafx.scene.control.TabPane;
import javafx.scene.control.ToggleGroup;
import javafx.scene.control.ToolBar;
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
	private volatile static boolean nextScopeData = false;
	
	// Offsets which select which buffer bytes to read
	private static final int CHANNEL_1_SELECT = 0;
	private static final int CHANNEL_2_SELECT = 1;
	private static int chanSelect = CHANNEL_1_SELECT;

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

	private static AnimationTimer myAnimationTimer;

	private NumberAxis xAxis;
	private NumberAxis yAxis;

	/*
	 * Main body of code
	 */

	private void init(Stage primaryStage) {

		// 211 / 10.55 = 20 divisions
		xAxis = new NumberAxis(0, DPScope.MAX_DATA_PER_CHANNEL, 10.55);
		xAxis.setForceZeroInRange(false);
		xAxis.setAutoRanging(false);
		xAxis.setTickLabelsVisible(false);
		xAxis.setTickMarkVisible(false);
		xAxis.setMinorTickVisible(false);

		yAxis = new NumberAxis(-25, 25, 5);
		// yAxis.setAutoRanging(true);

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
		lineChart.setPrefWidth(700);
		// lineChart.setOpacity(0.8);

		// Set Name for Series
		series1.setName("Series 1");

		// Add Chart Series
		lineChart.getData().add(series1);

		SplitPane spltPane = new SplitPane();
		spltPane.setDividerPosition(0, 0.18);
		// spltPane.setMinWidth(Control.USE_PREF_SIZE);

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
		stage.setMinWidth(900);
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

		// AddRandomDataToQueue addRandomDataToQueue = new
		// AddRandomDataToQueue();
		// executor.execute(addRandomDataToQueue);

		// AddTestDataToQueue addTestDataToQueue = new AddTestDataToQueue();
		// executor.execute(addTestDataToQueue);

//		AddScopeDataToQueue addScopeDataToQueue = new AddScopeDataToQueue();
//		executor.execute(addScopeDataToQueue);

		// -- Prepare Timeline
//		prepareTimeline();
	}

	private class AddScopeDataToQueue implements Runnable {
		public void run() {
			try {
				if (nextScopeData) {
					nextScopeData = false;
					myScope.armScope(DPScope.CH1_1, DPScope.CH2_1);

					// must query scope if its ready for readback
					while (!isArmed) {
						// TODO: Should be able to remove/reduce this timeout -
						// test
						// Thread.sleep(10);
						Thread.sleep(0);
						// gives enough time to re-check and for readBack
						// System.out.println("TestApp - not armed - wait...");
					}
					isArmed = false;
					// System.out.println("TestApp - Scope Armed");
					myScope.queryIfDone();
					while (!isDone) {
						// TODO: Should be able to remove/reduce this timeout -
						// test
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

	/**
	 * Function for adding DPScope data to plot
	 */
	private void addScopeDataToSeries() {
		if (readBackDone) {
			readBackDone = false;
			series1.getData().clear();

			int j = 0;
			for (int i = chanSelect; i < DPScope.MAX_READABLE_SIZE; i += 2) {
				series1.getData().add(new XYChart.Data<>(j++, myScope.scopeBuffer[i]*scaleFactorY));
			}
			nextScopeData = true;
		}
	}

	/**
	 * Function for adding random data to plot
	 */
	private void addTestDataToSeries() {
		if (nextTestData) {
			series1.getData().clear();
			nextTestData = false;
			for (int i = 0; i < DPScope.MAX_READABLE_SIZE; i++) {
				series1.getData().add(new XYChart.Data<>(i, Math.random() - 0.5));
			}
			nextTestData = true;
		}
	}

	// -- Timeline gets called in the JavaFX Main thread
	private void prepareTimeline(int dataSeries) {
		// Every frame to take any data from queue and add to chart
		if (dataSeries == 0) {
			myAnimationTimer = new AnimationTimer() {
				@Override
				public void handle(long now) {
					// timeCapture = System.nanoTime();
					 addTestDataToSeries();
					// timeElapsed = (long) (1.0e6/(System.nanoTime() -
					// timeCapture));
				}
			};
		} else if (dataSeries == 1) {
			myAnimationTimer = new AnimationTimer() {
				@Override
				public void handle(long now) {
					// timeCapture = System.nanoTime();
					addScopeDataToSeries();
					// timeElapsed = (long) (1.0e6/(System.nanoTime() -
					// timeCapture));
				}
			};
		}
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
		btnStart.setMinWidth(70);
		btnClear.setMinWidth(70);
		// btnClear.setMinWidth(Control.USE_PREF_SIZE);

		btnStart.setOnAction(new EventHandler<ActionEvent>() {
			@Override
			public void handle(ActionEvent e) {
				if (btnStart.getText().equals("Start".toUpperCase())) {
					btnStart.setText("Stop".toUpperCase());
					if (myScope != null) {
						nextScopeData = true;
						AddScopeDataToQueue addScopeDataToQueue = new AddScopeDataToQueue();
						executor.execute(addScopeDataToQueue);
						prepareTimeline(1);
					} else {
						// Just add test data to scope instead
						 AddTestDataToQueue addTestDataToQueue = new AddTestDataToQueue();
						 executor.execute(addTestDataToQueue);
						 prepareTimeline(0);
					}
					btnClear.setDisable(true);
					myAnimationTimer.start();
				} else {
					btnStart.setText("Start".toUpperCase());
					nextScopeData = false;
					btnClear.setDisable(false);
					myAnimationTimer.stop();
					myAnimationTimer = null;
				}
			}
		});

		// Experimenting with lambda expressions
		btnClear.setOnAction((event) -> {
			if (!series1.getData().isEmpty()) {
				series1.getData().clear();
			}
			if (!dataQ1.isEmpty()) {
				dataQ1.clear();
			}
		});

		// Voltage division scaling controls
//		ObservableList<String> listVoltageDivisionsText = FXCollections.observableArrayList(//
//				DPScope.DIV_50_MV, DPScope.DIV_100_MV, DPScope.DIV_200_MV, //
//				DPScope.DIV_500_MV, DPScope.DIV_1_V, DPScope.DIV_2_V);
		
		ObservableList<String> listVoltageDivisionsText = FXCollections.observableArrayList(DPScope.mapVoltageDivs.keySet());	
		
		SpinnerValueFactory<String> valueFactoryVoltageDiv = //
				new SpinnerValueFactory.ListSpinnerValueFactory<String>(listVoltageDivisionsText);
		valueFactoryVoltageDiv.setValue(DPScope.DIV_2_V);

		final Spinner<String> spinVoltageScale = new Spinner<String>();
		spinVoltageScale.setValueFactory(valueFactoryVoltageDiv);
		spinVoltageScale.getStyleClass().add(Spinner.STYLE_CLASS_SPLIT_ARROWS_VERTICAL);
		spinVoltageScale.setPrefWidth(150);

		
		spinVoltageScale.valueProperty().addListener((obs, oldValue, newValue) -> {
			double divScaler = (double) DPScope.mapVoltageDivs.get(newValue);
			yAxis.setUpperBound(5 * divScaler);
			yAxis.setLowerBound(-5 * divScaler);
			yAxis.setTickUnit(divScaler);
		});

		// Time division scaling controls
		ObservableList<String> listTimeDivisionsText = FXCollections.observableArrayList(DPScope.mapTimeDivs.keySet());

		SpinnerValueFactory<String> valueFactoryTimeDiv = //
				new SpinnerValueFactory.ListSpinnerValueFactory<String>(listTimeDivisionsText);
		valueFactoryTimeDiv.setValue(DPScope.DIV_1_S);

		final Spinner<String> spinTimeScale = new Spinner<String>();
		spinTimeScale.setValueFactory(valueFactoryTimeDiv);
		spinTimeScale.getStyleClass().add(Spinner.STYLE_CLASS_SPLIT_ARROWS_HORIZONTAL);
		spinTimeScale.setPrefWidth(150);

		spinTimeScale.valueProperty().addListener((obs, oldValue, newValue) -> {
			double divScaler = DPScope.mapTimeDivs.get(newValue);
//			xAxis.setUpperBound(5 * divScaler);
//			xAxis.setLowerBound(-5 * divScaler);
//			xAxis.setTickUnit(divScaler);
		});

		BorderPane brdrScopeControls = new BorderPane();
		brdrScopeControls.setTop(spinVoltageScale);
		brdrScopeControls.setCenter(spinTimeScale);
		brdrScopeControls.setStyle("-fx-border-color: red");

		FlowPane flowPaneControls = new FlowPane();
		flowPaneControls.setHgap(10);
		flowPaneControls.setVgap(20);
		flowPaneControls.setPadding(new Insets(15, 15, 15, 15));
		flowPaneControls.setPrefWidth(200);
		flowPaneControls.setMaxWidth(200);
		
		ToolBar toolbarChannelSelect = new ToolBar();
		toolbarChannelSelect.setOrientation(Orientation.HORIZONTAL);
		
		RadioButton rdoChan_1 = new RadioButton("Ch1");
		rdoChan_1.setOnAction((event) -> {
			chanSelect = CHANNEL_1_SELECT;
		});
		
		RadioButton rdoChan_2 = new RadioButton("Ch2");
		rdoChan_2.setOnAction((event) -> {
			chanSelect = CHANNEL_2_SELECT;
		});

		ToggleGroup groupChanSelect = new ToggleGroup();
		groupChanSelect.getToggles().addAll(rdoChan_1, rdoChan_2);
		groupChanSelect.selectToggle(rdoChan_1);
		
        toolbarChannelSelect.getItems().addAll(
                new Separator(),
                rdoChan_1,
                new Separator(),
                rdoChan_2,
                new Separator()
            );

		flowPaneControls.getChildren().addAll(btnStart, btnClear, spinVoltageScale, spinTimeScale, toolbarChannelSelect);
		paneTimeControls.getChildren().add(flowPaneControls);

		/*
		 * FFT control panel
		 */
		Pane paneFFTControls = new Pane();

		Tab tabFFT = new Tab("FFT");
		tabFFT.setClosable(false);
		tabFFT.setContent(paneFFTControls);

		// final MenuButton menuFiltering = new MenuButton();
		final ChoiceBox<Object> choiceFiltering = new ChoiceBox<Object>();
		choiceFiltering.setMinWidth(100);
		choiceFiltering.getItems()
				.addAll("None", new Separator(), "Hamming", "Hanning", "Blackman");
		choiceFiltering.getSelectionModel().selectFirst();
		
		choiceFiltering.valueProperty().addListener((obs, oldValue, newValue) -> {
			System.out.println(newValue);
		});

		BorderPane bpaneFFT = new BorderPane();
		bpaneFFT.setPadding(new Insets(15, 15, 15, 15));
		bpaneFFT.setTop(choiceFiltering);
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