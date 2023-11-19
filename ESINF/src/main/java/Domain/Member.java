package Domain;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public abstract class Member{
	private final String id;
	private final Location location;
	private HashMap<Integer, List<ProductStock>> stockRequestsPerDay = new HashMap<>();

	public Member(String id, Location location) {
		this.id = id;
		this.location = location;
	}

	public String getId() {
		return id;
	}

	public Location getLocation() {
		return location;
	}

	public void addRequest(int day, List<ProductStock> stock) {
		for (int i = 0; i < stock.size(); i++) {
			addRequest(day, stock.get(i));
		}
	}
	public void addRequest(int day, ProductStock stock) {
		addRequest(day, stock.getProduct(), stock.getQuantity());
	}

	public void addRequest(int day, Product product, double quantity) {
		if (stockRequestsPerDay.containsKey(day)) {
			List<ProductStock> ls = stockRequestsPerDay.get(day);
			if (ls.stream().map(ProductStock::getProduct).toList().contains(product)) { // A Product already exists
				ls.stream().filter(m->m.getProduct().compareTo(product)==0).findFirst().get().increaseQuantity(quantity);
			}
			else {
				ls.add(new ProductStock(product, quantity));
			}
		}
		else {
			List<ProductStock> l = new ArrayList<>();
			l.add(new ProductStock(product, quantity));
			stockRequestsPerDay.put(day, l);
		}
	}

	public List<ProductStock> getStockOfDay(int day) {

		//if (!stockRequestsPerDay.containsKey(day)) {
		//	return null;
		//}
		//return stockRequestsPerDay.get(day);

		for (int i = 1; i <= day; i++) {
			if (stockRequestsPerDay.containsKey(day)) {
				return stockRequestsPerDay.get(day);
			}
		}
		return null;
	}

	public ProductStock getProductByDay(int day, ProductStock product) {
		List<ProductStock> stockOfDay = stockRequestsPerDay.get(day);

		for (ProductStock productInStock : stockOfDay) {
			if(productInStock.getProduct().equals(product.getProduct())){
				return productInStock;
			}
		}

		return null;
	}

	public HashMap<Integer, List<ProductStock>> getStockRequestsPerDay() {
		return stockRequestsPerDay;
	}

	public void setStockRequestsPerDay(HashMap<Integer, List<ProductStock>> stockRequestsPerDay) {
		this.stockRequestsPerDay = stockRequestsPerDay;
	}

	@Override
	public String toString() {
		return getId().toString();
	}

    public void removeBasket() {
		stockRequestsPerDay.clear();
    }
}
