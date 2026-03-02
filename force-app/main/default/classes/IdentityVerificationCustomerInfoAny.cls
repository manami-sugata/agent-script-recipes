global with sharing class IdentityVerificationCustomerInfoAny {
    global class Request {
        @InvocableVariable(required=false)
        public String bondNumber;
        @InvocableVariable(required=false)
        public String name;
        @InvocableVariable(required=false)
        public String address;
        @InvocableVariable(required=false)
        public String telNumber;
        @InvocableVariable(required=false)
        public String birth;
    }
    global class Response {
        @InvocableVariable
        public Boolean isMatchAny; // ←ここを変更
    }
    @InvocableMethod(label='顧客情報いずれか一致判定')
    global static List<Response> invoke(List<Request> requests) {
        List<Response> results = new List<Response>();
        for(Request req : requests){
            Boolean matched = IdentityVerification.CustomerInfoAny(req.bondNumber,req.name, req.address, req.telNumber, req.birth);
            Response res = new Response();
            res.isMatchAny = matched; // ←ここも変更
            results.add(res);
        }
        return results;
    }
}