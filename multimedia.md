@startuml

start

if (multimedia?) then (yes)

  fork
  
    :audio ;
 
  fork again
  
    :video ;
  
  end fork

else (monoproc)

  : No action;

endif

@enduml

<img width="309" height="238" alt="image" src="https://github.com/user-attachments/assets/46967ee3-f173-44f5-870a-7f24c3725e5f" />
