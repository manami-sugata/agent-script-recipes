public with sharing class getContractInfo {
    // スタブデータ（テスト用契約情報）
    private static Map<String, ContractInfo> contractInfoMap = new Map<String, ContractInfo>{
        '山田太郎' => new ContractInfo('2021-04-01', 5, 'ABC1234', 'プリウス', '30歳以上', '家族限定', '通勤'),
        '佐藤花子' => new ContractInfo('2022-01-15', 3, 'XYZ9876', 'フィット', '21歳以上', '本人限定', 'レジャー')
        // 必要に応じて追加
    };

    /**
     * nameのみを受け取り、契約情報スタブを返す
     */
    @InvocableMethod(label='契約情報取得' description='nameに紐づく契約情報スタブを返す（本人確認制御なし）')
    public static List<ContractInfo> getStub(List<Request> requests) {
        List<ContractInfo> results = new List<ContractInfo>();
        for(Request req : requests){
            if(contractInfoMap.containsKey(req.name)){
                results.add(contractInfoMap.get(req.name));
            } else {
                // データがない場合は空データを返す
                results.add(new ContractInfo(null, 0, null, null, null, null, null));
            }
        }
        return results;
    }

    // 入力用
    public class Request {
        @InvocableVariable(label='契約者名')
        public String name;
    }

    // 出力用
    public class ContractInfo {
        @InvocableVariable(label='契約開始日')
        public String startDate;
        @InvocableVariable(label='契約年数')
        public Integer contractYears;
        @InvocableVariable(label='登録番号')
        public String regNumber;
        @InvocableVariable(label='変更前車名')
        public String oldCarName;
        @InvocableVariable(label='年齢条件')
        public String ageCondition;
        @InvocableVariable(label='運転者条件')
        public String driverLimit;
        @InvocableVariable(label='使用目的')
        public String usagePurpose;

        public ContractInfo(String startDate, Integer contractYears, String regNumber, String oldCarName, String ageCondition, String driverLimit, String usagePurpose){
            this.startDate = startDate;
            this.contractYears = contractYears;
            this.regNumber = regNumber;
            this.oldCarName = oldCarName;
            this.ageCondition = ageCondition;
            this.driverLimit = driverLimit;
            this.usagePurpose = usagePurpose;
        }
    }
}