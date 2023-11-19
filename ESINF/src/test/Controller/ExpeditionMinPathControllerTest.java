package Controller;

import DataStructures.Graph.Graph;
import Domain.Member;
import Domain.Store.ClientStore;
import Domain.Store.Company;
import Domain.Store.ProducerStore;
import Service.Loader.BasketLoader;
import Service.Loader.DistancesLoader;
import Service.Loader.LocIDFIleLoader;
import dto.MinPathInfo;
import org.junit.jupiter.api.*;


import javax.management.InstanceNotFoundException;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.*;

class ExpeditionMinPathControllerTest {

    Company company;
    ExpeditionMinPathController ctrl;
    LoadFileController loadCtrl;
    ProducerStore producerStore;
    ClientStore clientStore;

    private static String locID_path_small = "src/test/testFiles/clientes-produtores_small.csv";
    private static String dist_path_small = "src/test/testFiles/distancias_small.csv";
    private static String bskt_path_small = "src/test/testFiles/cabazes_small.csv";

    private static String locID_path_big = "src/test/testFiles/clientes-produtores_big.csv";
    private static String dist_path_big = "src/test/testFiles/distancias_big.csv";
    private static String bskt_path_big = "src/test/testFiles/cabazes_big.csv";

    public ExpeditionMinPathControllerTest() {
        company = App.getInstance().getCompany();
        ctrl = new ExpeditionMinPathController();
        loadCtrl = new LoadFileController();
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
            member.removeBasket();
            graph.removeVertex(member);
        }

    }

    @Test
    void getMinPathExpedition() throws InstanceNotFoundException, FileNotFoundException {

        new BasketLoader().load(bskt_path_small);

        producerStore.setProducerList(company.getProducers());
        clientStore.setClientList(company.getClients());

        Map<String, Double> originAndDestiny = new HashMap<>();

        MinPathInfo minimalPath =  ctrl.getMinPathExpedition(1, 1, 3, originAndDestiny);

        System.out.println("No exception thrown in 1 hub test, 1 hub test passed");


        List<Double> singularDistances = originAndDestiny.values().stream().collect(Collectors.toList());

        Double expected = 0.0;

        for (Double distance : singularDistances) {
            expected += distance;
            System.out.println("Singular Distance: " + distance);
        }
        System.out.println();

        System.out.println("Comparing singular distances with total distance: " + expected + " == " + minimalPath.getTotalDistance());
        assertEquals(expected, minimalPath.getTotalDistance());
        System.out.println("Distance test passed");


    }

}