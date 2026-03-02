public with sharing class TopicFlagUpdate {
    public class Request {
        @InvocableVariable public Boolean topic1Flag; // 現在の値（必要なら）
        @InvocableVariable public Boolean topic2Flag; // 現在の値（必要なら）
    }
    public class Response {
        @InvocableVariable public Boolean topic1Flag;
        @InvocableVariable public Boolean topic2Flag;
    }

    @InvocableMethod(label='トピックフラグ更新')
    public static List<Response> updateFlags(List<Request> requests) {
        List<Response> results = new List<Response>();
        for(Request req : requests){
            Response res = new Response();
            // トピック1終了時の更新例
            res.topic1Flag = false;
            res.topic2Flag = true;
            results.add(res);
        }
        return results;
    }
}