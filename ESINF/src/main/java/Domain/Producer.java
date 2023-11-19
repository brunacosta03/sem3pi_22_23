package Domain;

import java.util.ArrayList;
import java.util.List;

public class Producer extends Member {
	public Producer(String id, Location location) {
		super(id, location);
	}

	@Override
	public List<ProductStock> getStockOfDay(int day) {
		if(day == 1){
			return super.getStockOfDay(day);
		}

		if(day == 2){
			List<ProductStock> dayOne = super.getStockOfDay(day - 1);
			List<ProductStock> dayTwo = super.getStockOfDay(day);
			List<ProductStock> totalDay = new ArrayList<>();

			for (int i = 0; i < dayOne.size(); i++) {
				ProductStock productAdd = new ProductStock(dayOne.get(i).getProduct(), dayOne.get(i).getQuantity() + dayTwo.get(i).getQuantity());
				totalDay.add(productAdd);
			}

			return totalDay;
		}

		List<ProductStock> dayOne = super.getStockOfDay(day - 2);
		List<ProductStock> dayTwo = super.getStockOfDay(day - 1);
		List<ProductStock> dayThree = super.getStockOfDay(day);
		List<ProductStock> totalDay = new ArrayList<>();

		for (int i = 0; i < dayOne.size(); i++) {
			ProductStock productAdd = new ProductStock(dayOne.get(i).getProduct(), dayOne.get(i).getQuantity() + dayTwo.get(i).getQuantity() + dayThree.get(i).getQuantity());
			totalDay.add(productAdd);
		}

		return totalDay;
	}
}
