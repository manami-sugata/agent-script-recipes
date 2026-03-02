public class JsonApiSample {
    public static void getApiValue() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://jsonplaceholder.typicode.com/todos/1');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);

        // レスポンスボディ（JSON文字列）を取得
        String body = res.getBody();
        System.debug('API Response: ' + body);

        // JSONをパース
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(body);
        System.debug('userId: ' + result.get('userId'));
        System.debug('title: ' + result.get('title'));
        System.debug('completed: ' + result.get('completed'));
    }
}