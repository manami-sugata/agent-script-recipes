global with sharing class AgentforceTopicRouter {
    global class Request {
        @InvocableVariable
        public String dummy; // ダミーでOK
    }
    global class Response {
        @InvocableVariable
        public Boolean isOpening;
        @InvocableVariable
        public Boolean isTopicFilter;
    }

    @InvocableMethod(label='オープニング-トピック振り分け')
    global static List<Response> updateFlags(List<Request> reqs) {
        List<Response> results = new List<Response>();
        for (Request req : reqs) {
            Response res = new Response();
            res.isOpening = false;
            res.isTopicFilter = true;
            results.add(res);
        }
        return results;
    }
}