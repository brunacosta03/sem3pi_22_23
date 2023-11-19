package Domain.US306;

public enum Regularity {
    ALL_DAYS('t'),
    PAIR_DAYS('p'),
    IMPAIR_DAYS('i');

    private Character regularity;

    Regularity(Character regularity){
        this.regularity = regularity;
    }

    public Character getRegularity(){
        return regularity;
    }
}
