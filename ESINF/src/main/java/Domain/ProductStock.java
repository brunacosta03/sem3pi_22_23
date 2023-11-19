package Domain;

public class ProductStock {
	private Product product;
	private double quantity;

	public ProductStock(Product product, double quantity) {
		this.product = product;
		this.quantity = quantity;
	}

	public Product getProduct() {
		return product;
	}

	public double getQuantity() {
		return quantity;
	}

	public void setQuantity(double quantity) {
		this.quantity = quantity;
	}
	public void increaseQuantity(double quantity) {
		this.quantity+=quantity;
	}
}
