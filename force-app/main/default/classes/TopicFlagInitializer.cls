global with sharing class TopicFlagInitializer {
    global class Request {
        @InvocableVariable
        public String dummy; // ダミーでOK
    }
    global class Response {
        @InvocableVariable
        public Boolean topic1Flag;
        @InvocableVariable
        public Boolean topic2Flag;
    }

    @InvocableMethod(label='トピックフラグ初期化')
    global static List<Response> initialize(List<Request> reqs) {
        List<Response> results = new List<Response>();
        for (Request req : reqs) {
            Response res = new Response();
            res.topic1Flag = true;
            res.topic2Flag = false;
            results.add(res);
        }
        return results;
    }
}