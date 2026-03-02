public without sharing class UserResponseStepAction2 {
    @InvocableMethod(label='ユーザー回答（後半）を格納')
    public static List<Output> saveUserResponse(List<Request> requests) {
        List<Output> results = new List<Output>();
        for (Request req : requests) {
            UserResponse__c record;

            // レコード特定（bondNumber または name で検索）
            List<UserResponse__c> found = new List<UserResponse__c>();
            if (req.bondNumber != null) {
                found = [
                    SELECT Id FROM UserResponse__c WHERE bond_number__c = :req.bondNumber LIMIT 1
                ];
            } else if (req.name != null) {
                found = [
                    SELECT Id FROM UserResponse__c WHERE name__c = :req.name LIMIT 1
                ];
            }
            if (!found.isEmpty()) {
                record = found[0];
            } else {
                // 前半が未入力の場合新規作成
                record = new UserResponse__c();
                record.Name = req.name != null ? req.name + '_' + DateTime.now().getTime() : 'UserResponse_' + DateTime.now().getTime();
            }
            // 後半のみセット
            if (req.isConnected != null) record.isConnected__c = req.isConnected;
            if (req.carNumber != null) record.carNumber__c = req.carNumber;
            if (req.carName != null) record.carName__c = req.carName;
            if (req.vehicleNumber != null) record.vehicleNumber__c = req.vehicleNumber;
            if (req.expirationDate != null) record.expirationDate__c = req.expirationDate;
            if (req.isWelfare != null) record.isWelfare__c = req.isWelfare;
            if (req.isChangeAddress != null) record.isChangeAddress__c = req.isChangeAddress;
            if (req.contactNumber != null) record.contactNumber__c = req.contactNumber;
            if (req.isCarInsurance != null) record.isCarInsurance__c = req.isCarInsurance;
            if (req.ownerId != null) record.OwnerId = req.ownerId;

            upsert record;
            Output out = new Output();
            out.recordId = record.Id;
            out.statusMessage = '後半格納完了';
            results.add(out);
        }
        return results;
    }

    public class Request {
        @InvocableVariable(label='証券番号')
        public String bondNumber;
        @InvocableVariable(label='契約者名')
        public String name;
        @InvocableVariable(label='車名')
        public String carName;
        @InvocableVariable(label='コネクティッド有無')
        public String isConnected;
        @InvocableVariable(label='ナンバー')
        public String carNumber;
        @InvocableVariable(label='車台番号')
        public String vehicleNumber;
        @InvocableVariable(label='車検満了日')
        public Date expirationDate;
        @InvocableVariable(label='福祉車両割引')
        public String isWelfare;
        @InvocableVariable(label='住所変更有無')
        public String isChangeAddress;
        @InvocableVariable(label='日中連絡先')
        public String contactNumber;
        @InvocableVariable(label='車両保険付帯')
        public String isCarInsurance;
        @InvocableVariable(label='所有者')
        public Id ownerId;
    }

    public class Output {
        @InvocableVariable(label='レコードID')
        public Id recordId;
        @InvocableVariable(label='ステータス')
        public String statusMessage;
    }
}