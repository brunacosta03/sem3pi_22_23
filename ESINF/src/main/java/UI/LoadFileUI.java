package UI;

import Controller.LoadFileController;
import UI.Utils.Utils;

import javax.management.InstanceNotFoundException;
import java.io.FileNotFoundException;
import java.sql.SQLOutput;
import java.util.Arrays;

public class LoadFileUI implements Runnable {

	LoadFileController ctrl;

	static String[] options = {
			"Load LocationIDProducer File",
			"Load Distances File",
			"Load Basket File",
			"Load Default",
	};

	public LoadFileUI() {
		ctrl = new LoadFileController();
	}

	private static final String DEFAULT_LOCATIONS_BIG_FILE = "src/main/resources/Big/clientes-produtores_big.csv";
	private static final String DEFAULT_DISTANCES_BIG_FILE = "src/main/resources/Big/distancias_big.csv";
	private static final String DEFAULT_CABAZES_BIG_FILE = "src/main/resources/Big/cabazes_big.csv";

	private static final String DEFAULT_LOCATIONS_SMALL_FILE = "src/main/resources/Small/clientes-produtores_small.csv";
	private static final String DEFAULT_DISTANCES_SMALL_FILE = "src/main/resources/Small/distancias_small.csv";
	private static final String DEFAULT_CABAZES_SMALL_FILE = "src/main/resources/Small/cabazes_small.csv";

	private boolean LoadLocationFile(String filepath)  {
		try {
			ctrl.LoadLocationIDFile(filepath);
			System.out.println("File loaded successfully\n");
			return true;
		} catch (FileNotFoundException e) {
			System.out.println("File not found");
			return false;
		}
	}

	private boolean LoadDistancesFile(String filepath){
		try {
			ctrl.LoadDistancesFile(filepath);
			System.out.println("File loaded successfully\n");
			return true;
		} catch (FileNotFoundException e) {
			System.out.println("File not found");
			return false;
		} catch (InstanceNotFoundException e) {
			System.out.println(e.getMessage());
			return false;
		}
	}
	
	private boolean LoadBasketFile(String filepath) {
		try{
			ctrl.LoadBasketFile(filepath);
			return true;
		} catch (Exception e) {
			//System.out.println("Error: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	@Override
	public void run() {
		Utils.showList(Arrays.asList(options), "Load File Menu");
		int i = Utils.selectsIndex(Arrays.asList(options));
		String filepath = "";
		switch (i) {
			case 0:
				filepath = Utils.readLineFromConsole("LocationIDProducer Filepath: ");
				LoadLocationFile(filepath);
				break;
			case 1:
				filepath = Utils.readLineFromConsole("Distances Filepath: ");
				LoadDistancesFile(filepath);
				break;
			case 2:
				filepath = Utils.readLineFromConsole("Basket Filepath: ");
				LoadBasketFile(filepath);
				break;
			case 3:
				int c = Utils.readIntegerFromConsole("Big (1) or Small (2)");
				switch (c) {
					case 1:
						if (LoadLocationFile(DEFAULT_LOCATIONS_BIG_FILE)) {
							LoadDistancesFile(DEFAULT_DISTANCES_BIG_FILE);
							LoadBasketFile(DEFAULT_CABAZES_BIG_FILE);
						}
						break;
					case 2:
						if (LoadLocationFile(DEFAULT_LOCATIONS_SMALL_FILE)) {
							LoadDistancesFile(DEFAULT_DISTANCES_SMALL_FILE);
							LoadBasketFile(DEFAULT_CABAZES_SMALL_FILE);
						}
						break;
					default:
						System.out.println("Invalid Option");
				}
				break;
		}
	}
}
