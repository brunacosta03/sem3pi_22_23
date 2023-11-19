package Controller;

import Domain.Store.Company;

public class App {

	// Extracted from https://www.javaworld.com/article/2073352/core-java/core-java-simply-singleton.html?page=2
	private static App singleton = null;
	private Company company;

	public App(){
		this.company = new Company();
	}

	public static App getInstance()
	{
		if(singleton == null)
		{
			synchronized(App.class)
			{
				singleton = new App();
			}
		}
		return singleton;
	}

	public Company getCompany() {
		return company;
	}

	public void resetCompany() {
		this.company = new Company();
	}
}