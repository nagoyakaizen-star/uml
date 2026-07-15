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

# Q4 Draw IOで、https://www.osek-vdx.org/mirror/os21_rc1.pdf に出てくる状態遷移図、タイミング図からシーケンス図をそれぞれ一つづつ作成してください。
A4 
もちろんです。Draw.io（diagrams.net）でそのまま作図できるように、図形の配置と接続を具体的に示します。

OSEK OS 2.1r1では、状態遷移図（Figure 4-3）とタイミング図（Figure 4-6, Figure 4-7）が掲載されています。ここでは、**Figure 4-3（Basic Task State Model）**と**Figure 4-6（Full Preemptive Scheduling）**をもとに、それぞれシーケンス図へ変換した例を示します。([OSEK VDX][1])

---

# 1. 状態遷移図 → シーケンス図

## 元図（Figure 4-3）

```
Suspended
     |
ActivateTask
     |
Ready
     |
Scheduler
     |
Running
     |
TerminateTask
     |
Suspended
```

これは状態の遷移を示しています。シーケンス図では、「誰が誰を呼び出すか」に置き換えます。([OSEK VDX][1])

---

## Draw.ioで作るシーケンス図

### ライフライン

```
Application
OS
Scheduler
TaskA
```

横一列に並べます。

---

### メッセージ

```
Application
      |
      | ActivateTask(TaskA)
      V
OS
      |
      | enqueue(TaskA)
      V
Scheduler
      |
      | dispatch(TaskA)
      V
TaskA
      |
      | execute()
      |
      | TerminateTask()
      V
OS
      |
      | remove(TaskA)
      V
Scheduler
```

---

### Draw.ioで配置

```
+-----------+ +------+ +-----------+ +-------+
|Application| |  OS  | |Scheduler | | TaskA |
+-----------+ +------+ +-----------+ +-------+
     |            |           |          |
     |----------->|           |          |
     | ActivateTask()         |          |
     |            |---------->|          |
     |            | enqueue() |          |
     |            |           |--------->|
     |            |           | dispatch |
     |            |           |          |
     |            |           |<=========|
     |            |           | execute  |
     |            |<---------------------|
     |            | TerminateTask()      |
     |            |---------->|          |
     |            | remove()  |          |
```

Draw.ioでは

* UML → Sequence → Lifeline
* UML → Message

だけで描けます。

---

# 2. タイミング図（Figure 4-6）→ シーケンス図

Figure 4-6は

```
TaskLow 実行中

ISR発生

TaskHigh起動

TaskHigh終了

TaskLow再開
```

というプリエンプションを表しています。([OSEK VDX][2])

---

## Draw.ioでのライフライン

```
ISR
OS
Scheduler
TaskLow
TaskHigh
```

---

## メッセージ

```
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
```

---

### Draw.ioイメージ

```
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
```

---

# Draw.ioで使う図形

| UMLパレット        | 使用する図形           |
| -------------- | ---------------- |
| Lifeline       | ライフライン           |
| Activation     | アクティベーションバー      |
| Message        | 同期メッセージ          |
| Return Message | 戻りメッセージ          |
| Note           | OSEK API名や状態名の注記 |

---

## AUTOSAR/OSEK向けに改善するなら

OSEKの実装では、スケジューラはOS内部の一部として動作するため、シーケンス図では **OS** と **Scheduler** を別ライフラインに分けるよりも、`OS::Scheduler` のように一つのライフラインとして表現する方が実装に近くなります。また、`ActivateTask()` や `TerminateTask()` のほかに、`Dispatch()`、`Context Switch`、`Save Context`、`Restore Context` を明示すると、AUTOSAR OSやTOPPERS/ATK2の動作との対応も取りやすくなります。これはOSEK仕様書のタイミング図には直接描かれていない内部動作を、設計レベルで補足する表現として有用です。

[1]: https://www.osek-vdx.org/mirror/os21r1.pdf?utm_source=chatgpt.com "OSEK/VDX
Operating System
Specification 2.1r1OSEK/"
[2]: https://www.osek-vdx.org/osekvdx_os.html?utm_source=chatgpt.com "OS"

# Q6 mermaidの書式にしてください。
A6
以下は、先ほどの2つのシーケンス図を **Mermaid** の `sequenceDiagram` 書式に変換したものです。

### 1. OSEK状態遷移図（Basic Task State Model）→ シーケンス図

```mermaid
sequenceDiagram
    autonumber

    actor Application
    participant OS
    participant Scheduler
    participant TaskA

    Application->>OS: ActivateTask(TaskA)
    OS->>Scheduler: enqueue(TaskA)
    Scheduler->>TaskA: dispatch()

    activate TaskA
    Note over TaskA: Running

    TaskA->>TaskA: execute()

    TaskA->>OS: TerminateTask()

    deactivate TaskA

    OS->>Scheduler: remove(TaskA)
    Note over TaskA: Suspended
```

<img width="819" height="630" alt="image" src="https://github.com/user-attachments/assets/668c003a-8b31-4875-8ea2-e439ec36397c" />

---

### 2. OSEKタイミング図（Full Preemptive Scheduling）→ シーケンス図

```mermaid
sequenceDiagram
    autonumber

    participant TaskLow
    participant ISR
    participant OS
    participant Scheduler
    participant TaskHigh

    activate TaskLow
    TaskLow->>TaskLow: execute()

    Note over ISR: Interrupt occurs

    ISR->>OS: ActivateTask(TaskHigh)

    OS->>Scheduler: schedule()

    Scheduler->>TaskLow: preempt()

    deactivate TaskLow

    Scheduler->>TaskHigh: dispatch()

    activate TaskHigh

    TaskHigh->>TaskHigh: execute()

    TaskHigh->>OS: TerminateTask()

    deactivate TaskHigh

    OS->>Scheduler: TaskHigh terminated

    Scheduler->>TaskLow: resume()

    activate TaskLow

    TaskLow->>TaskLow: continue()

    deactivate TaskLow
```
<img width="4236" height="6000" alt="image" src="https://github.com/user-attachments/assets/3f867563-9b31-4c35-bc13-4e04d64609fd" />

MermaidはGitHub、GitLab、Markdown Viewer、Obsidianなどでそのまま表示できます。また、Draw.io（diagrams.net）でも **Arrange → Insert → Advanced → Mermaid** を選択し、このコードを貼り付けることでシーケンス図として取り込めます。


