package UI;

import Controller.App;
import Controller.GraphConnectedController;
import UI.Utils.Utils;

import javax.management.InstanceNotFoundException;
import java.util.Arrays;
import java.util.List;

public class GraphConnectedUI implements Runnable{

	GraphConnectedController ctrl = new GraphConnectedController();

	@Override
	public void run() {
		try {
			if (ctrl.isGraphConnected()){
				System.out.println("\nGraph is connected");
				System.out.println("Calculating Graph Diameter... Please wait");
				System.out.println("Graph Diameter: " + ctrl.getGraphDiameter());
				System.out.println("");
			}
			else System.out.println("\nGraph is not connected\n");


		} catch (Exception exception) {
			System.out.println("\nWARNING: " + exception.getMessage() + "\n");
		}
	}
}
