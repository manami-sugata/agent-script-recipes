public with sharing class BondNameCheck {

    // 入力：今回ユーザーが入力した項目＋セッション状態
    public class Request {
        @InvocableVariable public String bondNumber;     // 今回の証券番号（未入力可）
        @InvocableVariable public String name;           // 今回の氏名（未入力可）
        // セッション状態（呼び出し側で保持して渡す）
        @InvocableVariable public Integer bondAttempts;  // 証券番号不一致（存在しない）回数
        @InvocableVariable public Integer nameAttempts;  // 氏名不一致回数
        // 追加: 直近の正規化済み値（返却で受け取り毎回渡す）
        @InvocableVariable public String lastBond;
        @InvocableVariable public String lastName;
    }

    // 出力：次の指示テンプレートと更新済み状態
    public class Response {
        @InvocableVariable public Boolean matched;       // 氏名まで一致したら true
        // 旧仕様互換
        @InvocableVariable public Boolean exists;        // 証券番号が存在するか
        @InvocableVariable public String message;        // 技術メッセージ（ログ/分岐用）
        @InvocableVariable public String nextTemplateKey;// 次に提示すべき指示
        @InvocableVariable public Integer bondAttempts;  // 更新後の回数
        @InvocableVariable public Integer nameAttempts;  // 更新後の回数
        // 返却: 正規化済み最新値
        @InvocableVariable public String lastBond;
        @InvocableVariable public String lastName;
    }

     @InvocableMethod(label='証券番号＋氏名の一致チェック（正規化＋保持値合成）')
    public static List<Response> check(List<Request> reqs) {
        List<Response> outs = new List<Response>();
        if (reqs == null) return outs;

        for (Request r : reqs) {
            Response o = new Response();
            Integer bCnt = (r.bondAttempts == null ? 0 : r.bondAttempts);
            Integer nCnt = (r.nameAttempts == null ? 0 : r.nameAttempts);

            String inBond  = normalizeBond(r.bondNumber);
            String inName  = normalizeName(r.name);
            String keepBond= normalizeBond(r.lastBond);
            String keepName= normalizeName(r.lastName);

            String bond = String.isBlank(inBond) ? keepBond : inBond;
            String name = String.isBlank(inName) ? keepName : inName;

            o.lastBond = bond;
            o.lastName = name;

            if (String.isBlank(bond)) {
                o.matched = false; o.exists = false;
                o.nextTemplateKey = 'PT_BOND_ASK';
                o.message = 'bond missing';
                setState(o, bCnt, nCnt);
                outs.add(o);
                continue;
            }

            IdentityVerification.ContractInfo ci = IdentityVerification.getContractInfoByBondNumber(bond);
            Boolean exists = (ci != null);
            o.exists = exists;
            if (!exists) {
                bCnt++;
                if (bCnt >= 2) {
                    o.nextTemplateKey = 'PT_ESCALATE_4ITEMS';
                    o.message = 'bond not found twice -> escalate';
                } else {
                    o.nextTemplateKey = 'PT_BOND_RETRY';
                    o.message = 'bond not found; retry';
                }
                o.matched = false;
                setState(o, bCnt, nCnt);
                outs.add(o);
                continue;
            }

            if (String.isBlank(name)) {
                o.matched = false;
                o.nextTemplateKey = 'PT_NAME_ASK';
                o.message = 'name missing';
                setState(o, bCnt, nCnt);
                outs.add(o);
                continue;
            }

            String contractName = normalizeName(ci.name);
            Boolean eq = contractName.equals(name);
            if (!eq) {
                nCnt++;
                if (nCnt >= 2) {
                    o.nextTemplateKey = 'PT_ESCALATE_4ITEMS';
                    o.message = 'name mismatch twice -> escalate';
                } else {
                    o.nextTemplateKey = 'PT_NAME_RETRY';
                    o.message = 'name mismatch; retry';
                }
                o.matched = false;
                setState(o, bCnt, nCnt);
                outs.add(o);
                continue;
            }

            o.matched = true;
            o.nextTemplateKey = 'PT_EXTRA_ASK';
            o.message = 'bond+name matched';
            setState(o, bCnt, nCnt);
            outs.add(o);
        }
        return outs;
    }

    // 正規化（空白除去・全角→半角・大文字統一）
    private static String normalizeBond(String s) {
        if (String.isBlank(s)) return '';
        String t = s.trim();
        t = t.replaceAll('[\\s\\u3000]', '');
        t = toAsciiAlnum(t);
        t = t.toUpperCase();
        return t;
    }
    private static String normalizeName(String s) {
        if (String.isBlank(s)) return '';
        String t = s.trim();
        t = t.replaceAll('[\\s\\u3000]', '');
        return t;
    }
    private static String toAsciiAlnum(String s) {
        final String Z = '０１２３４５６７８９ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ';
        final String H = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        String out = '';
        for (Integer i=0; i<s.length(); i++) {
            String c = s.substring(i, i+1);
            Integer p = Z.indexOf(c);
            out += (p >= 0 ? H.substring(p, p+1) : c);
        }
        return out;
    }
    private static void setState(Response o, Integer bCnt, Integer nCnt) {
        o.bondAttempts = bCnt;
        o.nameAttempts = nCnt;
    }
}