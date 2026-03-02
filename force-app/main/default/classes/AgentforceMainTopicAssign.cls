global with sharing class AgentforceMainTopicAssign {
    global class Request {
        @InvocableVariable(label='ユーザー入力') public String userInput;
        @InvocableVariable(label='LLM暫定カテゴリ') public String topicName;
        @InvocableVariable(label='遷移確認中フラグ') public Boolean isConfirming;
    }

    global class Response {
        @InvocableVariable public Boolean isAssignTopic;          // お手続き遷移
        @InvocableVariable public Boolean isGeneralFAQ;           // FAQ遷移
        @InvocableVariable public Boolean isInquiryComplaint;     // 問い合わせ-苦情
        @InvocableVariable public Boolean isInquiryUpdateExpire;  // 問い合わせ-更新・満期
        @InvocableVariable public Boolean isInquiryPremium;       // 問い合わせ-保険料
        @InvocableVariable public Boolean isInquiryGeneral;       // 問い合わせ-一般
        @InvocableVariable public Boolean isCancelRequested;      // キャンセル・再選択
        @InvocableVariable public String suggestedTopic;          // 判定結果
    }

    @InvocableMethod(label='メイントピック遷移')
    global static List<Response> updateFlags(List<Request> reqs) {
        List<Response> results = new List<Response>();
        for (Request req : reqs) {
            Response res = new Response();

            // 全フラグを初期化
            res.isAssignTopic = false;
            res.isGeneralFAQ = false;
            res.isInquiryComplaint = false;
            res.isInquiryUpdateExpire = false;
            res.isInquiryPremium = false;
            res.isInquiryGeneral = false;
            res.isCancelRequested = false;
            res.suggestedTopic = '';

            String input = req.userInput != null ? req.userInput.trim() : '';
            String tName = req.topicName != null ? req.topicName : '';
            Boolean isConf = req.isConfirming != null ? req.isConfirming : false;

            // --- 1. キャンセル判定 ---
            if (isConf && (
                    input == '2' ||
                    input == 'いいえ' ||
                    input == 'No' ||
                    input == 'no' ||
                    input == 'NO' ||
                    input.contains('キャンセル') ||
                    input == 'キャンセル'
                )) {
                res.isCancelRequested = true;
                res.suggestedTopic = 'none';
                results.add(res);
                continue;
            }

            // --- 2. メニュー選択時の数字入力による強制割当 ---
            if (input == '1') {
                tName = 'procedure';
            } else if (input == '2') {
                tName = 'faq';
            } else if (input == '3') {
                tName = 'inquiryGeneral';
            }

            // --- 3. 相談ベース問い合わせ優先判定 ---
            Boolean isConsult = (
                input.contains('どうしたらいい') || input.contains('どうすればいい') ||
                input.contains('相談') || input.contains('サポートして') ||
                input.contains('連絡') || input.contains('電話') ||
                input.contains('案内して') || input.contains('問い合わせしたい') ||
                input.contains('知りたいことがある') || input.contains('質問があります')
            );

            if (isConsult) {
                // 相談ベース＋苦情ワード
                if (input.contains('苦情') || input.contains('不満') || input.contains('不快') ||
                    input.contains('態度') || input.contains('遅い') || input.contains('ひどい')) {
                    tName = 'inquiryComplaint';
                }
                // 相談ベース＋更新・満期ワード
                else if (input.contains('更新') || input.contains('満期') || input.contains('ハガキ')) {
                    tName = 'inquiryUpdateExpire';
                }
                // 相談ベース＋保険料ワード
                else if (input.contains('保険料') || input.contains('高い') || input.contains('支払い')) {
                    tName = 'inquiryPremium';
                }
                // 相談ベース＋お手続きワード
                else if (input.contains('変更') || input.contains('再発行') || input.contains('解約') ||
                         input.contains('住所') || input.contains('名義')) {
                    tName = 'procedure';
                }
                // 相談ベース＋FAQワード
                else if (input.contains('？') || input.contains('?') || input.contains('仕組み') || 
                         input.contains('とは') || input.contains('いつ') || input.contains('必要ですか')) {
                    tName = 'faq';
                }
                // 相談ベースだが何にも該当しなければ問い合わせ一般
                else {
                    tName = 'inquiryGeneral';
                }
            }
            // --- 4. FAQ優先判定 ---
            else if (
                input.contains('？') || input.contains('?') || input.contains('仕組み') || 
                input.contains('とは') || input.contains('いつ') || input.contains('必要ですか') || tName == 'faq'
            ) {
                tName = 'faq';
            }
            // --- 5. お手続き判定 ---
            else if (
                input.contains('変更') || input.contains('再発行') || input.contains('解約') || 
                input.contains('住所') || input.contains('名義') || tName == 'procedure'
            ) {
                tName = 'procedure';
            }
            // --- 6. 問い合わせ（苦情） ---
            else if (
                input.contains('苦情') || input.contains('不満') || input.contains('不快') || 
                input.contains('態度') || input.contains('遅い') || input.contains('ひどい')
            ) {
                tName = 'inquiryComplaint';
            }
            // --- 7. 問い合わせ（更新・満期） ---
            else if (
                input.contains('更新') || input.contains('満期') || input.contains('ハガキ')
            ) {
                tName = 'inquiryUpdateExpire';
            }
            // --- 8. 問い合わせ（保険料） ---
            else if (
                input.contains('保険料') || input.contains('高い') || input.contains('支払い')
            ) {
                tName = 'inquiryPremium';
            }
            // --- 9. デフォルトは「問い合わせ-一般」 ---
            else {
                tName = 'inquiryGeneral';
            }

            // フラグセット（どれか1つは必ずtrue）
            res.suggestedTopic = tName;
            if (tName == 'procedure') res.isAssignTopic = true;
            else if (tName == 'faq') res.isGeneralFAQ = true;
            else if (tName == 'inquiryComplaint') res.isInquiryComplaint = true;
            else if (tName == 'inquiryUpdateExpire') res.isInquiryUpdateExpire = true;
            else if (tName == 'inquiryPremium') res.isInquiryPremium = true;
            else if (tName == 'inquiryGeneral') res.isInquiryGeneral = true;

            results.add(res);
        }
        return results;
    }
}