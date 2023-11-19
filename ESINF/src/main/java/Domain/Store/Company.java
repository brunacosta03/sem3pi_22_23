package Domain.Store;

import Domain.Client;
import Domain.ClientType;
import Domain.Member;
import Domain.Producer;
import Domain.US306.IrrigationSystem;

import java.util.ArrayList;
import java.util.List;

public class Company{
	private MemberGraph memberGraph;
	private IrrigationSystem irrigationSystem;
	private ProductStore productStore;

	private ClientStore clientStore;
	private ProducerStore producerStore;

	private String vertexFile;
	private String edgeFile;
	private String basketFile;

	public Company() {
		this.memberGraph = new MemberGraph();
		productStore = new ProductStore();
		clientStore = new ClientStore();
		producerStore = new ProducerStore();
	}

	public MemberGraph getMemberGraph() {
		return memberGraph;
	}

	public List<Client> getEnterpriseClients() {
		List<Member> members = memberGraph.getMembersLocationGraph().vertices();

		List<Client> enterpriseClients = new ArrayList<>();

		for (Member m : members) {
			if (m instanceof Client) {
				Client c = (Client) m;
				if (c.getClientType().equals(ClientType.ENTERPRISE)) {
					enterpriseClients.add(c);
				}
			}
		}

		return enterpriseClients;
	}

	public ClientStore getClientStore() {
		return clientStore;
	}

	public ProducerStore getProducerStore() {
		return producerStore;
	}

	public void flush() {
		this.memberGraph = new MemberGraph();
	}

	public void setIrrigationSystem(IrrigationSystem irrigationSystem) {
		this.irrigationSystem = irrigationSystem;
	}

	public IrrigationSystem getIrrigationSystem() {
		return irrigationSystem;
	}

	public ProductStore getProductStore() {
		return productStore;
	}

	public void setClientStore(ClientStore clientStore) {
		this.clientStore = clientStore;
	}

	public void setProducerStore(ProducerStore producerStore) {
		this.producerStore = producerStore;
	}

	public void reset() {
		this.memberGraph = new MemberGraph();
		productStore = new ProductStore();
		clientStore = new ClientStore();
		producerStore = new ProducerStore();
		this.memberGraph.reset();
	}

	public String getVertexFile() {
		return vertexFile;
	}

	public void setVertexFile(String vertexFile) {
		this.vertexFile = vertexFile;
	}

	public String getEdgeFile() {
		return edgeFile;
	}

	public void setEdgeFile(String edgeFile) {
		this.edgeFile = edgeFile;
	}

	public String getBasketFile() {
		return basketFile;
	}

	public void setBasketFile(String basketFile) {
		this.basketFile = basketFile;
	}

	public List<Member> getProducers(){
		List<Member> producers = new ArrayList<>();
		for(Member m : memberGraph.getMembersLocationGraph().vertices()){
			if(m instanceof Producer){
				producers.add(m);
			}
		}
		return producers;
	}

	public List<Member> getClients() {
		List<Member> clients = new ArrayList<>();
		for(Member m : memberGraph.getMembersLocationGraph().vertices()){
			if(m instanceof Client){
				clients.add(m);
			}
		}
		return clients;
	}
}

