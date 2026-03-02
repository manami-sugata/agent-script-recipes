global with sharing class KycFlowApex {
    // ---------------------- スタブデータ ----------------------
    global class ContractInfo {
        public String bondNumber;
        public String name;
        public String startDate;
        public String regNumber;
        public String oldCarName;
        public ContractInfo(String bondNumber, String name, String startDate, String regNumber, String oldCarName) {
            this.bondNumber = bondNumber;
            this.name = name;
            this.startDate = startDate;
            this.regNumber = regNumber;
            this.oldCarName = oldCarName;
        }
    }
    global class CustomerInfo {
        public String bondNumber;
        public String name;
        public String address;
        public String telNumber;
        public String birth;
        public String carNumber;
        public CustomerInfo(String bondNumber, String name, String address, String telNumber, String birth, String carNumber) {
            this.bondNumber = bondNumber;
            this.name = name;
            this.address = address;
            this.telNumber = telNumber;
            this.birth = birth;
            this.carNumber = carNumber;
        }
    }
    private static List<ContractInfo> contractStub = new List<ContractInfo>{
        new ContractInfo('C1234', '山田太郎', '2020/04/01', '1234', 'プリウス'),
        new ContractInfo('C5678', '佐藤花子', '2021/07/15', '5678', 'アクア')
    };
    private static List<CustomerInfo> customerStub = new List<CustomerInfo>{
        new CustomerInfo('C1234', '山田太郎', '東京都千代田区1-2-3', '090-1234-5678', '1980/02/20', '1234'),
        new CustomerInfo('C5678', '佐藤花子', '東京都新宿区4-5-6', '', '', '5678')
    };

    // ---------------------- 正規化ユーティリティ ----------------------
    public static String normalizeAddress(String address) {
        if (address == null) return '';
        String a = address.trim();
        a = a.replaceAll('　', ' ');
        a = a.replaceAll('丁目', '-');
        a = a.replaceAll('−', '-');
        a = a.replaceAll('ー', '-');
        a = a.replaceAll('[^\\p{IsHan}\\p{IsHiragana}\\p{IsKatakana}\\w\\- ]', '');
        a = a.replaceAll(' ', '');
        return a;
    }
    public static String normalizeTel(String tel) {
        if (tel == null) return '';
        return tel.replaceAll('[^0-9]', '');
    }
    public static String normalizeBirth(String birth) {
        if (birth == null) return '';
        return birth.replaceAll('[^0-9]', '');
    }

    // ---------------------- 本人確認関連メソッド ----------------------
    // 証券番号＋名前一致
    public static Boolean verifyContract(String bondNumber, String name) {
        for (ContractInfo ci : contractStub) {
            if (ci.bondNumber == bondNumber && ci.name == name) {
                return true;
            }
        }
        return false;
    }
    // 名前一致
    public static Boolean existsCustomerName(String name) {
        for (CustomerInfo ci : customerStub) {
            if (ci.name == name) return true;
        }
        return false;
    }
    // 名前一致＋電話番号・生年月日両方登録あり
    public static Boolean hasTelAndBirth(String name) {
       for (CustomerInfo ci : customerStub) {
           // 前後スペース除去で一致判定
           if (
               ci.name != null && ci.name.trim() == name.trim() &&
               String.isNotBlank(ci.telNumber) &&
               String.isNotBlank(ci.birth)
           ) {
            return true;
             }
       }
       return false;
    }
    // 名前一致＋住所・電話番号・生年月日のいずれか一致
    public static Boolean customerInfoAny(String name, String address, String telNumber, String birth) {
        for (CustomerInfo ci : customerStub) {
            if (ci.name == name) {
                Boolean addressMatch = String.isNotBlank(address) && normalizeAddress(ci.address) == normalizeAddress(address);
                Boolean telMatch = String.isNotBlank(telNumber) && normalizeTel(ci.telNumber) == normalizeTel(telNumber);
                Boolean birthMatch = String.isNotBlank(birth) && normalizeBirth(ci.birth) == normalizeBirth(birth);
                if (addressMatch || telMatch || birthMatch) {
                    return true;
                }
            }
        }
        return false;
    }
    // 名前＋登録番号
    public static Boolean verifyCarNumber(String name, String regNumber) {
        for (CustomerInfo ci : customerStub) {
            if (
                ci.name != null && ci.name.trim() == name.trim() &&
                ci.carNumber != null && ci.carNumber.trim() == regNumber.trim()
                ) {
                return true;
            }
        }
        return false;
    }

    // ---------------------- フロー用リクエスト・レスポンス ----------------------
    global class Request {
        @InvocableVariable public String phase;
        @InvocableVariable public String bondNumber;
        @InvocableVariable public String name;
        @InvocableVariable public String address;
        @InvocableVariable public String telNumber;
        @InvocableVariable public String birth;
        @InvocableVariable public String regNumber;
    }
    global class Response {
        @InvocableVariable public String nextPhase;
        @InvocableVariable public Boolean isMatch;
        @InvocableVariable public String message;
    }

    // ---------------------- InvocableMethod本体（分岐判定） ----------------------
    @InvocableMethod(label='本人確認分岐フロー')
    global static List<Response> invoke(List<Request> reqs) {
        List<Response> resList = new List<Response>();
        for(Request req : reqs){
            Response res = new Response();

            // (3-1) 本人確認
            if(req.phase == null || req.phase == 'phase1'){
                if(String.isBlank(req.name) || req.name == 'お客様' || req.name == '契約者' || req.name == '不明' || req.name == 'ユーザー' || req.name == '本人' ){
                    res.nextPhase = 'phase1-2';
                    res.isMatch = false;
                    res.message = '契約者名を教えてください。';
                    }
            else if(String.isNotBlank(req.bondNumber)){
                    Boolean contractMatch = verifyContract(req.bondNumber, req.name);
                    if(contractMatch){
                        res.nextPhase = 'phase1-1';
                        res.isMatch = true;
                        res.message = 'ご本人様確認のため、住所・電話番号・生年月日のいずれかを教えてください。';
                    }else{
                        res.nextPhase = 'phase1-2';
                        res.isMatch = false;
                        res.message = '証券番号が不明です。契約者名を教えてください。';
                        }
                }else{
                    res.nextPhase = 'phase1-2';
                    res.isMatch = false;
                    res.message = '証券番号が不明です。契約者名を教えてください。';
                }
            }
            // (3-1-1) 本人確認追加情報収集①
            else if(req.phase == 'phase1-1'){
                Boolean infoMatch = customerInfoAny(req.name, req.address, req.telNumber, req.birth);
                if(infoMatch){
                    res.nextPhase = 'phase4';
                    res.isMatch = true;
                    res.message = '本人確認が完了しました。次のステップへ進みます。';
                }else{
                    res.nextPhase = 'phase1-1';
                    res.isMatch = false;
                    res.message = 'ご本人確認ができませんでした。もう一度ご確認ください。';
                }
            }
            // (3-1-2) 契約者名の確認
            else if(req.phase == 'phase1-2'){
                Boolean existName = existsCustomerName(req.name);
                if(existName){
                    res.nextPhase = 'phase1-3';
                    res.isMatch = true;
                    res.message = '契約者名が確認できました。住所、電話番号、生年月日を教えてください。';
                }else{
                    res.nextPhase = 'phase1-2';
                    res.isMatch = false;
                    res.message = '契約者名が見つかりませんでした。もう一度ご確認ください。';
                }
            }
            // (3-1-3) 電話番号と生年月日の登録有無確認
            else if(req.phase == 'phase1-3'){
                Boolean hasTelAndBirthResult = hasTelAndBirth(req.name);
                if(hasTelAndBirthResult){
                    res.nextPhase = 'phaseA';
                    res.isMatch = true;
                    res.message = '電話番号と生年月日の登録があります。住所・電話番号・生年月日をすべて教えてください。';
                }else{
                    res.nextPhase = 'phaseB';
                    res.isMatch = false;
                    res.message = '電話番号と生年月日の登録がありません。自動車の登録番号を教えてください。';
                }
            }
            // 分岐A：電話番号と生年月日の登録がある
            else if(req.phase == 'phaseA'){
                Boolean infoMatch = customerInfoAny(req.name, req.address, req.telNumber, req.birth);
                if(infoMatch){
                    res.nextPhase = 'phase4';
                    res.isMatch = true;
                    res.message = '本人確認が完了しました。次のステップへ進みます。';
                }else{
                    res.nextPhase = 'phaseA';
                    res.isMatch = false;
                    res.message = 'ご本人確認ができませんでした。もう一度ご確認ください。';
                }
            }
            // 分岐B：電話番号と生年月日の登録がない
            else if(req.phase == 'phaseB'){
                Boolean regMatch = verifyCarNumber(req.name, req.regNumber);
                if(regMatch){
                    res.nextPhase = 'phase4';
                    res.isMatch = true;
                    res.message = '本人確認が完了しました。次のステップへ進みます。';
                }else{
                    res.nextPhase = 'phaseB';
                    res.isMatch = false;
                    res.message = '登録番号が一致しませんでした。もう一度ご確認ください。';
                }
            }
            // 以降は必要に応じて「phase4」以降を追加

            resList.add(res);
        }
        return resList;
    }
}