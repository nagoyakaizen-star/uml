
```plantuml
@startuml
title アプリケーションサーバーの合成構成図 (Composite Structure)

' 配置方向を左から右に設定
left to right direction

' 外枠となる親クラス/コンポーネント
package "ApplicationServer" as AppServer {
    
    ' ポート (Port) の表現
    () "HTTP Port (8080)" as HttpPort
    () "DB Port (3306)" as DbPort

    ' 境界線上のポートを表現するため、隠しラインで外枠に近付ける
    HttpPort -[hidden]- RequestRouter

    ' 内部構造 (Parts)
    rectangle "RequestRouter\n(Routing Part)" as RequestRouter #lightgrey
    rectangle "AuthService\n(Auth Part)" as AuthService #lightgrey
    rectangle "BusinessLogic\n(Logic Part)" as BizLogic #lightgrey

    ' 内部コネクタ (Connectors) の定義
    RequestRouter --> AuthService : 1. 認証要求
    RequestRouter --> BizLogic : 2. 処理委譲
}

' 外部要素との接続
actor "Web Browser" as Client
database "PostgreSQL" as Database

' 外部からポート、ポートから内部パーツへの接続
Client --> HttpPort
HttpPort --> RequestRouter : [Delegate]

BizLogic --> DbPort : [Delegate]
DbPort --> Database
@enduml
```

PlantUML version 1.2026.7beta8 / ae7b054 [2026-07-09 22:27:49 UTC]
[From textarea (line 18) ]
 
@startuml
title アプリケーションサーバーの合成構成図 (Composite Structure)
 
left to right direction
 
package "ApplicationServer" as AppServer {
    
    () "HTTP Port (8080)" as HttpPort
    () "DB Port (3306)" as DbPort
 
    HttpPort -[hidden]- RequestRouter
 
    rectangle "RequestRouter\n(Routing Part)" as RequestRouter #lightgrey
 Use 'allowmixing' if you want to mix classes and other UML elements. (Assumed diagram type: class)

 # Q2 上記のPlantUMLは、WEB版で、 Use 'allowmixing' if you want to mix classes and other UML elements. (Assumed diagram type: class)
というエラーがでました。どうしたらいいですか。
A2 
そのエラーは、PlantUMLが図の種類を「クラス図（class）」と自動判定した一方で、コード内にクラス図以外（コンポーネント図やユースケース図など）の要素（`package` や `actor`、`database` など）が混在しているために発生しています。

これを解決する最も手っ取り早く確実な方法は、エラーメッセージにある通り、コードの先頭に **`allowmixing`** という宣言を追加することです。

以下が、エラーを修正した正常にレンダリングできるコードです。

```plantuml
@startuml
' 異なるUML要素の混在を許可する宣言
allowmixing

title アプリケーションサーバーの合成構成図 (Composite Structure)

' 配置方向を左から右に設定
left to right direction

' 外枠となる親クラス/コンポーネント
package "ApplicationServer" as AppServer {
    
    ' ポート (Port) の表現
    () "HTTP Port (8080)" as HttpPort
    () "DB Port (3306)" as DbPort

    ' 境界線上のポートを表現するため、隠しラインで外枠に近付ける
    HttpPort -[hidden]- RequestRouter

    ' 内部構造 (Parts)
    rectangle "RequestRouter\n(Routing Part)" as RequestRouter #lightgrey
    rectangle "AuthService\n(Auth Part)" as AuthService #lightgrey
    rectangle "BusinessLogic\n(Logic Part)" as BizLogic #lightgrey

    ' 内部コネクタ (Connectors) の定義
    RequestRouter --> AuthService : 1. 認証要求
    RequestRouter --> BizLogic : 2. 処理委譲
}

' 外部要素との接続
actor "Web Browser" as Client
database "PostgreSQL" as Database

' 外部からポート、ポートから内部パーツへの接続
Client --> HttpPort
HttpPort --> RequestRouter : [Delegate]

BizLogic --> DbPort : [Delegate]
DbPort --> Database
@enduml

```

### なぜこのエラーが起きるのか？

PlantUMLは、コードの書き出しを見て図の種類（クラス図、シーケンス図など）を推測します。今回のコードに登場した丸かっこ `()` を使ったインターフェース定義（`() "HTTP Port..."`）などが「クラス図の要素」と認識された一方で、`actor`（ユースケース図向け）や `database`（コンポーネント図向け）が混ざっていたため、**「クラス図の中に、別の種類のUML要素が混ざっています。混ぜる場合は明示的に許可してください」** という警告（エラー）が出ました。

先頭に `allowmixing` を1行足すだけで、PlantUMLがすべての要素を柔軟に配置してくれるようになります。

<img width="415" height="153" alt="image" src="https://github.com/user-attachments/assets/b9707de2-93db-4f3c-be3d-79ea27b91464" />

 
