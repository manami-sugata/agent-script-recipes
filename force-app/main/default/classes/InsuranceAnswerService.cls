public with sharing class InsuranceAnswerService {
    public class Request {
        @InvocableVariable
        public String question;
    }

    public class Response {
        @InvocableVariable
        public String answer;
    }

    @InvocableMethod(label='FAQ')
    public static List<Response> getAnswers(List<Request> requests) {
        List<Response> results = new List<Response>();
        // 検索対象カテゴリ（必要に応じて追加・修正）
        List<String> categories = new List<String>{'地震', '火災', '盗難', '自転車'};

        for (Request req : requests) {
            String answerText = '';
            String matchedCategory = null;

            // 質問文に含まれるカテゴリを抽出
            for (String cat : categories) {
                if (req.question != null && req.question.contains(cat)) {
                    matchedCategory = cat;
                    break;
                }
            }

            if (matchedCategory != null) {
                List<FAQ_Master__c> faqList = [
                    SELECT Answer_Body__c
                    FROM FAQ_Master__c
                    WHERE Category__c LIKE :('%' + matchedCategory + '%')
                    LIMIT 1
                ];
                if (!faqList.isEmpty()) {
                    answerText = faqList[0].Answer_Body__c;
                } else {
                    answerText = matchedCategory + 'に関する回答が見つかりませんでした。';
                }
            } else {
                answerText = 'ご質問内容に該当するカテゴリがありませんでした。';
            }
            Response res = new Response();
            res.answer = answerText;
            results.add(res);
        }
        return results;
    }
}