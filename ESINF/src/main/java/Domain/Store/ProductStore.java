package Domain.Store;

import Domain.Product;

import javax.management.InstanceAlreadyExistsException;
import javax.management.InstanceNotFoundException;
import java.util.HashMap;

public class ProductStore {

	private HashMap<String, Product> hm;

	public ProductStore() {
		this.hm = new HashMap<>();
	}

	public boolean contains(String designation) {
		return hm.containsValue(designation);
	}

	private void addProduct(Product p) throws InstanceAlreadyExistsException {
		if (contains(p.getDesignation()))
			throw new InstanceAlreadyExistsException("Product with that designation already exists");
		hm.put(p.getDesignation(), p);
	}
	public void addProduct(String designation) throws InstanceAlreadyExistsException {
		addProduct(new Product(designation));
	}

	public Product getProduct(String designation) throws InstanceNotFoundException {
		Product p = hm.get(designation);
		if (p==null) {
			throw new InstanceNotFoundException(String.format("Product with Designation \"%s\" does not exist", designation));
		}
		return p;
	}
}
