package com.dpscope;

import java.awt.BorderLayout;
import java.awt.EventQueue;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Random;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JPanel;
import javax.swing.Timer;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.plot.XYPlot;
import org.jfree.data.time.DynamicTimeSeriesCollection;
import org.jfree.data.time.Second;
import org.jfree.data.xy.XYDataset;
import org.jfree.ui.ApplicationFrame;
import org.jfree.ui.RefineryUtilities;

/** @see http://stackoverflow.com/questions/5048852 */
public class DTSCTest extends ApplicationFrame {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final String TITLE = "DPScope SE";
	private static final String START = "Start";
	private static final String STOP = "Stop";
	private static final String CONNECT = "Connect";
	private static final String DISCONNECT = "Disconnect";
	private static final int COUNT = 8 * 60;
	private static final int FAST = 10;
	private static final int SLOW = FAST * 5;
	private static final Random random = new Random();
	private Timer timer;

	private static DPScope myScope;
	private static byte adcAcq;
	private static byte ACQT;
	private static byte ADCS;

	public DTSCTest(final String title) {
		super(title);
		final DynamicTimeSeriesCollection dataset =
				new DynamicTimeSeriesCollection(1, COUNT, new Second());
		dataset.setTimeBase(new Second(0, 0, 0, 1, 1, 2011));
		dataset.addSeries(gaussianData(), 0, "Gaussian data");
		JFreeChart chart = createChart(dataset);

		final JButton run = new JButton(STOP);
		run.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				String cmd = e.getActionCommand();
				if (STOP.equals(cmd)) {
					timer.stop();
					run.setText(START);
				} else {
					timer.start();
					run.setText(STOP);
				}
			}
		});

		final JButton connect = new JButton(CONNECT);
		connect.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				String cmd = e.getActionCommand();
				if (DISCONNECT.equals(cmd)) {
					myScope.disconnect();
					timer.stop();
					connect.setText(CONNECT);
					run.setText(START);
				} else {
					if (myScope.isDevicePresent()) {
						myScope.connect();
						timer.start();
						connect.setText(DISCONNECT);
						run.setText(STOP);
					}
				}
			}
		});

		final JComboBox<String> speed = new JComboBox<String>();
		speed.addItem("Fast");
		speed.addItem("Slow");
		speed.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				if ("Fast".equals(speed.getSelectedItem())) {
					timer.setDelay(FAST);
				} else {
					timer.setDelay(SLOW);
				}
			}
		});
		
		
		final JComboBox<String> channelSelect = new JComboBox<String>();
		channelSelect.addItem("Ch1");
		channelSelect.addItem("Ch2");

		this.add(new ChartPanel(chart), BorderLayout.CENTER);
		JPanel btnPanel = new JPanel(new FlowLayout());
		btnPanel.add(run);
		btnPanel.add(connect);
		btnPanel.add(speed);
		btnPanel.add(channelSelect);
		this.add(btnPanel, BorderLayout.SOUTH);

		timer = new Timer(FAST, new ActionListener() {

			float[] newData = new float[1];

			@Override
			public void actionPerformed(ActionEvent e) {
				if(DISCONNECT.equals(connect.getText())){
					myScope.readADC(DPScope.BATTERY, DPScope.CH2_1, adcAcq);
					if("Ch1".equals(channelSelect.getSelectedItem())){
						newData[0] = myScope.getSignalCh1();
					} else {
						newData[0] = myScope.getSignalCh2();
					}
				} else {
					newData[0] = 10; //randomValue();
				}
				dataset.advanceTime();
				dataset.appendData(newData);
			}
		});
	}

	private float randomValue() {
		return (float) (random.nextGaussian() * 3);
	}

	private float[] gaussianData() {
		float[] a = new float[COUNT];
		for (int i = 0; i < a.length; i++) {
			a[i] = randomValue();
		}
		return a;
	}

	private JFreeChart createChart(final XYDataset dataset) {
		final JFreeChart result = ChartFactory.createTimeSeriesChart(
				TITLE, "hh:mm:ss", "milliVolts", dataset, true, true, false);
		final XYPlot plot = result.getXYPlot();
		ValueAxis domain = plot.getDomainAxis();
		domain.setAutoRange(true);
		ValueAxis range = plot.getRangeAxis();
//		range.setRange(-MIN, MAX);
		range.setAutoRange(true);
		return result;
	}

	public void start() {
		timer.start();
	}

	public static void main(final String[] args) {

		myScope = new DPScope();
		
		ADCS = 6;
		ACQT = 3;		
		adcAcq = (byte) (128 + ACQT * 8 + ADCS);

		EventQueue.invokeLater(new Runnable() {
			@Override
			public void run() {
				DTSCTest demo = new DTSCTest(TITLE);
				demo.pack();
				RefineryUtilities.centerFrameOnScreen(demo);
				demo.setVisible(true);
				demo.start();
			}
		});
	}
}