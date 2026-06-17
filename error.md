@startuml

start

if (multimedia?) then (yes)
  fork
    :audio ;
　　if (subtitle?) then (yes)
      fork
　　　  :transcript:
         if ( translate?) then (yes)
            fork
             : Japanese:
             : Chinese:
             : English:
             : Spanish:
             endfork       
           else (no)
             : original:
           endif
        endfork
     else (no)
     : No action:
     endif
  fork again
    :video ;
  end fork
else (no)
  : No action;
endif

@enduml


PlantUML version 1.2026.7beta3 / 2632e97 [2026-06-16 20:34:29 UTC]
[From textarea (line 8) ]
 
@startuml
 
start
 
if (multimedia?) then (yes)
  fork
    :audio ;
　　if (subtitle?) then (yes)
 Syntax Error? (Assumed diagram type: activity)
