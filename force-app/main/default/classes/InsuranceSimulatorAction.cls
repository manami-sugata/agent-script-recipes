public class InsuranceSimulatorAction {
    // 入力用クラス
    public class InsuranceInput {
        @InvocableVariable(label='車体金額')
        public Decimal carPrice;

        @InvocableVariable(label='車両保険種類')
        public String insuranceType;

        @InvocableVariable(label='自己負担額')
        public Decimal deductible;
    }

    // 出力用クラス
    public class InsuranceOutput {
        @InvocableVariable(label='試算保険料')
        public Decimal estimatedPremium;
    }

    // エージェントアクション用メソッド
    @InvocableMethod(label='保険料試算' description='車体金額・保険種類・自己負担額から保険料を試算します')
    public static List<InsuranceOutput> calcPremium(List<InsuranceInput> inputs) {
        List<InsuranceOutput> results = new List<InsuranceOutput>();
        for (InsuranceInput input : inputs) {
            Decimal basePremium = 20000;
            basePremium += input.carPrice * 0.01;

            if (input.insuranceType == '一般') {
                basePremium += 5000;
            } else if (input.insuranceType == '限定') {
                basePremium += 2000;
            }

            if (input.deductible >= 10000) {
                basePremium -= 2000;
            } else if (input.deductible >= 5000) {
                basePremium -= 1000;
            }

            if (basePremium < 10000) {
                basePremium = 10000;
            }

            InsuranceOutput output = new InsuranceOutput();
            output.estimatedPremium = basePremium.setScale(0);
            results.add(output);
        }
        return results;
    }
}