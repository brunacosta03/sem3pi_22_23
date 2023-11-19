package Controller;

import DataStructures.Graph.Edge;
import DataStructures.Graph.Graph;
import Domain.Client;
import Domain.ClientType;
import Domain.Location;
import Domain.Member;
import Domain.Store.ClientStore;
import Domain.Store.Company;
import Domain.Store.ProducerStore;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class MinimumNetworkTest {
    Company company;
    MinimumNetworkController ctrl;
    ProducerStore producerStore;
    ClientStore clientStore;

    public MinimumNetworkTest(){
        company = App.getInstance().getCompany();
        ctrl = new MinimumNetworkController();
        producerStore = company.getProducerStore();
        clientStore = company.getClientStore();
    }

    @AfterEach
    void finish(){
        Graph<Member, Double> graph = company.getMemberGraph().getMembersLocationGraph();

        ArrayList<Member> vertices = graph.vertices();

        for (Member member : vertices) {
            graph.removeVertex(member);
        }

        //for(Member client : clientStore.getMemberRequest()){
            //clientStore.getMemberRequest().remove(client);
        //}

        //for(Member producer : producerStore.getProducerStore()){
          //  producerStore.getProducerStore().remove(producer);
        //}
    }

    @Test
    void findMinimumNetWorkZeroReturn(){
        ArrayList<Edge<Member, Double>> mstList = ctrl.findMinimumNetwork();

        assertEquals(mstList.size(), 0);
    }

    @Test
    void findMinimumNetWork(){
        Graph<Member, Double> graph = company.getMemberGraph().getMembersLocationGraph();

        Location location1 = new Location("1", "100", "-100");
        Member member1 = new Client("1", location1, ClientType.CLIENT);
        graph.addVertex(member1);

        Location location2 = new Location("2", "200", "-200");
        Member member2 = new Client("2", location2, ClientType.CLIENT);
        graph.addVertex(member2);

        Location location3 = new Location("3", "100", "-100");
        Member member3 = new Client("3", location3, ClientType.CLIENT);
        graph.addVertex(member3);

        graph.addEdge(member1, member2, 100.0);
        graph.addEdge(member2, member3, 300.0);
        graph.addEdge(member3, member1, 300.0);


        ArrayList<Edge<Member, Double>> mstList = ctrl.findMinimumNetwork();

        assertEquals(mstList.size(), 2);
    }

    @Test
    void findMinimumNetWorkWithDuplicatedReversed(){
        Graph<Member, Double> graph = company.getMemberGraph().getMembersLocationGraph();

        Location location1 = new Location("1", "100", "-100");
        Member member1 = new Client("1", location1, ClientType.CLIENT);
        graph.addVertex(member1);

        Location location2 = new Location("2", "200", "-200");
        Member member2 = new Client("2", location2, ClientType.CLIENT);
        graph.addVertex(member2);

        Location location3 = new Location("3", "100", "-100");
        Member member3 = new Client("3", location3, ClientType.CLIENT);
        graph.addVertex(member3);

        graph.addEdge(member1, member2, 100.0);
        graph.addEdge(member2, member1, 100.0);
        graph.addEdge(member2, member3, 300.0);
        graph.addEdge(member3, member2, 300.0);
        graph.addEdge(member3, member1, 300.0);
        graph.addEdge(member1, member3, 300.0);


        ArrayList<Edge<Member, Double>> mstList = ctrl.findMinimumNetwork();

        assertEquals(mstList.size(), 2);
    }
}
