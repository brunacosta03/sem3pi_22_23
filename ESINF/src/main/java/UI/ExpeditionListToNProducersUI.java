package UI;

import Controller.App;
import Controller.ExpeditionListController;
import Controller.LoadFileController;
import Domain.Expedition;
import Domain.Store.Company;

import javax.management.InstanceNotFoundException;
import java.io.FileNotFoundException;
import java.util.List;
import java.util.Scanner;

public class ExpeditionListToNProducersUI implements Runnable{

    private ExpeditionListController ctrl;
    private Scanner sc;
    private Company company;
    private LoadFileController loadCtrl;

    public ExpeditionListToNProducersUI() {
        sc = new Scanner(System.in);
        ctrl = new ExpeditionListController();
        company = App.getInstance().getCompany();
    }

    @Override
    public void run() {
        try {
            System.out.println("Type the day you want to check the expedition list: ");
            int day = askNumber("Day");

            System.out.println("Type the number of hubs you want to define: ");
            int numberOfHubsDefined = askNumber("Number of hubs");

            System.out.println("Type the number of producers that will distribute: ");
            int numberOfProducers = askNumber("Number of producers");


            if (day < 1) {
                throw new IllegalArgumentException("Day must be a positive number");
            }

            List<Expedition> result = ctrl.getExpeditionListByProducerNumber(day, numberOfHubsDefined, numberOfProducers);

            printResult(result);

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    private void printResult(List<Expedition> result) {
        for (Expedition expedition : result) {
            System.out.println(expedition);
        }

    }

    private int askNumber(String message) {
        try {
            int number = Integer.parseInt(sc.nextLine());
            return number;
        } catch (NumberFormatException nfe) {
            throw new IllegalArgumentException(message + " must be a number");

        }
    }
}
