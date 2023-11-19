package Controller;

import Domain.Client;
import Domain.EnterpriseAverageDistance;
import Domain.HubAndDistanceToAClient;
import Domain.Store.Company;
import Service.NearestHubService;

import java.util.List;
import java.util.Map;

public class NearestHubController {
    NearestHubService service;

    public NearestHubController(){
        service = new NearestHubService();
    }

    public Map<Client, HubAndDistanceToAClient> getAllClientsEnterprises(List<EnterpriseAverageDistance> topNClosestEnterprises) {
        return service.getEnterprisesCloser(topNClosestEnterprises);
    }
}
