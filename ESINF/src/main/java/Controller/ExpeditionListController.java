package Controller;

import Domain.Client;
import Domain.EnterpriseAverageDistance;
import Domain.Expedition;
import Domain.HubAndDistanceToAClient;
import Domain.Store.ClientStore;
import Domain.Store.Company;
import Domain.Store.ProducerStore;
import Service.ExpeditionListService;
import Service.TopClosestEnterprisesService;

import javax.management.InstanceNotFoundException;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ExpeditionListController {

    private final ExpeditionListService service;
    private final NearestHubController nearestHubController;
    private final TopClosestEnterprisesController topClosestEnterprisesController;

    public ExpeditionListController() {
        this.service = new ExpeditionListService();
        this.nearestHubController = new NearestHubController();
        this.topClosestEnterprisesController = new TopClosestEnterprisesController();
    }

    public List<Expedition> getExpeditionList(int day) {
        List<Expedition> result = new ArrayList<>();
        service.saveStocks();

        for (int i = 1; i <= day; i++) {
            result = service.getExpeditionList(i);
        }

        service.resetStocks();

        if(result.size() == 0) {
            throw new IllegalArgumentException("No expeditions found for day " + day);
        }

        return result;
    }

    public List<Expedition> getExpeditionList(int day, Map<Client, HubAndDistanceToAClient> clientAndItsClosestHub, int numberOfProducers) {
        List<Expedition> result = new ArrayList<>();
        service.saveStocks();

        for (int i = 1; i <= day; i++) {
            result = service.getExpeditionList(i, clientAndItsClosestHub, numberOfProducers);
        }

        service.resetStocks();

        if(result.size() == 0) {
            throw new IllegalArgumentException("No expeditions found for day " + day);
        }

        return result;
    }

    public List<Expedition> getExpeditionListByProducerNumber(int day, int numberOfHubsDefined, int numberOfProducers) {

        List<EnterpriseAverageDistance> topNClosestEnterprises = topClosestEnterprisesController.getTopNClosestEnterprises(numberOfHubsDefined);

        Map<Client, HubAndDistanceToAClient> clientAndItsClosestHub = nearestHubController.getAllClientsEnterprises(topNClosestEnterprises);

        List<Expedition> result = getExpeditionList(day, clientAndItsClosestHub, numberOfProducers);

        return  result;
    }



}