public with sharing class UserResponseSummaryAction {
    @InvocableMethod(label='ユーザー回答要約を生成' description='全項目をまとめた要約テキストを返す')
    public static List<Output> summarize(List<Request> requests) {
        List<Output> results = new List<Output>();
        for (Request req : requests) {
            // nullの場合は「未入力」と表示
            String summary =
                '契約者名: ' + (req.name != null ? req.name : '未入力') + '\n'
                + '証券番号: ' + (req.bondNumber != null ? req.bondNumber : '未入力') + '\n'
                + '納車日: ' + (req.deliveryDate != null ? req.deliveryDate : '未入力') + '\n'
                + '登録年月日: ' + (req.registerDate != null ? req.registerDate : '未入力') + '\n'
                + '初度登録年月: ' + (req.dateFirstRegistration != null ? req.dateFirstRegistration : '未入力') + '\n'
                + '自動車の種別: ' + (req.carType != null ? req.carType : '未入力') + '\n'
                + '形状: ' + (req.carShape != null ? req.carShape : '未入力') + '\n'
                + '名義変更有無: ' + (req.isChangeMeigi != null ? req.isChangeMeigi : '未入力') + '\n'
                + '型式: ' + (req.carModel != null ? req.carModel : '未入力') + '\n'
                + '燃料種類: ' + (req.fuelType != null ? req.fuelType : '未入力') + '\n'
                + '車名: ' + (req.carName != null ? req.carName : '未入力') + '\n'
                + 'ハイブリッド車: ' + (req.isHybrid != null ? req.isHybrid : '未入力') + '\n'
                + 'コネクティッド有無: ' + (req.isConnected != null ? req.isConnected : '未入力') + '\n'
                + 'ナンバー: ' + (req.carNumber != null ? req.carNumber : '未入力') + '\n'
                + '車台番号: ' + (req.vehicleNumber != null ? req.vehicleNumber : '未入力') + '\n'
                + '車検満了日: ' + (req.expirationDate != null ? String.valueOf(req.expirationDate) : '未入力') + '\n'
                + '福祉車両割引: ' + (req.isWelfare != null ? req.isWelfare : '未入力') + '\n'
                + '住所変更有無: ' + (req.isChangeAddress != null ? req.isChangeAddress : '未入力') + '\n'
                + '日中連絡先: ' + (req.contactNumber != null ? req.contactNumber : '未入力') + '\n'
                + '車両保険付帯: ' + (req.isCarInsurance != null ? req.isCarInsurance : '未入力') + '\n'
                + '新価特約付帯: ' + (req.newPrice != null ? req.newPrice : '未入力') + '\n'
                + '所有者: ' + (req.ownerId != null ? String.valueOf(req.ownerId) : '未入力');
                
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
        @InvocableVariable(label='新価特約付帯')
        public String newPrice;
        @InvocableVariable(label='所有者')
        public Id ownerId;
    }

    public class Output {
        @InvocableVariable(label='要約テキスト')
        public String summary;
    }
}