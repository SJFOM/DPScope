package com.dpscope;

import java.awt.BorderLayout;
import java.awt.EventQueue;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.LinkedHashMap;
import java.util.Observable;
import java.util.Observer;
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

import com.dpscope.DPScope.Command;

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
	private static final String SCAN = "Scan";
	private static final String STOP_SCAN = "Stop Scan";
	private static final String USB_VOLTAGE = "Get Supply Voltage";
	private static final int COUNT = 8 * 60;
	private static final int FAST = 10;
	private static final int SLOW = FAST * 5;
	private static final Random random = new Random();
	private Timer timer;

	private JButton getUSBVoltage;
	private JButton btnPollData;
	
	private static DPScope myScope;
	
	private boolean ch1Select = true;
	private boolean ch2Select = false;

	private static float[] lastData = new float[1];

	private LinkedHashMap<Command, float[]> parsedMap;

	public DTSCTest(final String title) {
		super(title);
		final DynamicTimeSeriesCollection dataset = new DynamicTimeSeriesCollection(1, COUNT, new Second());
		dataset.setTimeBase(new Second(0, 0, 0, 1, 1, 2011));
		dataset.addSeries(gaussianData(), 0, "Scope data");
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
					myScope.deleteObservers();
					btnPollData.setText(SCAN);
					myScope.stopScan_RollMode();
				} else {
					if (myScope.isDevicePresent()) {
						myScope.connect();
						timer.start();
						connect.setText(DISCONNECT);
						run.setText(STOP);
						setupScopeObserver();
					}
				}
			}
		});

		btnPollData = new JButton(SCAN);
		btnPollData.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				String cmd = e.getActionCommand();
				if (SCAN.equals(cmd)) {
					if (DISCONNECT.equals(connect.getText())) {
						timer.start();
						btnPollData.setText(STOP_SCAN);
						run.setText(STOP);
						if(myScope.countObservers() == 0) {
							// probably never called...
							System.out.println("Empty observer list - run scan");
							setupScopeObserver();
						}
						myScope.runScan_RollMode(DPScope.CH1_1, DPScope.CH2_1);
					}
				} else {
					timer.stop();
					run.setText(START);
					btnPollData.setText(SCAN);
					myScope.stopScan_RollMode();
				}
			}
		});

		getUSBVoltage = new JButton(USB_VOLTAGE);
		getUSBVoltage.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				if (myScope.isDeviceConnected()) {
					if(myScope.countObservers() == 0) {
						// probably never called...
						System.out.println("Empty observer list - get usb voltage");
						setupScopeObserver();
					}
					myScope.checkUsbSupply(10);
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
		
		channelSelect.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// TODO Auto-generated method stub
				if (("Ch1".equals(channelSelect.getSelectedItem()))) {
					ch1Select = true;
					ch2Select = false;
				} else {
					ch1Select = false;
					ch2Select = true;
				}
			}
		});

		this.add(new ChartPanel(chart), BorderLayout.CENTER);
		JPanel btnPanel = new JPanel(new FlowLayout());
		btnPanel.add(run);
		btnPanel.add(connect);
		btnPanel.add(btnPollData);
		btnPanel.add(getUSBVoltage);
		btnPanel.add(speed);
		btnPanel.add(channelSelect);
		this.add(btnPanel, BorderLayout.SOUTH);
		

		timer = new Timer(1, new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				// lastData[0] = randomValue();
				dataset.advanceTime();
				dataset.appendData(lastData);
			}
		});
	}

	private void setupScopeObserver() {
		// TODO Auto-generated method stub
		myScope.addObserver(new Observer() {
			@Override
			public void update(Observable o, Object arg) {
				// TODO Auto-generated method stub
				parsedMap = (LinkedHashMap<Command, float[]>) arg;
				if (parsedMap.containsKey(Command.CMD_READADC)) {
					if (ch1Select) {
						lastData[0] = parsedMap.get(Command.CMD_READADC)[0];
					} else {
						lastData[0] = parsedMap.get(Command.CMD_READADC)[1];
					}
				} else if (parsedMap.containsKey(Command.CMD_CHECK_USB_SUPPLY)) {
					getUSBVoltage.setText(String.valueOf(String.format("%.3f", parsedMap.get(Command.CMD_CHECK_USB_SUPPLY)[0])) + " V");
				}
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
		final JFreeChart result = ChartFactory.createTimeSeriesChart(TITLE, "hh:mm:ss", "milliVolts", dataset, true,
				true, false);
		final XYPlot plot = result.getXYPlot();
		ValueAxis domain = plot.getDomainAxis();
		domain.setAutoRange(true);
		ValueAxis range = plot.getRangeAxis();
		// range.setRange(-MIN, MAX);
		range.setAutoRange(true);
		return result;
	}

	public void start() {
		timer.start();
	}

	public float runScan_ScopeMode(int channel) {
		float[] newData = new float[1];
		// if (myScope.isDone) {
		if (!(myScope.actionList.size() > 0)) {
			myScope.readBack(0);

			if (channel == 1) {
				newData[0] = myScope.getSignalCh1();
			} else {
				newData[0] = myScope.getSignalCh2();
			}

			myScope.armScope(DPScope.CH1_1, DPScope.CH2_1);

			return newData[0];
		} else {
			myScope.queryIfDone();
			return lastData[0];
		}
	}

	public static void main(final String[] args) {

		myScope = new DPScope();

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