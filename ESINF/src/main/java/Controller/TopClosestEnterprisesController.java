package Controller;

import Domain.EnterpriseAverageDistance;
import Service.TopClosestEnterprisesService;

import java.util.Collections;
import java.util.List;

public class TopClosestEnterprisesController {

    private TopClosestEnterprisesService service;

    public static final String ERROR_MESSAGE_MORE_ENTERPRISES
            = "The number of closest enterprises to show is greater than the number of enterprises in the system.\nTry again.\n";

    public static final String ERROR_MESSAGE_NEGATIVE_OR_ZERO_NUMBER
            = "The number of closest enterprises to show is negative.\nTry again.\n";

    public TopClosestEnterprisesController() {
        this.service = new TopClosestEnterprisesService();
    }

    public List<EnterpriseAverageDistance> getTopNClosestEnterprises(int n) {

        List<EnterpriseAverageDistance> totalList = service
                .getEnterprisesAverageDistance();

        if(n > totalList.size()) {
            throw new IllegalArgumentException(ERROR_MESSAGE_MORE_ENTERPRISES);
        }else if (n <= 0){
            throw new IllegalArgumentException(ERROR_MESSAGE_NEGATIVE_OR_ZERO_NUMBER);
        }

        Collections
                .sort(totalList);

        return totalList
                .subList(0, n);
    }

}
