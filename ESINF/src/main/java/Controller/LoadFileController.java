package Controller;

import Domain.Member;
import Domain.Store.MemberGraph;
import Service.Loader.BasketLoader;
import Service.Loader.DistancesLoader;
import Service.Loader.LocIDFIleLoader;

import javax.management.InstanceNotFoundException;
import java.io.FileNotFoundException;
import java.util.List;


public class LoadFileController {

	MemberGraph mg;

	public LoadFileController() {
		this.mg = App.getInstance().getCompany().getMemberGraph();
	}

	public void LoadLocationIDFile(String filepath) throws FileNotFoundException {
		if (mg.isLoaded()){
			mg.flush();
		}
		(new LocIDFIleLoader()).Load(filepath);
	}

	public void LoadDistancesFile(String filepath) throws FileNotFoundException, InstanceNotFoundException {
		DistancesLoader loader = new DistancesLoader();

		List<Member> members = mg.getMembersLocationGraph().vertices();
		if (members.size() == 0) {
			throw new InstanceNotFoundException("No members loaded");
		}
		loader.Load(filepath, members);
	}

	public void LoadBasketFile(String filepath) throws InstanceNotFoundException, FileNotFoundException {
		BasketLoader loader = new BasketLoader();
		loader.load(filepath);
	}

}
