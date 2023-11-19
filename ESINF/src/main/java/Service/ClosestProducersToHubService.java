package Service;

import Controller.App;
import DataStructures.Graph.Algorithms;
import Domain.Client;
import Domain.Member;
import Domain.Store.Company;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class ClosestProducersToHubService {

    private final Company company;

    public ClosestProducersToHubService() {
        this.company = App.getInstance().getCompany();
    }

    public List<Member> getClosestProducersToHub(Client hub, int numberOfProducers, List<Member> producers) {
        Map<Member, Double> closestProducersToHub = new HashMap<>();

        ArrayList<LinkedList<Member>> shortPaths = new ArrayList<>();

        ArrayList<Double> distances = new ArrayList<>();

        Algorithms.shortestPaths(
                this.company.getMemberGraph().getMembersLocationGraph(),
                hub,
                Double::compare,
                Double::sum,
                0.0,
                shortPaths,
                distances
        );

        for(Member producer : producers) {

            closestProducersToHub.put(
                    producer,
                    distances.get(this.company.getMemberGraph().getMembersLocationGraph().key(producer))
            );

        }

        Stream<Map.Entry<Member, Double>> producerStream = closestProducersToHub.entrySet().stream();
        producerStream = producerStream.sorted(Map.Entry.comparingByValue());

        List<Member> closestProducers = new ArrayList<>();

        for(Map.Entry<Member, Double> entry : producerStream.collect(Collectors.toList())) {
            closestProducers.add(entry.getKey());
        }

        return closestProducers.subList(0, numberOfProducers);
    }

}
