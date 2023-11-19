package UI;

import Controller.IrrigationSystemControler;
import Domain.US306.IrrigationPortion;
import UI.Utils.Utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.Set;

public class IrrigationSystemUI implements Runnable{
    private IrrigationSystemControler ctrl;
    private DateTimeFormatter dtf;

    public IrrigationSystemUI() {
        this.ctrl = new IrrigationSystemControler();
        this.dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    }

    @Override
    public void run() {
        String dateString = Utils.readLineFromConsole("Insert date to check (dd/MM/yyyy HH:mm): ");

        try {
            LocalDateTime dateToCheck = LocalDateTime.parse(dateString, dtf);

            Map<IrrigationPortion, String> result = ctrl.whatPortionsAreWorking(dateToCheck);
            Set<IrrigationPortion> portions = result.keySet();

            System.out.println("\n<-Portions of Irrigation System->\n");

            for (IrrigationPortion portion : portions) {
                System.out.println("\n" + "Portion " + portion.getPortionID()+ " " + result.get(portion) + "\n");
            }
        } catch (Exception e) {
            System.out.println("Invalid date format.\nTry again.\n");
        }
    }
}
