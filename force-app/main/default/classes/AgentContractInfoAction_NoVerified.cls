public with sharing class AgentContractInfoAction_NoVerified {
    // スタブデータ（テスト用契約情報）
    private static Map<String, ContractInfo> contractInfoMap = new Map<String, ContractInfo>{
        '山田太郎' => new ContractInfo('2021-04-01', 5, 'ABC1234', 'プリウス'),
        '佐藤花子' => new ContractInfo('2022-01-15', 3, 'XYZ9876', 'フィット')
        // 必要に応じて追加
    };

    /**
     * nameのみを受け取り、契約情報スタブを返す
     */
    @InvocableMethod(label='契約情報スタブ取得（本人確認フラグなし）' description='nameに紐づく契約情報スタブを返す（本人確認制御なし）')
    public static List<ContractInfo> getStub(List<Request> requests) {
        List<ContractInfo> results = new List<ContractInfo>();
        for(Request req : requests){
            if(contractInfoMap.containsKey(req.name)){
                results.add(contractInfoMap.get(req.name));
            } else {
                // データがない場合は空データを返す
                results.add(new ContractInfo(null, 0, null, null));
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

        public ContractInfo(String startDate, Integer contractYears, String regNumber, String oldCarName){
            this.startDate = startDate;
            this.contractYears = contractYears;
            this.regNumber = regNumber;
            this.oldCarName = oldCarName;
        }
    }
}