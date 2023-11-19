package Domain;

public class EnterpriseAverageDistance implements Comparable<EnterpriseAverageDistance> {
    private Client client;
    private Double averageDistance;

    public EnterpriseAverageDistance(Client client, double averageDistance) {
        this.client = client;
        this.averageDistance = averageDistance;
    }

    public Client getClient() {
        return client;
    }

    public Double getAverageDistance() {
        return averageDistance;
    }

    public String toString() {
    	return "Enterprise " + client.getId() + " | Average distance: " + String.format("%.2f", averageDistance) + " meters";
    }

    @Override
    public int compareTo(EnterpriseAverageDistance o) {
        return this.averageDistance.compareTo(o.averageDistance); // this will give us the ascending order
    }
}
