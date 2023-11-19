package Controller;

import DataStructures.Graph.Algorithms;
import DataStructures.Graph.Edge;
import DataStructures.Graph.Graph;
import DataStructures.Graph.map.MapGraph;
import Domain.Member;
import Service.MinimumNetworkService;

import java.util.ArrayList;

public class MinimumNetworkController {
    private MinimumNetworkService service;

    public MinimumNetworkController() {
        this.service = new MinimumNetworkService();
    }

    public ArrayList<Edge<Member, Double>> findMinimumNetwork(){
        Graph<Member, Double> graphMST = new MapGraph(false);

        ArrayList<Edge<Member, Double>> edgesList = service.getEdgedsOrderByWeightMemberGraph();
        service.setVerticeInMST(graphMST);

        Algorithms.kruskallAlgorithm(graphMST, edgesList);

        ArrayList<Edge<Member, Double>> graphMSTList = service.getEdgesOrderByWeight(graphMST);

        return graphMSTList;
    }
}
