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
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class TopClosestEnterprisesControllerTest {


    private TopClosestEnterprisesController ctrl;
    private LoadFileController loadctrl;
    ProducerStore producerStore;
    ClientStore clientStore;
    Company company;
    private final String clientProducerSmallfile = "src/main/resources/Small/clientes-produtores_small.csv";
    private final String distancesSmallfile = "src/main/resources/Small/distancias_small.csv";

    public TopClosestEnterprisesControllerTest() {
        company = App.getInstance().getCompany();
        this.ctrl = new TopClosestEnterprisesController();
        this.loadctrl = new LoadFileController();
        this.producerStore = App.getInstance().getCompany().getProducerStore();
        this.clientStore = App.getInstance().getCompany().getClientStore();
    }

    @AfterEach
    void tearDown() {
        Graph<Member, Double> graph = company.getMemberGraph().getMembersLocationGraph();

        ArrayList<Member> vertices = graph.vertices();

        for (Member member : vertices) {
            graph.removeVertex(member);
        }

        //for(Member client : clientStore.getMemberRequest()){
          //  clientStore.getMemberRequest().remove(client);
        //}

        //for(Member producer : producerStore.getProducerStore()) {
          //  producerStore.getProducerStore().remove(producer);
        //}
    }

    @Test
    void TestGetTopNClosestEnterprises() throws InstanceNotFoundException, FileNotFoundException {
        List<String> expected = new ArrayList<>();
        int n = 5;

        expected.add("E3");
        expected.add("E4");
        expected.add("E2");
        expected.add("E1");
        expected.add("E5");

        loadctrl.LoadLocationIDFile(clientProducerSmallfile);
        loadctrl.LoadDistancesFile(distancesSmallfile);

        List<EnterpriseAverageDistance> actual = ctrl.getTopNClosestEnterprises(n);

        assertEquals(n, actual.size());
        assertEquals(n, expected.size());


        for (int i = 0; i < n; i++) {
            assertEquals(expected.get(i), actual.get(i).getClient().getId());
        }
        System.out.println("\nAll enterprise ID'S/Distances were the same.\nTest passed");

        DataFlusher.flush();
    }

    @Test
    void testInvalidN() throws FileNotFoundException, InstanceNotFoundException {
        final int N_NEGATIVE = -1;
        final int N_ZERO = 0;
        final int N_GREATER_THAN_ENTERPRISES = 100;

        loadctrl.LoadLocationIDFile(clientProducerSmallfile);
        loadctrl.LoadDistancesFile(distancesSmallfile);

        Throwable exceptionNegative = assertThrows(IllegalArgumentException.class, () -> {
            ctrl.getTopNClosestEnterprises(N_NEGATIVE);
        });

        Throwable exceptionZero = assertThrows(IllegalArgumentException.class, () -> {
            ctrl.getTopNClosestEnterprises(N_ZERO);
        });

        Throwable exceptionGreaterThanEnterprises = assertThrows(IllegalArgumentException.class, () -> {
            ctrl.getTopNClosestEnterprises(N_GREATER_THAN_ENTERPRISES);
        });

        assertEquals(
                TopClosestEnterprisesController
                        .ERROR_MESSAGE_NEGATIVE_OR_ZERO_NUMBER,
                exceptionNegative.getMessage()
        );

        assertEquals(
                TopClosestEnterprisesController
                        .ERROR_MESSAGE_NEGATIVE_OR_ZERO_NUMBER,
                exceptionZero.getMessage()
        );

        assertEquals(
                TopClosestEnterprisesController
                        .ERROR_MESSAGE_MORE_ENTERPRISES,
                exceptionGreaterThanEnterprises.getMessage()
        );

        DataFlusher.flush();

        System.out.println("\nAll exceptions were thrown.\nTest passed");
    }

}