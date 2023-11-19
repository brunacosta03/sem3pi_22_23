package Domain;

public enum ClientType {
	CLIENT("C"),
	ENTERPRISE("E");

	private String indicator;

	ClientType(String indicator) {
		this.indicator = indicator;
	}

	public String getIndicator() {
		return indicator;
	}
}
