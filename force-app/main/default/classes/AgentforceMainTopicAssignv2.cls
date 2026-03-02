global with sharing class AgentforceMainTopicAssignv2 {
    global class Request {
        @InvocableVariable(label='ユーザー入力') public String userInput;
        @InvocableVariable(label='LLM暫定カテゴリ') public String topicName;
    }

    global class Response {
        @InvocableVariable public Boolean isAssignTopic;
        @InvocableVariable public Boolean isGeneralFAQ;
        @InvocableVariable public String suggestedTopic;
    }

    @InvocableMethod(label='メイントピック遷移v2')
    global static List<Response> updateFlags(List<Request> reqs) {
        List<Response> results = new List<Response>();
        for (Request req : reqs) {
            Response res = new Response();
            
            // フラグの初期化
            res.isAssignTopic = false;
            res.isGeneralFAQ = false;
            
            String tName = req.topicName != null ? req.topicName : '';

            // LLMが判定したカテゴリ(topicName)をそのままフラグに反映
            if (tName == 'procedure') {
                res.isAssignTopic = true;
            } else if (tName == 'faq') {
                res.isGeneralFAQ = true;
            }

            res.suggestedTopic = tName;
            results.add(res);
        }
        return results;
    }
}