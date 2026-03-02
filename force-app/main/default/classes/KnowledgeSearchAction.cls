public class KnowledgeSearchAction {
    @InvocableMethod(
        label='FAQナレッジを絞り込み検索' 
        description='口語的な長い質問でも、キーワードを抽出して関連ナレッジを特定します。1件なら直接回答、複数ならリストを返します。'
    )
    public static List<List<String>> searchKnowledge(List<String> userQueries) {
        List<List<String>> allResults = new List<List<String>>();
        List<String> searchResults = new List<String>();
        
        if (userQueries == null || userQueries.isEmpty() || String.isBlank(userQueries[0])) {
            return new List<List<String>>{ new List<String>{'検索ワードが空です。'} };
        }

        String rawQuery = userQueries[0];

        try {
            // SOSL検索：Onlineかつ日本語のナレッジを検索
            List<List<SObject>> searchList = [
                FIND :rawQuery IN ALL FIELDS 
                RETURNING Knowledge__kav(Title, Answer__c WHERE PublishStatus = 'Online' AND Language = 'ja')
                LIMIT 5
            ];

            List<Knowledge__kav> articles = (List<Knowledge__kav>)searchList[0];
            
            // ヒットした記事を一時的に格納するリスト
            List<Knowledge__kav> matchedArticles = new List<Knowledge__kav>();

            for (Knowledge__kav art : articles) {
                String title = art.Title;
                Boolean isPass = false;

                // 1. タイトルの中の「重要な単語」が質問に含まれているか？
                Integer matchCount = 0;
                List<String> importantWords = new List<String>{'高い','安い','メリット','理由','ネット','違い'};
                for(String word : importantWords) {
                    if(title.contains(word) && rawQuery.contains(word)) matchCount++;
                }

                if (matchCount >= 1 || rawQuery.contains(title) || title.contains(rawQuery)) {
                    isPass = true;
                } else {
                    // 2. 2文字ずつのチャンク一致判定（20%超でパス）
                    Integer chunksMatched = 0;
                    if (rawQuery.length() > 1) {
                        for (Integer i = 0; i < rawQuery.length() - 1; i++) {
                            if (title.contains(rawQuery.substring(i, i + 2))) chunksMatched++;
                        }
                        if (((Double)chunksMatched / (rawQuery.length() - 1)) > 0.2) isPass = true;
                    }
                }

                if (isPass) {
                    matchedArticles.add(art);
                }
            }

            // --- 出力ロジックの切り分け ---
            
            if (matchedArticles.size() == 1) {
                // 【1件のみヒット】
                // 余計な装飾を一切捨て、回答本文だけを返すことでAIに「直接回答」を促す
                String cleanAnswer = (matchedArticles[0].Answer__c != null) 
                    ? matchedArticles[0].Answer__c.replaceAll('<[^>]+>', ' ').replaceAll('\\s+', ' ').trim() 
                    : '回答内容が空です。';
                searchResults.add(cleanAnswer);
            } 
            else if (matchedArticles.size() > 1) {
                // 【複数ヒット】
                // ユーザーに選ばせるため、タイトル付きのリスト形式にする
                for (Knowledge__kav art : matchedArticles) {
                    String clean = (art.Answer__c != null) ? art.Answer__c.replaceAll('<[^>]+>', ' ').replaceAll('\\s+', ' ').trim() : '';
                    searchResults.add('【タイトル】: ' + art.Title + '\n【詳細回答】: ' + clean + '\n---');
                }
            } else {
                searchResults.add('関連するナレッジは見つかりませんでした。');
            }

        } catch (Exception e) {
            searchResults.add('Error: ' + e.getMessage());
        }

        allResults.add(searchResults);
        return allResults;
    }
}