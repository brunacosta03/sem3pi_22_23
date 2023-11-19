package dto;

import Domain.Client;
import Domain.Member;
import Domain.ProductInfo;

import java.util.List;
import java.util.Map;

public class MinPathInfo{

    List<Member> path;
    double totalDistance;
    Map<Client, List<ProductInfo>> infoHubs;

    public MinPathInfo(List<Member> path, double totalDistance, Map<Client, List<ProductInfo>> infoHubs) {
        this.path = path;
        this.totalDistance = totalDistance;
        this.infoHubs = infoHubs;
    }

    public List<Member> getPath() {
        return path;
    }

    public double getTotalDistance() {
        return totalDistance;
    }

    public Map<Client, List<ProductInfo>> getInfoHubs() {
        return infoHubs;
    }
}
