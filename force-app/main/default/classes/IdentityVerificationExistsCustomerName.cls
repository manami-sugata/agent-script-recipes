public with sharing class IdentityVerificationExistsCustomerName {
    public class Request {
        @InvocableVariable(required=true)
        public String name;
    }
    public class Response {
        @InvocableVariable
        public Boolean exists;
    }
    @InvocableMethod(label='契約者名の存在確認')
    public static List<Response> invoke(List<Request> requests) {
        List<Response> results = new List<Response>();
        for(Request req : requests){
            Boolean matched = IdentityVerification.existsCustomerName(req.name);
            Response res = new Response();
            res.exists = matched;
            results.add(res);
        }
        return results;
    }
}