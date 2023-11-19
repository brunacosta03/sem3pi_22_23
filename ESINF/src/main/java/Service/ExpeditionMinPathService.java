package Service;

import Comparator.SortByWeight;
import Controller.App;
import Controller.ExpeditionListController;
import Controller.NearestHubController;
import Controller.TopClosestEnterprisesController;
import DataStructures.Graph.Algorithms;
import DataStructures.Graph.Edge;
import DataStructures.Graph.Graph;
import Domain.*;
import Domain.Store.MemberGraph;
import Domain.Store.ProducerStore;
import dto.MinPathInfo;

import java.util.*;
import java.util.stream.Collectors;

public class ExpeditionMinPathService {

    NearestHubController nhCtrl;
    NearestHubService nhService;
    TopClosestEnterprisesController tceCtrl;

    ExpeditionListController expCtrl;
    MemberGraph memberGraph;
    ProducerStore ps;

    public ExpeditionMinPathService() {
        nhCtrl = new NearestHubController();
        nhService = new NearestHubService();
        tceCtrl = new TopClosestEnterprisesController();
        expCtrl = new ExpeditionListController();
        ps = App.getInstance().getCompany().getProducerStore();
        memberGraph = App.getInstance().getCompany().getMemberGraph();
    }

    private List<Member> getProducersOfExpedition(Expedition e) {

        List<Member> m = new ArrayList<>();

        for (ProductInfo pi : e.getProductsToDeliver()) {
            Member p = ps.getProducerStore()
                    .stream().filter(prdcr -> prdcr.getId().equals(pi.getProducerCode()))
                    .findFirst()
                    .orElse(null);
            if (p!=null && !m.contains(p)) {
                m.add(p);
            }
            else if (p==null) {
                //System.out.println("Could not read: " + pi.getProducerCode());
            }

        }

        return m;
    }

    private List<Member> getProducersOfExpeditions(List<Expedition> expeditions){
        List<Member> m = new ArrayList<>();

        for (Expedition exp : expeditions) {
            for (Member mem : getProducersOfExpedition(exp)) {
                if(!m.contains(mem))
                    m.add(mem);
            }
        }

        return m;
    }

    /**
     * Calcula o caminho minimo de entrega de uma Expedição.
     * O algoritmo passa pelos produtores primeiramente e depois passa pelos hubs (empresas)
     *
     * @param day
     * @param numberOfHubs
     * @return LinkedList - Caminho da expedição
     * @see Expedition
     */
    public MinPathInfo minPathExpeditionByDay(int day, int numberOfHubs, int numberOfProducers, Map<String, Double> originAndDestiny) {

        List<Expedition> expeditions = numberOfProducers==-1?expCtrl.getExpeditionList(day):expCtrl.getExpeditionListByProducerNumber(day, numberOfHubs, numberOfProducers);
        List<Member> producersInvolved = getProducersOfExpeditions(expeditions);
        List<Member> hubsInvolved = getHubsInvolved(numberOfHubs);

        Double distance = Double.valueOf(0.0);

        List<Map.Entry<String, Double>> originAndDestinyList = new ArrayList<>();

        // Choose Starting Producer
        Member p1 = producersInvolved.get(0);

        LinkedList<Member> path = new LinkedList<>();
        path.add(p1);

        List<Member> passed = new ArrayList<>();
        passed.add(p1);


        /**
         * Find the closest Producers and the paths between them until all producer have been covered
         */
        List<Member> piClone = new ArrayList<>(producersInvolved);
        while (piClone.size()>0) {

            Member closest = searchClosestProducer(path.getLast(), memberGraph.getMembersLocationGraph(), producersInvolved, passed);



            LinkedList<Member> pathToClosest = new LinkedList<>();

            Double dist = Algorithms.shortestPath(
                    memberGraph.getMembersLocationGraph(),
                    path.getLast(),
                    closest,
                    Double::compare,
                    Double::sum,
                    Double.sum(0,0),
                    pathToClosest
            );

            if(dist != null)
                originAndDestiny.put(path.getLast().getId() + "-" + closest.getId(), dist);

            distance = distance + (dist==null?0:dist);

            piClone.remove(path.getLast());

            // Add pathToClosest to path
            for (int j = 0; j < pathToClosest.size(); j++) {
                if (!(j==0 && pathToClosest.get(j).equals(path.getLast()))) {
                    path.add(pathToClosest.get(j));

                }
            }
        }

        List<Member> hubsClone = new ArrayList<>(hubsInvolved);
        passed = new ArrayList<>();
        while (hubsClone.size()>0) {

            Member closestHub = searchClosestHub(path.getLast(), memberGraph.getMembersLocationGraph(), hubsInvolved, passed);

            LinkedList<Member> pathToClosest = new LinkedList<>();

            Double dist = Algorithms.shortestPath(
                    memberGraph.getMembersLocationGraph(),
                    path.getLast(),
                    closestHub,
                    Double::compare,
                    Double::sum,
                    Double.sum(0,0),
                    pathToClosest
            );

            if(dist != null)
                originAndDestiny.put(path.getLast().getId() + "-" + closestHub.getId(), dist);

            distance = distance + (dist==null?0:dist);

            hubsClone.remove(closestHub);

            // Add pathToClosest to path
            for (int j = 0; j < pathToClosest.size(); j++) {
                if (!(j==0 && pathToClosest.get(j).equals(path.getLast()))) {
                    path.add(pathToClosest.get(j));

                }
            }
        }

        Map<Client, HubAndDistanceToAClient> map = nhCtrl.getAllClientsEnterprises(tceCtrl.getTopNClosestEnterprises(numberOfHubs));

        Map<Client, List<ProductInfo>> hubAndTheProductsItOwns = new HashMap<>();

        for (Expedition e : expeditions) {
            Client hub;

            if(map.get(e.getClientToSatisfy()) == null)
                hub = e.getClientToSatisfy();
            else
                hub = map.get(e.getClientToSatisfy()).getHub();


            List<ProductInfo> products = e.getProductsToDeliver();

            if(!hubAndTheProductsItOwns.containsKey(hub)){

                //filter all products that have no producer
                List<ProductInfo> productsWithProducer = products
                        .stream().filter(
                                p -> !p.getProducerCode().equals("No Producer")
                        ).collect(Collectors.toList());

                hubAndTheProductsItOwns.put(hub, new ArrayList<>(productsWithProducer));
            }else{
                List<ProductInfo> containsKey = hubAndTheProductsItOwns.get(hub);

                //filter all products that have no producer
                List<ProductInfo> productsWithProducer = products
                        .stream().filter(
                                p -> !p.getProducerCode().equals("No Producer")
                        ).collect(Collectors.toList());

                containsKey.addAll(productsWithProducer);
            }

        }



        return new MinPathInfo(path, distance, hubAndTheProductsItOwns);
    }

    private List<Member> getHubsInvolved(int numberOfHubs) {
        return nhService.getEnterprises(tceCtrl.getTopNClosestEnterprises(numberOfHubs))
                .stream().map(client -> (Member) client).toList();
    }


    /**
     * Finds the closest Member that is a Producer.
     * Returns null if not found
     *
     * @param v Initial Member of the search
     * @param graph That Graph in which the search will happen
     * @param memberFilter Members to be considered
     * @param passed Members that have been already passed through
     * @return
     */
    public Member searchClosestProducer(Member v, Graph<Member, Double> graph, List<Member> memberFilter, List<Member> passed) {

        List<Edge<Member, Double>> adjMember = (List<Edge<Member, Double>>) memberGraph.getMembersLocationGraph().outgoingEdges(v);
        adjMember.sort(new SortByWeight());

        // Algoritmo pode ser otimizado
        List<Member> search = Algorithms.BreadthFirstSearch(graph, v);

        for (Member m : search) {
            if (m instanceof Producer && !m.equals(v) && !passed.contains(m) && memberFilter.contains(m)) {
                memberFilter.remove(m);
                passed.add(m);
                return m;
            }
        }
        return null;
    }

    public Member searchClosestHub(Member v, Graph<Member, Double> graph, List<Member> memberFilter, List<Member> passed) {

        List<Edge<Member, Double>> adjMember = (List<Edge<Member, Double>>) memberGraph.getMembersLocationGraph().outgoingEdges(v);
        adjMember.sort(new SortByWeight());

        // Algoritmo pode ser otimizado
        List<Member> search = Algorithms.BreadthFirstSearch(graph, v);

        for (Member m : search) {
            if (m instanceof Client && ((Client) m).getClientType().equals(ClientType.ENTERPRISE) && !m.equals(v) && !passed.contains(m) && memberFilter.contains(m)) {
                //memberFilter.remove(memberFilter.indexOf(m));
                passed.add(m);
                return m;
            }
        }
        return null;
    }
}
