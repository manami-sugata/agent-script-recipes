public with sharing class UserResponseSummaryAction2 {
    @InvocableMethod(label='ユーザー回答要約（後半）を生成')
    public static List<Output> summarize(List<Request> requests) {
        List<Output> results = new List<Output>();
        for (Request req : requests) {
            String summary =
                'コネクティッド要否: ' + (req.isConnected != null ? req.isConnected : '') + '\n'
                + 'ナンバープレートの番号: ' + (req.carNumber != null ? req.carNumber : '') + '\n'
                + '車台番号: ' + (req.vehicleNumber != null ? req.vehicleNumber : '') + '\n'
                + '車検満了日: ' + (req.expirationDate != null ? String.valueOf(req.expirationDate) : '') + '\n'
                + '福祉車両割引: ' + (req.isWelfare != null ? req.isWelfare : '') + '\n'
                + '住所変更有無: ' + (req.isChangeAddress != null ? req.isChangeAddress : '') + '\n'
                + '日中連絡先: ' + (req.contactNumber != null ? req.contactNumber : '') + '\n'
                + '車両保険付帯: ' + (req.isCarInsurance != null ? req.isCarInsurance : '') + '\n'
                + '所有者: ' + (req.ownerId != null ? String.valueOf(req.ownerId) : '');

            Output out = new Output();
            out.summary = summary;
            results.add(out);
        }
        return results;
    }

    public class Request {
        @InvocableVariable(label='コネクティッド')
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
        @InvocableVariable(label='後半要約テキスト')
        public String summary;
    }
}