package Domain.Store;

import Domain.Member;
import Domain.Producer;
import Domain.ProductStock;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProducerStore {
    private List<Member> producerList;
    private HashMap<Producer, HashMap<Integer, List<ProductStock>>> resetProducerStock;

    public ProducerStore() {
        this.producerList = new ArrayList<>();
        this.resetProducerStock = new HashMap<>();
    }

    public void addProducerStock(Member producer) {
        if(!producerList.contains(producer)){
            producerList.add(producer);
        }
    }

    public List<Member> getProducerStore(){
        return producerList;
    }

    public void saveProducerStore() {
        for (Member producer: producerList) {
            Producer t_producer = (Producer) producer;

            HashMap<Integer, List<ProductStock>> stock = producer.getStockRequestsPerDay();
            HashMap<Integer, List<ProductStock>> t_stock = new HashMap<>();

            for (Map.Entry<Integer, List<ProductStock>> entry : stock.entrySet()) {
                ArrayList<ProductStock> listProductStock = new ArrayList<>();

                for (ProductStock productStock: entry.getValue()) {
                    ProductStock t_productStock = new ProductStock(productStock.getProduct(), productStock.getQuantity());

                    listProductStock.add(t_productStock);
                }

                t_stock.put(entry.getKey(), listProductStock);
            }

            resetProducerStock.put(t_producer, new HashMap<Integer, List<ProductStock>>(t_stock));
        }
    }

    public void resetStock(){
        for (Member member : producerList) {
            Producer t_producer = (Producer) member;

            HashMap<Integer, List<ProductStock>> t_stock = resetProducerStock.get(member);

            t_producer.setStockRequestsPerDay(t_stock);
        }
    }


    public void setProducerList(List<Member> producerList) {
        this.producerList = producerList;
    }
}
