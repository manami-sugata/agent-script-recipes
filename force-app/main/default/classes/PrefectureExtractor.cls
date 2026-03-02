public with sharing class PrefectureExtractor {

    // 都道府県リスト（全47都道府県）
    private static final List<String> PREF_LIST = new List<String>{
        '北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県',
        '茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県',
        '新潟県','富山県','石川県','福井県','山梨県','長野県',
        '岐阜県','静岡県','愛知県','三重県',
        '滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県',
        '鳥取県','島根県','岡山県','広島県','山口県',
        '徳島県','香川県','愛媛県','高知県',
        '福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県'
    };

    public class Request {
        @InvocableVariable(required=true)
        public String address;
    }

    public class Response {
        @InvocableVariable
        public String prefecture;
    }

    @InvocableMethod(label='住所から都道府県名を抽出')
    public static List<Response> extract(List<Request> requests) {
        List<Response> results = new List<Response>();
        for (Request req : requests) {
            Response res = new Response();
            res.prefecture = extractPrefecture(req.address);
            results.add(res);
        }
        return results;
    }

    // 住所から都道府県名を抜き出す関数
    public static String extractPrefecture(String address) {
        if (String.isBlank(address)) return '';
        for (String pref : PREF_LIST) {
            if (address.startsWith(pref)) {
                return pref;
            }
        }
        // 万が一先頭以外に含まれる場合（例：スペースや数字が先頭）
        for (String pref : PREF_LIST) {
            if (address.contains(pref)) {
                return pref;
            }
        }
        return '';
    }
}