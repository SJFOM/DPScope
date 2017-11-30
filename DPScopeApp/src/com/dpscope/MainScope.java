package com.dpscope;

import java.util.LinkedHashMap;
import java.util.Observable;
import java.util.Observer;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;

import com.dpscope.DPScope.Command;

import javafx.animation.AnimationTimer;
import javafx.application.Application;
import javafx.event.ActionEvent;
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
import javafx.scene.control.Menu;
import javafx.scene.control.MenuBar;
import javafx.scene.control.MenuButton;
import javafx.scene.control.MenuItem;
import javafx.scene.control.SplitPane;
import javafx.scene.control.Tab;
import javafx.scene.control.TabPane;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;

public class MainScope extends Application {

	// Scope controls
	private static DPScope myScope;
	private static RunScanScopeMode scopeMode;
	private static LinkedHashMap<Command, float[]> parsedMap;
	protected volatile static boolean taskReadScope = false;
	protected volatile static boolean readBackDone = false;
	private static float[] lastData = new float[1];
	private static boolean isDone = false;
	private static boolean isArmed = false;
	private static boolean scopeRead = false;

	// JavaFX layout controls
	private static final int MAX_DATA_POINTS = 500;
	private int xSeriesData = 0;
	private XYChart.Series<Number, Number> series1 = new XYChart.Series<>();
	private ExecutorService executor;
	private ConcurrentLinkedQueue<Number> dataQ1 = new ConcurrentLinkedQueue<>();

	private NumberAxis xAxis;

	private void init(Stage primaryStage) {

		xAxis = new NumberAxis(0, MAX_DATA_POINTS, MAX_DATA_POINTS / 10);
		xAxis.setForceZeroInRange(false);
		xAxis.setAutoRanging(false);
		xAxis.setTickLabelsVisible(false);
		xAxis.setTickMarkVisible(false);
		xAxis.setMinorTickVisible(false);

		NumberAxis yAxis = new NumberAxis();

		// Create a LineChart
		final LineChart<Number, Number> lineChart = new LineChart<Number, Number>(xAxis, yAxis) {
			// Override to remove symbols on each data point
			@Override
			protected void dataItemAdded(Series<Number, Number> series, int itemIndex, Data<Number, Number> item) {
			}
		};

		lineChart.setAnimated(false);
		lineChart.setLegendVisible(false);
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
		MenuBar menuBarRoot = new MenuBar();
		Menu menuScope = new Menu("Scope");
		MenuItem menuItemConnect = new MenuItem("Connect".toUpperCase());

		menuItemConnect.setOnAction(new EventHandler<ActionEvent>() {
			@Override
			public void handle(ActionEvent e) {

				if (menuItemConnect.getText().equals("Connect".toUpperCase())) {
					myScope = new DPScope();
					if (myScope.isDevicePresent()) {
						menuItemConnect.setText("Disconnect".toUpperCase());
						myScope.connect();
						myScope.addObserver(new Observer() {
							@Override
							public void update(Observable o, Object arg) {
								// TODO Auto-generated method stub
								parsedMap = (LinkedHashMap<Command, float[]>) arg;
								if (parsedMap.containsKey(Command.CMD_READADC)) {
									lastData[0] = parsedMap.get(Command.CMD_READADC)[0];
								} else if (parsedMap.containsKey(Command.CMD_CHECK_USB_SUPPLY)) {
									System.out.println("TestApp - USB supply: "
											+ parsedMap.get(Command.CMD_CHECK_USB_SUPPLY)[0] + " Volts");
								} else if (parsedMap.containsKey(Command.CMD_READBACK)) {
									readBackDone = true;
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
				} else {
					menuItemConnect.setText("Connect".toUpperCase());
					if (myScope != null) {
						myScope.disconnect();
						myScope.deleteObservers();
						myScope = null;
					}
				}
			}
		});

		menuScope.getItems().add(menuItemConnect);

		menuBarRoot.getMenus().add(menuScope);

		bpaneRoot.setTop(menuBarRoot);
		bpaneRoot.setCenter(spltPane);

		primaryStage.setScene(new Scene(bpaneRoot));
	}

	@Override
	public void start(Stage stage) {
		stage.setTitle("DPScope");
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

		scopeMode = new RunScanScopeMode();
		 AddToQueue addToQueue = new AddToQueue();
		 executor.execute(addToQueue);
		// -- Prepare Timeline
		prepareTimeline();
	}

	private class AddToQueue implements Runnable {
		public void run() {
			try {
				// add a item of random data to queue
				dataQ1.add(Math.random());

				Thread.sleep(10);
				executor.execute(this);
			} catch (InterruptedException ex) {
				ex.printStackTrace();
			}
		}
	}

	// -- Timeline gets called in the JavaFX Main thread
	private void prepareTimeline() {
		// Every frame to take any data from queue and add to chart
		new AnimationTimer() {
			@Override
			public void handle(long now) {
				addDataToSeries();
			}
		}.start();
	}

	private void addDataToSeries() {
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

	private class RunScanScopeMode implements Runnable {
		public void run() {
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

				// executor.execute(this);
			} catch (InterruptedException ex) {
				ex.printStackTrace();
			}
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
		btnStart.setMinWidth(50);
		btnClear.setMinWidth(Control.USE_PREF_SIZE);

		btnStart.setOnAction(new EventHandler<ActionEvent>() {
			@Override
			public void handle(ActionEvent e) {
				if (btnStart.getText().equals("Start".toUpperCase())) {
					btnStart.setText("Stop".toUpperCase());
					if (myScope != null) {
						executor.execute(scopeMode);
					}
					scopeRead = true;
				} else {
					btnStart.setText("Start".toUpperCase());
					scopeRead = false;
				}
			}
		});

		btnClear.setOnAction(new EventHandler<ActionEvent>() {
			@Override
			public void handle(ActionEvent e) {
				series1.getData().clear();
				dataQ1.clear();
			}
		});

		HBox hboxTime = new HBox();
		hboxTime.setPadding(new Insets(15, 12, 15, 12));
		hboxTime.setSpacing(80);
		hboxTime.prefWidthProperty().bind(paneTimeControls.widthProperty());

		hboxTime.getChildren().addAll(btnStart, btnClear);

		paneTimeControls.getChildren().add(hboxTime);

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
		chkAnimation.setLayoutX(50);
		chkAnimation.setLayoutY(20);

		paneOptions.getChildren().add(chkAnimation);
		// paneTimeControls.setStyle("-fx-background-color: #f64863;");
		// http://www.color-hex.com/color-palettes/

		final TabPane tbpControls = new TabPane();
		tbpControls.getTabs().addAll(tabTime, tabFFT, tabOptions);
		tbpControls.setMinWidth(Control.USE_PREF_SIZE);

		return tbpControls;

	}

	public static void main(String[] args) {
		launch(args);
	}
}