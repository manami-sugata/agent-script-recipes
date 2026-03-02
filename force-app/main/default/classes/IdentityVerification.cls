public with sharing class IdentityVerification {

    // -------- 共通ユーティリティ --------
    public static String normalize(String s) {
        if (s == null) return '';
        s = s.replaceAll('[\\s\\u3000\\u200B\\uFEFF]', '').trim();
        return s;
    }

    public static String normalizeBond(String bond) {
        if (bond == null) return '';
        String t = convertZenkakuToHankaku(bond);
        t = t.replaceAll('[\\s\\u3000\\u200B\\uFEFF]', '');
        t = t.toUpperCase();
        return t;
    }

    public static String normalizeName(String name) {
        if (name == null) return '';
        String t = name.replaceAll('[\\s\\u3000\\u200B\\uFEFF]', '').trim();
        t = t.toUpperCase();
        return t;
    }

    public static String normalizeAddress(String address) {
        if (address == null) return '';
        String a = address.trim();
        a = a.replaceAll('　', ' ');
        a = a.replaceAll('丁目', '-');
        a = a.replaceAll('−', '-');
        a = a.replaceAll('ー', '-');
        a = convertZenkakuToHankaku(a);
        a = a.replaceAll('[^\\p{IsHan}\\p{IsHiragana}\\p{IsKatakana}\\w\\- ]', '');
        a = a.replaceAll(' ', '');
        return a;
    }

    public static String normalizeTel(String tel) {
        if (tel == null) return '';
        String t = convertZenkakuToHankaku(tel);
        t = t.replaceAll('[^0-9]', '');
        return t;
    }

    public static String normalizeBirth(String birth) {
        if (birth == null) return '';
        String b = convertZenkakuToHankaku(birth);
        b = b.replaceAll('[^0-9]', '');
        if (b.length() == 8) return b;
        if (b.length() == 7) {
            String year = b.substring(0, 4);
            String month = b.substring(4, 5);
            String day = b.substring(5, 7);
            month = month.length() == 1 ? '0' + month : month;
            day = day.length() == 1 ? '0' + day : day;
            return year + month + day;
        }
        if (b.length() == 6) {
            String year = b.substring(0, 4);
            String month = b.substring(4, 5);
            String day = b.substring(5, 6);
            month = month.length() == 1 ? '0' + month : month;
            day = day.length() == 1 ? '0' + day : day;
            return year + month + day;
        }
        return '';
    }

    public static String convertZenkakuToHankaku(String s) {
        if (s == null) return '';
        final String zenkaku = '０１２３４５６７８９－ー（）';
        final String hankaku = '0123456789-()-';
        String result = '';
        for (Integer i = 0; i < s.length(); i++) {
            String c = s.substring(i, i+1);
            Integer idx = zenkaku.indexOf(c);
            if (idx != -1) result += hankaku.substring(idx, idx+1);
            else result += c;
        }
        return result;
    }

    public static Integer calcContractTermYears(String startDateStr, String endDateStr) {
        if (String.isBlank(startDateStr) || String.isBlank(endDateStr)) return null;
        try {
            Date s = Date.valueOf(startDateStr.replace('/', '-'));
            Date e = Date.valueOf(endDateStr.replace('/', '-'));
            Integer years = e.year() - s.year();
            if (e.month() < s.month() || (e.month() == s.month() && e.day() < s.day())) years -= 1;
            return years;
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, 'calcContractTermYears parse error: ' + ex.getMessage());
            return null;
        }
    }

    // -------- 契約情報スタブ --------
    public class ContractInfo {
        @AuraEnabled public String bondNumber;
        @AuraEnabled public String name;
        @AuraEnabled public String startDate;
        @AuraEnabled public String endDate;
        @AuraEnabled public Integer contractTermYears;
        @AuraEnabled public String regNumber;
        @AuraEnabled public String oldCarName;
        @AuraEnabled public Boolean hasConnectedCar;
        @AuraEnabled public Boolean hasshinka;
        @AuraEnabled public Boolean hasVehicleInsurance;
        @AuraEnabled public String vehicleInsuranceType;
        @AuraEnabled public String usageType;
        @AuraEnabled public String ageCondition;
        @AuraEnabled public String driverCondition;
        @AuraEnabled public String grade;

        public ContractInfo(
            String bondNumber, String name, String startDate, String endDate, Integer contractTermYears,
            String regNumber, String oldCarName, Boolean hasConnectedCar, Boolean hasshinka,
            Boolean hasVehicleInsurance, String vehicleInsuranceType, String usageType,
            String ageCondition, String driverCondition, String grade
        ) {
            this.bondNumber = bondNumber; this.name = name;
            this.startDate = startDate; this.endDate = endDate; this.contractTermYears = contractTermYears;
            this.regNumber = regNumber; this.oldCarName = oldCarName;
            this.hasConnectedCar = hasConnectedCar; this.hasshinka = hasshinka;
            this.hasVehicleInsurance = hasVehicleInsurance; this.vehicleInsuranceType = vehicleInsuranceType;
            this.usageType = usageType; this.ageCondition = ageCondition; this.driverCondition = driverCondition; this.grade = grade;
        }
    }

    // -------- 顧客情報スタブ --------
    public class CustomerInfo {
        @AuraEnabled public String bondNumber;         // この契約に紐づく証券番号
        @AuraEnabled public String name;               // 氏名
        @AuraEnabled public String address;            // 住所
        @AuraEnabled public String telNumber;          // 代表電話番号
        @AuraEnabled public String birth;              // 生年月日
        @AuraEnabled public String otherBondNumber;    // 他契約証券番号
        @AuraEnabled public String homeTelNumber;      // 固定電話
        @AuraEnabled public String mobileTelNumber;    // 携帯電話
        @AuraEnabled public String baseLocation;       // 本拠地

        public CustomerInfo(
            String bondNumber, String name, String address, String telNumber, String birth,
            String otherBondNumber, String homeTelNumber, String mobileTelNumber, String baseLocation
        ) {
            this.bondNumber = bondNumber;
            this.name = name;
            this.address = address;
            this.telNumber = telNumber;
            this.birth = birth;
            this.otherBondNumber = otherBondNumber;
            this.homeTelNumber = homeTelNumber;
            this.mobileTelNumber = mobileTelNumber;
            this.baseLocation = baseLocation;
        }
    }

    // 契約スタブデータ
    private static List<ContractInfo> contractStub = new List<ContractInfo>{
        new ContractInfo('C1234', '山田太郎', '2025/10/01', '2026/10/01', 1, '1234', 'プリウス', true, true, true, '一般', '日常・レジャー', '全年齢', '限定なし', '20'),
        new ContractInfo('C5678', '佐藤花子', '2021/07/15', '2022/07/15', 1, '5678', 'アクア', false, false, false, null, '業務用', '35歳以上', '本人限定', '7'),
        new ContractInfo('D1234', '山田次郎', '2022/04/01', '2025/04/01', 3, '1111', 'プリウス', true, false, true, '限定', '通勤・通学', '21歳以上', '本人・配偶者限定', '5')
    };

    // 顧客スタブデータ
    private static List<CustomerInfo> customerStub = new List<CustomerInfo>{
        new CustomerInfo('C1234', '山田太郎', '東京都千代田区1-2-3', '090-1234-5678', '19800220',
            'C4567', '03-1234-5678', '090-1234-5678', '東京都千代田区1-2-3'),
        new CustomerInfo('C5678', '佐藤花子', '東京都新宿区4-5-6', '', '',
            'D1234', '03-8765-4321', '080-2222-3333', '東京都新宿区4-5-6'),
        new CustomerInfo('D1234', '山田次郎','東京都千代田区1-2-3', '080-1234-5678', '19800220',
            '', '042-333-4444', '070-9999-8888', '神奈川県横浜市1-9-8')
    };

    // 外部クラスからアクセス用getter
    public static List<CustomerInfo> getCustomerStub() {
        return customerStub;
    }
    public static List<ContractInfo> getContractStub() {
        return contractStub;
    }

    // -------- 契約取得ユーティリティ --------
    public static ContractInfo getContractInfoByBondNumber(String bondNumber) {
        String target = normalizeBond(bondNumber);
        for (ContractInfo ci : contractStub) {
            if (normalizeBond(ci.bondNumber).equals(target)) return ci;
        }
        return null;
    }
    public static ContractInfo getContractInfoByName(String name) {
        String target = normalizeName(name);
        for (ContractInfo ci : contractStub) {
            if (normalizeName(ci.name).equals(target)) return ci;
        }
        return null;
    }

    // 4項目でbondNumberを逆引き
    public static String findBondByFourItems(String name, String address, String telNumber, String birth) {
        String nName = normalizeName(name);
        String nAddr = normalizeAddress(address);
        String nTel  = normalizeTel(telNumber);
        String nBirth= normalizeBirth(birth);
        for (CustomerInfo c : customerStub) {
            Boolean ok = normalizeName(c.name).equals(nName)
                      && normalizeAddress(c.address).equals(nAddr)
                      && normalizeTel(c.telNumber).equals(nTel)
                      && normalizeBirth(c.birth).equals(nBirth);
            if (ok) return c.bondNumber;
        }
        return null;
    }

    // 契約要約
    public static String buildContractSummaryByBond(String bondNumber) {
        ContractInfo ci = getContractInfoByBondNumber(bondNumber);
        if (ci == null) return null;
        ContractInfoResponse dto = toResponseSafe(ci);
        String yrs = (dto.contractTermYears == null ? '' : dto.contractTermYears + '年');
        return '証券番号：' + dto.bondNumber
             + '／契約者：' + dto.name
             + '／契約期間：' + dto.startDate + '～' + dto.endDate + '（' + yrs + '）'
             + '／車名：' + dto.oldCarName
             + '／年齢条件：' + dto.ageCondition
             + '／運転者条件：' + dto.driverCondition
             + '／車両保険：' + (dto.hasVehicleInsurance == true ? (dto.vehicleInsuranceType == null ? 'あり' : dto.vehicleInsuranceType) : 'なし')
             ;
    }

    // -------- 契約レスポンス DTO --------
    public class ContractInfoResponse {
        @InvocableVariable public String bondNumber;
        @InvocableVariable public String name;
        @InvocableVariable public String startDate;
        @InvocableVariable public String endDate;
        @InvocableVariable public String contractTermYears;
        @InvocableVariable public String regNumber;
        @InvocableVariable public String oldCarName;
        @InvocableVariable public Boolean hasConnectedCar;
        @InvocableVariable public Boolean hasshinka;
        @InvocableVariable public Boolean hasVehicleInsurance;
        @InvocableVariable public String vehicleInsuranceType;
        @InvocableVariable public String usageType;
        @InvocableVariable public String ageCondition;
        @InvocableVariable public String driverCondition;
        @InvocableVariable public String grade;
    }

    public static ContractInfoResponse toResponse(ContractInfo ci) {
        ContractInfoResponse dto = new ContractInfoResponse();
        dto.bondNumber = ci.bondNumber; dto.name = ci.name;
        dto.startDate = ci.startDate; dto.endDate = ci.endDate;
        Integer years = (ci.contractTermYears != null) ? ci.contractTermYears : calcContractTermYears(ci.startDate, ci.endDate);
        dto.contractTermYears = (years == null) ? null : String.valueOf(years);
        dto.regNumber = ci.regNumber; dto.oldCarName = ci.oldCarName;
        dto.hasConnectedCar = ci.hasConnectedCar; dto.hasshinka = ci.hasshinka;
        dto.hasVehicleInsurance = ci.hasVehicleInsurance; dto.vehicleInsuranceType = ci.vehicleInsuranceType;
        dto.usageType = ci.usageType; dto.ageCondition = ci.ageCondition; dto.driverCondition = ci.driverCondition; dto.grade = ci.grade;
        return dto;
    }

    public static ContractInfoResponse toResponseSafe(ContractInfo ci) {
        ContractInfoResponse dto = toResponse(ci);
        if (dto.contractTermYears == null || dto.contractTermYears == '') {
            Integer years = calcContractTermYears(ci.startDate, ci.endDate);
            dto.contractTermYears = (years == null) ? null : String.valueOf(years);
        }
        return dto;
    }

    // -------- 本人確認ロジック（判定API群） --------
    public static Boolean isContractIdentified(String bondNumber) {
        String nBond = normalizeBond(bondNumber);
        ContractInfo ci = getContractInfoByBondNumber(nBond);
        return (ci != null);
    }

    public static Boolean isNameValid(String bondNumber, String name) {
        String nBond = normalizeBond(bondNumber);
        String nName = normalizeName(name);
        ContractInfo ci = getContractInfoByBondNumber(nBond);
        return (ci != null && normalizeName(ci.name).equals(nName));
    }

    public static Boolean isInfoMatched(String bondNumber, String address, String telNumber, String birth) {
        String nBond = normalizeBond(bondNumber);
        CustomerInfo c = null;
        for (CustomerInfo cc : customerStub) {
            if (normalizeBond(cc.bondNumber).equals(nBond)) {
                c = cc;
                break;
            }
        }
        if (c == null) return false;
        Boolean addrOk = !String.isBlank(address) && normalizeAddress(c.address).equals(normalizeAddress(address));
        Boolean telOk  = !String.isBlank(telNumber) && normalizeTel(c.telNumber).equals(normalizeTel(telNumber));
        Boolean birthOk= !String.isBlank(birth) && normalizeBirth(c.birth).equals(normalizeBirth(birth));
        return addrOk || telOk || birthOk;
    }

    public static Boolean areDetailsRegistered(String bondNumber, String name) {
        String nBond = normalizeBond(bondNumber);
        String nName = normalizeName(name);
        CustomerInfo c = null;
        for (CustomerInfo cc : customerStub) {
            if (normalizeBond(cc.bondNumber).equals(nBond) && normalizeName(cc.name).equals(nName)) {
                c = cc;
                break;
            }
        }
        if (c == null) return false;
        return !String.isBlank(c.telNumber) && !String.isBlank(c.birth);
    }

    public static Boolean isInfoAllMatched(String name, String address, String telNumber, String birth) {
        String nName = normalizeName(name);
        String nAddr = normalizeAddress(address);
        String nTel  = normalizeTel(telNumber);
        String nBirth= normalizeBirth(birth);
        for (CustomerInfo c : customerStub) {
            Boolean ok = normalizeName(c.name).equals(nName)
                      && normalizeAddress(c.address).equals(nAddr)
                      && normalizeTel(c.telNumber).equals(nTel)
                      && normalizeBirth(c.birth).equals(nBirth);
            if (ok) return true;
        }
        return false;
    }

    public static Boolean isRegistrationMatched(String bondNumber, String regNumber) {
        String nBond = normalizeBond(bondNumber);
        ContractInfo ci = getContractInfoByBondNumber(nBond);
        if (ci == null) return false;
        return !String.isBlank(regNumber) && normalize(ci.regNumber).equals(normalize(regNumber));
    }

    // -------- Invocable: 証券番号存在チェック --------
    public class BondCheckRequest { @InvocableVariable(required=true) public String bondNumber; }
    public class BondCheckResponse { @InvocableVariable public Boolean exists; @InvocableVariable public String message; }

    @InvocableMethod(label='証券番号存在チェックAgentScript用')
    public static List<BondCheckResponse> checkBondExists(List<BondCheckRequest> requests) {
        List<BondCheckResponse> results = new List<BondCheckResponse>();
        for (BondCheckRequest req : requests) {
            String nBond = normalizeBond(req.bondNumber);
            BondCheckResponse out = new BondCheckResponse();
            if (String.isBlank(nBond)) { out.exists = false; out.message = 'bondNumber required'; results.add(out); continue; }
            ContractInfo ci = getContractInfoByBondNumber(nBond);
            out.exists = (ci != null);
            out.message = out.exists ? 'Exists' : 'Not found';
            results.add(out);
        }
        return results;
    }

    // -------- デバッグ --------
    public static void debugContractStub() {
        System.debug(LoggingLevel.WARN, '--- contractStub ---');
        for (ContractInfo ci : contractStub) {
            System.debug(LoggingLevel.WARN,
                'name=' + ci.name + ', bond=' + ci.bondNumber + ', start=' + ci.startDate + ', end=' + ci.endDate +
                ', years=' + ci.contractTermYears + ', usage=' + ci.usageType + ', vehicleType=' + ci.vehicleInsuranceType
            );
        }
    }
}