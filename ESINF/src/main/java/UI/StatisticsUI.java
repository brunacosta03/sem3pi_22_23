package UI;

import Controller.App;
import Controller.StatisticsController;
import Domain.Client;
import Domain.Member;
import Domain.Store.Company;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class StatisticsUI implements Runnable {
    StatisticsController ctrl;
    Scanner sc;
    Company company;

    public static final String ERROR_MESSAGE_NEGATIVE_OR_ZERO_DAY = "The day number should be a number over 0.\nTry again.\n";

    public StatisticsUI(){
        ctrl = new StatisticsController();
        sc= new Scanner(System.in);
        company= App.getInstance().getCompany();
    }

    @Override
    public void run() {

        try {
            System.out.println("Choose which statistics to get:\n1 - Basket ( 1 day )\n2 - Client\n3 - Producer\n4 - Hub");
            String option = sc.nextLine();
            int opt = Integer.parseInt(option);
            if (opt > 0 && opt < 5) {
                try {
                    switch (opt) {
                        case 1 -> {
                            System.out.println("Which day do you want to record from the basket");
                            String day = sc.nextLine();
                            int number = Integer.parseInt(day);
                            System.out.println("Do you want to define the maximum number of hubs and producers?\n1 - Yes\n2 - No");
                            String maxO = sc.nextLine();
                            int maximumO = Integer.parseInt(maxO);
                            if (maximumO == 1) {
                                System.out.println("What is the maximum number of hubs willing to be defined?");
                                String nEnter = sc.nextLine();
                                int intnumC = Integer.parseInt(nEnter);
                                System.out.println("What is the maximum number of producers willing to be defined? ");
                                String maxProdS = sc.nextLine();
                                int maxProdC = Integer.parseInt(maxProdS);
                                List<Double> list = ctrl.listsCabaz(number, intnumC, maxProdC);
                                for (int i = 0; i < ctrl.clientsCabaz().size(); i++) {
                                    if (list.size() != 0) {
                                        System.out.println("Client " + ctrl.clientsCabaz().get(i).getId() + "\nNumber of complete products : "
                                                + list.get(i * 5) + "\nNumber of parcial products : " + list.get(i * 5 + 1) +
                                                "\nNumber of null products : " + list.get(i * 5 + 2));

                                        double percentage = list.get(i * 5 + 3);

                                        if (list.get(i * 5 + 3).isNaN()) {
                                            percentage = 0.0;
                                        }

                                        System.out.printf("Percentage of quantity delivered : %.2f%% \nNumber of different producers: %.2f\n\n",
                                                percentage, list.get(i * 5 + 4));
                                    }
                                }
                            } else if (maximumO == 2) {
                                List<Double> list = ctrl.listsCabaz(number);

                                if (list != null) {
                                    for (int i = 0; i < ctrl.clientsCabaz().size(); i++) {
                                        System.out.println("Client " + ctrl.clientsCabaz().get(i).getId() + "\nNumber of complete products : " + list.get(i * 5) +
                                                "\nNumber of parcial products : " + list.get(i * 5 + 1) +
                                                "\nNumber of null products : " + list.get(i * 5 + 2));

                                        double percentage = list.get(i * 5 + 3);

                                        if (list.get(i * 5 + 3).isNaN()) {
                                            percentage = 0.0;
                                        }

                                        System.out.printf("Percentage of quantity delivered : %.2f%% \nNumber of different producers: %.2f\n\n",
                                                percentage, list.get(i * 5 + 4));
                                    }
                                }
                            } else {
                                System.out.println("The option should be 1 or 2");
                            }
                        }
                        case 2 -> {
                            System.out.println("What is the client's ID ?");
                            String clientID = sc.nextLine();

                            System.out.println("What is the maximum day you want to evaluate ?");
                            String maxDayS = sc.nextLine();
                            int maxDay = Integer.parseInt(maxDayS);

                            System.out.println("Do you want to define the maximum number of hubs and producers?\n1 - Yes\n2 - No");
                            String maxOC = sc.nextLine();
                            int maximumOC = Integer.parseInt(maxOC);
                            if (maximumOC == 1) {
                                System.out.println("What is the maximum number of hubs willing to be defined?");
                                String nEnterC = sc.nextLine();
                                int intnumCC = Integer.parseInt(nEnterC);
                                System.out.println("What is the maximum number of producers willing to be defined? ");
                                String maxProdS = sc.nextLine();
                                int maxProdC = Integer.parseInt(maxProdS);
                                List<Double> listClient = ctrl.listClient(maxDay, clientID, intnumCC, maxProdC);
                                if (listClient != null) {
                                    System.out.println("Client " + clientID + "\nNumber of complete baskets : " + listClient.get(0) +
                                            "\nNumber of parcial baskets : " + listClient.get(1) +
                                            "\nNumber of different producers : " + listClient.get(2) + "\n");
                                }
                            } else if (maximumOC == 2) {
                                List<Double> listClient = ctrl.listClient(maxDay, clientID);
                                if (listClient != null) {
                                    System.out.println("Client " + clientID + "\nNumber of complete baskets : " + listClient.get(0) +
                                            "\nNumber of parcial baskets : " + listClient.get(1) +
                                            "\nNumber of different producers : " + listClient.get(2) + "\n");
                                }
                            } else {
                                System.out.println("The option should be 1 or 2");
                            }
                        }
                        case 3 -> {
                            System.out.println("What is the producer's ID ?");
                            String producerID = sc.nextLine();
                            System.out.println("What is the maximum day you want to evaluate ?");
                            String maxDaySt = sc.nextLine();
                            int maxDayP = Integer.parseInt(maxDaySt);
                            System.out.println("Do you want to define the maximum number of hubs and producers?\n1 - Yes\n2 - No");
                            String maxOP = sc.nextLine();
                            int maximumOP = Integer.parseInt(maxOP);
                            if (maximumOP == 1) {
                                System.out.println("What is the maximum number of hubs willing to be defined?");
                                String nEnterP = sc.nextLine();
                                int intnumP = Integer.parseInt(nEnterP);

                                System.out.println("What is the maximum number of producers willing to be defined? ");
                                String maxProdSt = sc.nextLine();
                                int maxProdP = Integer.parseInt(maxProdSt);

                                List<Double> listP = ctrl.listProducer(maxDayP, producerID, intnumP, maxProdP);
                                if (listP != null) {
                                    System.out.println("Producer " + producerID + "\nNumber of complete baskets : " + listP.get(0) + "\nNumber of parcial baskets : " + listP.get(1) +
                                            "\nNumber of different clients distributed to : " + listP.get(2) + "\nNumber of products with no stock : " + listP.get(3) +
                                            "\nNumber of hubs he distributes to : " + listP.get(4) + "\n");
                                }
                            } else if (maximumOP == 2) {
                                List<Double> listP = ctrl.listProducer(maxDayP, producerID);
                                if (listP != null) {
                                    System.out.println("Producer " + producerID + "\nNumber of complete baskets : " + listP.get(0) + "\nNumber of parcial baskets : " + listP.get(1) +
                                            "\nNumber of different clients distributed to : " + listP.get(2) + "\nNumber of products with no stock : " + listP.get(3) +
                                            "\nNumber of hubs he distributes to : " + listP.get(4) + "\n");
                                }
                            } else {
                                System.out.println("The option should be 1 or 2");
                            }
                        }
                        case 4 -> {
                            System.out.println("What is the hub's ID ?");
                            String hubID = sc.nextLine();
                            System.out.println("What is the maximum day you want to evaluate ?");
                            String maxDayStr = sc.nextLine();
                            int maxDayH = Integer.parseInt(maxDayStr);
                            System.out.println("What is the maximum number of hubs willing to be defined?");
                            String nEnterE = sc.nextLine();
                            int intnumE = Integer.parseInt(nEnterE);
                                System.out.println("Do you want to define the maximum number of producers?\n1 - Yes\n2 - No");
                                String maxOPE = sc.nextLine();
                                int maximumOPE = Integer.parseInt(maxOPE);
                                if (maximumOPE == 1) {
                                    System.out.println("What is the maximum number of producers willing to be defined? ");
                                    String maxProdStr = sc.nextLine();
                                    int maxProdP = Integer.parseInt(maxProdStr);
                                    List<Double> listH = ctrl.listHub(intnumE, hubID, maxDayH, maxProdP);
                                    if (listH != null) {
                                        System.out.println("Enterprise : " + hubID + "\nNumber of different clients : " + listH.get(0) + "\nNumber of  different producers : " + listH.get(1) + "\n");
                                    }
                                } else if (maximumOPE == 2) {
                                    List<Double> listH = ctrl.listHub(intnumE, hubID, maxDayH);
                                    if (listH != null) {
                                        System.out.println("Enterprise : " + hubID + "\nNumber of different clients : " + listH.get(0) + "\nNumber of  different producers : " + listH.get(1) + "\n");
                                    }
                                } else {
                                    System.out.println("The option should be 1 or 2");
                                }
                        }
                    }
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("The introduced character has to be a number");
                }
            } else {
                throw new IllegalArgumentException("The option should be a number between 1 and 4");
            }
        }catch (Exception e){
            System.out.println(e.getMessage());
        }
    }
}
