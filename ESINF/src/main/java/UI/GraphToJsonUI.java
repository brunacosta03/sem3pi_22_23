package UI;

import Controller.GraphToJsonController;
import UI.Utils.Utils;

import java.io.IOException;
import java.sql.SQLOutput;

public class GraphToJsonUI implements Runnable {

	GraphToJsonController ctrl = new GraphToJsonController();

	String PATH_DEFAULT = "src/main/resources/graph.json";

	@Override
	public void run() {

		System.out.println("Save to json file");
		String path = Utils.readLineFromConsole("Filepath, if empty, use default path\n -> ");
		try {
			if (path.isEmpty()) {
				path = PATH_DEFAULT;
			}
			ctrl.saveGraphToJson(path);
			System.out.println("File saved successfully\n\n");
		} catch (IOException e) {
			System.out.println("Something went wrong: " + e.getMessage());;
		}
	}
}
