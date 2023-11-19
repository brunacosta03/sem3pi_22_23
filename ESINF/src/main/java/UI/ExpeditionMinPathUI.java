package UI;

import Controller.ExpeditionMinPathController;
import Domain.Client;
import Domain.Expedition;
import Domain.Member;
import Domain.ProductInfo;
import UI.Utils.Utils;
import dto.MinPathInfo;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ExpeditionMinPathUI implements Runnable {

    ExpeditionMinPathController ctrl = new ExpeditionMinPathController();

    @Override
    public void run() {
        try {
            int day = Utils.readIntegerFromConsole("Day of the expedition: ");
            int nhubs = Utils.readIntegerFromConsole("Number of Hubs to consider: ");
            int nprod = Utils.readIntegerFromConsole("Number of Producers to consider (-1 for all): ");

            Map<String, Double> originAndDestiny = new HashMap<>();

            MinPathInfo minPathInfo = ctrl.getMinPathExpedition(day, nhubs, nprod, originAndDestiny);

            printMinPathInfo(minPathInfo, originAndDestiny);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    private static int pathWidth = 25;

    void printMinPathInfo(MinPathInfo m, Map<String, Double> originAndDestiny) {
        System.out.println("\n------------------------------------------------------------------------------------");
        System.out.println("Calculated Path: ");

        for (int i = 0; i < m.getPath().size(); i++) {
            String path = "";
            String v = m.getPath().get(i).getId();
            if(i == m.getPath().size() - 1)
                path += v;
            else
                path += v + " -> ";
            System.out.printf(path);
        }

        System.out.println("\n------------------------------------------------------------------------------------");

        System.out.println("Origin-Destiny: Distance\n");

        //for (String s : originAndDestiny.keySet()) {
            //System.out.println(s + ": " + originAndDestiny.get(s) + " m");
        //}

        for (int i = 0; i < m.getPath().size() - 1; i++) {
            System.out.println(m.getPath().get(i).getId() + "-" + m.getPath().get(i+1).getId() + ": " + originAndDestiny.get(m.getPath().get(i).getId() + "-" + m.getPath().get(i+1).getId()) + " m");
        }

        System.out.println("\n------------------------------------------------------------------------------------");

        System.out.println("Total Distance: " + m.getTotalDistance() + " m");

        System.out.println("------------------------------------------------------------------------------------");

        Map<Client, List<ProductInfo>> hubAndProducts = m.getInfoHubs();

        for(Client hub : hubAndProducts.keySet()) {
            System.out.println("Hub: " + hub.getId() + "\n");
            if(hubAndProducts.get(hub).size() == 0){
                System.out.println("No products to deliver to this hub\n");
                System.out.println("------------------------------------------------------------------------------------");
            }
            else {
                System.out.println("Products: ");
                for(ProductInfo p : hubAndProducts.get(hub)) {
                    System.out.println("\tProduct: " + p.getProductName() + " | Producer: " + p.getProducerCode() + " | Quantity: " + p.getQuantityDelivered());
                }
                System.out.println("------------------------------------------------------------------------------------");
            }


        }
    }
}
