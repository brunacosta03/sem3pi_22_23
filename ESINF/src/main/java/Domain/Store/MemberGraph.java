package Domain.Store;

import DataStructures.Graph.Algorithms;
import DataStructures.Graph.Edge;
import DataStructures.Graph.map.MapGraph;
import Domain.Client;
import Domain.ClientType;
import Domain.Member;

import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

public class MemberGraph {

	private MapGraph<Member, Double> membersLocationGraph;

	private static final boolean IS_DIRECTED = false;

	public MemberGraph() {
		membersLocationGraph = new MapGraph<>(IS_DIRECTED);
	}

	public MapGraph<Member, Double> getMembersLocationGraph() {
		return membersLocationGraph;
	}

	/**
	 * Check if the graph has any vertices loaded, hence being considered loaded
	 *
	 * @return boolean - true if  the numbers of vertices is NOT 0, else false
	 */
	public boolean isLoaded() {
		if (membersLocationGraph.vertices().size()==0) return false;
		else return true;
	}

	/**
	 * Checks if graph is Connected
	 *
	 * @return boolean - true if graph is connected
	 */
	public boolean isConnected() {
		LinkedList<Member> members = Algorithms.DepthFirstSearch(
				getMembersLocationGraph(),
				getMembersLocationGraph().vertices().get(0)
		);
		return (members.size() == membersLocationGraph.vertices().size());
	}

	/**
	 * Deletes the currently loaded data, if there is none returns nothing
	 *
	 * @return void
	 */
	public void flush() {
		membersLocationGraph = new MapGraph<>(IS_DIRECTED);
	}

	public static void writeJsonFile(MapGraph<Member,Double> graph, String fileName) throws IOException {
		FileWriter fileWriter = new FileWriter(fileName);

		fileWriter.write("{\n");
		fileWriter.write("\"kind\":{\"graph\":true},\n");
		fileWriter.write("\"nodes\":[\n");
		for (Member vertice: graph.vertices()) {
			String color = "red";
			if (vertice instanceof Client) {
				if (((Client) vertice).getClientType() == ClientType.ENTERPRISE) {
					color = "green";
				}
				if (((Client) vertice).getClientType() == ClientType.CLIENT) {
					color = "blue";
				}
			}
			fileWriter.write(String.format(
					"{\"id\": \"%s\", \"label\": \"%s\", \"color\": \"%s\", \"x\":\"%s\", \"y\":\"%s\"},\n",
					vertice.getId(),
					vertice.getId(),
					color,
					vertice.getLocation().getLat(),
					vertice.getLocation().getLon()
			));
		}
		fileWriter.write("],\n");

		fileWriter.write("\"edges\":[\n");
		List<Edge<Member, Double>> edgesTemp = new ArrayList<>();
		for (Edge<Member, Double> edge: graph.edges()) {
			boolean existsReversedEdge = edgesTemp.stream().anyMatch(e -> (e.getVDest().equals(edge.getVOrig()) && e.getVOrig().equals(edge.getVDest())));
			if (!existsReversedEdge) {
				fileWriter.write(String.format(
						"{\"from\": \"%s\", \"to\": \"%s\", \"color\":\"lightgray\", \"label\": \"%s\"},\n",
						edge.getVOrig().getId(),
						edge.getVDest().getId(),
						edge.getWeight()
				));
				edgesTemp.add(edge);
			}
		}
		fileWriter.write("]\n");

		fileWriter.write("}\n");
		fileWriter.close();
	}

	public int getMinEdgesToFullyConnect() {
		int nVert = membersLocationGraph.numVertices();
		return (nVert * (nVert - 1)) / 2;
	}

	public int getNumberOfEdgesToFullyConnect() {
		return getMinEdgesToFullyConnect() - membersLocationGraph.edges().size();
	}

	public int getGraphDiameter() {
		LinkedList<Member> longestPath = null;
		for (Member m1 : membersLocationGraph.vertices()) {
			for (Member m2 : membersLocationGraph.vertices()) {
				LinkedList<Member> path = new LinkedList<>();
				Algorithms.shortestPath(membersLocationGraph, m1, m2, Double::compare, Double::sum, Double.valueOf("0"), path);
				if (longestPath == null || path.size() > longestPath.size()) {
					longestPath = path;
				}
			}
		}
		return longestPath.size();
	}

	public void reset() {
		this.membersLocationGraph = new MapGraph<>(IS_DIRECTED);
	}
}
