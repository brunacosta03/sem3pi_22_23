package Service.Loader;

import Controller.App;
import Domain.Member;
import Domain.Store.Company;
import org.jetbrains.annotations.NotNull;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;
import java.util.concurrent.atomic.AtomicInteger;

public class DistancesLoader {

	private final Company company = App.getInstance().getCompany();

	private static final String SEPARATOR_DEFAULT = ",";
	private static final boolean HAS_HEADER_DEFAULT = true;
	private static final int NUM_COLUMNS_DEFAULT = 3;

	public void Load(String filepath, List<Member> members) throws FileNotFoundException {
		Load(filepath, HAS_HEADER_DEFAULT, SEPARATOR_DEFAULT, NUM_COLUMNS_DEFAULT, members);
	}

	private int getNumOfLines(String filepath) throws FileNotFoundException {
		Scanner scanner = new Scanner(new File(filepath));
		String header = scanner.nextLine();
		int lines = 0;
		while (scanner.hasNextLine()) {
			scanner.nextLine();
			lines++;
		}
		scanner.close();
		return lines;
	}

	private static @NotNull String trim(String s) {
		return s.replaceAll("\"", "").replaceAll("'", "");
	}

	public void Load(String filepath, boolean hasHeaders, String separator, int numColumns, List<Member> members) throws FileNotFoundException {
		Scanner sc = new Scanner(new File(filepath));
		if (hasHeaders) sc.nextLine();

		AtomicInteger i = new AtomicInteger();
		while (sc.hasNextLine()) {
			List<String> line = Arrays.asList(sc.nextLine().split(",")).stream().map(s->trim(s)).toList();
			String id1 = trim(line.get(0));
			String id2 = trim(line.get(1));
			double distance = Double.parseDouble(trim(line.get(2)));

			members.stream().filter(m -> m.getLocation().getId().equals(id1)).findFirst().ifPresent(m1 -> {
				members.stream().filter(m -> m.getLocation().getId().equals(id2)).findFirst().ifPresent(m2 -> {
					company.getMemberGraph().getMembersLocationGraph().addEdge(m1, m2, distance);
					i.getAndIncrement();
					//System.out.println("Added edge: " + m1.getId() + " -> " + m2.getId() + " = " + distance);
				});
			});
		}

		System.out.println("Added " + i + " of " + getNumOfLines(filepath) + " edges total");
		sc.close();

		this.company.setEdgeFile(filepath);
	}
}
