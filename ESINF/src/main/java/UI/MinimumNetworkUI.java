package UI;

import Controller.MinimumNetworkController;
import DataStructures.Graph.Edge;
import Domain.Member;

import java.util.ArrayList;

public class MinimumNetworkUI implements Runnable {
    private MinimumNetworkController ctrl;

    public MinimumNetworkUI() {
        this.ctrl = new MinimumNetworkController();
    }

    @Override
    public void run() {
        System.out.println();

        ArrayList<Edge<Member, Double>> graphMSTList = ctrl.findMinimumNetwork();
        int sumWeight = 0;

        if(graphMSTList.size() != 0){
            for (Edge<Member, Double> edge : graphMSTList) {
                System.out.println(edge.getVOrig().getId() + " <--> " + edge.getVDest().getId() + " : " + edge.getWeight() + "m");
                sumWeight += edge.getWeight();
            }

            System.out.println("\nMinimum Spanning Tree cost - " + sumWeight + "m\n");
        } else{
            System.out.println("\nImport files first!\n");
        }
    }
}
