package Domain;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

public class Client extends Member {
	private ClientType clientType;
	public Client(String id, Location location, ClientType clientType) {
		super(id, location);
		this.clientType = clientType;
	}

	public ClientType getClientType() {
		return clientType;
	}
}
