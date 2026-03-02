global with sharing class AgentforceInquiryTopic {
    global class Request {
        @InvocableVariable(required=true label='保険種類') public String insuranceType;
        @InvocableVariable(required=true label='用件') public String requirement;
    }

    global class Response {
        @InvocableVariable(label='遷移準備完了フラグ') public Boolean isReadyToTransition;
    }

    @InvocableMethod(label='保険種類・用件確認')
    global static List<Response> validate(List<Request> reqs) {
        List<Response> results = new List<Response>();
        for (Request req : reqs) {
            Response res = new Response();
            // insuranceType と requirement が 'none' 以外で埋まっていれば、
            // 内容がどうあれ「次のアクション（フラグ更新）へ進んでよし」と許可を出す
            res.isReadyToTransition = (req.insuranceType != 'none' && String.isNotBlank(req.requirement) && req.requirement != 'none');
            results.add(res);
        }
        return results;
    }
}