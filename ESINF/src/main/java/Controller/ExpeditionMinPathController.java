package Controller;

import Domain.Expedition;
import Domain.Member;
import Service.ExpeditionMinPathService;
import dto.MinPathInfo;

import java.util.List;
import java.util.Map;

public class ExpeditionMinPathController {

    private ExpeditionMinPathService minPathService = new ExpeditionMinPathService();

    public MinPathInfo getMinPathExpedition(int day, int numberOfHubs, int numberOfProducers, Map<String, Double> originAndDestiny) {
        return minPathService.minPathExpeditionByDay(day, numberOfHubs, numberOfProducers, originAndDestiny);
    }

}
