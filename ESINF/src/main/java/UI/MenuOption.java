package UI;

public class MenuOption {

	private Runnable runnable;
	private String optionTitle;

	public MenuOption(String optionTitle, Runnable runnable) {
		this.runnable = runnable;
		this.optionTitle = optionTitle;
	}

	public Runnable getRunnable() {
		return runnable;
	}

	public String getOptionTitle() {
		return optionTitle;
	}
}
