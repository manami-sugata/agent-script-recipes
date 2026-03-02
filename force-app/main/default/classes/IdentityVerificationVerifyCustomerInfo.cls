public with sharing class IdentityVerificationVerifyCustomerInfo {
    public class Request {
        @InvocableVariable(required=true)
        public String name;
        @InvocableVariable(required=true)
        public String address;
        @InvocableVariable(required=true)
        public String telNumber;
        @InvocableVariable(required=true)
        public String birth;
    }
    public class Response {
        @InvocableVariable
        public Boolean isMatchAll;
    }
    @InvocableMethod(label='顧客情報一致判定')
    public static List<Response> invoke(List<Request> requests) {
        List<Response> results = new List<Response>();
        for(Request req : requests){
            Boolean matched = IdentityVerification.verifyCustomerInfo(req.name, req.address, req.telNumber, req.birth);
            Response res = new Response();
            res.isMatchAll = matched;
            results.add(res);
        }
        return results;
    }
}