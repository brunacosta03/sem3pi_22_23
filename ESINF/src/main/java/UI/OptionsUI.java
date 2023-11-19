package UI;

import Controller.App;
import UI.Utils.Utils;

import java.util.Arrays;
import java.util.List;

public class OptionsUI implements Runnable {

	List<MenuOption> option = List.of(
			new MenuOption("Save current loaded graph to a json file", new GraphToJsonUI())
	);

	@Override
	public void run() {
		int opt = 1;
		while (opt!=-1) {
			opt = Utils.showAndSelectIndex(option.stream().map(MenuOption::getOptionTitle).toList(), "Options Menu:");
			if (opt!=-1) {
				option.get(opt).getRunnable().run();
			}
		}
	}
}
