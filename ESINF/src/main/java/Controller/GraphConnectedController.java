package Controller;

import Domain.Store.MemberGraph;

import javax.management.InstanceNotFoundException;

public class GraphConnectedController {

	MemberGraph graph = App.getInstance().getCompany().getMemberGraph();

	InstanceNotFoundException instanceNotFoundException = new InstanceNotFoundException("Graph is empty");

	public boolean isGraphConnected() throws InstanceNotFoundException {
		if (!graph.isLoaded()) {
			throw instanceNotFoundException;
		}
		return graph.isConnected();
	}

	public int getGraphDiameter() throws InstanceNotFoundException {
		if (!graph.isLoaded()) {
			throw instanceNotFoundException;
		}
		return graph.getGraphDiameter();
	}

}
