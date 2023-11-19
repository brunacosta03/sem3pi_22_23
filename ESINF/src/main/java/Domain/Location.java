package Domain;

public class Location implements Comparable<Location> {

	private String id;
	private String lat;
	private String lon;

	public Location(String id, String lat, String lon) {
		this.id = id;
		this.lat = lat;
		this.lon = lon;
	}

	public String getId() {
		return id;
	}

	public String getLat() {
		return lat;
	}

	public String getLon() {
		return lon;
	}

	@Override
	public int compareTo(Location o) {
		return this.id.compareTo(o.id);
	}
}
