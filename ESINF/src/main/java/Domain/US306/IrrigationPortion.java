package Domain.US306;

public class IrrigationPortion implements Comparable<IrrigationPortion>{


    private Character portionID;
    private Integer irrigationTime;
    private Regularity regularity;

    public IrrigationPortion(Character portionID, Integer irrigationTime, Character regularity) {
        this.portionID = portionID;
        this.irrigationTime = irrigationTime;
        setRegularity(regularity);
    }

    public Character getPortionID() {
        return portionID;
    }

    public void setPortionID(Character portionID) {
        this.portionID = portionID;
    }

    public Integer getIrrigationTime() {
        return irrigationTime;
    }

    public void setIrrigationTime(Integer irrigationTime) {
        this.irrigationTime = irrigationTime;
    }

    public Regularity getRegularityENUM() {
        return regularity;
    }

    public void setRegularity(Character regularity) {
        switch (regularity){
            case 't':
                this.regularity = Regularity.ALL_DAYS;
                break;
            case 'p':
                this.regularity = Regularity.PAIR_DAYS;
                break;
            case 'i':
                this.regularity = Regularity.IMPAIR_DAYS;
                break;
            default:
                throw new IllegalArgumentException("Not valid regularity of irrigation.");
        }
    }

    @Override
    public int compareTo(IrrigationPortion o) {
        return this.portionID.compareTo(o.portionID);
    }
}
