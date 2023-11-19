package Service;

import Controller.App;
import Controller.ExpeditionListController;
import Controller.TopClosestEnterprisesController;
import DataStructures.Graph.Algorithms;
import Domain.*;
import Domain.Store.ClientStore;
import Domain.Store.Company;
import Domain.Store.ProducerStore;

import java.util.*;

public class StatisticsService {
    ExpeditionListService service;
    NearestHubService nearestHubService;
    Company comp;
    ClientStore clientStore;
    ProducerStore producerStore;
    TopClosestEnterprisesController topClosestEnterprisesCtrl;
    List<Expedition> expList;

    List<Client> allClientsCabaz;

    public StatisticsService(){
        service = new ExpeditionListService();
        nearestHubService = new NearestHubService();
        topClosestEnterprisesCtrl = new TopClosestEnterprisesController();
        comp = App.getInstance().getCompany();
        clientStore = comp.getClientStore();
        producerStore = comp.getProducerStore();
        allClientsCabaz = new ArrayList<>();
        expList=new ArrayList<>();
    }
    public List<Client> getAllClientsCabaz(){
        return allClientsCabaz;
    }
    public List<Double> cabazStatistics(int day, int nHubs, int nProducers){
        List<Double> statistics = new ArrayList<>();
        expList = service.getExpeditionList(day, nearestHubService.getEnterprisesCloser(topClosestEnterprisesCtrl.getTopNClosestEnterprises(nHubs)), nProducers);
        for(Expedition e: expList){
                List<ProductInfo> info = e.getProductsToDeliver();
                double totalProdCompleto = 0;
                double prodNulo = 0;
                double parcialProd = 0;
                double totalQuantityRequested = 0;
                double totalQuantityDelivered = 0;
                List<String> producers = new ArrayList<>();
                for (ProductInfo prod : info) {
                    if (Objects.equals(prod.getQuantityRequested(), prod.getQuantityDelivered())) {
                        totalProdCompleto++;
                    }
                    if (prod.getQuantityDelivered() == 0) {
                        prodNulo++;
                    }
                    if (prod.getQuantityDelivered() < prod.getQuantityRequested() && prod.getQuantityDelivered()!=0) {
                        parcialProd++;
                    }
                    producers.removeIf(s -> s.equals(prod.getProducerCode()));
                    producers.add(prod.getProducerCode());
                    totalQuantityDelivered += prod.getQuantityDelivered();
                    totalQuantityRequested += prod.getQuantityRequested();
                }
                statistics.add(totalProdCompleto);
                statistics.add(parcialProd);
                statistics.add(prodNulo);
                double percentSatisfeito = totalQuantityDelivered * 100 / totalQuantityRequested ;
                statistics.add(percentSatisfeito);
                statistics.add((double) producers.size());
                allClientsCabaz.add(e.getClientToSatisfy());
            }
        return statistics;
    }
    public List<Double> cabazStatistics(int day){
        List<Double> statistics = new ArrayList<>();
        expList = service.getExpeditionList(day);
        for(Expedition e: expList){
            List<ProductInfo> info = e.getProductsToDeliver();
            double totalProdCompleto = 0;
            double prodNulo = 0;
            double parcialProd = 0;
            double totalQuantityRequested = 0;
            double totalQuantityDelivered = 0;
            List<String> producers = new ArrayList<>();
            for (ProductInfo prod : info) {
                if (Objects.equals(prod.getQuantityRequested(), prod.getQuantityDelivered())) {
                    totalProdCompleto++;
                }
                if (prod.getQuantityDelivered() == 0) {
                    prodNulo++;
                }
                if (prod.getQuantityDelivered() < prod.getQuantityRequested() && prod.getQuantityDelivered()!=0) {
                    parcialProd++;
                }
                producers.removeIf(s -> s.equals(prod.getProducerCode()));
                producers.add(prod.getProducerCode());
                totalQuantityDelivered += prod.getQuantityDelivered();
                totalQuantityRequested += prod.getQuantityRequested();
            }
            statistics.add(totalProdCompleto);
            statistics.add(parcialProd);
            statistics.add(prodNulo);
            double percentSatisfeito = totalQuantityDelivered * 100 / totalQuantityRequested ;
            statistics.add(percentSatisfeito);
            statistics.add((double) producers.size());

            if(!allClientsCabaz.contains(e.getClientToSatisfy())){
                allClientsCabaz.add(e.getClientToSatisfy());
            }
        }
        return statistics;
    }
    public List<Double> clienteStatistics(int maxDay, String clientName, int nHubs, int nProducers){
        double totalCabazesComp = 0;
        double totalCabazesParciais = 0;
        List<String> producers = new ArrayList<>();

        List<Double> statistics = new ArrayList<>();

        for(int i = 1; i < maxDay+1; i++) {
            expList = service.getExpeditionList(i, nearestHubService.getEnterprisesCloser(topClosestEnterprisesCtrl.getTopNClosestEnterprises(nHubs)), nProducers);
            if(expList==null){
                break;
            }
            for (Expedition e : expList) {
                if (e.getClientToSatisfy().getId().equals(clientName)) {
                    int count = 0;
                    int count2 =0;
                    for(ProductInfo prod : e.getProductsToDeliver()){
                        if(prod.getQuantityDelivered()==0){
                            count++;
                        }
                        if(prod.getQuantityDelivered()!=0 && prod.getQuantityDelivered()<prod.getQuantityRequested()){
                            count2++;
                        }
                        if(!producers.contains(prod.getProducerCode()) && prod.getProducerCode()!="No Producer"){
                            producers.add(prod.getProducerCode());
                        }
                    }
                    if(count!=e.getProductsToDeliver().size()){
                        if(count==0 && count2 ==0){
                            totalCabazesComp++;
                        }else if(count2>0){
                            totalCabazesParciais++;
                        }
                    }
                    break;
                }
            }
        }
        statistics.add(totalCabazesComp);
        statistics.add(totalCabazesParciais);
        statistics.add((double)producers.size());
        return statistics;
    }
    public List<Double> clienteStatistics(int maxDay, String clientName){
        double totalCabazesComp = 0;
        double totalCabazesParciais = 0;
        List<String> producers = new ArrayList<>();

        List<Double> statistics = new ArrayList<>();

        for(int i = 1; i < maxDay+1; i++) {
            expList = service.getExpeditionList(i);
            if(expList==null){
                break;
            }
            for (Expedition e : expList) {
                if (e.getClientToSatisfy().getId().equals(clientName)) {
                    int count = 0;
                    int count2 = 0;
                    for(ProductInfo prod : e.getProductsToDeliver()){
                        if(prod.getQuantityDelivered()==0){
                            count++;
                        }
                        if(prod.getQuantityDelivered()!=0 && prod.getQuantityDelivered()<prod.getQuantityRequested()){
                            count2++;
                        }
                        if(!producers.contains(prod.getProducerCode()) && prod.getProducerCode()!="No Producer"){
                            producers.add(prod.getProducerCode());
                        }
                    }
                    if(count!=e.getProductsToDeliver().size()){
                        if(count==0 && count2 ==0){
                            totalCabazesComp++;
                        }else if(count2>0){
                            totalCabazesParciais++;
                        }
                    }
                    break;
                }
            }
        }
        statistics.add(totalCabazesComp);
        statistics.add(totalCabazesParciais);
        statistics.add((double)producers.size());
        return statistics;
    }
    public List<Double> produtorStatistics(int maxDay, String producerName, int maxHub, int maxProd){

        double totalCabazesComp = 0;
        double totalCabazesParciais = 0;
        double countStock = 0;

        List<String> clients = new ArrayList<>();
        List<String> hubs = new ArrayList<>();
        List<Double> statistics = new ArrayList<>();

        List<Member> producers = comp.getProducerStore().getProducerStore();
        Producer producer = null;
        for(Member m : producers){
            if (m.getId().equals(producerName)){
                producer = (Producer) m;
                break;
            }
        }
        if(producer!=null) {
            for (int i = 1; i < maxDay + 1; i++) {
                expList = service.getExpeditionList(i, nearestHubService.getEnterprisesCloser(topClosestEnterprisesCtrl.getTopNClosestEnterprises(maxHub)), maxProd);
                if (expList == null) {
                    break;
                }
                for (Expedition e : expList) {
                    int count = 0;
                    int count2 = 0;
                    for (ProductInfo prod : e.getProductsToDeliver()) {
                        if (prod.getProducerCode().equals(producerName)) {
                            if (String.valueOf(e.getClientToSatisfy().getId().charAt(0)).equals("C")) {
                                clients.removeIf(c -> c.equals(e.getClientToSatisfy().getId()));
                                clients.add(e.getClientToSatisfy().getId());
                            }
                            if (String.valueOf(e.getClientToSatisfy().getId().charAt(0)).equals("E")) {
                                hubs.removeIf(c -> c.equals(e.getClientToSatisfy().getId()));
                                hubs.add(e.getClientToSatisfy().getId());
                            }
                            if (prod.getQuantityDelivered() == prod.getQuantityRequested()) {
                                count++;
                            }else
                            if (prod.getQuantityDelivered() > 0) {
                                count2++;
                            }
                        }
                    }
                    if (count == e.getProductsToDeliver().size() && !e.getProductsToDeliver().isEmpty()) {
                        totalCabazesComp++;
                    } else if (count2 > 0) {
                        totalCabazesParciais++;
                    }
                }
            }
            statistics.add(totalCabazesComp); // Ponto 1
            statistics.add(totalCabazesParciais); // Ponto 2

            statistics.add((double) clients.size()); // Ponto 3

            for (ProductStock stock : producer.getStockOfDay(maxDay)) {
                if (stock.getQuantity() <= 0) {
                    countStock++;
                }// Ponto 4
            }
            statistics.add(countStock);
            statistics.add((double) hubs.size()); // Ponto 5
            return statistics;
        }else {
            System.out.println("The producer is not within the system");
            return null;
        }
    }
    public List<Double> produtorStatistics(int maxDay, String producerName){

        double totalCabazesComp = 0;
        double totalCabazesParciais = 0;
        double countStock = 0;

        List<String> clients = new ArrayList<>();
        List<String> hubs = new ArrayList<>();
        List<Double> statistics = new ArrayList<>();

        List<Member> producers = comp.getProducerStore().getProducerStore();
        Producer producer = null;
        for(Member m : producers){
            if (m.getId().equals(producerName)){
                producer = (Producer) m;
                break;
            }
        }
        if(producer!=null) {
            for (int i = 1; i < maxDay + 1; i++) {
                expList = service.getExpeditionList(i);
                if (expList == null) {
                    break;
                }
                for (Expedition e : expList) {
                    int count = 0;
                    int count2 = 0;
                    for (ProductInfo prod : e.getProductsToDeliver()) {
                        if (prod.getProducerCode().equals(producerName)) {
                            if (String.valueOf(e.getClientToSatisfy().getId().charAt(0)).equals("C")) {
                                clients.removeIf(c -> c.equals(e.getClientToSatisfy().getId()));
                                clients.add(e.getClientToSatisfy().getId());
                            }
                            if (String.valueOf(e.getClientToSatisfy().getId().charAt(0)).equals("E")) {
                                hubs.removeIf(c -> c.equals(e.getClientToSatisfy().getId()));
                                hubs.add(e.getClientToSatisfy().getId());
                            }
                            if (prod.getQuantityDelivered() == prod.getQuantityRequested()) {
                                count++;
                            }else
                            if (prod.getQuantityDelivered() > 0) {
                                count2++;
                            }
                        }
                    }
                    if (count == e.getProductsToDeliver().size() && !e.getProductsToDeliver().isEmpty()) {
                        totalCabazesComp++;
                    } else if (count2 > 0) {
                        totalCabazesParciais++;
                    }
                }
            }
            statistics.add(totalCabazesComp); // Ponto 1
            statistics.add(totalCabazesParciais); // Ponto 2

            statistics.add((double) clients.size()); // Ponto 3

            for (ProductStock stock : producer.getStockOfDay(maxDay)) {
                if (stock.getQuantity() <= 0) {
                    countStock++;
                }// Ponto 4
            }
            statistics.add(countStock);
            statistics.add((double) hubs.size()); // Ponto 5
            return statistics;
        }else {
            System.out.println("The producer is not within the system");
            return null;
        }
    }
    public List<Double> hubStatistics(int nEnterprises, String enterpriseID, int maxDay, int nProducers){
        List<Double> statistics = new ArrayList<>();
        double totalClients = 0;
        List<EnterpriseAverageDistance> enterprises = topClosestEnterprisesCtrl.getTopNClosestEnterprises(nEnterprises);
        Client c = null;
        for(Client e : comp.getEnterpriseClients()){
            if(e.getId().equals(enterpriseID)){
                c = e;
                break;
            }
        }
        if(c!= null) {
            Map<Client, HubAndDistanceToAClient> clientHubAndDistanceToAClientMap = nearestHubService.getEnterprisesCloser(enterprises);
            for (HubAndDistanceToAClient v : clientHubAndDistanceToAClientMap.values()) {
                if (v.getHub().equals(c)) {
                    totalClients++;
                }
            }
            statistics.add(totalClients);

            List<String> producers = new ArrayList<>();

            for (int i = 1; i < maxDay + 1; i++) {
                expList = service.getExpeditionList(i, clientHubAndDistanceToAClientMap, nProducers);
                if (expList == null) {
                    break;
                }
                for (Expedition e : expList) {
                    if (e.getClientToSatisfy().getId().equals(enterpriseID)) {
                        for (ProductInfo prod : e.getProductsToDeliver()) {
                            if (!producers.contains(prod.getProducerCode()) && prod.getProducerCode() != "No Producer") {
                                producers.add(prod.getProducerCode());
                            }
                        }
                    }
                }
            }
            statistics.add((double) producers.size());

            return statistics;
        }else {
            System.out.println("The hub is not in the system within the number of enterprises defined");
            return null;
        }
    }
    public List<Double> hubStatistics(int nEnterprises, String enterpriseID, int maxDay){
        List<Double> statistics = new ArrayList<>();
        double totalClients = 0;
        List<EnterpriseAverageDistance> enterprises = topClosestEnterprisesCtrl.getTopNClosestEnterprises(nEnterprises);
        Client c = null;
        for(Client e : comp.getEnterpriseClients()){
            if(e.getId().equals(enterpriseID)){
                c = e;
                break;
            }
        }
        if(c!= null) {
            Map<Client, HubAndDistanceToAClient> clientHubAndDistanceToAClientMap = nearestHubService.getEnterprisesCloser(enterprises);
            for (HubAndDistanceToAClient v : clientHubAndDistanceToAClientMap.values()) {
                if (v.getHub().equals(c)) {
                    totalClients++;
                }
            }
            statistics.add(totalClients);

            List<String> producers = new ArrayList<>();

            for (int i = 1; i < maxDay + 1; i++) {
                expList = service.getExpeditionList(i);
                if (expList == null) {
                    break;
                }
                for (Expedition e : expList) {
                    if (e.getClientToSatisfy().getId().equals(enterpriseID)) {
                        for (ProductInfo prod : e.getProductsToDeliver()) {
                            if (!producers.contains(prod.getProducerCode()) && prod.getProducerCode() != "No Producer") {
                                producers.add(prod.getProducerCode());
                            }
                        }
                    }
                }
            }
            statistics.add((double) producers.size());

            return statistics;
        }else {
            System.out.println("This hub is not in the system within the given number of enterprises");
            return null;
        }
    }
    public void saveStocks(){
        clientStore.saveMemberRequest();
        producerStore.saveProducerStore();
    }

    public void resetStocks(){
        clientStore.resetStock();
        producerStore.resetStock();
    }
}
