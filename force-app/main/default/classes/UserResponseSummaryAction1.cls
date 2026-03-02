public with sharing class UserResponseSummaryAction1 {
    @InvocableMethod(label='ユーザー回答要約（前半）を生成')
    public static List<Output> summarize(List<Request> requests) {
        List<Output> results = new List<Output>();
        for (Request req : requests) {
            String summary =
                '契約者名: ' + (req.name != null ? req.name : '') + '\n'
                + '証券番号: ' + (req.bondNumber != null ? req.bondNumber : '') + '\n'
                + '納車日: ' + (req.deliveryDate != null ? req.deliveryDate : '') + '\n'
                + '登録年月日: ' + (req.registerDate != null ? req.registerDate : '') + '\n'
                + '初度登録年月: ' + (req.dateFirstRegistration != null ? req.dateFirstRegistration : '') + '\n'
                + '自動車の種別: ' + (req.carType != null ? req.carType : '') + '\n'
                + '形状: ' + (req.carShape != null ? req.carShape : '') + '\n'
                + '名義変更有無: ' + (req.isChangeMeigi != null ? req.isChangeMeigi : '') + '\n'
                + '型式: ' + (req.carModel != null ? req.carModel : '') + '\n'
                + '燃料の種類: ' + (req.fuelType != null ? req.fuelType : '') + '\n'
                + '車名: ' + (req.carName != null ? req.carName : '') + '\n'
                + 'ハイブリッド車要否: ' + (req.isHybrid != null ? req.isHybrid : '');

            Output out = new Output();
            out.summary = summary;
            results.add(out);
        }
        return results;
    }

    public class Request {
        @InvocableVariable(label='証券番号')
        public String bondNumber;
        @InvocableVariable(label='契約者名')
        public String name;
        @InvocableVariable(label='納車日')
        public String deliveryDate;
        @InvocableVariable(label='登録年月日')
        public String registerDate;
        @InvocableVariable(label='初度登録年月')
        public String dateFirstRegistration;
        @InvocableVariable(label='自動車の種別')
        public String carType;
        @InvocableVariable(label='形状')
        public String carShape;
        @InvocableVariable(label='名義変更有無')
        public String isChangeMeigi;
        @InvocableVariable(label='型式')
        public String carModel;
        @InvocableVariable(label='燃料種類')
        public String fuelType;
        @InvocableVariable(label='車名')
        public String carName;
        @InvocableVariable(label='ハイブリッド車')
        public String isHybrid;
    }

    public class Output {
        @InvocableVariable(label='前半要約テキスト')
        public String summary;
    }
}