package Controller;

import Domain.US306.IrrigationPortion;
import Service.IrrigationSystemService;

import java.time.LocalDateTime;
import java.util.Map;

public class IrrigationSystemControler {

    private IrrigationSystemService service;

    public IrrigationSystemControler(){
        this.service = new IrrigationSystemService();
    }

    public Map<IrrigationPortion, String> whatPortionsAreWorking(LocalDateTime timeToCheck){
        return service.whatPortionsAreWorking(timeToCheck);
    }

}
