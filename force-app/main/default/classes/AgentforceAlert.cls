public class AgentforceAlert {

    public class Result {
        @InvocableVariable(label='処理結果')
        public Boolean success;
        @InvocableVariable(label='通知内容')
        public String message;
    }

    @InvocableMethod(label='エージェントアラート通知')
    public static List<Result> sendAlert(List<String> messages) {
        List<Result> results = new List<Result>();
        for (String msg : messages) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {'manami.sugata@accenture.com'});
            mail.setSubject('【Agentforce通知】ユーザー対応要');
            mail.setPlainTextBody(msg + '\n至急、有人対応をお願いします。');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});

            Result r = new Result();
            r.success = true;
            r.message = '通知済: ' + msg;
            results.add(r);
        }
        return results;
    }
}