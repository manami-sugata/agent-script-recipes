public with sharing class IdentityVerificationHasTelAndBirth {
    public class Request {
        @InvocableVariable(required=true)
        public String name;
    }
    public class Response {
        @InvocableVariable
        public Boolean hasTelAndBirth;
    }
    @InvocableMethod(label='電話番号・生年月日の登録有無')
    public static List<Response> invoke(List<Request> requests) {
        List<Response> results = new List<Response>();
        for(Request req : requests){
            Boolean matched = IdentityVerification.hasTelAndBirth(req.name);
            Response res = new Response();
            res.hasTelAndBirth = matched;
            results.add(res);
        }
        return results;
    }
}