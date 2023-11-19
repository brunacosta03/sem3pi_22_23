package Domain.US306;

import Controller.App;
import Domain.Store.Company;

import java.io.File;
import java.io.FileNotFoundException;
import java.time.LocalTime;
import java.util.Scanner;

public class IrrigationSystemLoader {

    private static Scanner sc;
    private static Company company;

    public void loadIrrigationSystem()  {
        company = App.getInstance().getCompany();
        try{

            sc = new Scanner(new File("src/main/resources/US306/rega_exemplo.txt"));
        }catch(Exception e){
            System.out.println("Irrigation System File not found.\n Please check the file path.");
        }

        String[] hours = sc.nextLine().split(",");
        LocalTime morningTime = LocalTime.of(
                Integer.parseInt(hours[0].split(":")[0]),
                Integer.parseInt(hours[0].split(":")[1])
        );

        LocalTime afternoonTime = LocalTime.of(
                Integer.parseInt(hours[1].split(":")[0]),
                Integer.parseInt(hours[1].split(":")[1])
        );

        IrrigationSystem irrigationSystem = new IrrigationSystem(morningTime, afternoonTime);

        while(sc.hasNextLine()){
            String[] portion = sc.nextLine().split(",");
            Character portionID = portion[0].charAt(0);
            Integer irrigationTime = Integer.parseInt(portion[1]);
            Character regularity = portion[2].charAt(0);
            IrrigationPortion irrigationPortion = new IrrigationPortion(portionID, irrigationTime, regularity);
            irrigationSystem.addPortion(irrigationPortion);
        }

        company.setIrrigationSystem(irrigationSystem);
    }
}
