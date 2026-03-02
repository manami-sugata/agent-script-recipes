public with sharing class AddressNumberSimplifier {

    public class Request {
        @InvocableVariable(required=true)
        public String address;
    }

    public class Response {
        @InvocableVariable
        public String simplified_address; // 変換後のフルアドレス
    }

    @InvocableMethod(label='住所から丁目番地号を抜き出し簡略化（フルアドレス返却）')
    public static List<Response> simplify(List<Request> requests) {
        List<Response> results = new List<Response>();
        for (Request req : requests) {
            Response res = new Response();
            String simplified = extractNumbers(req.address);
            res.simplified_address = replaceNumbers(req.address, simplified);
            results.add(res);
        }
        return results;
    }

    // 丁目・番地・号を抜き出して1-2-3形式（数字は全角・漢数字→半角数字対応）
    public static String extractNumbers(String address) {
        if (String.isBlank(address)) return '';
        address = convertZenkakuToHankaku(address);

        // 「○丁目○番○号」
        String regex = '(\\d+)[丁目]?[- 　]*(\\d+)[番]?[- 　]*(\\d+)[号]?';
        Pattern p = Pattern.compile(regex);
        Matcher m = p.matcher(address);
        if (m.find()) {
            return m.group(1) + '-' + m.group(2) + '-' + m.group(3);
        }
        // 「○丁目○番」または「○-○」だけ
        String regex2 = '(\\d+)[丁目]?[- 　]*(\\d+)[番地号-]?';
        Matcher m2 = Pattern.compile(regex2).matcher(address);
        if (m2.find()) {
            return m2.group(1) + '-' + m2.group(2);
        }
        // 「-」区切り（3連続）
        String regex3 = '(\\d+)-(\\d+)-(\\d+)';
        Matcher m3 = Pattern.compile(regex3).matcher(address);
        if (m3.find()) {
            return m3.group(1) + '-' + m3.group(2) + '-' + m3.group(3);
        }
        // ヒットしなければ空
        return '';
    }

    // 元住所の丁目・番地・号部分を1-2-3などに置換したフルアドレスを返す
    private static String replaceNumbers(String address, String simplified) {
        if (String.isBlank(address) || String.isBlank(simplified)) return address;

        String orig = address;
        orig = convertZenkakuToHankaku(orig);

        // 1. 「○丁目○番○号」を「1-2-3」に置換
        String regex = '(\\d+)[丁目]?[- 　]*(\\d+)[番]?[- 　]*(\\d+)[号]?';
        Pattern p = Pattern.compile(regex);
        Matcher m = p.matcher(orig);
        if (m.find()) {
            return m.replaceFirst(simplified);
        }

        // 2. 「○丁目○番」または「○-○」の場合
        String regex2 = '(\\d+)[丁目]?[- 　]*(\\d+)[番地号-]?';
        Matcher m2 = Pattern.compile(regex2).matcher(orig);
        if (m2.find()) {
            return m2.replaceFirst(simplified);
        }

        // 3. 「-」区切り（3連続）
        String regex3 = '(\\d+)-(\\d+)-(\\d+)';
        Matcher m3 = Pattern.compile(regex3).matcher(orig);
        if (m3.find()) {
            return m3.replaceFirst(simplified);
        }

        // 置換できなければ元の住所を返す
        return address;
    }

    // 全角数字・漢数字→半角数字
    private static String convertZenkakuToHankaku(String s) {
        if (s == null) return '';
        final String zenkaku = '０１２３４５６７８９';
        final String hankaku = '0123456789';
        String result = '';
        for (Integer i = 0; i < s.length(); i++) {
            String c = s.substring(i, i+1);
            Integer idx = zenkaku.indexOf(c);
            if (idx != -1) result += hankaku.substring(idx, idx+1);
            else result += c;
        }
        // 漢数字も対応
        result = result.replaceAll('一', '1')
                       .replaceAll('二', '2')
                       .replaceAll('三', '3')
                       .replaceAll('四', '4')
                       .replaceAll('五', '5')
                       .replaceAll('六', '6')
                       .replaceAll('七', '7')
                       .replaceAll('八', '8')
                       .replaceAll('九', '9')
                       .replaceAll('十', '10');
        return result;
    }
}