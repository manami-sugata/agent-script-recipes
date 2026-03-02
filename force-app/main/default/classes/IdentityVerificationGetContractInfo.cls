public with sharing class IdentityVerificationGetContractInfo {

    public class ContractInfoRequest {
        @InvocableVariable(required=true)
        @AuraEnabled
        public String name;
    }

    public class ContractInfoResponse {
        @InvocableVariable @AuraEnabled public String bondNumber;
        @InvocableVariable @AuraEnabled public String name;
        @InvocableVariable @AuraEnabled public String startDate;
        @InvocableVariable @AuraEnabled public String regNumber;
        @InvocableVariable @AuraEnabled public String oldCarName;
    }

    public static IdentityVerification.ContractInfo getContractInfo(String name) {
        String target = IdentityVerification.normalize(name);
        for (IdentityVerification.ContractInfo ci : IdentityVerification.getContractStub()) {
            String stubName = IdentityVerification.normalize(ci.name);
            if (stubName.equals(target)) {
                return ci;
            }
        }
        return null;
    }

    @InvocableMethod(label='契約情報取得')
    public static List<ContractInfoResponse> getContractInfoAction(List<ContractInfoRequest> requests) {
        List<ContractInfoResponse> results = new List<ContractInfoResponse>();
        for (ContractInfoRequest req : requests) {
            IdentityVerification.ContractInfo ci = getContractInfo(req.name);
            if (ci != null) {
                ContractInfoResponse res = new ContractInfoResponse();
                res.bondNumber = ci.bondNumber;
                res.name = ci.name;
                res.startDate = ci.startDate;
                res.regNumber = ci.regNumber;
                res.oldCarName = ci.oldCarName;
                results.add(res);
            }
        }
        return results;
    }
}