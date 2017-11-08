package com.dpscope;

import java.io.IOException;
import java.net.URL;
import java.util.Random;
import java.util.ResourceBundle;

import com.dpscope.view.SampleController;

import javafx.application.Application;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Scene;
import javafx.scene.chart.LineChart;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;

public class MainApp extends Application implements Initializable {

    private Stage primaryStage;
    private BorderPane rootLayout;

    @FXML
    private LineChart<Double, Double> lineGraph;
    
    @Override
    public void start(Stage primaryStage) {
        this.primaryStage = primaryStage;
        this.primaryStage.setTitle("DPScopeApp");

        initRootLayout();

        showPersonOverview();
        
    }

    /**
     * Initializes the root layout.
     */
	public void initRootLayout() {
		try {
			// Load root layout from fxml file.
			FXMLLoader loader = new FXMLLoader();
			loader.setLocation(MainApp.class.getResource("view/RootLayout.fxml"));
			rootLayout = (BorderPane) loader.load();

			// Show the scene containing the root layout.
			Scene scene = new Scene(rootLayout);
			

			scene.getStylesheets().add(getClass().getResource("view/stylesheet.css").toExternalForm());
			
			
			setUserAgentStylesheet(STYLESHEET_MODENA);
			
//			JFXButton jfoenixButton = new JFXButton("JFoenix Button");
//			JFXButton button = new JFXButton("Raised Button".toUpperCase());
//			button.getStyleClass().add("button-raised");
//			
//			rootLayout.getChildren().add(button);
			
			primaryStage.setScene(scene);
			primaryStage.show();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

    /**
     * Shows the person overview inside the root layout.
     */
    public void showPersonOverview() {
        try {
            // Load person overview.
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(MainApp.class.getResource("view/DPScopeOverview.fxml"));
            AnchorPane dpscopeOverview = (AnchorPane) loader.load();
           
            
            // Set person overview into the center of root layout.
            rootLayout.setCenter(dpscopeOverview);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Returns the main stage.
     * @return
     */
    public Stage getPrimaryStage() {
        return primaryStage;
    }

    public static void main(String[] args) {
        launch(args);
//        DPScope myScope = new DPScope();
//        if(myScope.isDevicePresent()){
//        	myScope.connect();
//        	myScope.ping();
//        	myScope.toggleLed(false);
//        }
    }

	@Override
	public void initialize(URL arg0, ResourceBundle arg1) {
		// TODO Auto-generated method stub
		
	}
}