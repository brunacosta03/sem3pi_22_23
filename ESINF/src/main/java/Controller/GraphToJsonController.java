package Controller;

import Domain.Member;
import Domain.Store.MemberGraph;

import java.io.IOException;

public class GraphToJsonController {

	MemberGraph graph = App.getInstance().getCompany().getMemberGraph();
	private static String DEFAULT_PATH = "src\\main\\resources\\graph.json";
	public void saveGraphToJson(String path) throws IOException {
		if (path.isEmpty()) {
			path = DEFAULT_PATH;
		}
		MemberGraph.writeJsonFile(graph.getMembersLocationGraph(), path);
	}

}
