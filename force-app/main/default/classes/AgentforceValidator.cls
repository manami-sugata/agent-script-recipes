global with sharing class AgentforceValidator {
    global class Request {
        @InvocableVariable(required=true) public String insuranceType; // 自動車, auto, 火災, fire など
        @InvocableVariable(required=true) public String requirement;    // 住所変更, reissue, 解約 など
        @InvocableVariable public String userInput;
    }

    global class Response {
        @InvocableVariable public String finalTopicName;
        @InvocableVariable public Boolean isReadyToTransition;
        @InvocableVariable public String summary;
    }

    @InvocableMethod(label='トピック判定バリデーター')
    global static List<Response> validateIntent(List<Request> reqs) {
        List<Response> results = new List<Response>();
        
        // フラグ更新Apex（AgentforceTopicAssign）の判定名と完全に一致させるリスト
        Set<String> validTopics = new Set<String>{
            'autoReissue', 'autoAddressChange', 'autoAccountChange', 'autoNameChange',
            'autoPurposeChange', 'autoPhoneChange', 'autoCancel', 'autoVehicleSwap', 'autoDriverChange',
            'fireCancel', 'fireReissue', 'fireAddressChange', 'firePhoneChange', 'fireAccountChange',
            'compulsoryCancel', 'compulsoryMove', 'compulsoryProof'
        };

        for (Request req : reqs) {
            Response res = new Response();
            
            // --- 判定準備：保険種別の正規化（英語・日本語両対応） ---
            String typePrefix = '';
            String lowType = (req.insuranceType != null) ? req.insuranceType.toLowerCase() : '';
            if (lowType.contains('自動車') || lowType.contains('auto')) {
                typePrefix = 'auto';
            } else if (lowType.contains('火災') || lowType.contains('fire')) {
                typePrefix = 'fire';
            } else if (lowType.contains('自賠責') || lowType.contains('compulsory')) {
                typePrefix = 'compulsory';
            }

            // --- 判定準備：用件の正規化（AIが生成する英単語にも対応） ---
            String reqEnglish = '';
            String lowReq = (req.requirement != null) ? req.requirement.toLowerCase() : '';
            
            if (lowReq.contains('住所') || lowReq.contains('address')) reqEnglish = 'AddressChange';
            else if (lowReq.contains('解約') || lowReq.contains('cancel')) reqEnglish = 'Cancel';
            else if (lowReq.contains('名義') || lowReq.contains('name')) reqEnglish = 'NameChange';
            else if (lowReq.contains('口座') || lowReq.contains('account')) reqEnglish = 'AccountChange';
            else if (lowReq.contains('再発行') || lowReq.contains('reissue')) reqEnglish = 'Reissue';
            else if (lowReq.contains('電話') || lowReq.contains('phone')) reqEnglish = 'PhoneChange';
            else if (lowReq.contains('車両') || lowReq.contains('vehicle')) reqEnglish = 'VehicleSwap';
            else if (lowReq.contains('運転者') || lowReq.contains('driver')) reqEnglish = 'DriverChange';
            else if (lowReq.contains('目的') || lowReq.contains('purpose')) reqEnglish = 'PurposeChange';
            else if (lowReq.contains('転居') || lowReq.contains('move')) reqEnglish = 'Move';
            else if (lowReq.contains('証明') || lowReq.contains('proof')) reqEnglish = 'Proof';

            // --- 判定フェーズ1：具体的な手続きトピックの結合チェック（最優先） ---
            String generatedTopic = '';
            if (String.isNotBlank(typePrefix) && String.isNotBlank(reqEnglish)) {
                generatedTopic = typePrefix + reqEnglish;
            }

            if (validTopics.contains(generatedTopic)) {
                res.finalTopicName = generatedTopic;
            } 
            // --- 判定フェーズ2：保険種別が未特定（none）だが用件はある場合 ---
            else if (String.isBlank(typePrefix) && String.isNotBlank(reqEnglish)) {
                res.finalTopicName = 'inquiryGeneral'; // まだ保険種類を聞く必要がある
            }
            // --- 判定フェーズ3：キーワードによる問い合わせ種別の特定 ---
            else if (lowReq.contains('連絡') || lowReq.contains('遅い') || lowReq.contains('不満')) {
                res.finalTopicName = 'inquiryComplaint';
            }
            else if (lowReq.contains('引き落とし') || lowReq.contains('保険料') || lowReq.contains('支払い')) {
                res.finalTopicName = 'inquiryPremium';
            }
            else if (lowReq.contains('更新') || lowReq.contains('満期')) {
                res.finalTopicName = 'inquiryUpdateExpire';
            }
            else {
                res.finalTopicName = 'inquiryGeneral';
            }

            // 準備完了フラグ
            // inquiryGeneral 以外、かつ保険種別が判明していれば True
            res.isReadyToTransition = (res.finalTopicName != 'inquiryGeneral' && String.isNotBlank(typePrefix));
            
            res.summary = req.requirement + 'に関するお手続き';
            results.add(res);
        }
        return results;
    }
}