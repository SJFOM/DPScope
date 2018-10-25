package com.dpscope;

import java.time.Duration;
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
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.Control;
import javafx.scene.control.Label;
import javafx.scene.control.RadioButton;
import javafx.scene.control.Separator;
import javafx.scene.control.Spinner;
import javafx.scene.control.SpinnerValueFactory;
import javafx.scene.control.SplitPane;
import javafx.scene.control.Tab;
import javafx.scene.control.TabPane;
import javafx.scene.control.ToolBar;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.FlowPane;
import javafx.scene.layout.Pane;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;
import javafx.stage.Stage;

@SuppressWarnings("restriction")
public class MainScope extends Application
{

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
	private static final byte CHANNEL_1_SELECT = 0x01;
	private static final byte CHANNEL_2_SELECT = 0x02;
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
	private static boolean hasConnectedOnce = false;

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
	private volatile XYChart.Series<Number, Number> series1 = new XYChart.Series<>();
	private XYChart.Series<Number, Number> series2 = new XYChart.Series<>();
	private ExecutorService executor;
	private ConcurrentLinkedQueue<Number> dataQ1 = new ConcurrentLinkedQueue<>();

	private static AnimationTimer myAnimationTimer;

	private NumberAxis xAxis;
	private NumberAxis yAxis;

	/*
	 * Main body of code
	 */

	private void init(Stage primaryStage)
	{

		// 211 / 10.55 = 20 divisions
		xAxis = new NumberAxis(0, DPScope.MAX_DATA_PER_CHANNEL, 10.55);
		xAxis.setForceZeroInRange(false);
		xAxis.setAutoRanging(false);
		xAxis.setTickLabelsVisible(false);
		xAxis.setTickMarkVisible(false);
		xAxis.setMinorTickVisible(false);

		yAxis = new NumberAxis(-25, 25, 5);
		yAxis.setCache(true); // Very slight performance boost possible here by caching as bitmap
		// yAxis.setAutoRanging(true);

		// Create a LineChart
		final LineChart<Number, Number> lineChart = new LineChart<Number, Number>(xAxis, yAxis)
		{
		};

		lineChart.setAnimated(false);
		lineChart.setLegendVisible(false);
		lineChart.setVerticalGridLinesVisible(true);
		lineChart.setHorizontalGridLinesVisible(true);
		// lineChart.setTitle("Animated Line Chart");
		lineChart.setHorizontalGridLinesVisible(true);
		lineChart.setPrefWidth(700);
		// Remove symbols on each data point
		lineChart.setCreateSymbols(false);
		lineChart.setOpacity(0.8);
		lineChart.getStyleClass().add("thick-chart");

		// Set Name for Series
		series1.setName("Channel 1");
		series2.setName("Channel 2");

		// Add Chart Series
		lineChart.getData().add(series1);
		lineChart.getData().add(series2);

		// Change the colour of series2
		Node line = series2.getNode().lookup(".chart-series-line");

		Color color = Color.CYAN; // or any other color

		String rgb = String.format("%d, %d, %d", (int) (color.getRed() * 255), (int) (color.getGreen() * 255),
				(int) (color.getBlue() * 255));

		line.setStyle("-fx-stroke: rgba(" + rgb + ", 1.0);");

		SplitPane spltPane = new SplitPane();
		spltPane.setDividerPosition(0, 0.18);
		// spltPane.setMinWidth(Control.USE_PREF_SIZE);

		spltPane.getItems().addAll(tabPaneControls(), lineChart);

		BorderPane bpaneRoot = new BorderPane();

		JFXButton btnConnect = new JFXButton("Connect".toUpperCase());
		Label lblNotfication = new Label("");

		btnConnect.setStyle("-fx-background-color: #f64863;");

		btnConnect.setOnAction(new EventHandler<ActionEvent>()
		{
			@Override
			public void handle(ActionEvent e)
			{

				if (btnConnect.getText().equals("Connect".toUpperCase()))
				{
					myScope = new DPScope();
					if (myScope.isDevicePresent())
					{
						lblNotfication.setText("");
						btnConnect.setText("Disconnect".toUpperCase());
						myScope.connect();
						myScope.addObserver(new Observer()
						{
							@Override
							public void update(Observable o, Object arg)
							{
								// TODO Auto-generated method stub
								parsedMap = (LinkedHashMap<Command, float[]>) arg;
								if (parsedMap.containsKey(Command.CMD_READADC))
								{
									lastData[0] = parsedMap.get(Command.CMD_READADC)[0];
								}
								else if (parsedMap.containsKey(Command.CMD_CHECK_USB_SUPPLY))
								{
									actualSupplyVoltage = (float) (parsedMap.get(Command.CMD_CHECK_USB_SUPPLY)[0] + vUsbOffset);
									supplyVoltageRatio = actualSupplyVoltage / DPScope.NOMINAL_SUPPLY;

									/*
									 * full ADC range is 255 steps (8 bit) and covers 5V; we are using only slightly
									 * less than half range for display, i.e. 12 units out of possible 25 --> factor
									 * 25/12 full range is 255 and we have want to scale values 0...100 for full
									 * screen height --> 100/255 = 1/2.55 scope is trimmed so 0V results in ADC
									 * value 128 (mid scale), which on screen should be scaled at 50
									 */
//									scaleFactorY = (float) (supplyVoltageRatio * 25 / 12 / 2.55);
									scaleFactorY = (float) (supplyVoltageRatio / 2 / 2.55);
									System.out.println("USB supply voltage: " + actualSupplyVoltage + " Volts");
									System.out.println("supplyVoltageRatio: " + supplyVoltageRatio);
									System.out.println("scaleFactorY: " + scaleFactorY);
								}
								else if (parsedMap.containsKey(Command.CMD_READBACK))
								{
									readBackDone = true;
								}
								else if (parsedMap.containsKey(Command.CMD_DONE))
								{
									isDone = true;
								}
								else if (parsedMap.containsKey(Command.CMD_ARM))
								{
									isArmed = true;
								}
								else if (parsedMap.containsKey(Command.EVT_DEVICE_REMOVED))
								{
									disconnectScope();
								}
								parsedMap.clear();
							}
						});
						btnConnect.setStyle("-fx-background-color: #99ffcc;");
						myScope.checkUsbSupply();

					}
					else
					{
						System.out.println("SampleController - No device present");
						lblNotfication.setText("No scope present");
						myScope = null;
					}
				}
				else
				{
					btnConnect.setText("Connect".toUpperCase());
					disconnectScope();
					btnConnect.setStyle("-fx-background-color: #f64863;");
				}
			}
		});

		FlowPane flowStatusBar = new FlowPane();
		flowStatusBar.setHgap(20);
		flowStatusBar.setVgap(20);
		flowStatusBar.getChildren().addAll(btnConnect, lblNotfication);
		bpaneRoot.setTop(flowStatusBar);
		bpaneRoot.setCenter(spltPane);

		primaryStage.setScene(new Scene(bpaneRoot));

	}

	@Override
	public void start(Stage stage)
	{
		stage.setTitle("DPScope");
		stage.setMinWidth(900);
		stage.setMinHeight(400);
		stage.setWidth(800);
		stage.setHeight(500);
		init(stage);
		stage.getScene().getStylesheets().add("com/dpscope/stylesheet.css");
		stage.show();

		executor = Executors.newCachedThreadPool(new ThreadFactory()
		{
			@Override
			public Thread newThread(Runnable r)
			{
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

		// AddScopeDataToQueue addScopeDataToQueue = new AddScopeDataToQueue();
		// executor.execute(addScopeDataToQueue);

		// -- Prepare Timeline
		// prepareTimeline();
	}

	private class AddScopeDataToQueue implements Runnable
	{
		public void run()
		{
			try
			{
				if (nextScopeData)
				{
					nextScopeData = false;
					myScope.armScope();

					// must query scope if its ready for readback
					while (!isArmed)
					{
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
					while (!isDone)
					{
						// TODO: Should be able to remove/reduce this timeout -
						// test
						// Thread.sleep(5);
						Thread.sleep(0);
						// gives enough time to re-check and for readBack
					}
					isDone = false;

					// System.out.println("TestApp - Ready for read!");

					for (int i = 0; i < DPScope.ALL_BLOCKS; i++)
					{
						myScope.readBack(i);
					}
				}

				executor.execute(this);
			}
			catch (InterruptedException ex)
			{
				ex.printStackTrace();
			}
		}
	}

	private class AddRandomDataToQueue implements Runnable
	{
		public void run()
		{
			try
			{
				// add a item of random data to queue
				dataQ1.add(Math.random());
				// dataQ1.add(timeElapsed);

				Thread.sleep(10);
				executor.execute(this);
			}
			catch (InterruptedException ex)
			{
				ex.printStackTrace();
			}
		}
	}

	private class AddTestDataToQueue implements Runnable
	{
		public void run()
		{
			try
			{
				Thread.sleep(10);
				nextTestData = true;
				executor.execute(this);
			}
			catch (InterruptedException ex)
			{
				ex.printStackTrace();
			}
		}
	}

	/**
	 * Function for adding DPScope data to plot
	 */
//	static int timeCount = 0;
//	long timeKeep[] = new long[20];

	private synchronized void addScopeDataToSeries()
	{
		if (readBackDone)
		{
			readBackDone = false;
			series1.getData().clear();
			series2.getData().clear();
			double tmpScaleFactor = scaleFactorY;
			
			if(yAxis.getTickUnit() < 1.0)
			{
				tmpScaleFactor *= 2 * yAxis.getTickUnit();
			} 
			else 
			{
				tmpScaleFactor /= (double) (5.0 / yAxis.getTickUnit());
			}

//			long startTime = System.nanoTime();

			int j = 0;
			if ((chanSelect & CHANNEL_1_SELECT) > 0)
			{
				for (int i = 0; i < DPScope.MAX_READABLE_SIZE; i += 2)
				{
					series1.getData().add(new XYChart.Data<>(j++, myScope.scopeBuffer[i] * tmpScaleFactor));
				}
			}

//			long stopTime = System.nanoTime();
//			timeKeep[timeCount++] = (long) (stopTime - startTime);
//			if (timeCount == 20)
//			{
//				long sum = 0;
//				for (long d : timeKeep)
//					sum += d;
//				long meanTime = (long) (sum / timeCount);
//				System.out.println("Series1 avg fill time: " + meanTime / 1.0e6 + " ms");
//				timeCount = 0;
//			}
//			System.out.println("Filled series1 in: " + (stopTime - startTime)/1e6 + " ms");

			if ((chanSelect & CHANNEL_2_SELECT) > 0)
			{
				j = 0;
				for (int i = 1; i < DPScope.MAX_READABLE_SIZE; i += 2)
				{
					series2.getData().add(new XYChart.Data<>(j++, myScope.scopeBuffer[i] * tmpScaleFactor));
				}
			}
			nextScopeData = true;
		}
	}

	/**
	 * Function for adding random data to plot
	 */
	private void addTestDataToSeries()
	{
		if (nextTestData)
		{
			nextTestData = false;
			series1.getData().clear();
			series2.getData().clear();

			if ((chanSelect & CHANNEL_1_SELECT) > 0)
			{
				for (int i = 0; i < DPScope.MAX_READABLE_SIZE; i++)
				{
					series1.getData().add(new XYChart.Data<>(i, Math.random() - 0.5));
				}
			}

			if ((chanSelect & CHANNEL_2_SELECT) > 0)
			{
				for (int i = 1; i < DPScope.MAX_READABLE_SIZE; i++)
				{
					series2.getData().add(new XYChart.Data<>(i, Math.random() - 0.5));
				}
			}
			nextTestData = true;
		}
	}

	// -- Timeline gets called in the JavaFX Main thread
	private void prepareTimeline(int dataSeries)
	{
		// Every frame to take any data from queue and add to chart
		if (dataSeries == 0)
		{
			myAnimationTimer = new AnimationTimer()
			{
				@Override
				public void handle(long now)
				{
					// timeCapture = System.nanoTime();
					addTestDataToSeries();
					// timeElapsed = (long) (1.0e6/(System.nanoTime() -
					// timeCapture));
				}
			};
		}
		else if (dataSeries == 1)
		{
			myAnimationTimer = new AnimationTimer()
			{
				@Override
				public void handle(long now)
				{
					// timeCapture = System.nanoTime();
					addScopeDataToSeries();
					// timeElapsed = (long) (1.0e6/(System.nanoTime() -
					// timeCapture));
				}
			};
		}
	}

	private TabPane tabPaneControls()
	{

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

		btnStart.setOnAction(new EventHandler<ActionEvent>()
		{
			@Override
			public void handle(ActionEvent e)
			{
				if (btnStart.getText().equals("Start".toUpperCase()))
				{
					btnStart.setText("Stop".toUpperCase());
					if (myScope != null)
					{
						nextScopeData = true;
						AddScopeDataToQueue addScopeDataToQueue = new AddScopeDataToQueue();
						executor.execute(addScopeDataToQueue);
						prepareTimeline(1);
						if (hasConnectedOnce == false)
						{
							/*
							 * Set default samplingMode and timeAxisScale values
							 */
							myScope.samplingMode = DPScope.SAMPLE_MODE_RT;
							myScope.timeAxisScale = 0.0005d;
							scopeSetupTimebase(DPScope.DIV_500_US);
							hasConnectedOnce = true;
						}
					}
					else
					{
						// Just add test data to scope instead
						AddTestDataToQueue addTestDataToQueue = new AddTestDataToQueue();
						executor.execute(addTestDataToQueue);
						prepareTimeline(0);
					}
					btnClear.setDisable(true);
					myAnimationTimer.start();
				}
				else
				{
					btnStart.setText("Start".toUpperCase());
					nextScopeData = false;
					btnClear.setDisable(false);
					myAnimationTimer.stop();
					myAnimationTimer = null;
				}
			}
		});

		// Experimenting with lambda expressions
		btnClear.setOnAction((event) ->
		{
			if (!series1.getData().isEmpty())
			{
				series1.getData().clear();
			}
			if (!series2.getData().isEmpty())
			{
				series2.getData().clear();
			}
			if (!dataQ1.isEmpty())
			{
				dataQ1.clear();
			}
		});

		ObservableList<String> listVoltageDivisionsText = FXCollections.observableArrayList(DPScope.mapVoltageDivs.keySet());

		SpinnerValueFactory<String> valueFactoryVoltageDiv = //
				new SpinnerValueFactory.ListSpinnerValueFactory<String>(listVoltageDivisionsText);
		valueFactoryVoltageDiv.setValue(DPScope.DIV_2_V);

		final Spinner<String> spinVoltageScale = new Spinner<String>();
		spinVoltageScale.setValueFactory(valueFactoryVoltageDiv);
		spinVoltageScale.getStyleClass().add(Spinner.STYLE_CLASS_SPLIT_ARROWS_VERTICAL);
		spinVoltageScale.setPrefWidth(150);

		spinVoltageScale.valueProperty().addListener((obs, oldValue, newValue) ->
		{
			double divScaler = (double) DPScope.mapVoltageDivs.get(newValue);
			yAxis.setUpperBound(5.0 * divScaler);
			yAxis.setLowerBound(-5.0 * divScaler);
			yAxis.setTickUnit(divScaler);

			if (myScope != null)
			{
				switch (newValue)
				{
				case DPScope.DIV_2_V:
					myScope.sample_shift_ch1 = (byte) 2;
					myScope.sample_subtract_ch1 = (byte) 0;
					myScope.sample_shift_ch2 = (byte) 2;
					myScope.sample_subtract_ch2 = (byte) 0;
					myScope.comp_input_chan = (byte) 1;
					myScope.triggerLevel = (byte) 255;
					break;
				case DPScope.DIV_1_V:
					myScope.sample_shift_ch1 = (byte) 1;
					myScope.sample_subtract_ch1 = (byte) 128;
					myScope.sample_shift_ch2 = (byte) 1;
					myScope.sample_subtract_ch2 = (byte) 128;
					myScope.comp_input_chan = (byte) 1;
					myScope.triggerLevel = (byte) 128; // (192 - 64);
					break;
				case DPScope.DIV_500_MV:
					myScope.sample_shift_ch1 = (byte) 0;
					myScope.sample_subtract_ch1 = (byte) 192;
					myScope.sample_shift_ch2 = (byte) 0;
					myScope.sample_subtract_ch2 = (byte) 192;
					myScope.comp_input_chan = (byte) 1;
					myScope.triggerLevel = (byte) 64; // (160 - 96);
					break;
				case DPScope.DIV_200_MV:
					myScope.sample_shift_ch1 = (byte) 2;
					myScope.sample_subtract_ch1 = (byte) 0;
					myScope.sample_shift_ch2 = (byte) 2;
					myScope.sample_subtract_ch2 = (byte) 0;
					myScope.comp_input_chan = (byte) 2;
					myScope.triggerLevel = (byte) 255;
					break;
				case DPScope.DIV_100_MV:
					myScope.sample_shift_ch1 = (byte) 1;
					myScope.sample_subtract_ch1 = (byte) 128;
					myScope.sample_shift_ch2 = (byte) 1;
					myScope.sample_subtract_ch2 = (byte) 128;
					myScope.comp_input_chan = (byte) 2;
					myScope.triggerLevel = (byte) 128; // (192 - 64);
					break;
				case DPScope.DIV_50_MV:
					myScope.sample_shift_ch1 = (byte) 0;
					myScope.sample_subtract_ch1 = (byte) 192;
					myScope.sample_shift_ch2 = (byte) 0;
					myScope.sample_subtract_ch2 = (byte) 192;
					myScope.comp_input_chan = (byte) 2;
					myScope.triggerLevel = (byte) 64; // (160 - 96);
					break;
				default:
					break;
				}
			}
		});

		// Time division scaling controls
		ObservableList<String> listTimeDivisionsText = FXCollections.observableArrayList(DPScope.mapTimeDivs.keySet());

		SpinnerValueFactory<String> valueFactoryTimeDiv = //
				new SpinnerValueFactory.ListSpinnerValueFactory<String>(listTimeDivisionsText);
		valueFactoryTimeDiv.setValue(DPScope.DIV_500_US);

		final Spinner<String> spinTimeScale = new Spinner<String>();
		spinTimeScale.setValueFactory(valueFactoryTimeDiv);
		spinTimeScale.getStyleClass().add(Spinner.STYLE_CLASS_SPLIT_ARROWS_HORIZONTAL);
		spinTimeScale.setPrefWidth(150);

		// Text to complement the selected time scale - as seen in the DPScope Windows
		// application.
		Text txtSamplingRate = new Text(DPScope.mapSamplingRates.get(valueFactoryTimeDiv.getValue()));

		spinTimeScale.valueProperty().addListener((obs, oldValue, newValue) ->
		{
			// double divScaler = DPScope.mapTimeDivs.get(newValue);
			// xAxis.setUpperBound(5 * divScaler);
			// xAxis.setLowerBound(-5 * divScaler);
			// xAxis.setTickUnit(divScaler);
			txtSamplingRate.setText(DPScope.mapSamplingRates.get(newValue));

			if (myScope != null)
			{

				// TODO: Deal with RT/ET switching in the VB code below

				// If ListIndex <= 5 And TimeBaseListIndex_old > 5 Then ' change from real time
				// to equivalent time
				// TriggerAuto_old = TriggerAuto
				// TriggerCH1_old = TriggerCH1 ' remember old setting so we can restore it when
				// going back to real-time sampling
				// TriggerExt_old = TriggerExt ' remember old setting so we can restore it when
				// going back to real-time sampling
				//
				// If TriggerAuto Then TriggerCH1 = True ' enforce triggered mode in equivalent
				// time mode
				// TriggerAuto = False
				// TriggerAuto.Enabled = False
				// End If
				//
				// If ListIndex > 5 And TimeBaseListIndex_old <= 5 Then ' change from equivalent
				// time to real time
				// TriggerAuto.Enabled = True -> This is a GUI input where the options are Auto,
				// CH1 or external
				// TriggerAuto = TriggerAuto_old
				// TriggerCH1 = TriggerCH1_old ' restore setting
				// TriggerExt = TriggerExt_old
				// End If

				// These are all set for ScopeMode (vs Rollmode)
				// TriggerAuto.Enabled = True
				// TriggerCH1.Enabled = True
				// TriggerExt.Enabled = True
				// TriggerRising.Enabled = True
				// TriggerFalling.Enabled = True

				// which are initialized with the following values from MainModule.bas
				// .TriggerAuto_old = True
				// .TriggerCH1_old = False
				// .TriggerExt_old = False

				// OK, this is more just like - if you were in ET mode then swap back to RT mode
				// Doesn't need to do anything if you're already in RT mode (which is the
				// default really..).

				/*
				 * If ListIndex <= 5 And TimeBaseListIndex_old > 5 Then ' change from real time
				 * to equivalent time TriggerAuto_old = TriggerAuto TriggerCH1_old = TriggerCH1
				 * ' remember old setting so we can restore it when going back to real-time
				 * sampling TriggerExt_old = TriggerExt ' remember old setting so we can restore
				 * it when going back to real-time sampling
				 * 
				 * If TriggerAuto Then TriggerCH1 = True ' enforce triggered mode in equivalent
				 * time mode TriggerAuto = False TriggerAuto.Enabled = False End If
				 * 
				 * If ListIndex > 5 And TimeBaseListIndex_old <= 5 Then ' change from equivalent
				 * time to real time TriggerAuto.Enabled = True TriggerAuto = TriggerAuto_old
				 * TriggerCH1 = TriggerCH1_old ' restore setting TriggerExt = TriggerExt_old End
				 * If
				 */
				// TODO: add comments with sampling rate values
				switch (newValue)
				{
				case DPScope.DIV_5_US:
					myScope.samplingMode = DPScope.SAMPLE_MODE_ET;
					myScope.sampleInterval = (byte) 1;
					myScope.timeAxisScale = 0.000005d;
					break;
				case DPScope.DIV_10_US:
					myScope.samplingMode = DPScope.SAMPLE_MODE_ET;
					myScope.sampleInterval = (byte) 2;
					myScope.timeAxisScale = 0.00001d;
					break;
				case DPScope.DIV_20_US:
					myScope.samplingMode = DPScope.SAMPLE_MODE_ET;
					myScope.sampleInterval = (byte) 4;
					myScope.timeAxisScale = 0.00002d;
					break;
				case DPScope.DIV_50_US:
					myScope.samplingMode = DPScope.SAMPLE_MODE_ET;
					myScope.sampleInterval = (byte) 10;
					myScope.timeAxisScale = 0.00005d;
					break;
				case DPScope.DIV_100_US:
					myScope.samplingMode = DPScope.SAMPLE_MODE_ET;
					myScope.sampleInterval = (byte) 20;
					myScope.timeAxisScale = 0.0001d;
					break;
				case DPScope.DIV_200_US: // 50 kSa/sec
					myScope.samplingMode = DPScope.SAMPLE_MODE_RT;
					myScope.sampleInterval = (byte) 40;
					myScope.timeAxisScale = 0.0002d;
					break;
				case DPScope.DIV_500_US:
					myScope.samplingMode = DPScope.SAMPLE_MODE_RT;
					myScope.timeAxisScale = 0.0005d;
					break;
				case DPScope.DIV_1_MS:
					myScope.samplingMode = DPScope.SAMPLE_MODE_RT;
					myScope.timeAxisScale = 0.001d;
					break;
				case DPScope.DIV_2_MS:
					myScope.samplingMode = DPScope.SAMPLE_MODE_RT;
					myScope.timeAxisScale = 0.002d;
					break;
				case DPScope.DIV_5_MS:
					myScope.samplingMode = DPScope.SAMPLE_MODE_RT;
					myScope.timeAxisScale = 0.005d;
					break;
				case DPScope.DIV_10_MS:
					myScope.samplingMode = DPScope.SAMPLE_MODE_RT;
					myScope.timeAxisScale = 0.01d;
					break;
				case DPScope.DIV_20_MS:
					myScope.samplingMode = DPScope.SAMPLE_MODE_RT;
					myScope.timeAxisScale = 0.02d;
					break;
				case DPScope.DIV_50_MS:
					myScope.samplingMode = DPScope.SAMPLE_MODE_RT;
					myScope.timeAxisScale = 0.05d;
					break;
				case DPScope.DIV_100_MS:
					myScope.samplingMode = DPScope.SAMPLE_MODE_RT;
					myScope.timeAxisScale = 0.1d;
					break;
				case DPScope.DIV_200_MS:
					myScope.samplingMode = DPScope.SAMPLE_MODE_RT;
					myScope.timeAxisScale = 0.2d;
					break;
				case DPScope.DIV_500_MS:
					myScope.samplingMode = DPScope.SAMPLE_MODE_RT;
					myScope.timeAxisScale = 0.5d;
					break;
				case DPScope.DIV_1_S:
					myScope.samplingMode = DPScope.SAMPLE_MODE_RT;
					myScope.timeAxisScale = 1.0d;
					break;
				default:
					break;
				}

				scopeSetupTimebase((String) newValue);
			}
		});

		FlowPane flowPaneControls = new FlowPane();
		flowPaneControls.setHgap(10);
		flowPaneControls.setVgap(20);
		flowPaneControls.setPadding(new Insets(15, 15, 15, 15));
		flowPaneControls.setPrefWidth(180);
		flowPaneControls.setMaxWidth(180);
		flowPaneControls.setAlignment(Pos.CENTER);
		// flowPaneControls.setStyle("-fx-border-color: red");
		// TODO: Set control panel scaling correctly when maximizing to full screen

		ToolBar toolbarChannelSelect = new ToolBar();
		toolbarChannelSelect.setOrientation(Orientation.HORIZONTAL);

		RadioButton rdoChan_1 = new RadioButton("Ch1");
		rdoChan_1.setOnAction((event) ->
		{
			chanSelect ^= CHANNEL_1_SELECT;
		});

		RadioButton rdoChan_2 = new RadioButton("Ch2");
		rdoChan_2.setOnAction((event) ->
		{
			chanSelect ^= CHANNEL_2_SELECT;
		});

		rdoChan_1.setSelected(true);
		chanSelect = CHANNEL_1_SELECT;

		// ToggleGroup groupChanSelect = new ToggleGroup();
		// groupChanSelect.getToggles().addAll(rdoChan_1, rdoChan_2);
		// groupChanSelect.selectToggle(rdoChan_1);

		toolbarChannelSelect.getItems().addAll(new Separator(), rdoChan_1, new Separator(), rdoChan_2, new Separator());

		flowPaneControls.getChildren().addAll(btnStart, btnClear, spinVoltageScale, spinTimeScale, txtSamplingRate, toolbarChannelSelect);
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
		choiceFiltering.getItems().addAll("None", new Separator(), "Hamming", "Hanning", "Blackman");
		choiceFiltering.getSelectionModel().selectFirst();

		choiceFiltering.valueProperty().addListener((obs, oldValue, newValue) ->
		{
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

	/*
	 * Set up the timing parameters for the scope Better to have this as a separate
	 * function as it needs to be called every time the scope is initialized and
	 * thus shouldn't rely on a gui interface callback
	 */
	private void scopeSetupTimebase(String newValue)
	{
		/*
		 * Real time sampling uses a timer
		 */
		double tSample = 0.0d;
		double counts = 0.0d;
		double preload = 0.0d;

		// equivalent to: If ListIndex >= 6 Then
		if ((myScope.samplingMode == DPScope.SAMPLE_MODE_RT) && (newValue != DPScope.DIV_200_US))
		{
			/*
			 * empirical formula for necessary timer counts Counts = T_sample(usec) * 6 - 54
			 * preload = 65536 - counts
			 */

			if (myScope.timeAxisScale <= (double) 0.05d)
			{
				myScope.prescalerBypass = (byte) 1; // no prescaler
				myScope.prescalerSelection = (byte) 0;

				tSample = (myScope.timeAxisScale * 1000000.0d) / 10; // in usec, but 10 samples/div
				counts = tSample * 6 - 54;
				preload = 65536 - counts; // TODO: Tidy this up with constants
			}
			else
			{
				myScope.prescalerBypass = (byte) 0; // use prescaler (i.e. don't bypass) for slow sample rates to
													// prevent overflow
				myScope.prescalerSelection = (byte) 6; // divide by 2^(6+1) = 128 - headroom up to approx. 10 sec/div

				tSample = (myScope.timeAxisScale * 1000000.0d) / 10; // in usec, but 10 samples/div
				counts = (tSample * 6 - 54) / 128;
				preload = 65536 - counts;
			}
		}
		else if (newValue == DPScope.DIV_500_US)
		{ // 50 kSa/sec
			// special case: alternated acquisition at 50 kSa/sec per channel
			myScope.prescalerBypass = (byte) 1; // no prescaler
			myScope.prescalerSelection = (byte) 0;

			tSample = 2 * (myScope.timeAxisScale * 1000000.0d) / 10; // in usec, but 10 samples/div
			counts = tSample * 6 - 54;
			preload = 65536 - counts; // TODO: Tidy this up with constants
		}
		else
		{
			myScope.prescalerBypass = (byte) 1; // no prescaler
			myScope.prescalerSelection = (byte) 0;

			myScope.timerPreloadHigh = (byte) (255 & 0xff); // so we don't get accidentally stuck with a super-slow
															// counter
			myScope.timerPreloadLow = (byte) 0;
		}

		myScope.timerPreloadHigh = (byte) ((int) (preload / 256) & 0xff);
		myScope.timerPreloadLow = (byte) ((int) (preload % 256) & 0xff);

	}

	private boolean disconnectScope()
	{
		if (myScope != null)
		{
			myScope.disconnect();
			myScope.deleteObservers();
			myScope = null;
			nextScopeData = false;
			return true;
		}
		return false;
	}

	@Override
	public void stop()
	{
		// System.out.println("App is closing");
		if (disconnectScope())
		{
			System.out.println("Disconnecting scope...");
		}
	}

	public static void main(String[] args)
	{
		launch(args);
	}
}