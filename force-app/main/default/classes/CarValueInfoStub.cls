public with sharing class CarValueInfoStub {

    // 車価情報スタブ
    public class CarValueInfo {
        @AuraEnabled public String carName;         // 車両名
        @AuraEnabled public String grade;           // グレード
        @AuraEnabled public String modelYear;       // 年式（例: 2021）
        @AuraEnabled public Decimal newCarPrice;    // 新車価格
        @AuraEnabled public Decimal currentValue;   // 現在価値（査定額など）
        @AuraEnabled public Decimal lowerLimit;     // 価格帯下限
        @AuraEnabled public Decimal upperLimit;     // 価格帯上限

        public CarValueInfo(
            String carName,
            String grade,
            String modelYear,
            Decimal newCarPrice,
            Decimal currentValue,
            Decimal lowerLimit,
            Decimal upperLimit
        ) {
            this.carName = carName;
            this.grade = grade;
            this.modelYear = modelYear;
            this.newCarPrice = newCarPrice;
            this.currentValue = currentValue;
            this.lowerLimit = lowerLimit;
            this.upperLimit = upperLimit;
        }
    }

    // スタブデータ
    private static List<CarValueInfo> carValueStub = new List<CarValueInfo>{
        new CarValueInfo('プリウス', 'Aグレード', '2022', 320.0, 240.0, 200.0, 350.0),
        new CarValueInfo('アクア', 'G', '2021', 210.0, 150.0, 100.0, 230.0),
        new CarValueInfo('カローラ', 'S', '2020', 220.0, 110.0, 90.0, 220.0)
    };

    public class CarValueInfoRequest {
        @InvocableVariable(required=true)
        public String carName;
        @InvocableVariable public String grade;
        @InvocableVariable public String modelYear;
    }
    public class CarValueInfoResponse {
        @InvocableVariable public String carName;
        @InvocableVariable public String grade;
        @InvocableVariable public String modelYear;
        @InvocableVariable public Decimal newCarPrice;
        @InvocableVariable public Decimal currentValue;
        @InvocableVariable public Decimal lowerLimit;
        @InvocableVariable public Decimal upperLimit;
    }

    // 車価情報取得
    @InvocableMethod(label='車価情報取得')
    public static List<CarValueInfoResponse> getCarValueInfo(List<CarValueInfoRequest> requests) {
        List<CarValueInfoResponse> result = new List<CarValueInfoResponse>();
        for (CarValueInfoRequest req : requests) {
            for (CarValueInfo stub : carValueStub) {
                if (
                    stub.carName == req.carName &&
                    (String.isBlank(req.grade) || stub.grade == req.grade) &&
                    (String.isBlank(req.modelYear) || stub.modelYear == req.modelYear)
                ) {
                    CarValueInfoResponse res = new CarValueInfoResponse();
                    res.carName = stub.carName;
                    res.grade = stub.grade;
                    res.modelYear = stub.modelYear;
                    res.newCarPrice = stub.newCarPrice;
                    res.currentValue = stub.currentValue;
                    res.lowerLimit = stub.lowerLimit;
                    res.upperLimit = stub.upperLimit;
                    result.add(res);
                }
            }
        }
        return result;
    }
}