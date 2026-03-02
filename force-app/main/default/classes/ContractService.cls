global class ContractService {
    global class DriverConditionInfo {
        @InvocableVariable
        public String name;
        @InvocableVariable
        public String usagePurpose;   // 使用目的
        @InvocableVariable
        public String ageCondition;   // 年齢条件
        @InvocableVariable
        public String driverLimit;    // 運転者限定

        public DriverConditionInfo() {}
        public DriverConditionInfo(String name, String usagePurpose, String ageCondition, String driverLimit) {
            this.name = name;
            this.usagePurpose = usagePurpose;
            this.ageCondition = ageCondition;
            this.driverLimit = driverLimit;
        }
    }

    private static List<DriverConditionInfo> driverConditionStub = new List<DriverConditionInfo>{
        new DriverConditionInfo('山田太郎', '日常・レジャー', '30歳以上', '本人のみ'),
        new DriverConditionInfo('佐藤花子', '通勤', '全年齢', '家族限定')
    };

    // 引数用ラッパークラス
    global class NameInput {
        @InvocableVariable
        public String name;
    }

    /**
     * フローやエージェントアクションから呼び出し可能なメソッド
     * 引数: NameInputのリスト（通常は1件）
     * 戻り値: DriverConditionInfoのリスト（0件または1件）
     */
    @InvocableMethod(label='運転者条件情報取得' description='名前を指定して運転者条件情報を取得')
    global static List<DriverConditionInfo> getDriverConditionByName(List<NameInput> nameInputList) {
        List<DriverConditionInfo> result = new List<DriverConditionInfo>();
        if (nameInputList != null && !nameInputList.isEmpty()) {
            String searchName = nameInputList[0].name;
            for (DriverConditionInfo info : driverConditionStub) {
                if (info.name == searchName) {
                    result.add(info);
                    break;
                }
            }
        }
        return result;
    }
}