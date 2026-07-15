# Q1 mermaidのUMLのPort対応を提案したいと思っています。初版を作ってください
A1
Mermaidは現在、**Class Diagram**、**Sequence Diagram**、**State Diagram**などをサポートしていますが、**Composite Structure Diagram**はありません。そのため、Portを追加するのであれば、単に「Portだけ」を追加するよりも、**UML Composite Structure Diagram全体をサポートする拡張**として提案する方が受け入れられやすいでしょう。

以下は、GitHub IssueやRFCとして提出できる初版の提案書です。

# Proposal: UML Composite Structure Diagram and Port Support for Mermaid

## Summary

This proposal adds UML Composite Structure Diagram support to Mermaid, including UML Ports, Parts, Connectors, and Delegation Connectors.

The goal is to enable architecture modeling for component-based systems such as AUTOSAR, SysML, ROS, DDS, IEC 61499, and software/hardware co-design.

---

# Motivation

Mermaid already supports

* Class Diagram
* Sequence Diagram
* State Diagram
* ER Diagram
* Flowchart

However, UML Composite Structure Diagrams are currently unsupported.

Composite Structure Diagrams are widely used in

* AUTOSAR Software Components
* Embedded systems
* Component-Based Software Engineering
* Robotics
* MBSE
* System Architecture

The most important missing element is the UML **Port**.

---

# Proposed Syntax

Introduce a new diagram type.

```mermaid
compositeDiagram
```

Example:

```mermaid
compositeDiagram

component ApplicationServer {

    port http
    port db

    part Router
    part Auth
    part BusinessLogic

    http --> Router
    Router --> Auth
    Router --> BusinessLogic
    BusinessLogic --> db
}

actor Browser
database PostgreSQL

Browser --> http
db --> PostgreSQL
```

---

# Port Types

Support UML Port stereotypes.

```mermaid
port p1
```

```mermaid
portin request
```

```mermaid
portout response
```

or

```mermaid
port provide VehicleSpeed
port require BrakeRequest
```

---

# Port Position

Ports should automatically snap to the nearest component boundary.

Example:

```text
+---------------------------+
| □                         |
|                           |
|      Component            |
|                           |
|                       □   |
+---------------------------+
```

---

# Parts

Parts represent internal owned instances.

Syntax:

```mermaid
part Controller

part Sensor

part Gateway
```

---

# Connectors

Support UML connectors.

```mermaid
Sensor --> Controller

Controller --> Gateway
```

---

# Delegation Connector

Support delegation.

```mermaid
port http

part Router

http ==> Router
```

where

```text
==>
```

represents Delegation Connector.

---

# Assembly Connector

Support assembly connector.

```mermaid
ComponentA.portA === ComponentB.portB
```

---

# Multiplicity

Optional multiplicity.

```mermaid
port sensors[4]

port clients[*]
```

---

# Port Labels

Allow interface names.

```mermaid
port provide VehicleSpeed : SenderReceiverInterface

port require BrakeRequest : ClientServerInterface
```

---

# Example (AUTOSAR)

```mermaid
compositeDiagram

component ControllerSWC {

    port require VehicleSpeed

    port provide ThrottleCmd

    part ControllerLogic
}
```

---

# Rendering

Ports are rendered as small squares attached to component boundaries.

* Left side
* Right side
* Top
* Bottom

depending on connector direction.

---

# Benefits

This proposal enables Mermaid to model

* UML Composite Structure Diagrams
* AUTOSAR Software Components
* SysML Internal Block Diagrams
* IEC 61499 Function Blocks
* DDS Component Models
* ROS Node Architectures

without introducing significant syntax complexity.

The syntax follows Mermaid's existing declarative style while remaining close to UML terminology.

---

# Backward Compatibility

No existing syntax changes are required.

The proposal introduces only a new diagram type:

```mermaid
compositeDiagram
```

therefore maintaining full backward compatibility.

### 追加で提案すると良い点

この初版はシンプルですが、Mermaidの開発者からは「既存の `classDiagram` を拡張できないか？」という議論が出る可能性があります。そのため、第2版では以下のような点も検討するとよいでしょう。

* `classDiagram` の `class` に `port` を持たせる案との比較
* UML 2.x Composite Structure Diagramとの対応表
* PlantUMLの `port` / `portin` / `portout` 構文との互換性
* AUTOSAR、SysML Internal Block Diagram（IBD）への適用例
* レイアウトアルゴリズム（ELKやDagre）でのPort配置ルール

このように段階的に提案すると、Mermaidコミュニティでも議論しやすい内容になります。
