package Domain;

import java.util.ArrayList;
import java.util.List;

public class Expedition {

    private Client clientToSatisfy;
    private List<ProductInfo> productsToDeliver;

    public Expedition(Client clientToSatisfy) {
        this.clientToSatisfy = clientToSatisfy;
        this.productsToDeliver = new ArrayList<>();
    }
    public void addProductToDeliver(ProductInfo productInfo) {
        productsToDeliver.add(productInfo);
    }

    public Client getClientToSatisfy() {
        return clientToSatisfy;
    }

    public void setClientToSatisfy(Client clientToSatisfy) {
        this.clientToSatisfy = clientToSatisfy;
    }

    public List<ProductInfo> getProductsToDeliver() {
        return productsToDeliver;
    }

    public void setProductsToDeliver(List<ProductInfo> productsToDeliver) {
        this.productsToDeliver = productsToDeliver;
    }

    @Override
    public String toString() {
        if(productsToDeliver.size() == 0){
            return "\nClient to satisfy: " + clientToSatisfy.getId() + "\nNo products to deliver";
        }
        return "\nClient to satisfy: " + clientToSatisfy.getId() + "\n" + constructStringOfProducts();
    }

    private String constructStringOfProducts() {
        StringBuilder sb = new StringBuilder();

        for (ProductInfo productInfo : productsToDeliver) {
            sb.append(productInfo.toString());
        }

        return sb.toString();
    }
}
