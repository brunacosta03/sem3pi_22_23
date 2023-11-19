package Service;

import Controller.App;
import Domain.*;
import Domain.Store.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ExpeditionListService {

    Company company;
    ClientStore clientStore;
    ProducerStore producerStore;
    ClosestProducersToHubService closestProducersService;


    public ExpeditionListService() {
        this.company = App.getInstance().getCompany();
        this.clientStore = company.getClientStore();
        this.producerStore = company.getProducerStore();
        this.closestProducersService = new ClosestProducersToHubService();
    }
    public void setNewStockQuantity(ProductStock product, double quantity, int day, Member producer){
        if (day == 1) {
            if(product.getQuantity() - quantity < 0) {
                product.setQuantity(0);
            } else {
                product.setQuantity(product.getQuantity() - quantity);
            }
        }


        if (day == 2) {
            ProductStock productDayOne = producer.getProductByDay(day - 1, product);
            ProductStock productDayTwo = producer.getProductByDay(day, product);

            if (productDayOne.getQuantity() - quantity < 0) {
                quantity = quantity - productDayOne.getQuantity();
                productDayOne.setQuantity(0);
                productDayTwo.setQuantity(productDayTwo.getQuantity() - quantity);
            } else {
                quantity = productDayOne.getQuantity() - quantity;
                productDayOne.setQuantity(quantity);
            }
        }

        if (day >= 3) {
            ProductStock productDayOne = producer.getProductByDay(day - 2, product);
            ProductStock productDayTwo = producer.getProductByDay(day - 1, product);
            ProductStock productDayThree = producer.getProductByDay(day, product);

            if (productDayOne.getQuantity() - quantity < 0) {
                quantity = quantity - productDayOne.getQuantity();

                productDayOne.setQuantity(0);

                if (productDayTwo.getQuantity() - quantity < 0) {
                    quantity = quantity - productDayTwo.getQuantity();
                    productDayTwo.setQuantity(0);

                    if (productDayThree.getQuantity() - quantity < 0) {
                        productDayThree.setQuantity(0);
                    } else {
                        productDayThree.setQuantity(productDayThree.getQuantity() - quantity);
                    }
                } else {
                    quantity = productDayTwo.getQuantity() - quantity;
                    productDayTwo.setQuantity(quantity);
                }
            } else {
                quantity = productDayOne.getQuantity() - quantity;
                productDayOne.setQuantity(quantity);
            }
        }
    }

    public ProductStock getSpecificProduct(List<ProductStock> stockProducer, Product productToFind){
        for (ProductStock productStock: stockProducer) {
            if (productToFind.getDesignation().compareTo(productStock.getProduct().getDesignation()) == 0) {
                return productStock;
            }
        }
        return null;
    }

    public List<Expedition> getExpeditionList (int day) {
        List<Expedition> expeditionList = new ArrayList<>();
        List<Member> requestsList = clientStore.getMemberRequest();
        List<Member> producersList = producerStore.getProducerStore();
        Member maxProducer = null;
        ProductStock maxProductStock = null;
        double maxQuantity = 0;
        boolean isSatisfy = false;

        for (Member member : requestsList) {
            List<ProductStock> listOfRequest = member.getStockOfDay(day);

            if(listOfRequest == null)
                continue;

            Expedition expedition = new Expedition((Client) member);

            for (int i = 0; i < listOfRequest.size(); i++) {
                ProductStock product = listOfRequest.get(i);

                if (product.getQuantity() != 0) {
                    for (Member producer : producersList) {
                        List<ProductStock> stockProducer = producer.getStockOfDay(day);
                        ProductStock productStock = getSpecificProduct(stockProducer, product.getProduct());

                        if (product.getQuantity() != 0) {
                            if (productStock.getQuantity() >= product.getQuantity()) {
                                ProductInfo productInfo = new ProductInfo(
                                        product.getProduct().getDesignation(),
                                        producer.getId(),
                                        product.getQuantity(),
                                        product.getQuantity()
                                );
                                expedition.getProductsToDeliver().add(productInfo);
                                setNewStockQuantity(productStock, product.getQuantity(), day, producer);
                                product.setQuantity(0);
                                isSatisfy = true;
                            } else {
                                if (productStock.getQuantity() > maxQuantity) {
                                    maxQuantity = productStock.getQuantity();
                                    maxProducer = producer;
                                    maxProductStock = productStock;
                                }
                            }
                        }
                    }
                    if (product.getQuantity() != 0) {
                        if (!isSatisfy && maxQuantity != 0) {
                            ProductInfo productInfo = new ProductInfo(
                                    product.getProduct().getDesignation(),
                                    maxProducer.getId(),
                                    product.getQuantity(),
                                    maxQuantity
                            );
                            expedition.getProductsToDeliver().add(productInfo);
                            setNewStockQuantity(maxProductStock, maxQuantity, day, maxProducer);
                            product.setQuantity(product.getQuantity() - maxQuantity);
                            product.setQuantity(0);
                        }
                        if (!isSatisfy && maxProducer == null) {
                            ProductInfo productInfo = new ProductInfo(
                                    product.getProduct().getDesignation(),
                                    "No Producer",
                                    product.getQuantity(),
                                    0.0
                            );
                            expedition.getProductsToDeliver().add(productInfo);
                            product.setQuantity(0);
                        }
                    }
                    maxProducer = null;
                    maxQuantity = 0;
                    isSatisfy = false;
                }
            }
            expeditionList.add(expedition);
        }

        return expeditionList;
    }


    public List<Expedition> getExpeditionList (int day, Map<Client, HubAndDistanceToAClient> clientAndItsClosestHub, int numberOfProducers) {
        List<Member> producersStock = producerStore.getProducerStore();

        if(numberOfProducers > producersStock.size()) {
            throw new IllegalArgumentException("Number of producers input is greater than the number of producers in the company\nTry again");
        }else if(numberOfProducers <= 0) {
            throw new IllegalArgumentException("Number of producers input has to be positive\nTry again");
        }

        List<Expedition> expeditionList = new ArrayList<>();

        List<Member> requestsList = clientStore.getMemberRequest();
        List<Member> producersList = null;

        Member maxProducer = null;
        ProductStock maxProductStock = null;
        double maxQuantity = 0;
        boolean isSatisfy = false;

        for (Member member : requestsList) {
            List<ProductStock> listOfRequest = member.getStockOfDay(day);

            if(listOfRequest == null)
                continue;

            Expedition expedition = new Expedition((Client) member);

            HubAndDistanceToAClient hubAndDistanceToThisClient = clientAndItsClosestHub.get(member);

            Client closestHub;

            if(hubAndDistanceToThisClient == null)
                closestHub = (Client) member;
            else
                closestHub = hubAndDistanceToThisClient.getHub();

            producersList = closestProducersService.getClosestProducersToHub(closestHub, numberOfProducers, producersStock);

            for (int i = 0; i < listOfRequest.size(); i++) {
                ProductStock product = listOfRequest.get(i);

                if (product.getQuantity() != 0) {



                    for (Member producer : producersList) {
                        List<ProductStock> stockProducer = producer.getStockOfDay(day);
                        ProductStock productStock = getSpecificProduct(stockProducer, product.getProduct());

                        if (product.getQuantity() != 0) {
                            if (productStock.getQuantity() >= product.getQuantity()) {
                                ProductInfo productInfo = new ProductInfo(product.getProduct().getDesignation(), producer.getId(), product.getQuantity(), product.getQuantity());
                                expedition.getProductsToDeliver().add(productInfo);
                                setNewStockQuantity(productStock, product.getQuantity(), day, producer);
                                product.setQuantity(0);
                                isSatisfy = true;
                            } else {
                                if (productStock.getQuantity() > maxQuantity) {
                                    maxQuantity = productStock.getQuantity();
                                    maxProducer = producer;
                                    maxProductStock = productStock;
                                }
                            }
                        }
                    }
                    if (product.getQuantity() != 0) {
                        if (!isSatisfy && maxQuantity != 0) {
                            ProductInfo productInfo = new ProductInfo(product.getProduct().getDesignation(), maxProducer.getId(), product.getQuantity(), maxQuantity);
                            expedition.getProductsToDeliver().add(productInfo);
                            setNewStockQuantity(maxProductStock, maxQuantity, day, maxProducer);
                            product.setQuantity(product.getQuantity() - maxQuantity);
                            product.setQuantity(0);
                        }
                        if (!isSatisfy && maxProducer == null) {
                            ProductInfo productInfo = new ProductInfo(product.getProduct().getDesignation(), "No Producer", product.getQuantity(), 0.0);
                            expedition.getProductsToDeliver().add(productInfo);
                            product.setQuantity(0);
                        }
                    }
                    maxProducer = null;
                    maxQuantity = 0;
                    isSatisfy = false;
                }
            }
            expeditionList.add(expedition);
        }

        return expeditionList;
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