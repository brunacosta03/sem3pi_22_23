package Service.Loader;


import Controller.App;
import Domain.Client;
import Domain.Member;
import Domain.Producer;
import Domain.ProductStock;
import Domain.Store.*;
import org.jetbrains.annotations.NotNull;

import javax.management.InstanceNotFoundException;
import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

public class BasketLoader {
	Company company = App.getInstance().getCompany();
	ProductStore ps = company.getProductStore();
	MemberGraph memberGraph = company.getMemberGraph();
	ClientStore clientStore = company.getClientStore();
	ProducerStore producerStore = company.getProducerStore();

	private static int ProductColumnShift = 2;

	private static final String SEPARATOR_DEFAULT = ",";

	public static @NotNull String trim(String s) {
		return s.replaceAll("\"", "").replaceAll("'", "");
	}

	public void load(String filepath) throws InstanceNotFoundException, FileNotFoundException {
		try {
			Scanner sc = new Scanner(new File(filepath));
			sc.close();

			load(filepath, SEPARATOR_DEFAULT);
		} catch (IOException e) {
			throw new FileNotFoundException("File not found");
		}
	}

	public void load(String filepath, String separator) throws IOException, InstanceNotFoundException {
		if (!memberGraph.isLoaded())
			throw new InstanceNotFoundException("Graph not loaded");

		BufferedReader reader = new BufferedReader(new FileReader(filepath));

		List<String> header = Arrays.asList(reader.readLine().split(separator)).stream().map(s -> trim(s)).toList();
		for (int i = ProductColumnShift; i < header.size(); i++) {
			try {
				ps.addProduct(header.get(i));
			} catch (Exception ignored) {
			}
		}

		int nt = 0, n = 0;
		String lineNotSeparated;
		//;
		while ((lineNotSeparated = reader.readLine()) != null) {
			String[] line = lineNotSeparated.split(separator);
			String actor = trim(line[0]);
			int day = Integer.parseInt(trim(line[1]));

			// Find graphMember
			Member member = memberGraph.getMembersLocationGraph().vertices().stream()
					.filter(m -> m.getId().equals(actor)).findFirst().orElse(null);

			List<ProductStock> pl = new ArrayList<>();

			for (int i = ProductColumnShift; i < header.size(); i++) {
				pl.add(new ProductStock(ps.getProduct(header.get(i)), Double.parseDouble(line[i])));
			}

			if (member != null) {
				member.addRequest(day, pl);

				if (member instanceof Client) {
					clientStore.addMemberRequest(member);
				}

				if (member instanceof Producer) {
					producerStore.addProducerStock(member);
				}
			} else {
				n--;
			}


			nt++;
			n++;
		}
		System.out.println("\nLoaded " + n + " out of " + nt + " baskets\n");

		this.company.setBasketFile(filepath);
	}

}