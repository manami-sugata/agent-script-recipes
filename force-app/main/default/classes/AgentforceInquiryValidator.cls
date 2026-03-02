global with sharing class AgentforceInquiryValidator {
    global class Request {
        @InvocableVariable(label='ユーザーの発言内容')
        public String userInput;
        @InvocableVariable(label='特定された用件')
        public String requirement;
        @InvocableVariable(label='特定された保険種類')
        public String insuranceType;
    }

    global class Response {
        @InvocableVariable(label='遷移準備完了フラグ')
        public Boolean isReadyToTransition;
        @InvocableVariable(label='トピック名（合成）')
        public String finalTopicName;
        @InvocableVariable(label='不足情報メッセージ')
        public String missingInfoMessage;
    }

    @InvocableMethod(label='用件・保険種別チェック')
    global static List<Response> validate(List<Request> reqs) {
        Set<String> validTopics = new Set<String>{
            'autoReissue', 'autoAddressChange', 'autoAccountChange', 'autoNameChange',
            'autoPurposeChange', 'autoPhoneChange', 'autoCancel', 'autoVehicleSwap',
            'autoDriverChange', 'fireCancel', 'fireReissue', 'fireAddressChange',
            'firePhoneChange', 'fireAccountChange', 'compulsoryCancel', 
            'compulsoryMove', 'compulsoryProof'
        };

        List<Response> results = new List<Response>();
        for (Request req : reqs) {
            Response res = new Response();
            String input = (req.userInput != null) ? req.userInput : '';
            String type = (req.insuranceType != null) ? req.insuranceType.toLowerCase() : 'none';
            String reqVal = (req.requirement != null) ? req.requirement : 'none';

            // 要約素材の準備（全角ドット回避）
            String userTask = (reqVal != 'none' && reqVal != 'null') ? reqVal : input;
            if (userTask.length() > 50) { 
                userTask = userTask.substring(0, 50) + '...'; 
            }

            Boolean hasType = (type != 'none' && String.isNotBlank(type));
            Boolean hasReq = (reqVal != 'none' && String.isNotBlank(reqVal));

            // --- 振り分けトピック名の決定ロジック ---
            String targetTopic = 'inquiry'; // デフォルト

            if (hasType) {
                if (type == 'auto') {
                    targetTopic = 'autoInquiry';
                } else if (type == 'fire') {
                    targetTopic = 'fireInquiry';
                } else if (type == 'compulsory') {
                    targetTopic = 'compulsoryInquiry';
                }
            }

            // --- 判定ロジック ---

            if (hasType) {
                // 【遷移OK】保険種類がある場合
                res.isReadyToTransition = true;
                
                // 特定の手続きに合致するかチェック
                String generatedName = type + reqVal.substring(0, 1).toUpperCase() + reqVal.substring(1);
                res.finalTopicName = (hasReq && validTopics.contains(generatedName)) ? generatedName : targetTopic;
                
                res.missingInfoMessage = ''; 
            } 
            else {
                // 【遷移保留】保険種類が不明な場合
                res.isReadyToTransition = false;
                res.finalTopicName = targetTopic;
                
                // LLMに「要約」と「共感」を依頼するタグ形式
                res.missingInfoMessage = 'SUMMARIZE_START[' + userTask + ']SUMMARIZE_END';
            }
            results.add(res);
        }
        return results;
    }
}