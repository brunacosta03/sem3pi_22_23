package Controller;

import Domain.*;
import Domain.Store.Company;
import Service.ExpeditionListService;
import Service.StatisticsService;

import java.util.ArrayList;
import java.util.List;

public class StatisticsController {
    StatisticsService service;

    ExpeditionListService expService;
    ExpeditionListController ctrl;
    Company comp;

    public static final String ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY = "The day number should be a number over 0.\nTry again.\n";
    public static final String GREATER_PRODUCERS = "The number of producers in the system is lower than the value defined\n Try again\n";
    public static final String GREATER_HUBS = "The number of hubs in the system is lower than the value defined\nTry again\n";
    public static final String NEGATIVE_PRODUCERS = "The number of producers defined should be a positive number\nTryagain\n";
    public static final String NEGATIVE_HUBS = "The number of hubs defined should be a positive number\nTry again\n";

    public StatisticsController(){
        service= new StatisticsService();
        ctrl = new ExpeditionListController();
        expService = new ExpeditionListService();
        comp = App.getInstance().getCompany();
    }
    public List<Double> listsCabaz(int day, int nHubs, int nProducers) {
        if (day > 0) {
            if (nHubs > 0) {
                if (nProducers > 0) {
                    if(nProducers<=comp.getProducerStore().getProducerStore().size()) {
                        if(nHubs<=comp.getEnterpriseClients().size()) {
                            return service.cabazStatistics(day, nHubs, nProducers);
                        }else{
                            throw new IllegalArgumentException(GREATER_HUBS);
                        }
                    }else{
                        throw new IllegalArgumentException(GREATER_PRODUCERS);
                    }
                } else {
                    throw new IllegalArgumentException(NEGATIVE_PRODUCERS);
                }
            } else {
                throw new IllegalArgumentException(NEGATIVE_HUBS);
            }
        } else {
            throw new IllegalArgumentException(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY);
        }
    }
    public List<Double> listsCabaz(int day){
        if (day <= 0){
            throw new IllegalArgumentException(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY);
        }
        return service.cabazStatistics(day);
    }
    public List<Client> clientsCabaz(){
        return service.getAllClientsCabaz();
    }

    public List<Double> listClient(int maxDay, String clientCode, int nHubs, int nProducers) {
        int count = 0;
        for (Member client : comp.getClientStore().getMemberRequest()) {
            if (client instanceof Client) {
                if (!clientCode.equals(client.getId())) {
                    count++;
                }
            }
        }
        if (count == comp.getClientStore().getMemberRequest().size()) {
            throw new IllegalArgumentException("The client isn't defined in the system");
        } else {
            if (nHubs > 0) {
                if (nProducers > 0) {
                    if (maxDay > 0) {
                        if(nProducers<=comp.getProducerStore().getProducerStore().size()) {
                            if(nHubs<=comp.getEnterpriseClients().size()) {
                                return service.clienteStatistics(maxDay, clientCode, nHubs, nProducers);
                            }else{
                                throw new IllegalArgumentException(GREATER_HUBS);
                            }
                        }else{
                            throw new IllegalArgumentException(GREATER_PRODUCERS);
                        }
                    } else {
                        throw new IllegalArgumentException(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY);
                    }
                } else {
                    throw new IllegalArgumentException(NEGATIVE_PRODUCERS);
                }
            } else {
                throw new IllegalArgumentException(NEGATIVE_HUBS);
            }
        }
    }
    public List<Double> listClient(int maxDay, String clientCode){
        int count = 0;
        for (Member client : comp.getClientStore().getMemberRequest()) {
            if (client instanceof Client) {
                if (clientCode.equals(client.getId())) {
                    count++;
                    break;
                }
            }
        }
        if (count == 0) {
            throw new IllegalArgumentException("The client isn't defined in the system");
        } else {
            if (maxDay > 0) {
                return service.clienteStatistics(maxDay, clientCode);
            } else {
                throw  new IllegalArgumentException(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY);
            }
        }
    }

    public List<Double> listProducer(int maxDay, String producerCode, int nHubs, int nProducers){
        service.saveStocks();
        int count2 = 0;
        for (Member producer : comp.getProducerStore().getProducerStore()) {
            if (producerCode.equals(producer.getId())) {
                count2++;
                break;
            }
        }
        if (count2 == 0) {
            service.resetStocks();
            throw new IllegalArgumentException("The producer isn't defined in the system\n");
        } else {
            if (nHubs > 0) {
                if (nProducers > 0) {
                    if (maxDay > 0) {
                        if (nProducers <= comp.getProducerStore().getProducerStore().size()) {
                            if (nHubs <= comp.getEnterpriseClients().size()) {
                                List<Double> list = service.produtorStatistics(maxDay, producerCode, nHubs, nProducers);
                                service.resetStocks();
                                return list;
                            } else {
                                service.resetStocks();
                                throw new IllegalArgumentException(GREATER_HUBS);
                            }
                        } else {
                            service.resetStocks();
                            throw new IllegalArgumentException(GREATER_PRODUCERS);
                        }

                    } else {
                        service.resetStocks();
                        throw new IllegalArgumentException(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY);
                    }
                } else {
                    service.resetStocks();
                    throw new IllegalArgumentException(NEGATIVE_PRODUCERS);
                }
            } else {
                service.resetStocks();
                throw new IllegalArgumentException(NEGATIVE_HUBS);
            }
        }
    }
    public List<Double> listProducer(int maxDay, String producerCode){
        service.saveStocks();
        int count2 = 0;
        for (Member producer : comp.getProducerStore().getProducerStore()) {
                if (producerCode.equals(producer.getId())) {
                    count2++;
                    break;
                }
        }
        if (count2 == 0) {
            throw new IllegalArgumentException("The producer isn't defined in the system\n");
        } else {
            if (maxDay > 0) {
                List<Double> list = service.produtorStatistics(maxDay, producerCode);
                service.resetStocks();
                return list;
            } else {
                service.resetStocks();
                throw new IllegalArgumentException(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY);
            }
        }
    }
    public List<Double> listHub(int nEnterprises, String hubID, int maxDay, int nProducers){
        int count3 = 0;
        for (Client producer : comp.getEnterpriseClients()) {
            if (hubID.equals(producer.getId())) {
                count3++;
                break;
            }
        }
        if (count3 == 0) {
            throw new IllegalArgumentException("The hub isn't defined in the system");
        } else {
            if(nEnterprises>0) {
                if (maxDay > 0) {
                    if (nProducers > 0) {
                        if(nProducers<=comp.getProducerStore().getProducerStore().size()) {
                            if(nEnterprises<=comp.getEnterpriseClients().size()) {
                                return service.hubStatistics(nEnterprises, hubID, maxDay, nProducers);
                            }else{
                                throw new IllegalArgumentException(GREATER_HUBS);
                            }
                        }else{
                            throw new IllegalArgumentException(GREATER_PRODUCERS);
                        }
                    } else {
                        throw new IllegalArgumentException(NEGATIVE_PRODUCERS);
                    }
                } else {
                    throw new IllegalArgumentException(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY);
                }
            }else {
                throw new IllegalArgumentException(NEGATIVE_HUBS);
            }
        }
    }
    public List<Double> listHub(int nEnterprises, String hubID, int maxDay){
        int count3 = 0;
        for (Client producer : comp.getEnterpriseClients()) {
            if (hubID.equals(producer.getId())) {
                count3++;
                break;
            }
        }
        if (count3 == 0) {
            throw new IllegalArgumentException("The hub isn't defined in the system");
        } else {
            if(nEnterprises>0) {
                if (maxDay > 0) {
                    if(nEnterprises<=comp.getEnterpriseClients().size()) {
                        return service.hubStatistics(nEnterprises, hubID, maxDay);
                    }else {
                        throw new IllegalArgumentException(GREATER_HUBS);
                    }
                } else {
                    throw new IllegalArgumentException(ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY);
                }
            }else {
                throw new IllegalArgumentException(NEGATIVE_HUBS);
            }
        }
    }
}
