public with sharing class AgentIdentityAction {

    public class Input {
        @InvocableVariable public String bondNumber;    // 証券番号
        @InvocableVariable public String name;          // 氏名
        @InvocableVariable public String address;       // 住所
        @InvocableVariable public String telNumber;     // 電話番号
        @InvocableVariable public String birth;         // 生年月日
        @InvocableVariable public String regNumber;     // 車両登録番号
        @InvocableVariable public Boolean inFourItemsMode; // 4項目モードかどうか
    }

    public class Output {
        @InvocableVariable public Boolean areDetailsRegistered;   // ④ 証券番号＋名前で電話番号・生年月日が登録されているか
        @InvocableVariable public Boolean isInfoAllMatched;       // ⑤ 4項目（名前・住所・電話番号・生年月日）全一致
        @InvocableVariable public Boolean isRegistrationMatched;  // ⑥ 車両登録番号一致
        @InvocableVariable public String nextTemplateKey;
        @InvocableVariable public String message;
    }

    @InvocableMethod(label='エージェント本人確認アクション')
    public static List<Output> run(List<Input> inputs) {
        List<Output> results = new List<Output>();
        if (inputs == null) return results;

        for (Input item : inputs) {
            Output out = new Output();

            // ④ 証券番号＋名前で電話番号・生年月日が登録されているか
            out.areDetailsRegistered = IdentityVerification.areDetailsRegistered(item.bondNumber, item.name);

            // ⑤ 4項目一致
            out.isInfoAllMatched = IdentityVerification.isInfoAllMatched(item.name, item.address, item.telNumber, item.birth);

            // ⑥ 車両登録番号一致
            out.isRegistrationMatched = IdentityVerification.isRegistrationMatched(item.bondNumber, item.regNumber);

            // nextTemplateKey の例（業務要件にあわせて分岐を調整）
            if (out.isInfoAllMatched) {
                out.nextTemplateKey = 'PT_CONFIRM_CONTRACT';
                out.message = '4項目一致で本人確認OK';
            } else if (out.isRegistrationMatched) {
                out.nextTemplateKey = 'PT_CONFIRM_CONTRACT_BY_REG';
                out.message = '車両登録番号一致で本人確認OK';
            } else if (out.areDetailsRegistered) {
                out.nextTemplateKey = 'PT_ASK_MORE_INFO';
                out.message = '電話番号・生年月日が登録されています。追加項目を案内';
            } else {
                out.nextTemplateKey = 'PT_ESCALATE';
                out.message = '本人確認不可、エスカレーション';
            }

            results.add(out);
        }
        return results;
    }
}