Q1 How can I describe activity diagram recursively fork and join by plantuml？
A1 by Gemini
To describe recursive `fork` and `join` structures in PlantUML, you need to understand that PlantUML treats forks as **block structures**. Just like nested `if` statements or loops in programming, every inner `fork` must be fully opened and closed *within* its parent fork branch.

Here is how you can structure it, along with a clean example.

---

## The Golden Rule for Nesting Forks

When you nest a fork inside another fork, follow these structural rules:

1. Start the main `fork`.
2. Inside one of the paths, start a new `fork`.
3. Provide the parallel paths for that *inner* fork using `fork again`.
4. Close the inner fork using `end fork` **before** you move on to the next branch of the outer fork.
5. Close the outer fork with its own `end fork`.

---

## Code Example: Recursive Forking

Here is a practical example of a multi-tiered parallel process, where a "Package Delivery" task splits into "Physical Shipping" and "Digital Notification". The notification task then further splits into "Email" and "SMS" concurrently.

```plantuml
@startuml
skinparam DoNotLinkToMainFork true

start
:Receive Order;

fork
  == Outer Fork: Branch 1 ==
  :Ship Physical Package;
  :Track Delivery;

fork again
  == Outer Fork: Branch 2 ==
  :Process Digital Notifications;
  
  fork
    == Inner Fork: Branch A ==
    :Send Email Receipt;
  fork again
    == Inner Fork: Branch B ==
    :Send SMS Update;
  end fork
  
  :Log Notification Status;

end fork

:Complete Order;
stop
@enduml

```

---

## Visualizing the Hierarchy

As shown in the logic above:

* **The Outer Fork / Join:** Encompasses the entire parallel operation between the physical warehouse team and the automated system team.
* **The Inner (Recursive) Fork / Join:** Is entirely contained within the automated system branch, spinning up two simultaneous micro-tasks (Email and SMS) that merge back together before the system branch joins the main warehouse flow.

### Key Syntax Tips:

* **Labels:** Using `== Label ==` right after a `fork` or `fork again` helps visually document what each parallel thread is doing, which is incredibly useful when diagrams get deep.
* **No `join` keyword:** In PlantUML's modern activity syntax, you do not type "join". The `end fork` command automatically acts as the synchronization bar (join) for all paths inside that specific block level.
