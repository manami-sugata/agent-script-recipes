public with sharing class VehicleInsQuoteStub {

    // 試算結果データクラス（スタブ1件＝契約パターン1件）
    public class InsQuote {
        @AuraEnabled public String carName;            // 車名
        @AuraEnabled public String coverageType;       // 補償タイプ（'一般' / '限定' / null（車両なし））
        @AuraEnabled public Integer contractTermYears; // 契約期間（1 or 3年）
        @AuraEnabled public Integer InsAmount1;        // 1年目保険金額（万円）
        @AuraEnabled public Integer InsAmount2;        // 2年目保険金額（万円）※1年契約はnull許容
        @AuraEnabled public Integer InsAmount3;        // 3年目保険金額（万円）※1年契約はnull許容
        @AuraEnabled public Integer deductible;        // 免責金額（万円）
        @AuraEnabled public Integer InsurancePremium1; // 1年目年間保険料（円）
        @AuraEnabled public Integer InsurancePremium2; // 2年目年間保険料（円）※1年契約はnull許容
        @AuraEnabled public Integer InsurancePremium3; // 3年目年間保険料（円）※1年契約はnull許容
        @AuraEnabled public Integer newPrice; // ← 追加（型をIntegerに）

        public InsQuote(String carName, String coverageType, Integer contractTermYears,
                        Integer InsAmount1, Integer InsAmount2, Integer InsAmount3,
                        Integer deductible,
                        Integer InsurancePremium1, Integer InsurancePremium2, Integer InsurancePremium3,Integer newPrice) {
            this.carName = carName;
            this.coverageType = coverageType;
            this.contractTermYears = contractTermYears;
            this.InsAmount1 = InsAmount1;
            this.InsAmount2 = InsAmount2;
            this.InsAmount3 = InsAmount3;
            this.deductible = deductible;
            this.InsurancePremium1 = InsurancePremium1;
            this.InsurancePremium2 = InsurancePremium2;
            this.InsurancePremium3 = InsurancePremium3;
            this.newPrice = newPrice; // ← 追加
        }
    }

    // スタブデータ（1年契約は2年目・3年目をnullで定義）
    private static List<InsQuote> quoteStub = new List<InsQuote>{
        // プリウス・一般
        new InsQuote('プリウス', '一般', 1, 300, null, null, 0, 10000, null, null, 300),
        new InsQuote('プリウス', '一般', 3, 300, 280, 270, 0, 10000, 9500, 9000, 300),
        new InsQuote('プリウス', '一般', 1, 100, null, null, 3, 5000, null, null, 100),
        new InsQuote('プリウス', '一般', 3, 100,  90,  80, 3, 5000, 4000, 3000, 100),
        // プリウス・限定
        new InsQuote('プリウス', '限定', 1, 100, null, null, 3, 3000, null, null,100),
        new InsQuote('プリウス', '限定', 3, 100,  90,  80, 3, 3000, 2500, 2000, 100),
        // プリウス・車両なし
        new InsQuote('プリウス', null, 1, 0, null, null, 0, 6000, null, null, 0),
        new InsQuote('プリウス', null, 3, 0, 0, 0, 0, 6000, 5800, 5600, 0),

        // アクア・一般
        new InsQuote('アクア', '一般', 1, 300, null, null, 0, 10000, null, null, 300),
        new InsQuote('アクア', '一般', 3, 300, 280, 270, 0, 10000, 9500, 9000, 300),
        new InsQuote('アクア', '一般', 1, 100, null, null, 3, 5000, null, null, 100),
        new InsQuote('アクア', '一般', 3, 100,  90,  80, 3, 5000, 4000, 3000, 100),
        // アクア・限定
        new InsQuote('アクア', '限定', 1, 100, null, null, 3, 3000, null, null, 100),
        new InsQuote('アクア', '限定', 3, 100,  90,  80, 3, 3000, 2500, 2000, 100),
        // アクア・車両なし
        new InsQuote('アクア', null, 1, 0, null, null, 0, 5500, null, null, 0),
        new InsQuote('アクア', null, 3, 0, 0, 0, 0, 5500, 5300, 5100, 0),

        // ステップワゴン・一般
        new InsQuote('ステップワゴン', '一般', 1, 300, null, null, 0, 15000, null, null, 100),
        new InsQuote('ステップワゴン', '一般', 3, 300, 280, 270, 0, 15000, 10000, 9500, 300)
    };

    // ---- Invocable入出力 ----
    public class InsQuoteRequest {
        @InvocableVariable(required=false) public String bondNumber;        // ContractFetchByBond から取得
        @InvocableVariable(required=true)  public String carName;           // 例: 'プリウス'
        @InvocableVariable(required=true)  public String coverageType;      // 例: '一般条件' / '車対車+限定危険' / '一般' / '限定' / '車両なし'
        @InvocableVariable(required=true)  public String contractTermYears; // 例: '3'（bond優先）
        @InvocableVariable(required=true)  public String InsAmount;         // 例: '300' / '300万円'
        @InvocableVariable(required=true)  public String deductible;        // 例: '0' / '3' / '3万円'
        @InvocableVariable(required=false) public Boolean hasVehicleInsurance;
        @InvocableVariable(required=false) public Integer newPrice; // ←追加
    }

    public class InsQuoteResponse {
        @InvocableVariable public String carName;
        @InvocableVariable public String coverageType; // 正規化後（'一般' / '限定' / null）
        @InvocableVariable public Integer contractTermYears;
        @InvocableVariable public Integer InsAmount1;
        @InvocableVariable public Integer InsAmount2;
        @InvocableVariable public Integer InsAmount3;
        @InvocableVariable public Integer deductible;         // 万円
        @InvocableVariable public Integer InsurancePremium1;  // 円
        @InvocableVariable public Integer InsurancePremium2;  // 円
        @InvocableVariable public Integer InsurancePremium3;  // 円
        @InvocableVariable public String requestId;
        @InvocableVariable public Integer newPrice; // ←追加

        @InvocableVariable public Boolean isError;
        @InvocableVariable public String errorCode;
        @InvocableVariable public String errorMessage;
    }

    @InvocableMethod(label='車両保険試算結果取得')
    public static List<InsQuoteResponse> getInsQuote(List<InsQuoteRequest> requests) {
        List<InsQuoteResponse> result = new List<InsQuoteResponse>();
        if (requests == null) return result;

        for (InsQuoteRequest req : requests) {
            InsQuoteResponse res = new InsQuoteResponse();
            try {
                if (req == null) {
                    setError(res, 'BAD_REQUEST', 'リクエストが空です。');
                    result.add(res);
                    continue;
                }

                String requestId = 'RQ-' + String.valueOf(DateTime.now().getTime()) + '-' + String.valueOf(Crypto.getRandomInteger());
                res.requestId = requestId;

                // 1) bondNumberから契約期間を解決（ContractFetchByBond を呼び出し）
                Integer yearsFromBond = resolveYearsFromBond(req.bondNumber);
                Integer yearsFromReq  = parseIntOrNull(req.contractTermYears);
                Integer years = (yearsFromBond != null) ? yearsFromBond : yearsFromReq;
                if (years == null) {
                    setError(res, 'BAD_REQUEST', '契約期間を1年または3年で指定してください。');
                    result.add(res);
                    continue;
                }
                if (years != 1 && years != 3) {
                    years = 1; // 不正値は 1 にフォールバック
                }
                res.contractTermYears = years;

                // 2) coverageType 正規化
                String cov = normalizeCoverageType(req.coverageType);
                res.coverageType = cov;

                // 2.5) 付帯希望と coverageType の整合チェック
                if (req.hasVehicleInsurance != null) {
                    Boolean hv = req.hasVehicleInsurance;
                    if (hv && cov == null) {
                        setError(res, 'VALIDATION', '付帯希望ありですが、補償タイプが車両なしになっています。補償タイプを選択してください（一般/限定）。');
                        result.add(res);
                        continue;
                    }
                    if (!hv && (cov == '一般' || cov == '限定')) {
                        setError(res, 'VALIDATION', '付帯希望なしですが、補償タイプが車両あり（一般/限定）になっています。補償タイプは「車両なし」を選択してください。');
                        result.add(res);
                        continue;
                    }
                }

                // 3) 金額の正規化
                Integer amountMan = parseManYen(req.InsAmount);
                Integer dedMan    = parseManYen(req.deductible);
                if (amountMan == null) {
                    setError(res, 'BAD_REQUEST', '保険金額は万円単位の整数で入力してください。');
                    result.add(res);
                    continue;
                }
                if (dedMan == null) {
                    setError(res, 'BAD_REQUEST', '免責金額は万円単位の整数で入力してください。');
                    result.add(res);
                    continue;
                }
                res.deductible = dedMan;
                res.InsAmount1 = amountMan; // 入力痕跡

                // 4) スタブ検索
                InsQuote matched;
                for (InsQuote stub : quoteStub) {
                    if (stub.carName == req.carName &&
                        equalsAllowNull(stub.coverageType, cov) &&
                        stub.contractTermYears == years &&
                        stub.InsAmount1 == amountMan &&
                        stub.deductible == dedMan
                    ) {
                        if (years == 3) {
                            if (stub.InsAmount2 != null && stub.InsAmount3 != null &&
                                stub.InsurancePremium2 != null && stub.InsurancePremium3 != null) {
                                matched = stub; break;
                            }
                        } else {
                            matched = stub; break;
                        }
                    }
                }

                // 5) 3年が完全一致しない場合のフォールバック
                if (matched == null) {
                    for (InsQuote stub : quoteStub) {
                        if (stub.carName == req.carName &&
                            equalsAllowNull(stub.coverageType, cov) &&
                            stub.contractTermYears == years &&
                            stub.InsAmount1 == amountMan &&
                            stub.deductible == dedMan
                        ) {
                            matched = stub; break;
                        }
                    }
                }

                if (matched != null) {
                    res.carName = matched.carName;
                    res.InsAmount1 = matched.InsAmount1;
                    res.InsurancePremium1 = matched.InsurancePremium1;
                    if (years == 3) {
                        res.InsAmount2 = matched.InsAmount2;
                        res.InsAmount3 = matched.InsAmount3;
                        res.InsurancePremium2 = matched.InsurancePremium2;
                        res.InsurancePremium3 = matched.InsurancePremium3;
                    }
                    res.isError = false;
                    res.errorCode = null;
                    res.errorMessage = null;
                } else {
                    setError(res, 'NOT_FOUND', '試算対象の組み合わせが見つかりません。入力値をご確認ください。');
                }
            } catch (Exception e) {
                setError(res, 'UNKNOWN', '処理中に予期せぬエラーが発生しました: ' + e.getMessage());
            }
            result.add(res);
        }
        return result;
    }

    private static void setError(InsQuoteResponse res, String code, String msg) {
        res.isError = true;
        res.errorCode = code;
        res.errorMessage = msg;
    }

    // ---- ContractFetchByBond.fetch を用いて契約期間を解決 ----
    // fetch は Invocable 形式のため、List<Request> を渡して List<Response> を受ける
    private static Integer resolveYearsFromBond(String bondNumber) {
        if (String.isBlank(bondNumber)) return null;

        ContractFetchByBond.Request rq = new ContractFetchByBond.Request();
        rq.bondNumber = bondNumber;
        List<ContractFetchByBond.Response> outs = ContractFetchByBond.fetch(new List<ContractFetchByBond.Request>{ rq });

        if (outs == null || outs.isEmpty()) return null;
        ContractFetchByBond.Response r = outs[0];
        if (r == null) return null;

        // 正常取得できているかメッセージを参考（仕様に合わせて必要なら判定強化）
        if (String.isBlank(r.contractTermYears)) {
            // 文字列日付から推定（"yyyy-MM-dd" 前提。異なる場合は適宜修正）
            Date startD = parseDateSafe(r.startDate);
            Date endD   = parseDateSafe(r.endDate);
            if (startD != null && endD != null) {
                Integer days = endD.daysBetween(startD);
                // 365日を1年として丸め（仕様に応じて 365/366 など調整可）
                Integer approxYears = Math.max(1, Math.round((Decimal)days / 365));
                return approxYears;
            }
            return null;
        }
        Integer y = parseIntOrNull(r.contractTermYears);
        return y;
    }

    // "yyyy-MM-dd" などの簡易パーサ（失敗時は null）
    private static Date parseDateSafe(String s) {
        if (String.isBlank(s)) return null;
        try {
            // 例: 2025-01-31 or 2025/01/31 に対応
            String t = s.replace('/', '-').trim();
            List<String> parts = t.split('-');
            if (parts.size() == 3) {
                Integer yy = Integer.valueOf(parts[0]);
                Integer mm = Integer.valueOf(parts[1]);
                Integer dd = Integer.valueOf(parts[2]);
                return Date.newInstance(yy, mm, dd);
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    // coverageTypeの正規化
    private static String normalizeCoverageType(String cov) {
        if (cov == null) return null;
        String c = cov.trim();
        c = c.replace('＋', '+');
        if (c == '一般条件') return '一般';
        if (c == '車対車+限定危険' || c == '車対車＋限定危険') return '限定';
        if (c == '車両なし' || c == 'なし') return null;
        if (c == '一般' || c == '限定') return c;
        return c;
    }

    // 「万円」単位の整数に変換
    private static Integer parseManYen(String s) {
        if (s == null) return null;
        String t = s.replaceAll('[\\s\\u3000]', '');
        t = t.replace('万円', '').replace('万', '');
        if (t == '') return null;
        try { return Integer.valueOf(t); } catch (Exception e) { return null; }
    }

    private static Integer parseIntOrNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        if (t == '') return null;
        try { return Integer.valueOf(t); } catch (Exception e) { return null; }
    }

    private static Boolean equalsAllowNull(String a, String b) {
        if (a == null && b == null) return true;
        return a == b;
    }
}