package Domain;

public class HubAndDistanceToAClient {
    Client hub;
    Double distance;

    public HubAndDistanceToAClient(Client hub, Double distance) {
        this.hub = hub;
        this.distance = distance;
    }

    public Client getHub() {
        return hub;
    }

    public void setHub(Client hub) {
        this.hub = hub;
    }

    public Double getDistance() {
        return distance;
    }

    public void setDistance(Double distance) {
        this.distance = distance;
    }

    @Override
    public String toString() {
        return hub.getId() + " -- " + distance;
    }
}
