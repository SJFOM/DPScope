package com.dpscope;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;

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
//		lineChart.setTitle("Animated Line Chart");
		lineChart.setHorizontalGridLinesVisible(true);

		// Set Name for Series
		series1.setName("Series 1");

		// Add Chart Series
		lineChart.getData().add(series1);
		
		SplitPane spltPane = new SplitPane();
		spltPane.setDividerPosition(0, 0.3);
		spltPane.setMinWidth(Control.USE_PREF_SIZE);
		
		spltPane.getItems().addAll(tabPaneControls(), lineChart);
		

		primaryStage.setScene(new Scene(spltPane));
	}


    @Override
    public void start(Stage stage) {
        stage.setTitle("Animated Line Chart Sample");
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

        AddToQueue addToQueue = new AddToQueue();
        executor.execute(addToQueue);
        //-- Prepare Timeline
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

    //-- Timeline gets called in the JavaFX Main thread
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
        for (int i = 0; i < 20; i++) { //-- add 20 numbers to the plot+
            if (dataQ1.isEmpty()) break;
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

    private TabPane tabPaneControls(){
		
    	/*
    	 *  TIME control panel
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
		    @Override public void handle(ActionEvent e) {
		    	if(btnStart.getText().equals("Start".toUpperCase())){
		    		btnStart.setText("Stop".toUpperCase());
		    	} else{
		    		btnStart.setText("Start".toUpperCase());
		    	}	    		    	
		    }
		});

		HBox hboxTime = new HBox();
		hboxTime.setPadding(new Insets(15, 12, 15, 12));
		hboxTime.setSpacing(80);
		hboxTime.prefWidthProperty().bind(paneTimeControls.widthProperty());
		
		hboxTime.getChildren().addAll(btnStart, btnClear);
	
		paneTimeControls.getChildren().add(hboxTime);

		
    	/*
    	 *  FFT control panel
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
    	 *  Options control panel
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
//		paneTimeControls.setStyle("-fx-background-color: #f64863;"); http://www.color-hex.com/color-palettes/



		final TabPane tbpControls = new TabPane();
		tbpControls.getTabs().addAll(tabTime, tabFFT, tabOptions);
		tbpControls.setMinWidth(Control.USE_PREF_SIZE);
			
		
    	return tbpControls;
    	
    }
    
    public static void main(String[] args) {
        launch(args);
    }
}