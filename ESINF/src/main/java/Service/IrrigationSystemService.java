package Service;

import Controller.App;
import Domain.Store.Company;
import Domain.US306.IrrigationPortion;
import Domain.US306.IrrigationSystem;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Map;
import java.util.TreeMap;

public class IrrigationSystemService {

    private IrrigationSystem system;
    private Company company;

    public IrrigationSystemService(){
        this.company = App.getInstance().getCompany();
    }


    public Map<IrrigationPortion, String> whatPortionsAreWorking(LocalDateTime timeToCheck){

        this.system = company.getIrrigationSystem();

        Integer day = timeToCheck.getDayOfMonth();

        Character regularity = checkRegularity(day);

        Map<IrrigationPortion, String> portionsWorking = new TreeMap<>();

        for(IrrigationPortion portion : system.getPortions()){
            if((portion.getRegularityENUM().getRegularity().equals(regularity) ||
               portion.getRegularityENUM().getRegularity().equals('t') &&
                    checkTime(system.getMorningTime(), system.getAfternoonTime(), timeToCheck, portion))){

                Integer difference = getDifference(
                        timeToCheck,
                        system.getMorningTime().plusMinutes(portion.getIrrigationTime()),
                        system.getAfternoonTime().plusMinutes(portion.getIrrigationTime())
                );

                portionsWorking.put(portion, "is working and will finish in " + difference + " minutes");

            }else {
                portionsWorking.put(portion, "is not Working");
            }
        }

        return portionsWorking;
    }

    private Integer getDifference(LocalDateTime timeToCheck, LocalTime morningTime, LocalTime afternoonTime) {
        Integer differenceMorning = morningTime.toSecondOfDay() - timeToCheck.toLocalTime().toSecondOfDay();
        Integer differenceAfternoon = afternoonTime.toSecondOfDay() - timeToCheck.toLocalTime().toSecondOfDay();

        if(differenceMorning < differenceAfternoon){
            return differenceMorning/60;
        }else{
            return differenceAfternoon/60;
        }
    }

    private boolean checkTime(LocalTime morningTime, LocalTime afternoonTime, LocalDateTime timeToCheck, IrrigationPortion portion) {
        LocalTime morningTimeEnd = morningTime.plusMinutes(portion.getIrrigationTime());
        LocalTime afternoonTimeEnd = afternoonTime.plusMinutes(portion.getIrrigationTime());

        return (timeToCheck.toLocalTime().isAfter(morningTime) && timeToCheck.toLocalTime().isBefore(morningTimeEnd)) ||
                (timeToCheck.toLocalTime().isAfter(afternoonTime) && timeToCheck.toLocalTime().isBefore(afternoonTimeEnd));
    }

    private Character checkRegularity(Integer day) {
        return day % 2 == 0 ? 'p' : 'i';
    }

}
