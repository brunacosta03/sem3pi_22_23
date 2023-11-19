package Service.Loader;

import Controller.App;
import Domain.*;
import Domain.Store.Company;
import org.jetbrains.annotations.NotNull;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

public class LocIDFIleLoader {

	private static final String SEPARATOR_DEFAULT = ",";
	private static final boolean HAS_HEADER_DEFAULT = true;
	private static final int NUM_COLUMNS_DEFAULT = 4;

	Company comp;

	public LocIDFIleLoader() {
		comp = App.getInstance().getCompany();
	}

	public void Load(String filepath) throws FileNotFoundException {
		Load(filepath, HAS_HEADER_DEFAULT, SEPARATOR_DEFAULT, NUM_COLUMNS_DEFAULT);
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

	public static @NotNull String trim(String s) {
		return s.replaceAll("\"", "").replaceAll("'", "");
	}

	private void Load(String filepath, boolean hasHeaders, String separator, int numColumns) throws FileNotFoundException {
		Scanner sc = new Scanner(new File(filepath));

		if (hasHeaders) sc.nextLine();
		int i = 0;
		while(sc.hasNext()) {

			List<String> line = Arrays.asList(sc.nextLine().split(separator)).stream().map(s->trim(s)).toList();

			Location loc = new Location(line.get(0), line.get(1), line.get(2));
			String id = line.get(3);

			Member m = null;
			switch (id.charAt(0)){
				case 'P':
					m = new Producer(id, loc);
					break;
				case 'C':
					m = new Client(id, loc, ClientType.CLIENT);
					break;
				case 'E':
					m = new Client(id, loc, ClientType.ENTERPRISE);
			}
			if (m!=null){
				comp.getMemberGraph().getMembersLocationGraph().addVertex(m);
				i++;
			}
		}
		System.out.printf("Added %d vertexes of %d total \n", i, getNumOfLines(filepath));;

		this.comp.setVertexFile(filepath);
	}
}
