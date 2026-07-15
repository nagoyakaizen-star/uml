# Q1 https://www.osek-vdx.org/mirror/os21_rc1.pdf に出てくる状態遷移図、タイミング図からシーケンス図をそれぞれ一つづつ作成してください。
A1 by Chatgpt
はい。OSEK OS 2.1r1には、

* **状態遷移図 (State Transition Diagram)**（Figure 4-1, 4-3など）
* **タイミング図 (Timing Chart)**（Figure 4-6 Full preemptive scheduling、Figure 4-7 Non preemptive scheduling）

が掲載されています。([OSEK VDX][1])

これらをUMLシーケンス図へ変換した例を示します。

---

# ① 状態遷移図（Basic Task State Model）→ シーケンス図

元の状態遷移

```
Suspended
    |
ActivateTask()
    |
Ready
    |
Scheduler
    |
Running
    |
TerminateTask()
    |
Suspended
```

これをシーケンス図にすると、

```plantuml
@startuml
title OSEK Basic Task State Transition

actor Application
participant OS
participant Scheduler
participant Task

Application -> OS : ActivateTask(TaskA)

OS -> Task : state = READY

Scheduler -> Task : dispatch()

activate Task
Task -> Task : execute()

Task -> OS : TerminateTask()

deactivate Task

OS -> Task : state = SUSPENDED

@enduml
```

<img width="444" height="475" alt="image" src="https://github.com/user-attachments/assets/f5131ee4-db71-4536-8df8-150f1ed92a32" />


ポイント

* 状態遷移図では「状態」が主役
* シーケンス図では「API呼び出し」が主役
* SchedulerがReady→Runningを担当することが明確になります。

---

# ② Full Preemptive Scheduling（Timing Chart）→ シーケンス図

タイミング図では

```
TaskLow
|
|-------------------------
|
          ↑
      ActivateTask(High)

TaskHigh
             |---------|
```

という時間変化が描かれています。([Scribd][2])

これをシーケンス図にすると

```plantuml
@startuml
title OSEK Full Preemptive Scheduling

participant ISR
participant OS
participant Scheduler
participant TaskLow
participant TaskHigh

activate TaskLow

TaskLow -> TaskLow : processing()

ISR -> OS : ActivateTask(TaskHigh)

OS -> Scheduler : reschedule()

Scheduler -> TaskLow : preempt()

deactivate TaskLow

Scheduler -> TaskHigh : dispatch()

activate TaskHigh

TaskHigh -> TaskHigh : execute()

TaskHigh -> OS : TerminateTask()

deactivate TaskHigh

Scheduler -> TaskLow : resume()

activate TaskLow

TaskLow -> TaskLow : continue()

@enduml
```

<img width="584" height="502" alt="image" src="https://github.com/user-attachments/assets/9fc93067-ce34-4a4d-ade2-6de67fadd893" />


ここでは

* ISRが高優先度タスクを起動
* Schedulerが即座にプリエンプト
* 高優先度終了後に元のタスクを再開

という流れがタイミング図より読み取りやすくなります。

---

# UML的な対応関係

| OSEK図                    | UML図                  | 主な表現対象       |
| ------------------------ | --------------------- | ------------ |
| State Transition Diagram | State Machine Diagram | 状態と遷移        |
| Timing Chart             | Timing Diagram        | 時間軸          |
| API呼び出しの流れ               | Sequence Diagram      | メッセージ交換      |
| Schedulerの動作             | Sequence Diagram      | オブジェクト間の相互作用 |

---

AUTOSARやOSEKの仕様書をUMLへ置き換える場合は、**状態遷移図・タイミング図・シーケンス図を相互に対応付ける**と理解しやすくなります。例えば、状態遷移図で示される **Activate → Ready → Running → Terminate** のライフサイクルを、シーケンス図では `ActivateTask()`、スケジューラによるディスパッチ、`TerminateTask()` のメッセージとして表現でき、タイミング図ではそれらが時間軸上でどのように発生するかを示せます。これは仕様レビューや設計レビューでも有効な表現方法です。

[1]: https://www.osek-vdx.org/osekvdx_os.html?utm_source=chatgpt.com "OS"
[2]: https://www.scribd.com/doc/47007279/Programming-in-the-OSEK-VDX-Environment-With-CD-ROM?utm_source=chatgpt.com "Programming in The OSEK-VDX Environment (With CD-ROM) | PDF | Computer Engineering | Intellectual Works"

Q1 https://www.osek-vdx.org/mirror/os21_rc1.pdf に出てくる状態遷移図、タイミング図からシーケンス図をそれぞれ一つづつ作成してください。
A1  by Gemini
OSEK/VDX OS 仕様書（v2.1）に登場する代表的な「タスクの状態遷移図（Task State Transitions）」**および**「フルプリエンプティブ・スケジューリングのタイミング図（Full Preemptive Scheduling）」のシナリオをベースに、それぞれの挙動を視覚化するPlantUMLのシーケンス図を作成しました。

そのままPlantUMLのエディタに貼り付けてレンダリングできます。

---

### 1. 状態遷移図（Extended Taskモデル）に基づくシーケンス図

仕様書の「Figure 4-1 (タスク状態遷移図)」における、**SUSPENDED（休止） → READY（実行可能） → RUNNING（実行中） → WAITING（待ち） → READY → RUNNING → SUSPENDED** という一連のライフサイクル遷移を表現しています。

```plantuml
@startuml
title 状態遷移図に基づくシーケンス図 (Extended Taskのライフサイクル)

actor "他タスク / ISR" as Other
participant "OS (スケジューラ)" as OS
participant "対象タスク (Extended Task)" as Task

note over Task : [SUSPENDED 状態]\nタスクは休止中

== 1. タスクの起動 (SUSPENDED -> READY -> RUNNING) ==
Other -> OS : ActivateTask(Task)
note over Task : [READY 状態] に遷移
OS -> OS : スケジューリング判断
OS -> Task : ディスパッチ (実行権の譲渡)
note over Task : [RUNNING 状態] に遷移

== 2. イベント待ちによる待機 (RUNNING -> WAITING) ==
Task -> OS : WaitEvent(Event1)
note over Task : [WAITING 状態] に遷移\n(CPUを解放)
OS -> Other : 他の処理へ移行

== 3. イベント発生による復帰 (WAITING -> READY -> RUNNING) ==
Other -> OS : SetEvent(Task, Event1)
note over Task : [READY 状態] に遷移
OS -> OS : スケジューリング判断
OS -> Task : ディスパッチ (実行再開)
note over Task : [RUNNING 状態] に遷移

== 4. タスクの終了 (RUNNING -> SUSPENDED) ==
Task -> OS : ClearEvent(Event1)
Task -> OS : TerminateTask()
note over Task : [SUSPENDED 状態] に戻る
OS -> OS : 次のタスクへディスパッチ

@enduml

```
<img width="550" height="785" alt="image" src="https://github.com/user-attachments/assets/a95d6b80-cbea-4b99-9b92-0b455e7e040f" />
<img width="526" height="361" alt="image" src="https://github.com/user-attachments/assets/23615ac8-3f7e-4870-ba8c-50a9ad61b14b" />



---

### 2. タイミング図（フルプリエンプティブ）に基づくシーケンス図

仕様書の「Figure 4-5 (Full Preemptive Scheduling)」等で示される、「低優先度タスクの実行中に、高優先度タスクが起動して割り込む（プリエンプション）」というタイミングチャートのシナリオを表現しています。

```plantuml
@startuml
title タイミング図に基づくシーケンス図 (Full Preemptive Scheduling)

participant "低優先度タスク (Task Low)" as Low
participant "OS (スケジューラ)" as OS
participant "高優先度タスク (Task High)" as High

note over Low : [RUNNING]\n低優先度タスクが実行中

== 高優先度タスクの起動イベント発生 ==
Low -> OS : ActivateTask(Task High)
note over High : [READY] 高優先度タスクが実行可能になる

activate OS
note over OS : プリエンプションの発生\n(優先度 High > Low)

OS -> Low : 【中断】実行権の回収
note over Low : [READY] 実行状態から一時停止

OS -> High : 【開始】ディスパッチ
deactivate OS
note over High : [RUNNING] 高優先度タスクの実行開始

... High の処理を実行中 ...

== 高優先度タスクの終了 ==
High -> OS : TerminateTask()
note over High : [SUSPENDED] 高優先度タスクが終了

activate OS
OS -> OS : 次に優先度の高いタスクを検索
OS -> Low : 【再開】ディスパッチ
deactivate OS

note over Low : [RUNNING]\n低優先度タスクが中断した場所から再開
... Low の残りの処理 ...

@enduml

```
<img width="566" height="760" alt="image" src="https://github.com/user-attachments/assets/61baa89f-c5c7-4365-9f98-3500284d63df" />

---

### 作成のポイント

* **状態の明示:** OSEKの仕様書で重要となるタスク状態（`SUSPENDED`, `READY`, `RUNNING`, `WAITING`）の変化が視覚的に追えるよう、`note over` を使ってタイムライン上に明記しています。
* **APIのコール:** 状態遷移やタイミング変化のトリガーとなる `ActivateTask`、`WaitEvent`、`TerminateTask` といった OSEK OS 標準のシステムサービス（API呼び出し）をメッセージラインとして表現しています。

