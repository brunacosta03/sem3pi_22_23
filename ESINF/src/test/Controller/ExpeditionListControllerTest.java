package Controller;

import DataStructures.Graph.Graph;
import Domain.*;
import Domain.Store.ClientStore;
import Domain.Store.Company;
import Domain.Store.ProducerStore;
import Service.Loader.BasketLoader;
import Service.Loader.DistancesLoader;
import Service.Loader.LocIDFIleLoader;
import org.junit.Ignore;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.management.InstanceNotFoundException;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class ExpeditionListControllerTest {

    Company company;
    LoadFileController loadCtrl;
    ExpeditionListController ctrl;
    NearestHubController nearestHubCtrl;
    TopClosestEnterprisesController topClosestEnterprisesCtrl;
    ProducerStore producerStore;
    ClientStore clientStore;

    private static String locID_path_small = "src/test/testFiles/clientes-produtores_small.csv";
    private static String dist_path_small = "src/test/testFiles/distancias_small.csv";
    private static String bskt_path_small = "src/test/testFiles/cabazes_small.csv";

    private static String locID_path_big = "src/test/testFiles/clientes-produtores_big.csv";
    private static String dist_path_big = "src/test/testFiles/distancias_big.csv";
    private static String bskt_path_big = "src/test/testFiles/cabazes_big.csv";

    public ExpeditionListControllerTest() {
        company = App.getInstance().getCompany();
        loadCtrl = new LoadFileController();
        ctrl = new ExpeditionListController();
        nearestHubCtrl = new NearestHubController();
        topClosestEnterprisesCtrl = new TopClosestEnterprisesController();
        producerStore = company.getProducerStore();
        clientStore = company.getClientStore();
    }

    @BeforeEach
    void setUp() throws FileNotFoundException, InstanceNotFoundException {
        int c = 1;

        if(c==1) {
            (new LocIDFIleLoader()).Load(locID_path_small);
            (new DistancesLoader()).Load(
                    dist_path_small,
                    App.getInstance().getCompany()
                            .getMemberGraph().getMembersLocationGraph()
                            .vertices());
            (new BasketLoader()).load(bskt_path_small);
        } else if (c==2) {
            (new LocIDFIleLoader()).Load(locID_path_big);
            (new DistancesLoader()).Load(
                    dist_path_big,
                    App.getInstance().getCompany()
                            .getMemberGraph().getMembersLocationGraph()
                            .vertices());
            (new BasketLoader()).load(bskt_path_big);
        }


    }

    @AfterEach
    void tearDown() {
        Graph<Member, Double> graph = company.getMemberGraph().getMembersLocationGraph();

        ArrayList<Member> vertices = graph.vertices();

        for (Member member : vertices) {
            graph.removeVertex(member);
        }

    }

    @Test
    void invalidProducerNumber() throws InstanceNotFoundException, FileNotFoundException {
        int day = 3;
        int numberOfHubs = 5;
        int numberOfProducers = 90;

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());



        Map<Client, HubAndDistanceToAClient>  clientAndItsClosestHub =  nearestHubCtrl.getAllClientsEnterprises(
                topClosestEnterprisesCtrl.getTopNClosestEnterprises(numberOfHubs)
        );

        Throwable exception = assertThrows(IllegalArgumentException.class, () -> {
            ctrl.getExpeditionList(day, clientAndItsClosestHub, numberOfProducers);
        });

        assertEquals("Number of producers input is greater than the number of producers in the company\nTry again", exception.getMessage());

        System.out.println("Test invalidProducerNumber passed");
        System.out.println("Producer Input: " + numberOfProducers);
    }

    @Test
    void invalidProducerNumber2() throws InstanceNotFoundException, FileNotFoundException {
        int day = 3;
        int numberOfHubs = 5;
        int numberOfProducers = 0;

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());



        Map<Client, HubAndDistanceToAClient>  clientAndItsClosestHub =  nearestHubCtrl.getAllClientsEnterprises(
                topClosestEnterprisesCtrl.getTopNClosestEnterprises(numberOfHubs)
        );

        Throwable exception = assertThrows(IllegalArgumentException.class, () -> {
            ctrl.getExpeditionList(day, clientAndItsClosestHub, numberOfProducers);
        });

        assertEquals("Number of producers input has to be positive\nTry again", exception.getMessage());

        System.out.println("Test invalidProducerNumber passed");
        System.out.println("Producer Input: " + numberOfProducers);
    }

    @Test
    void getExpeditionListWithNProducers() throws InstanceNotFoundException, FileNotFoundException {
        int day = 3;
        int numberOfHubs = 5;
        int numberOfProducers = 3;

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());



        Map<Client, HubAndDistanceToAClient>  clientAndItsClosestHub =  nearestHubCtrl.getAllClientsEnterprises(
                topClosestEnterprisesCtrl.getTopNClosestEnterprises(numberOfHubs)
        );


        List<Expedition> expeditionList = ctrl.getExpeditionList(day, clientAndItsClosestHub, numberOfProducers);

        List<Expedition> noProducts = getExpeditionsWithNoProducts(expeditionList);

        System.out.println("\nClients with no products to satisfy: " + noProducts.size() + "\n");

        for(Expedition e : noProducts) {
            System.out.println("\tClient: " + e.getClientToSatisfy().getId());
            assertEquals(0, e.getProductsToDeliver().size());
        }

        List<Expedition> fullySatisfied = clientsWithTheWholeBasketSatisfied(expeditionList);

        System.out.println("\nClients with the whole basket satisfied: " + fullySatisfied.size() + "\n");

        for(Expedition e : fullySatisfied) {
            System.out.println("\tClient: " + e.getClientToSatisfy().getId());

            List<ProductInfo> productsToDeliver = e.getProductsToDeliver();

            for(ProductInfo p : productsToDeliver) {
                assertEquals(p.getQuantityDelivered(), p.getQuantityRequested());
            }
        }

        List<Expedition> partiallySatisfied = clientsPartiallySatisfied(expeditionList);

        System.out.println("\nClients partially satisfied: " + partiallySatisfied.size() + "\n");

        for(Expedition e : partiallySatisfied) {
            System.out.println("\tClient: " + e.getClientToSatisfy().getId());

            List<ProductInfo> productsToDeliver = e.getProductsToDeliver();

            int counter  = 0;

            for(ProductInfo p : productsToDeliver) {
                if(p.getQuantityDelivered() < p.getQuantityRequested()) {
                    counter++;
                }
            }

            assertTrue(counter > 0);
        }

        System.out.println("\nTotal number of expeditions: " + expeditionList.size() + "\n");

        System.out.println("\nExpedition List with N producers closest to client hub test passed!");



    }

    @Test
    void getExpeditionList() throws InstanceNotFoundException, FileNotFoundException {
        int day = 3;


        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());


        List<Expedition> expeditionList = ctrl.getExpeditionList(day);

        List<Expedition> noProducts = getExpeditionsWithNoProducts(expeditionList);

        System.out.println("\nClients with no products to satisfy: " + noProducts.size() + "\n");

        for(Expedition e : noProducts) {
            System.out.println("\tClient: " + e.getClientToSatisfy().getId());
            assertEquals(0, e.getProductsToDeliver().size());
        }

        List<Expedition> fullySatisfied = clientsWithTheWholeBasketSatisfied(expeditionList);

        System.out.println("\nClients with the whole basket satisfied: " + fullySatisfied.size() + "\n");

        for(Expedition e : fullySatisfied) {
            System.out.println("\tClient: " + e.getClientToSatisfy().getId());

            List<ProductInfo> productsToDeliver = e.getProductsToDeliver();

            for(ProductInfo p : productsToDeliver) {
                assertEquals(p.getQuantityDelivered(), p.getQuantityRequested());
            }
        }

        List<Expedition> partiallySatisfied = clientsPartiallySatisfied(expeditionList);

        System.out.println("\nClients partially satisfied: " + partiallySatisfied.size() + "\n");

        for(Expedition e : partiallySatisfied) {
            System.out.println("\tClient: " + e.getClientToSatisfy().getId());

            List<ProductInfo> productsToDeliver = e.getProductsToDeliver();

            int counter  = 0;

            for(ProductInfo p : productsToDeliver) {
                if(p.getQuantityDelivered() < p.getQuantityRequested()) {
                    counter++;
                }
            }

            assertTrue(counter > 0);
        }

        System.out.println("\nTotal number of expeditions: " + expeditionList.size() + "\n");

        System.out.println("\nExpedition List test passed!");



    }

    @Test
    void getExpeditionListInvalidDay() throws InstanceNotFoundException, FileNotFoundException {
        int day = 10;


        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable exception = assertThrows(IllegalArgumentException.class, () -> {
            ctrl.getExpeditionList(day);
        });

        String messageExpected = "No expeditions found for day " + day;

        assertEquals(messageExpected, exception.getMessage());

    }

    @Test
    void getExpeditionListInvalidDay2() throws InstanceNotFoundException, FileNotFoundException {
        int day = 10;
        int numberOfHubs = 5;
        int numberOfProducers = 3;

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());



        Map<Client, HubAndDistanceToAClient>  clientAndItsClosestHub =  nearestHubCtrl.getAllClientsEnterprises(
                topClosestEnterprisesCtrl.getTopNClosestEnterprises(numberOfHubs)
        );

        Throwable exception = assertThrows(IllegalArgumentException.class, () -> {
            ctrl.getExpeditionList(day, clientAndItsClosestHub, numberOfProducers);
        });

        String messageExpected = "No expeditions found for day " + day;

        assertEquals(messageExpected, exception.getMessage());

    }

    List<Expedition> getExpeditionsWithNoProducts(List<Expedition> expeditionList){
        List<Expedition> result = new ArrayList<>();

        for(Expedition expedition : expeditionList){
            if(expedition.getProductsToDeliver().isEmpty()){
                result.add(expedition);
            }
        }

        return result;
    }

    List<Expedition> clientsWithTheWholeBasketSatisfied(List<Expedition> expeditionList){
        List<Expedition> result = new ArrayList<>();
        boolean satisfied = true;

        for(Expedition expedition : expeditionList){

            List<ProductInfo> productsToDeliver = expedition.getProductsToDeliver();

            if(productsToDeliver.isEmpty()){
                continue;
            }

            for(ProductInfo productInfo : productsToDeliver){
                if(productInfo.getQuantityDelivered() < productInfo.getQuantityRequested()){
                    satisfied = false;
                }
            }

            if(satisfied){
                result.add(expedition);
            }

            satisfied = true;

        }

        return result;
    }

    List<Expedition> clientsPartiallySatisfied(List<Expedition> expeditionList){
        List<Expedition> result = new ArrayList<>();
        boolean satisfied = true;

        for(Expedition expedition : expeditionList){

            List<ProductInfo> productsToDeliver = expedition.getProductsToDeliver();

            if(productsToDeliver.isEmpty()){
                continue;
            }

            for(ProductInfo productInfo : productsToDeliver){
                if(productInfo.getQuantityDelivered() < productInfo.getQuantityRequested()){
                    satisfied = false;
                }
            }

            if(!satisfied){
                result.add(expedition);
            }

            satisfied = true;

        }

        return result;
    }
}