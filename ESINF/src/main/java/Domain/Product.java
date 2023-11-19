package Domain;

public class Product implements Comparable<Product> {

	private String designation;

	public Product(String designation) {
		this.designation = designation;
	}

	public String getDesignation() {
		return designation;
	}

	@Override
	public int compareTo(Product o) {
		return designation.compareTo(o.designation);
	}
}
