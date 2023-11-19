package Domain.Store;

import DataStructures.Graph.Algorithms;
import Domain.Location;
import Domain.Producer;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class MemberGraphTest {

	MemberGraph mg;

	@BeforeEach
	void setup(){
		mg = new MemberGraph();

		Producer p1 = new Producer("p1", new Location("1", "1","1"));
		Producer p2 = new Producer("p2", new Location("2", "2","2"));
		Producer p3 = new Producer("p3", new Location("3", "3","3"));
		Producer p4 = new Producer("p4", new Location("4", "4","4"));

		mg.getMembersLocationGraph().addVertex(p1);
		mg.getMembersLocationGraph().addVertex(p2);
		mg.getMembersLocationGraph().addVertex(p3);
		mg.getMembersLocationGraph().addVertex(p4);

		mg.getMembersLocationGraph().addEdge(p1, p2, 1.0);
		mg.getMembersLocationGraph().addEdge(p3, p4, 1.0);
		mg.getMembersLocationGraph().addEdge(p1, p3, 1.0);
	}

	@DisplayName("Test of isConnected")
	@Test
	void isConnectedTest() {
		mg = new MemberGraph();

		Producer p1 = new Producer("p1", new Location("1", "1","1"));
		Producer p2 = new Producer("p2", new Location("2", "2","2"));
		Producer p3 = new Producer("p3", new Location("3", "3","3"));
		Producer p4 = new Producer("p4", new Location("4", "4","4"));

		mg.getMembersLocationGraph().addVertex(p1);
		mg.getMembersLocationGraph().addVertex(p2);
		mg.getMembersLocationGraph().addVertex(p3);
		mg.getMembersLocationGraph().addVertex(p4);

		mg.getMembersLocationGraph().addEdge(p1, p2, 1.0);
		mg.getMembersLocationGraph().addEdge(p3, p4, 1.0);

		System.out.printf("Vertices: %d\nBreathed Size: %d",
				mg.getMembersLocationGraph().vertices().size(),
				Algorithms.DepthFirstSearch(mg.getMembersLocationGraph(), p1).size()
		);
		System.out.println("\nIs Connected: " + mg.isConnected());
		assertFalse(mg.isConnected());



		mg.getMembersLocationGraph().addEdge(p1, p3, 1.0);
		System.out.printf("\nVertices: %d\nBreathed Size: %d",
				mg.getMembersLocationGraph().vertices().size(),
				Algorithms.DepthFirstSearch(mg.getMembersLocationGraph(), p1).size()
		);

		assertTrue(mg.isConnected());
		System.out.println("\nIs Connected: " + mg.isConnected());
	}

	@Test
	void getNumberOfEdgesToFullyConnect() {
		int nEdges = mg.getMembersLocationGraph().edges().size();
		int nVert = mg.getMembersLocationGraph().vertices().size();
		System.out.println("Number of edges: " + nEdges);
		System.out.println("Number of vertices: " + nVert);
		System.out.println("Number of max edges: " + mg.getMinEdgesToFullyConnect());
		System.out.println("Number of edges to fully connect: " + mg.getNumberOfEdgesToFullyConnect());

		assertEquals((nVert*(nVert-1)/2)-nEdges, mg.getNumberOfEdgesToFullyConnect());

	}

	@Test
	void getGraphDiameter() {
		System.out.println("Graph Diameter: " + mg.getGraphDiameter());
		assertEquals(4, mg.getGraphDiameter());
	}
}