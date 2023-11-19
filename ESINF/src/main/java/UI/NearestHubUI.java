package UI;

import Controller.NearestHubController;
import Controller.TopClosestEnterprisesController;
import Domain.Client;
import Domain.EnterpriseAverageDistance;
import Domain.HubAndDistanceToAClient;

import java.util.List;
import java.util.Map;
import java.util.Scanner;

public class NearestHubUI implements Runnable{
    NearestHubController ctrl;
    TopClosestEnterprisesController topCtrl;
    Scanner sc;

    public NearestHubUI(){
        topCtrl = new TopClosestEnterprisesController();
        ctrl = new NearestHubController();
        sc = new Scanner(System.in);
    }

    @Override
    public void run(){

        try{

            System.out.println("Type the number of hubs you wanna define: ");
            int num = sc.nextInt();
            List<EnterpriseAverageDistance> topNClosestEnterprises = topCtrl.getTopNClosestEnterprises(num);
            Map<Client, HubAndDistanceToAClient> areaClient = ctrl.getAllClientsEnterprises(topNClosestEnterprises);

            System.out.println("This is all the information in the system:\n Client ID -- Enterprise ID -- Distance\n");

            for(Client c : areaClient.keySet()){
                System.out.println(c.getId() + " -- " + areaClient.get(c));
            }


        }catch (Exception e){
            System.out.println(e.getMessage());
        }
    }
}
