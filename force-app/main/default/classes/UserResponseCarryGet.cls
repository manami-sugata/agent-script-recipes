public without sharing class UserResponseCarryGet {
    @InvocableMethod(label='証券番号・名前・車名・初度登録年月・新住所を取得')
    public static List<Output> getCarryInfo(List<Input> requests) {
        List<Output> results = new List<Output>();
        String sessionId = UserInfo.getSessionId();
        List<UserResponse__c> found = [
            SELECT bond_number__c, name__c, carName__c, dateFirstRegistration__c, newAddress__c
            FROM UserResponse__c
            WHERE sessionId__c = :sessionId
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        if (!found.isEmpty()) {
            UserResponse__c rec = found[0];
            Output out = new Output();
            out.bondNumber = rec.bond_number__c;
            out.name = rec.name__c;
            out.carName = rec.carName__c;
            out.dateFirstRegistration = rec.dateFirstRegistration__c;
            out.newAddress = rec.newAddress__c;
            results.add(out);
        }
        return results;
    }

    public class Input {
        @InvocableVariable(label='ダミー')
        public String dummyValue;
    }

    public class Output {
        @InvocableVariable(label='証券番号')
        public String bondNumber;
        @InvocableVariable(label='契約者名')
        public String name;
        @InvocableVariable(label='車名')
        public String carName;
        @InvocableVariable(label='初度登録年月')
        public String dateFirstRegistration;
        @InvocableVariable(label='新住所')
        public String newAddress;
    }
}