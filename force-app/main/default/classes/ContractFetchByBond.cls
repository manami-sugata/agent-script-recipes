public with sharing class ContractFetchByBond {

    public class Request {
        @InvocableVariable(required=true) public String bondNumber;
    }

    public class Response {
        @InvocableVariable public String bondNumber;
        @InvocableVariable public String name;
        @InvocableVariable public String startDate;
        @InvocableVariable public String endDate;
        @InvocableVariable public String contractTermYears;
        @InvocableVariable public String regNumber;
        @InvocableVariable public String oldCarName;
        @InvocableVariable public Boolean hasConnectedCar;
        @InvocableVariable public Boolean hasshinka;
        @InvocableVariable public Boolean hasVehicleInsurance;
        @InvocableVariable public String vehicleInsuranceType;
        @InvocableVariable public String usageType;
        @InvocableVariable public String ageCondition;
        @InvocableVariable public String driverCondition;
        @InvocableVariable public String grade;

        @InvocableVariable public String otherBondNumber;   // 他契約証券番号
        @InvocableVariable public String homeTelNumber;     // 固定電話
        @InvocableVariable public String mobileTelNumber;   // 携帯電話
        @InvocableVariable public String baseLocation;      // 本拠地

        @InvocableVariable public String message;
    }

    @InvocableMethod(label='契約情報取得（bond＋追加情報）AgentScript用')
    public static List<Response> fetch(List<Request> requests) {
        List<Response> results = new List<Response>();
        for (Request req : requests) {
            String nBond = IdentityVerification.normalizeBond(req.bondNumber);
            Response out = new Response();
            if (String.isBlank(nBond)) {
                out.message = 'bondNumber required';
                results.add(out);
                continue;
            }
            IdentityVerification.ContractInfo ci = IdentityVerification.getContractInfoByBondNumber(nBond);
            if (ci == null) {
                out.message = 'contract not found for bond=' + nBond;
                results.add(out);
                continue;
            }
            IdentityVerification.ContractInfoResponse tmp = IdentityVerification.toResponseSafe(ci);
            out.bondNumber = tmp.bondNumber;
            out.name = tmp.name;
            out.startDate = tmp.startDate;
            out.endDate = tmp.endDate;
            out.contractTermYears = tmp.contractTermYears;
            out.regNumber = tmp.regNumber;
            out.oldCarName = tmp.oldCarName;
            out.hasConnectedCar = tmp.hasConnectedCar;
            out.hasshinka = tmp.hasshinka;
            out.hasVehicleInsurance = tmp.hasVehicleInsurance;
            out.vehicleInsuranceType = tmp.vehicleInsuranceType;
            out.usageType = tmp.usageType;
            out.ageCondition = tmp.ageCondition;
            out.driverCondition = tmp.driverCondition;
            out.grade = tmp.grade;

            // CustomerInfoの追加情報も取得
            IdentityVerification.CustomerInfo ci2 = null;
            for (IdentityVerification.CustomerInfo c : IdentityVerification.getCustomerStub()) {
                if (IdentityVerification.normalizeBond(c.bondNumber) == nBond) {
                    ci2 = c;
                    break;
                }
            }
            if (ci2 != null) {
                out.otherBondNumber = ci2.otherBondNumber;
                out.homeTelNumber = ci2.homeTelNumber;
                out.mobileTelNumber = ci2.mobileTelNumber;
                out.baseLocation = ci2.baseLocation;
            }
            out.message = 'OK';
            results.add(out);
        }
        return results;
    }
}