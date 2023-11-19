package Service.Loader;

import Controller.App;
import DataStructures.Graph.Graph;
import Domain.Member;
import Domain.Store.MemberGraph;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.FileNotFoundException;
import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;

class DistancesLoaderTest {

    MemberGraph memberGraph;
    DistancesLoader distancesLoader;
    LocIDFIleLoader locIDFIleLoader;

    private static String clientesProducers_filePath_small = "src/test/testFiles/clientes-produtores_small.csv";
    private static String distances_filePath_small = "src/test/testFiles/distancias_small.csv";
    private static int nOutEdgesFile = 66;

    @BeforeEach
    void setUp() throws FileNotFoundException {
        locIDFIleLoader = new LocIDFIleLoader();
        distancesLoader = new DistancesLoader();
        memberGraph = App.getInstance().getCompany().getMemberGraph();
        if (memberGraph.isLoaded()) {
            memberGraph.flush();
        }
        locIDFIleLoader.Load(clientesProducers_filePath_small);
    }

    @Test
    @DisplayName("Throws File Not Found Exception if Bad Path")
    void LoadBadPath() {
        System.out.println("Throws FileNotFoundException if Bad File Path");
        assertThrows(FileNotFoundException.class, () -> {
            distancesLoader.Load("", memberGraph.getMembersLocationGraph().vertices());
        });
    }

    @Test
    void LoadNEdges() throws FileNotFoundException {
        distancesLoader.Load(distances_filePath_small, memberGraph.getMembersLocationGraph().vertices());
        assertEquals(nOutEdgesFile, memberGraph.getMembersLocationGraph().edges().size());
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