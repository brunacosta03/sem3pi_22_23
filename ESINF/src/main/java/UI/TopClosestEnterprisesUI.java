package UI;

import Controller.TopClosestEnterprisesController;
import Domain.EnterpriseAverageDistance;
import UI.Utils.Utils;

import java.util.List;

public class TopClosestEnterprisesUI implements Runnable {

    private TopClosestEnterprisesController ctrl;

    public TopClosestEnterprisesUI() {
        this.ctrl = new TopClosestEnterprisesController();
    }

    @Override
    public void run() {
        try{
            Integer n = Utils.readIntegerFromConsole("Enter the number of closest enterprises to show: ");

            System.out.println("Processing Result... \nPlease wait.");

            List<EnterpriseAverageDistance> topNClosestEnterprises = ctrl.getTopNClosestEnterprises(n);

            Utils.showListNoExit(topNClosestEnterprises, "\nTop " + n + " closest enterprises\n");
        }catch(NumberFormatException nfe){
            System.out.println("Input must be a number.\nPlease try again.");
        }catch(Exception e) {
            System.out.println(e.getMessage());
        }
    }



}
