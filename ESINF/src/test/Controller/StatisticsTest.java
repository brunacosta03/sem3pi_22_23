package Controller;

import DataStructures.Graph.Graph;
import Domain.Client;
import Domain.Member;
import Domain.Store.ClientStore;
import Domain.Store.Company;
import Domain.Store.ProducerStore;
import Service.Loader.BasketLoader;
import Service.Loader.DistancesLoader;
import Service.Loader.LocIDFIleLoader;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.management.InstanceNotFoundException;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;


import static org.junit.jupiter.api.Assertions.*;

public class StatisticsTest {
    Company company;
    LoadFileController loadCtrl;
    StatisticsController statCtrl;
    ExpeditionListController expListCtrl;
    NearestHubController nearestHubCtrl;
    TopClosestEnterprisesController topClosestEnterprisesCtrl;
    ProducerStore producerStore;
    ClientStore clientStore;

    public static final String ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY = "The day number should be a number over 0.\nTry again.\n";
    public static final String GREATER_PRODUCERS = "The number of producers in the system is lower than the value defined\n Try again\n";
    public static final String GREATER_HUBS = "The number of hubs in the system is lower than the value defined\nTry again\n";
    public static final String NEGATIVE_PRODUCERS = "The number of producers defined should be a positive number\nTryagain\n";
    public static final String NEGATIVE_HUBS = "The number of hubs defined should be a positive number\nTry again\n";

    private static String locID_path_small = "src/test/testFiles/clientes-produtores_small.csv";
    private static String dist_path_small = "src/test/testFiles/distancias_small.csv";
    private static String bskt_path_small = "src/test/testFiles/cabazes_small.csv";

    private static String locID_path_big = "src/test/testFiles/clientes-produtores_big.csv";
    private static String dist_path_big = "src/test/testFiles/distancias_big.csv";
    private static String bskt_path_big = "src/test/testFiles/cabazes_big.csv";

    public StatisticsTest(){
        company = App.getInstance().getCompany();
        loadCtrl = new LoadFileController();
        statCtrl = new StatisticsController();
        expListCtrl = new ExpeditionListController();
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
    void wrongDayCabazDay() throws InstanceNotFoundException, FileNotFoundException {

        int day = -10;

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listsCabaz(day));

        assertEquals(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY, e.getMessage());

    }
    @Test
    void rightCabazDay() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        List<Double> list =  statCtrl.listsCabaz(day);

        assertEquals(list.size(), 5*expListCtrl.getExpeditionList(1).size());

    }
    @Test
    void wrongDayCabazDayProdHub() throws InstanceNotFoundException, FileNotFoundException {

        int day = -10;
        int nProd = 3;
        int nHubs = 5;

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listsCabaz(day, nHubs, nProd));

        assertEquals(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY, e.getMessage());

    }
    @Test
    void lowerProdCabazDayProdHub() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nProd = -1;
        int nHubs = 5;

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listsCabaz(day, nHubs, nProd));

        assertEquals(NEGATIVE_PRODUCERS, e.getMessage());

    }
    @Test
    void lowerHubCabazDayProdHub() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nProd = 3;
        int nHubs = -2;

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listsCabaz(day, nHubs, nProd));

        assertEquals(NEGATIVE_HUBS, e.getMessage());

    }
    @Test
    void greaterProdCabazDayProdHub() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nProd = 5;
        int nHubs = 5;

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listsCabaz(day, nHubs, nProd));

        assertEquals(GREATER_PRODUCERS, e.getMessage());

    }
    @Test
    void greaterHubCabazDayProdHub() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nProd = 3;
        int nHubs = 10;

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listsCabaz(day, nHubs, nProd));

        assertEquals(GREATER_HUBS, e.getMessage());

    }
    @Test
    void rightCabazDayHubProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = 5;
        int nProd = 3;

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        List<Double> list =  statCtrl.listsCabaz(day, nHub, nProd);

        assertEquals(list.size(), 5*expListCtrl.getExpeditionList(1).size());

    }
    @Test
    void wrongDayClientDay() throws InstanceNotFoundException, FileNotFoundException {

        int day = -3;
        String code = "C1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listClient(day, code));

        assertEquals(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY, e.getMessage());

    }
    @Test
    void wrongClientClientDay() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        String code = "C24";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listClient(day, code));

        assertEquals("The client isn't defined in the system", e.getMessage());

    }
    @Test
    void rightClientDay() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        String code = "C1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        List<Double> list =  statCtrl.listClient(day, code);

        assertEquals(list.size(), 3);

    }
    @Test
    void wrongDayClientDayHubProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = -3;
        int nHubs = 5;
        int nProd = 3;
        String code = "C1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listClient(day, code, nHubs, nProd));

        assertEquals(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY, e.getMessage());
    }
    @Test
    void wrongClientClientDayHubProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHubs = 5;
        int nProd = 3;
        String code = "C24";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listClient(day, code, nHubs, nProd));

        assertEquals("The client isn't defined in the system", e.getMessage());

    }
    @Test
    void lowerHubClientDayHubProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHubs = 0;
        int nProd = 3;
        String code = "C1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listClient(day, code, nHubs, nProd));

        assertEquals(NEGATIVE_HUBS, e.getMessage());

    }
    @Test
    void greaterHubClientDayHubProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHubs = 10;
        int nProd = 3;
        String code = "C1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listClient(day, code, nHubs, nProd));

        assertEquals(GREATER_HUBS, e.getMessage());

    }
    @Test
    void lowerProdClientDayHubProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHubs = 5;
        int nProd = -4;
        String code = "C1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listClient(day, code, nHubs, nProd));

        assertEquals(NEGATIVE_PRODUCERS, e.getMessage());

    }
    @Test
    void greaterProdClientDayHubProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHubs = 5;
        int nProd = 10;
        String code = "C1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listClient(day, code, nHubs, nProd));

        assertEquals(GREATER_PRODUCERS, e.getMessage());
    }
    @Test
    void wrongClientDayProdHub() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = 5;
        int nProd = 3;
        String code = "C1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        List<Double> list =  statCtrl.listClient(day, code, nHub, nProd);

        assertEquals(list.size(), 3);

    }
    @Test
    void wrongDayProdDay() throws InstanceNotFoundException, FileNotFoundException {

        int day = -2;
        String code = "P1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listProducer(day, code));

        assertEquals(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY, e.getMessage());
    }
    @Test
    void wrongProdProdDay() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        String code = "P67";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listProducer(day, code));

        assertEquals("The producer isn't defined in the system\n", e.getMessage());
    }
    @Test
    void rightProdDay() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        String code = "P1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        List<Double> list =  statCtrl.listProducer(day, code);

        assertEquals(list.size(), 5);

    }
    @Test
    void wrongDayProdDayHubProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = -3;
        int nHub = 5;
        int nProd = 3;
        String code = "P1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listProducer(day, code, nHub, nProd));

        assertEquals(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY, e.getMessage());
    }
    @Test
    void wrongProdProdDayHubProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = 5;
        int nProd = 3;
        String code = "P67";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listProducer(day, code, nHub, nProd));

        assertEquals("The producer isn't defined in the system\n", e.getMessage());
    }

    @Test
    void lowerHubProdDayHubProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = -4;
        int nProd = 3;
        String code = "P1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listProducer(day, code, nHub, nProd));

        assertEquals(NEGATIVE_HUBS, e.getMessage());
    }
    @Test
    void greaterHubProdDayHubProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = 50;
        int nProd = 3;
        String code = "P1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listProducer(day, code, nHub, nProd));

        assertEquals(GREATER_HUBS, e.getMessage());
    }
    @Test
    void lowerProdProdDayHubProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = 5;
        int nProd = -50;
        String code = "P1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listProducer(day, code, nHub, nProd));

        assertEquals(NEGATIVE_PRODUCERS, e.getMessage());
    }
    @Test
    void greaterProdProdDayHubProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = 5;
        int nProd = 10;
        String code = "P1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listProducer(day, code, nHub, nProd));

        assertEquals(GREATER_PRODUCERS, e.getMessage());
    }
    @Test
    void rightProdDayHubProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = 5;
        int nProd = 3;
        String code = "P1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        List<Double> list =  statCtrl.listProducer(day, code, nHub, nProd);

        assertEquals(list.size(), 5);

    }
    @Test
    void wrongDayHubDay() throws InstanceNotFoundException, FileNotFoundException {

        int day = -6;
        int nHub = 5;
        String code = "E1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listHub(nHub, code,day));

        assertEquals(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY, e.getMessage());
    }
    @Test
    void wrongHubHubDay() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = 5;
        String code = "E12";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listHub(nHub, code,day));

        assertEquals("The hub isn't defined in the system", e.getMessage());
    }
    @Test
    void lowerHubsHubDay() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = -1;
        String code = "E1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listHub(nHub, code,day));

        assertEquals(NEGATIVE_HUBS, e.getMessage());
    }
    @Test
    void greaterHubsHubDay() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = 10;
        String code = "E1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listHub(nHub, code,day));

        assertEquals(GREATER_HUBS, e.getMessage());
    }
    @Test
    void rightHubDay() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = 5;
        String code = "E1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        List<Double> list =  statCtrl.listHub(nHub, code, day);

        assertEquals(list.size(), 2);

    }
    @Test
    void wrongDayHubDayProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = -50;
        int nHub = 5;
        int nProd = 3;
        String code = "E1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listHub(nHub, code,day, nProd));

        assertEquals(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY, e.getMessage());
    }
    @Test
    void wrongHubHubDayProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = 5;
        int nProd = 3;
        String code = "E12";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listHub(nHub, code,day, nProd));

        assertEquals("The hub isn't defined in the system", e.getMessage());
    }
    @Test
    void lowerHubsHubDayProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = -50;
        int nProd = 3;
        String code = "E1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listHub(nHub, code,day, nProd));

        assertEquals(NEGATIVE_HUBS, e.getMessage());
    }
    @Test
    void greaterHubsHubDayProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = 30;
        int nProd = 3;
        String code = "E1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listHub(nHub, code,day, nProd));

        assertEquals(GREATER_HUBS, e.getMessage());
    }
    @Test
    void lowerProdsHubDayProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = 5;
        int nProd = -7;
        String code = "E1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listHub(nHub, code,day, nProd));

        assertEquals(NEGATIVE_PRODUCERS, e.getMessage());
    }
    @Test
    void greaterProdsHubDayProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = 5;
        int nProd = 30;
        String code = "E1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Throwable e = assertThrows(IllegalArgumentException.class, () ->  statCtrl.listHub(nHub, code,day, nProd));

        assertEquals(GREATER_PRODUCERS, e.getMessage());
    }
    @Test
    void rightHubDayProd() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;
        int nHub = 5;
        int nProd = 3;
        String code = "E1";

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        List<Double> list =  statCtrl.listHub(nHub, code, day, nProd);

        assertEquals(list.size(), 2);

    }
    @Test
    void cabazSize() throws InstanceNotFoundException, FileNotFoundException {

        int day = 3;

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        List<Double> list =  statCtrl.listsCabaz(3);
        List<Client> clients = statCtrl.clientsCabaz();

        assertEquals(company.getClients().size(), clients.size());

    }

}
