global with sharing class KycFlowApex_ContractInfo {
    global class Request {
        @InvocableVariable public String name;
    }
    global class Response {
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

        public Response(
            String name, String startDate, String endDate, String contractTermYears, String regNumber,
            String oldCarName, Boolean hasConnectedCar, Boolean hasshinka, Boolean hasVehicleInsurance,
            String vehicleInsuranceType, String usageType, String ageCondition, String driverCondition, String grade
        ) {
            this.name = name;
            this.startDate = startDate;
            this.endDate = endDate;
            this.contractTermYears = contractTermYears;
            this.regNumber = regNumber;
            this.oldCarName = oldCarName;
            this.hasConnectedCar = hasConnectedCar;
            this.hasshinka = hasshinka;
            this.hasVehicleInsurance = hasVehicleInsurance;
            this.vehicleInsuranceType = vehicleInsuranceType;
            this.usageType = usageType;
            this.ageCondition = ageCondition;
            this.driverCondition = driverCondition;
            this.grade = grade;
        }
        public Response() {}
    }

    private static List<Response> contractStub = new List<Response>{
        new Response('山田太郎', '2023/04/01', '2024/03/31', '1', '1234', 'プリウス', true, true, true, '一般', '通勤', '30歳以上', '家族限定', '20'),
        new Response('佐藤花子', '2022/07/15', '2023/07/14', '1', '5678', 'アクア', false, false, true, '限定', 'レジャー', '21歳以上', '本人限定', '18')
    };

    @InvocableMethod(label='契約詳細取得（名前）')
    global static List<Response> getContractInfoByName(List<Request> reqs) {
        List<Response> results = new List<Response>();
        for(Request req : reqs){
            Response hit = null;
            for(Response ci : contractStub){
                if(ci.name == req.name){
                    hit = ci;
                    break;
                }
            }
            if(hit != null){
                results.add(hit);
            }else{
                results.add(new Response());
            }
        }
        return results;
    }
}