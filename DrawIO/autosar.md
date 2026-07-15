# Q1 AUTOSARのsoftware Componentをdraw.ioで記述した例を教えてください。
A1
はい。AUTOSAR Software Component（SWC）は、UML Composite Structure Diagramに非常に近い表現ができます。draw.ioでもPortを境界線上に配置し、P-Port（Provide Port）とR-Port（Require Port）を表現できます。

例えば、以下のようなSWCを考えます。

* SensorSWC

  * P-Port: SensorData
* ControllerSWC

  * R-Port: SensorData
  * P-Port: ActuatorCmd
* ActuatorSWC

  * R-Port: ActuatorCmd

---

## 例1：最も一般的なAUTOSAR SWC構成

```text
              SensorSWC

      +-------------------------+
      |                         |
      |     Sensor Logic        |
      |                         |
      |                    □ P  |
      +--------------------|----+
                           |
                           | SensorData
                           |
      +--------------------|----+
      | □ R                    P□|
      |                         |
      |    Controller Logic     |
      |                         |
      +-------------------------+
                     |
                     | ActuatorCmd
                     |
      +-------------------------+
      |□ R                      |
      |                         |
      |     Actuator Logic      |
      |                         |
      +-------------------------+
```

---

## draw.ioでの作成手順

### ① UMLライブラリを有効にする

* **More Shapes**
* **Software**
* **UML**

---

### ② Componentを配置

```
Component

+-------------------+
|   SensorSWC       |
+-------------------+
```

---

### ③ Portを配置

左側

```
□
```

Require Port

右側

```
□
```

Provide Port

へドラッグします。

---

### ④ 名前を付ける

```
□
R:SensorData
```

または

```
□
P:SensorData
```

---

### ⑤ Connectorで接続

```
P-Port ---------------- R-Port
```

---

## AUTOSARらしい表記

実際のAUTOSARではPortの型も記載します。

```
□ P
VehicleSpeed
SenderReceiverInterface
```

```
□ R
VehicleSpeed
SenderReceiverInterface
```

これだけでもかなりAUTOSARらしくなります。

---

## Composition SWC

さらにCompositionを描くと

```text
+----------------------------------------------------+
|            VehicleControlComposition               |
|                                                    |
|   +-------------+     +---------------+            |
|   | SensorSWC   |---->| ControllerSWC |            |
|   +-------------+     +---------------+            |
|                                   |                |
|                                   |                |
|                             +-------------+        |
|                             | ActuatorSWC |        |
|                             +-------------+        |
|                                                    |
+----------------------------------------------------+
```

これはAUTOSAR仕様書にもよく出てくる構成です。

---

## Port Interfaceまで記載

実務ではPortの横にInterface名を書きます。

```text
□ R
VehicleSpeed
<<SenderReceiverInterface>>
```

```
□ P
ThrottleCmd
<<ClientServerInterface>>
```

---

## 実際のAUTOSARツールに近い表現

```text
+-------------------------------------------------------+
|                 ControllerSWC                         |
|                                                       |
| □ R                                                   |
| VehicleSpeed                                          |
| <<SenderReceiverInterface>>                           |
|                                                       |
|              Controller Logic                         |
|                                                       |
|                                     □ P              |
|                                     ThrottleCmd      |
|                                     <<ClientServer>> |
+-------------------------------------------------------+
```

このような表現は、AUTOSARツール（DaVinci DeveloperやEB tresosなど）でも見かけるスタイルです。

---

### draw.ioで再現するコツ

* SWCは「Component」または「Rectangle」で表現
* Portは小さな四角形（UMLのPort図形または4×4〜8×8程度の正方形）を境界線上に配置
* Port名とInterface名はPortの近くにテキストで配置
* SWC間はコネクタで接続し、必要に応じて `Assembly Connector` や `Delegation Connector` と注記する

この方法で、AUTOSARのSoftware ComponentやCompositionを見やすく表現できます。
