public with sharing class IdentityVerificationVerifyContract {
    public class Request {
        @InvocableVariable(required=true)
        public String bondNumber;
        @InvocableVariable(required=true)
        public String name;
    }
    public class Response {
        @InvocableVariable
        public Boolean isMatch;
    }
    @InvocableMethod(label='契約情報の本人確認')
    public static List<Response> invoke(List<Request> requests) {
        List<Response> results = new List<Response>();
        for(Request req : requests){
            Boolean matched = IdentityVerification.verifyContract(req.bondNumber, req.name);
            Response res = new Response();
            res.isMatch = matched;
            results.add(res);
        }
        return results;
    }
}