package Service;

import Comparator.SortByWeight;
import Controller.App;
import DataStructures.Graph.Edge;
import DataStructures.Graph.Graph;
import Domain.Member;
import Domain.Store.Company;

import java.util.ArrayList;

public class MinimumNetworkService {
    Company company;

    public MinimumNetworkService() {
        this.company = App.getInstance().getCompany();
    }

    public ArrayList<Edge<Member, Double>> getEdgedsOrderByWeightMemberGraph(){
        return getEdgesOrderByWeight(company.getMemberGraph().getMembersLocationGraph());
    }

    public ArrayList<Edge<Member, Double>> getEdgesOrderByWeight(Graph<Member, Double> graph) {
        ArrayList<Edge<Member, Double>> edges = (ArrayList<Edge<Member, Double>>) graph.edges();
        ArrayList<Edge<Member, Double>> edgesOrderWeight = new ArrayList<>();

        edges.sort(new SortByWeight());

        for (Edge<Member, Double> edge : edges) {
            if(!edgesOrderWeight.contains(new Edge<>(edge.getVDest(), edge.getVOrig(), edge.getWeight()))){
                edgesOrderWeight.add(edge);
            }
        }

        return edgesOrderWeight;
    }

    public void setVerticeInMST(Graph<Member, Double> graphMST) {
        ArrayList<Member> vertices = company.getMemberGraph().getMembersLocationGraph().vertices();

        for (Member vertice : vertices) {
            graphMST.addVertex(vertice);
        }
    }
}
