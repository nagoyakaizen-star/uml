@startuml
skinparam DoNotLinkToMainFork true

start
:Receive Order;

fork
  :Ship Physical Package;
  :Track Delivery;

fork again
  :Process Digital Notifications;
  
  fork
    :Send Email Receipt;
  fork again

    :Send SMS Update;
  end fork
  
  :Log Notification Status;

end fork

:Complete Order;
stop
@enduml

---
<img width="415" height="415" alt="image" src="https://github.com/user-attachments/assets/1b76c907-99f1-4b2d-83fa-073bf4684ac4" />
