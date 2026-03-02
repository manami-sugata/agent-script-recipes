public without sharing class UserResponseCarrySave {
    @InvocableMethod(label='証券番号・名前・車名・初度登録年月・新住所を格納')
    public static List<Output> saveCarryInfo(List<Input> requests) {
        List<Output> results = new List<Output>();
        String sessionId = UserInfo.getSessionId();
        for (Input req : requests) {
            UserResponse__c record = new UserResponse__c();
            record.sessionId__c = sessionId; // セッションIDを格納
            if (req.bondNumber != null) record.bond_number__c = req.bondNumber;
            if (req.name != null) record.name__c = req.name;
            if (req.dateFirstRegistration != null) record.dateFirstRegistration__c = req.dateFirstRegistration;
            if (req.carName != null) record.carName__c = req.carName;
            if (req.newAddress != null) record.newAddress__c = req.newAddress;
            insert record;
 
            Output out = new Output();
            out.recordId = record.Id;
            out.status = '格納完了';
            results.add(out);
        }
        return results;
    }
 
    public class Input {
        @InvocableVariable(label='証券番号')
        public String bondNumber;
        @InvocableVariable(label='契約者名')
        public String name;
        @InvocableVariable(label='初度登録年月')
        public String dateFirstRegistration;
        @InvocableVariable(label='車名')
        public String carName;
        @InvocableVariable(label='新住所')
        public String newAddress;
    }
 
    public class Output {
        @InvocableVariable(label='レコードID')
        public Id recordId;
        @InvocableVariable(label='ステータス')
        public String status;
    }
}