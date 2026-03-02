public with sharing class IdentityVerificationVerifyCarNumber {
    public class Request {
        @InvocableVariable(required=true)
        public String name;
        @InvocableVariable(required=true)
        public String carNumber;
    }
    public class Response {
        @InvocableVariable
        public Boolean isMatchNumber;
    }
    @InvocableMethod(label='ナンバープレート一致判定')
    public static List<Response> invoke(List<Request> requests) {
        List<Response> results = new List<Response>();
        for(Request req : requests){
            Boolean matched = IdentityVerification.verifyCarNumber(req.name, req.carNumber);
            Response res = new Response();
            res.isMatchNumber = matched;
            results.add(res);
        }
        return results;
    }
}