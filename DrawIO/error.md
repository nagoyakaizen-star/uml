https://github.com/nagoyakaizen-star/uml/blob/main/plantuml/os.md

でDrawIOの図

+-----+ +------+ +-----------+ +---------+ +----------+
| ISR | |  OS  | |Scheduler | | TaskLow | | TaskHigh |
+-----+ +------+ +-----------+ +---------+ +----------+
                          |             |
                          |============>| execute
                          |
----interrupt------------->
      ActivateTask()
          |
          V
      schedule()
          |
          V
      preempt()
          |
          X------------------------------+
                                         |
                              dispatch() |
                                         V
                                   TaskHigh
                                      |
                                      | execute()
                                      |
                                      | TerminateTask()
                                      |
                                      V
                                   Scheduler
                                      |
                                      | resume()
                                      V
                                   TaskLow
をMermaidとして入力したら次のエラーがでた。
                                   
<img width="397" height="175" alt="image" src="https://github.com/user-attachments/assets/b9a383e5-5d5b-489c-b3fa-999c8ca49fd5" />

TaskLow
   |
   | execute()
   |
ISR
   |
   | ActivateTask(TaskHigh)
   |
OS
   |
   | schedule()
   |
Scheduler
   |
   | preempt(TaskLow)
   |
TaskLow

Scheduler
   |
   | dispatch(TaskHigh)
   |
TaskHigh
   |
   | execute()
   |
   | TerminateTask()
   |
OS
   |
Scheduler
   |
   | resume(TaskLow)
   |
TaskLow




<img width="391" height="181" alt="image" src="https://github.com/user-attachments/assets/0a0b7c00-f7c0-4c67-a31a-f986f390b7f6" />


# Q1 draw.ioでPortを境界線上に配置する例を教えてください。
A1 by ChatGPT
はい。**draw.io (diagrams.net) は UML Composite Structure Diagram の Port を図形として境界線上に配置できます。** ただし、PapyrusやEnterprise Architectのように「Port」というUML要素をメタモデルとして扱うのではなく、**Port図形をコンポーネントの境界にスナップさせる**という仕組みです。

## 方法1（おすすめ） UMLライブラリを使う

1. **More Shapes...**
2. **Software → UML** にチェック
3. **Apply**

左側のパレットに UML 図形が追加されます。

---

### コンポーネントを配置

```
+--------------------------------------+
|          ApplicationServer           |
|                                      |
|   RequestRouter                      |
|   AuthService                        |
|   BusinessLogic                      |
|                                      |
+--------------------------------------+
```

---

### Portをドラッグ

UMLライブラリには

```
□
```

という小さい四角があります。

これをドラッグすると

```
+--------------------------------------+
|□                                     |
|          ApplicationServer           |
|                                      |
|                                      |
+--------------------------------------+
```

境界線に吸着します。

右側も同様です。

```
+--------------------------------------+
|□                                     |
|          ApplicationServer        □  |
|                                      |
|                                      |
+--------------------------------------+
```

---

### Connectorで接続

```
Browser
    |
    v
□ HTTP -----------------> RequestRouter
```

```
BusinessLogic ----------> □ DB
                           |
                           v
                      PostgreSQL
```

完成イメージ

```
                 Browser
                    |
                    |
                    v
      +------------------------------------+
      | □HTTP                             |
      |                                    |
      | RequestRouter                      |
      |      |                             |
      |      +-->AuthService               |
      |      |                             |
      |      +-->BusinessLogic----□DB      |
      +------------------------------------+
                                  |
                                  |
                             PostgreSQL
```

これはComposite Structure Diagramにかなり近い表現になります。

---

# 方法2（Shape検索）

検索窓で

```
Port
```

と入力すると

```
□
```

が見つかります。

---

# 方法3（もっともUMLらしい方法）

実務ではPortを

```
□HTTP
```

ではなく

```
«port»
HTTP
```

のように名前付きにします。

```
+--------------------------------------+
|□HTTP                                 |
|                                      |
| RequestRouter                        |
|                                      |
|                          □DB          |
+--------------------------------------+
```

---

# 接続例

```
Browser
    |
    |
    v
+------------------------------------------------+
|□HTTP                                           |
|   |                                            |
|   | Delegate                                   |
|   v                                            |
| RequestRouter                                  |
|   |                                            |
|   +-------------------->AuthService            |
|   |                                            |
|   +-------------------->BusinessLogic          |
|                                |               |
|                                | Delegate      |
|                                v               |
|                             □DB               |
+------------------------------------------------+
                                 |
                                 |
                                 v
                           PostgreSQL
```

---

# Draw.ioの便利機能

Portを選択すると

* Connection Point（接続点）
* Glue Point（吸着）
* Snap to Geometry（図形境界へのスナップ）

が利用できます。

Portをコンポーネントの枠線へドラッグすると、枠線に吸着し、コンポーネントを移動してもPortは一緒に移動します。

---

## XMLでPortを定義することも可能

draw.ioのファイル形式（mxGraph XML）では、Portを親コンポーネントに対する相対位置（`x=0`：左辺、`x=1`：右辺など）で定義できます。そのため、コンポーネントを移動・サイズ変更してもPortが境界線上の適切な位置を保つようにできます。

AUTOSAR Software ComponentのようにPortを多数持つ図を作成する場合は、このXMLをテンプレート化して自動生成すると、手作業よりも効率的かつ一貫性のある図を作成できます。これはAUTOSARのARXMLからComposite Structure Diagramを生成する用途にも応用しやすい方法です。


-----
# DrqwIO UML
<img width="3368" height="4324" alt="image" src="https://github.com/user-attachments/assets/b9855045-46f1-4ee2-999d-03b7a718b84d" />


