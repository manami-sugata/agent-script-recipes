public with sharing class UserResponseSummaryMerger {
    @InvocableMethod(label='要約テキスト合体' description='前半・後半の要約文字列を結合')
    public static List<Output> mergeSummaries(List<Request> requests) {
        List<Output> results = new List<Output>();
        for (Request req : requests) {
            String merged = '';
            if (req.summary1 != null && req.summary1 != '') {
                merged += req.summary1.trim();
            }
            if (req.summary2 != null && req.summary2 != '') {
                if (merged != '') merged += '\n'; // 前半が空でなければ改行
                merged += req.summary2.trim();
            }
            Output out = new Output();
            out.summary = merged;
            results.add(out);
        }
        return results;
    }

    public class Request {
        @InvocableVariable(label='前半要約テキスト')
        public String summary1;
        @InvocableVariable(label='後半要約テキスト')
        public String summary2;
    }

    public class Output {
        @InvocableVariable(label='合体要約テキスト')
        public String summary;
    }
}