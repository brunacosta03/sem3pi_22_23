package Controller;

import DataStructures.Graph.Graph;
import Domain.*;
import Domain.Store.ClientStore;
import Domain.Store.Company;
import Domain.Store.ProducerStore;
import UI.Utils.DataFlusher;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;

import javax.management.InstanceNotFoundException;

import static org.junit.jupiter.api.Assertions.*;


import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class NearestHubTest {
    private NearestHubController ctrl;
    private Company comp;
    private LoadFileController loadctrl;
    private TopClosestEnterprisesController topctrl;
    ProducerStore producerStore;
    ClientStore clientStore;

    private final String clientProducerSmallfile = "src/main/resources/Small/clientes-produtores_small.csv";
    private final String distancesSmallfile = "src/main/resources/Small/distancias_small.csv";
    private final String basketSmallfile = "src/main/resources/Small/cabazes_small.csv";

    public NearestHubTest(){
        comp = App.getInstance().getCompany();
        ctrl = new NearestHubController();
        loadctrl = new LoadFileController();
        topctrl = new TopClosestEnterprisesController();
        producerStore = comp.getProducerStore();
        clientStore = comp.getClientStore();
    }

    @AfterEach
    void tearDown() {
        Graph<Member, Double> graph = comp.getMemberGraph().getMembersLocationGraph();

        ArrayList<Member> vertices = graph.vertices();

        for (Member member : vertices) {
            member.removeBasket();
            graph.removeVertex(member);
        }

        //for(Member client : clientStore.getMemberRequest()){
          //  clientStore.getMemberRequest().remove(client);
        //}

        //for(Member producer : producerStore.getProducerStore()){
         //   producerStore.getProducerStore().remove(producer);
        //}
    }

    @Test
    void testGetValue() throws FileNotFoundException, InstanceNotFoundException {

        loadctrl.LoadLocationIDFile(clientProducerSmallfile);
        loadctrl.LoadDistancesFile(distancesSmallfile);
        loadctrl.LoadBasketFile(basketSmallfile);

        List<Client> clients = comp.getEnterpriseClients();

        clients.add(new Client("C1", new Location("CT5", "42.6", "53"), ClientType.CLIENT));
        clients.add(new Client("C2", new Location("CT6", "50.6", "-43"), ClientType.CLIENT));
        clients.add(new Client("C3", new Location("CT7", "-41.3", "-21"), ClientType.CLIENT));
        clients.add(new Client("C4", new Location("CT8", "30", "67"), ClientType.CLIENT));
        clients.add(new Client("C5", new Location("CT9", "12", "4"), ClientType.CLIENT));
        clients.add(new Client("C6", new Location("CT10", "35", "-5.6"), ClientType.CLIENT));
        clients.add(new Client("C7", new Location("CT11", "19.9", "-42.4"), ClientType.CLIENT));
        clients.add(new Client("C8", new Location("CT12", "-56.7", "21"), ClientType.CLIENT));
        clients.add(new Client("C9", new Location("CT13", "39.2369", "-8.685"), ClientType.CLIENT));



        List<EnterpriseAverageDistance> topN = topctrl.getTopNClosestEnterprises(5);
        Map<Client, HubAndDistanceToAClient> clientsCloser;
        clientsCloser = ctrl.getAllClientsEnterprises(topN);

        assertEquals(5, topN.size());
        assertEquals(clients.size(), clientsCloser.size());



    }
}
