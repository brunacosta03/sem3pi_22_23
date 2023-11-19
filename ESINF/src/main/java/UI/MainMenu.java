package UI;

import Domain.US306.IrrigationSystemLoader;
import Service.TopClosestEnterprisesService;
import UI.Utils.Utils;

import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

public class MainMenu implements Runnable {

	Scanner sc = new Scanner(System.in);

	private List<MenuOption> options = Arrays.asList(
			new MenuOption("Load Files", new LoadFileUI()),
			new MenuOption("Verify Graph Connection", new GraphConnectedUI()),
			new MenuOption("Top N Closest Enterprises", new TopClosestEnterprisesUI()),
			new MenuOption("List of Clients and the closer area of each", new NearestHubUI()),
			new MenuOption("Network that connects all costumers and producers", new MinimumNetworkUI()),
			new MenuOption("Show Portions and its state of the Irrigation System", new IrrigationSystemUI()),
			new MenuOption("Get an expedition list of the baskets for a given day", new ExpeditionListUI()),
			new MenuOption("Get an expedition list of the baskets for a given day and a given number of producers", new ExpeditionListToNProducersUI()),
			new MenuOption("Find Minimum Path for Expedition", new ExpeditionMinPathUI()),
			new MenuOption("Get the statistics for a basket or a member", new StatisticsUI()),
			new MenuOption("Options", new OptionsUI())
	);

	@Override
	public void run(){
		new IrrigationSystemLoader()
				.loadIrrigationSystem();

		int opt = 1;
		while (opt != -1) {
			List<String> optionList = options.stream().map(MenuOption::getOptionTitle).toList();
			opt = Utils.showAndSelectIndex(optionList, "Main Menu");
			try {
				options.get(opt).getRunnable().run();
			} catch (ArrayIndexOutOfBoundsException e) {}
		}
	}

}
