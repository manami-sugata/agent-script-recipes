global with sharing class AgentforceTopicAssign {
    global class Request {
        @InvocableVariable(required=true label='遷移先トピック名' description='autoReissue, autoInquiry, reset などを入力')
        public String topicName;
    }

    global class Response {
        @InvocableVariable public Boolean isTopicFilter;
        @InvocableVariable public Boolean isAutoReissue;
        @InvocableVariable public Boolean isAutoAddressChange;
        @InvocableVariable public Boolean isAutoAccountChange;
        @InvocableVariable public Boolean isAutoNameChange;
        @InvocableVariable public Boolean isAutoPurposeChange;
        @InvocableVariable public Boolean isAutoPhoneChange;
        @InvocableVariable public Boolean isAutoCancel;
        @InvocableVariable public Boolean isAutoVehicleSwap;
        @InvocableVariable public Boolean isAutoDriverChange;
        @InvocableVariable public Boolean isFireCancel;
        @InvocableVariable public Boolean isFireReissue;
        @InvocableVariable public Boolean isFireAddressChange;
        @InvocableVariable public Boolean isFirePhoneChange;
        @InvocableVariable public Boolean isFireAccountChange;
        @InvocableVariable public Boolean isCompulsoryCancel;
        @InvocableVariable public Boolean isCompulsoryMove;
        @InvocableVariable public Boolean isCompulsoryProof;
        @InvocableVariable public Boolean isInquiryUpdateExpire;
        @InvocableVariable public Boolean isInquiryComplaint;
        @InvocableVariable public Boolean isInquiryPremium;
        @InvocableVariable public Boolean isInquiryGeneral;
        @InvocableVariable public Boolean isFireEarthquake;
        @InvocableVariable public Boolean isFireContractChange;
        @InvocableVariable public Boolean isFireTargetChange;
        // 追加分
        @InvocableVariable public Boolean isAutoCoverageChange;   // 自動車保険-補償内容変更
        @InvocableVariable public Boolean isAutoContractChange;   // 自動車保険-契約者変更
    }

    @InvocableMethod(label='トピックフラグ更新')
    global static List<Response> updateFlags(List<Request> reqs) {
        List<Response> results = new List<Response>();
        for (Request req : reqs) {
            Response res = new Response();

            // --- 全て False で初期化 ---
            res.isTopicFilter = false;
            res.isAutoReissue = false;
            res.isAutoAddressChange = false;
            res.isAutoAccountChange = false;
            res.isAutoNameChange = false;
            res.isAutoPurposeChange = false;
            res.isAutoPhoneChange = false;
            res.isAutoCancel = false;
            res.isAutoVehicleSwap = false;
            res.isAutoDriverChange = false;
            res.isFireCancel = false;
            res.isFireReissue = false;
            res.isFireAddressChange = false;
            res.isFirePhoneChange = false;
            res.isFireAccountChange = false;
            res.isCompulsoryCancel = false;
            res.isCompulsoryMove = false;
            res.isCompulsoryProof = false;
            res.isInquiryUpdateExpire = false;
            res.isInquiryComplaint = false;
            res.isInquiryPremium = false;
            res.isInquiryGeneral = false;
            res.isFireEarthquake = false;
            res.isFireContractChange = false;
            res.isFireTargetChange = false;
            // 追加分も初期化
            res.isAutoCoverageChange = false;
            res.isAutoContractChange = false;

            // --- topicName に基づいて該当フラグを True に更新 ---
            if (req.topicName == 'autoReissue') res.isAutoReissue = true;
            else if (req.topicName == 'autoAddressChange') res.isAutoAddressChange = true;
            else if (req.topicName == 'autoAccountChange') res.isAutoAccountChange = true;
            else if (req.topicName == 'autoNameChange') res.isAutoNameChange = true;
            else if (req.topicName == 'autoPurposeChange') res.isAutoPurposeChange = true;
            else if (req.topicName == 'autoPhoneChange') res.isAutoPhoneChange = true;
            else if (req.topicName == 'autoCancel') res.isAutoCancel = true;
            else if (req.topicName == 'autoVehicleSwap') res.isAutoVehicleSwap = true;
            else if (req.topicName == 'autoDriverChange') res.isAutoDriverChange = true;
            else if (req.topicName == 'fireCancel') res.isFireCancel = true;
            else if (req.topicName == 'fireReissue') res.isFireReissue = true;
            else if (req.topicName == 'fireAddressChange') res.isFireAddressChange = true;
            else if (req.topicName == 'firePhoneChange') res.isFirePhoneChange = true;
            else if (req.topicName == 'fireAccountChange') res.isFireAccountChange = true;
            else if (req.topicName == 'compulsoryCancel') res.isCompulsoryCancel = true;
            else if (req.topicName == 'compulsoryMove') res.isCompulsoryMove = true;
            else if (req.topicName == 'compulsoryProof') res.isCompulsoryProof = true;
            else if (req.topicName == 'inquiryUpdateExpire') res.isInquiryUpdateExpire = true;
            else if (req.topicName == 'inquiryComplaint') res.isInquiryComplaint = true;
            else if (req.topicName == 'inquiryPremium') res.isInquiryPremium = true;
            else if (req.topicName == 'inquiryGeneral') res.isInquiryGeneral = true;
            else if (req.topicName == 'fireEarthquake') res.isFireEarthquake = true;
            else if (req.topicName == 'fireContractChange') res.isFireContractChange = true;
            else if (req.topicName == 'fireTargetChange') res.isFireTargetChange = true;
            // 追加分
            else if (req.topicName == 'autoCoverageChange') res.isAutoCoverageChange = true;
            else if (req.topicName == 'autoContractChange') res.isAutoContractChange = true;

            results.add(res);
        }
        return results;
    }
}