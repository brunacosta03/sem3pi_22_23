package Service.Loader;

import Controller.App;
import DataStructures.Graph.Graph;
import Domain.Member;
import Domain.Store.MemberGraph;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import javax.management.InstanceNotFoundException;
import java.io.FileNotFoundException;
import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;

class BasketLoaderTest {

    MemberGraph memberGraph;
    DistancesLoader distancesLoader;
    LocIDFIleLoader locIDFIleLoader;
    BasketLoader basketLoader;

    private static String clientesProducers_filePath_small = "src/test/testFiles/clientes-produtores_small.csv";
    private static String distances_filePath_small = "src/test/testFiles/distancias_small.csv";
    private static String basket_filePath_small = "src/test/testFiles/cabazes_small.csv";

    private static int nBasket_small = 85;
    private static int nProduct_day = 12;

    @BeforeEach
    void setUp() throws FileNotFoundException {
        locIDFIleLoader = new LocIDFIleLoader();
        distancesLoader = new DistancesLoader();
        basketLoader = new BasketLoader();
        memberGraph = App.getInstance().getCompany().getMemberGraph();
        if (memberGraph.isLoaded()) {
            memberGraph.flush();
        }
        locIDFIleLoader.Load(clientesProducers_filePath_small);
        distancesLoader.Load(distances_filePath_small, App.getInstance().getCompany().getMemberGraph().getMembersLocationGraph().vertices());
    }

    @Test
    void LoadBadPath() {
        FileNotFoundException fileNotFoundException = assertThrows(FileNotFoundException.class, () -> {
            basketLoader.load("");
        });
        System.out.println("Throws FileNotFoundException if Bad Path");
    }
    
    @Test
    @DisplayName("Loads the correct amount of baskets")
    void NBaskets() throws InstanceNotFoundException, FileNotFoundException {
        basketLoader.load(basket_filePath_small);
        int totalStock = 0;
        for (Member m : memberGraph.getMembersLocationGraph().vertices()) {
            for (int i = 1; i <= m.getStockRequestsPerDay().size(); i++) {
                totalStock += m.getStockRequestsPerDay().get(i).size();
            }
        }
        assertEquals(nBasket_small*nProduct_day, totalStock);
        System.out.println("Loads the correct amount of baskets");
    }

    @AfterEach
    void tearDown() {
        Graph<Member, Double> graph = App.getInstance().getCompany().getMemberGraph().getMembersLocationGraph();

        ArrayList<Member> vertices = graph.vertices();

        for (Member member : vertices) {
            member.removeBasket();
            graph.removeVertex(member);
        }

    }
}