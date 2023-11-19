package Service;

import Controller.App;
import DataStructures.Graph.Algorithms;
import DataStructures.Graph.Edge;
import Domain.*;
import Domain.Store.Company;

import java.util.*;

public class NearestHubService {
    Company company;


    public NearestHubService(){
        this.company = App.getInstance().getCompany();
    }

    public Map<Client, HubAndDistanceToAClient> getEnterprisesCloser(List<EnterpriseAverageDistance> topNClosestEnterprises) {
                List<Member> members = company.getMemberGraph().getMembersLocationGraph().vertices();
                List<Client> enterprises = getEnterprises(topNClosestEnterprises);
                List<Member> finalMembers = new ArrayList<>();
                List<String> finalList = new ArrayList<>();
                Member clientID = null;
                Client entID = null;
                double distance = Double.MAX_VALUE;
                ArrayList<LinkedList<Member>> shortPath = new ArrayList<>();

                Map<Client, HubAndDistanceToAClient> clientHubAndDistanceToAClientMap = new HashMap<>();
                for (Member m : members) {

                    ArrayList<Double> distances = new ArrayList<>();
                    if (!(m instanceof Producer)) {
                        Algorithms.shortestPaths(
                                this.company.getMemberGraph().getMembersLocationGraph(),
                                m,
                                Double::compare,
                                Double::sum,
                                0.0,
                                shortPath,
                                distances);
                        for (Client e : enterprises) {
                            Double dist = distances.get(this.company.getMemberGraph().getMembersLocationGraph().key(e));
                            if (distance > dist && e!=m) {
                                distance = dist;
                                clientID = m;
                                entID = e;
                            }
                        }
                    }
                    if (!finalMembers.contains(clientID)) {
                        String enterpriseClient = clientID.getId() + " -- " + entID.getId() + " -- " + distance;
                        finalList.removeIf(enterpriseClient::equals);
                        finalList.add(enterpriseClient);
                        finalMembers.add(clientID);

                        clientHubAndDistanceToAClientMap.put((Client) clientID, new HubAndDistanceToAClient(entID, distance));

                    }

                    distance = Double.MAX_VALUE;
                }


            return clientHubAndDistanceToAClientMap;
        }

        public List<Client> getEnterprises(List<EnterpriseAverageDistance> topNClosestEnterprises){
                List<Client> enterprises = new ArrayList<>();
                for(EnterpriseAverageDistance c : topNClosestEnterprises){
                        enterprises.add(c.getClient());
                    }
            return enterprises;
        }

}
