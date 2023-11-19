package Domain.US306;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class IrrigationSystem {

    LocalTime morningTime;
    LocalTime afternoonTime;
    List<IrrigationPortion> portions;

    public IrrigationSystem(LocalTime morningTime, LocalTime afternoonTime) {
        this.morningTime = morningTime;
        this.afternoonTime = afternoonTime;
        this.portions = new ArrayList<>();
    }

    public LocalTime getMorningTime() {
        return morningTime;
    }

    public void setMorningTime(LocalTime morningTime) {
        this.morningTime = morningTime;
    }

    public LocalTime getAfternoonTime() {
        return afternoonTime;
    }

    public void setAfternoonTime(LocalTime afternoonTime) {
        this.afternoonTime = afternoonTime;
    }

    public List<IrrigationPortion> getPortions() {
        return portions;
    }

    public void setPortions(List<IrrigationPortion> portions) {
        this.portions = portions;
    }

    public void addPortion(IrrigationPortion portion){
        portions.add(portion);
    }
}
