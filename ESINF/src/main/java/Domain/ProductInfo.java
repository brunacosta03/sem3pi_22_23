package Domain;

public class ProductInfo {


    private String productName;
    private String producerCode;
    private Double quantityRequested;
    private Double quantityDelivered;



    public ProductInfo(String productName, String producerCode, Double quantityRequested, Double quantityDelivered) {
        this.productName = productName;
        this.producerCode = producerCode;
        this.quantityRequested = quantityRequested;
        this.quantityDelivered = quantityDelivered;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProducerCode() {
        return producerCode;
    }

    public void setProducerCode(String producerCode) {
        this.producerCode = producerCode;
    }

    public Double getQuantityRequested() {
        return quantityRequested;
    }

    public void setQuantityRequested(Double quantityRequested) {
        this.quantityRequested = quantityRequested;
    }

    public Double getQuantityDelivered() {
        return quantityDelivered;
    }

    public void setQuantityDelivered(Double quantityDelivered) {
        this.quantityDelivered = quantityDelivered;
    }

    @Override
    public String toString() {
        return "Product: " + productName + " | Producer: " + producerCode + " | Quantity Requested: " + quantityRequested + " | Quantity Delivered: " + quantityDelivered + "\n";
    }
}
