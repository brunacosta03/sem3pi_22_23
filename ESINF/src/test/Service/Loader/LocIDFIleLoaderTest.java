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
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class LocIDFIleLoaderTest {

    LocIDFIleLoader loader;

    MemberGraph memberGraph;

    private static String filePath_small = "src/test/testFiles/clientes-produtores_small.csv";
    private static int numberOfVertexes_small = 17;

    @BeforeEach
    void setup() {
        loader = new LocIDFIleLoader();
        memberGraph = App.getInstance().getCompany().getMemberGraph();

        if (memberGraph.isLoaded()) {
            memberGraph.flush();
        }
    }

    @Test
    @DisplayName("Throws FileNotFoundException if bad path to file")
    void FileBadPath(){
        assertThrows(FileNotFoundException.class, () -> {
            loader.Load("");
        });
        System.out.println("Bad File Throws FileNotFoundException");
    }

    @Test
    @DisplayName("Check if the number of vertexes loaded is correct")
    void loadNVertexes() throws FileNotFoundException {
        loader.Load(filePath_small);
        assertEquals(memberGraph.getMembersLocationGraph().vertices().size(), numberOfVertexes_small);
        System.out.println("Loads correct number of vertices");
    }

    @Test
    void verticesName() throws FileNotFoundException {
        loader.Load(filePath_small);

        List<String> vertexName = Arrays.asList(
                "C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9",
                "E1", "E2", "E3", "E4", "E5",
                "P1", "P2", "P3"
        );

        assertEquals(
                vertexName,
                memberGraph.getMembersLocationGraph()
                        .vertices().stream().map(vert -> vert.getId()).toList()
        );

        System.out.println("Loaded Vertices Name match the file");

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