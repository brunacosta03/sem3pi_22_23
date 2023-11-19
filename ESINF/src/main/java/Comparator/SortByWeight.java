package Comparator;


import DataStructures.Graph.Edge;
import Domain.Member;

import java.util.Comparator;

public class SortByWeight implements Comparator<Edge<Member, Double>> {
    public int compare(Edge<Member, Double> a, Edge<Member, Double> b) {
        return a.getWeight().compareTo(b.getWeight());
    }
}
