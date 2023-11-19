package Service;

import Controller.App;
import DataStructures.Graph.Algorithms;
import Domain.Client;
import Domain.EnterpriseAverageDistance;
import Domain.Member;
import Domain.Store.Company;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class TopClosestEnterprisesService{

    Company company;
    List<Client> enterpriseList;
    List<Member> members;

    public TopClosestEnterprisesService() {
        this.company = App.getInstance().getCompany();
    }

    public List<EnterpriseAverageDistance> getEnterprisesAverageDistance() {
        this.enterpriseList = this.company.getEnterpriseClients();

        List<EnterpriseAverageDistance> enterpriseAverageDistanceList = new ArrayList<>();

        ArrayList<LinkedList<Member>> shortPaths = new ArrayList<>();

        for(Client c : enterpriseList) {

            ArrayList<Double> distances = new ArrayList<>();
            Double sum = (double) 0;
            Double numberOfMembers = (double) 0;

            Algorithms.shortestPaths(
                    this.company.getMemberGraph().getMembersLocationGraph(),
                    c,
                    Double::compare,
                    Double::sum,
                    0.0,
                    shortPaths,
                    distances
            );

            for(Double value : distances) {
                if(value != 0.0) {
                    sum += value;
                    numberOfMembers++;
                }
            }

            if(numberOfMembers != 0) {
                double averageDistance = sum / numberOfMembers;
                enterpriseAverageDistanceList.add(new EnterpriseAverageDistance(c, averageDistance));
            }
        }

        return enterpriseAverageDistanceList;
    }
}
