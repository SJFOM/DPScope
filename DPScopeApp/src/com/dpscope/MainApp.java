package com.dpscope;

import java.io.IOException;

import com.dpscope.controller.MainController;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;

public class MainApp extends Application {

    private Stage primaryStage;
    private BorderPane rootLayout;
    
    @Override
    public void start(Stage primaryStage) {
        this.primaryStage = primaryStage;
        this.primaryStage.setTitle("DPScopeApp");        
        
        initRootLayout();
        showPersonOverview();
        setUserAgentStylesheet(STYLESHEET_MODENA);
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
			
			scene.getStylesheets().add(getClass().getResource("stylesheet.css").toExternalForm());
						
			
			
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
            dpscopeOverview.getStylesheets().add(getClass().getResource("stylesheet.css").toExternalForm());
            
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

    @Override
	public void stop() {
		System.out.println("Stage is closing");
		if (MainController.disconnectScope()) {
			System.out.println("Disconnecting scope...");
		}
	}
    
    public static void main(String[] args) {
        launch(args);
    }
}