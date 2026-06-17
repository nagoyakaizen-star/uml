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

----
PlantUML version 1.2026.7beta3 / 2632e97 [2026-06-16 20:34:29 UTC]
[From textarea (line 8) ]
 
@startuml
skinparam DoNotLinkToMainFork true
 
start
:Receive Order;
 
fork
  == Outer Fork: Branch 1 ==
 Syntax Error? (Assumed diagram type: activity)
