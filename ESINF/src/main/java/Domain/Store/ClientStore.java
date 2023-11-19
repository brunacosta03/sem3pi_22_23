package Domain.Store;

import Domain.Client;
import Domain.ClientType;
import Domain.Member;
import Domain.ProductStock;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClientStore {
    private List<Member> clientList;
    private HashMap<Client, HashMap<Integer, List<ProductStock>>> resetStockRequest;

    public ClientStore() {
        this.clientList = new ArrayList<>();
        this.resetStockRequest = new HashMap<>();
    }

    public void addMemberRequest(Member member) {
        if(!clientList.contains(member)){
            clientList.add(member);
        }
    }

    public List<Member> getMemberRequest(){
        return clientList;
    }

    public void saveMemberRequest() {
        for (Member member : clientList) {
            Client t_client = (Client) member;

            HashMap<Integer, List<ProductStock>> stock = member.getStockRequestsPerDay();
            HashMap<Integer, List<ProductStock>> t_stock = new HashMap<>();

            for (Map.Entry<Integer, List<ProductStock>> entry : stock.entrySet()) {
                ArrayList<ProductStock> listProductStock = new ArrayList<>();

                for (ProductStock productStock: entry.getValue()) {
                    ProductStock t_productStock = new ProductStock(productStock.getProduct(), productStock.getQuantity());

                    listProductStock.add(t_productStock);
                }

                t_stock.put(entry.getKey(), listProductStock);
            }

            resetStockRequest.put(t_client, new HashMap<Integer, List<ProductStock>>(t_stock));
        }
    }

    public void resetStock(){
        for (Member member : clientList) {
            Client t_client = (Client) member;

            HashMap<Integer, List<ProductStock>> t_stock = resetStockRequest.get(member);

            t_client.setStockRequestsPerDay(t_stock);
        }
    }

    public void setClientList(List<Member> clientList) {
        this.clientList = clientList;
    }
}
