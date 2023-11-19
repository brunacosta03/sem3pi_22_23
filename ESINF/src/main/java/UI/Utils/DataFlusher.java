package UI.Utils;

import Controller.App;
import Domain.Store.Company;

/**
 * Class that flushes the data of the application (useful for testing purposes)
 */
public class DataFlusher {
    public static void flush() {
        Company company = App.getInstance().getCompany();
        company.flush();

    }

    public static void resetStocks() {

    }

    public static void resetMembers() {

    }
}
