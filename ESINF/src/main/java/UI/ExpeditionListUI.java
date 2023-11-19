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

public class ExpeditionListUI implements  Runnable {

    private ExpeditionListController ctrl;
    private Scanner sc;
    private Company company;
    private LoadFileController loadCtrl;

    public ExpeditionListUI() {
        sc = new Scanner(System.in);
        ctrl = new ExpeditionListController();
        company = App.getInstance().getCompany();
    }

    @Override
    public void run() {
        try {
            System.out.println("Type the day you want to check the expedition list: ");
            int day = Integer.parseInt(sc.nextLine());

            if (day < 1) {
                System.out.println("Day must be a positive number");
            } else {
                try{
                    List<Expedition> result = ctrl.getExpeditionList(day);

                    printResult(result);
                } catch (IllegalArgumentException e){
                    System.out.println(e.getMessage());
                }
            }


        }catch(NumberFormatException nfe){
            System.out.println("\nDay must be a number\n");
        }catch (Exception e) {
            System.out.println("\n"+e.getMessage()+"\n");
        }
    }



    private void printResult(List<Expedition> result) {
        for (Expedition expedition : result)
            System.out.println(expedition);
    }
}
