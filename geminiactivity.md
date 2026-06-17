@startuml

start

if (multimedia?) then (yes)
  fork
    :audio;
    if (subtitle?) then (yes)
      fork
        :transcript;
        if (translate?) then (yes)
          fork
            :Japanese;
          fork again
            :Chinese;
          fork again
            :English;
          fork again
            :Spanish;
          end fork       
        else (no)
          :original;
        endif
      fork again
        :text formatting; '' Added a secondary path to make the transcript fork valid
      end fork
    else (no)
      :No action;
    endif
  fork again
    :video;
  end fork
else (no)
  :No action;
endif

stop

@enduml

----
PlantUML version 1.2026.7beta3 / 2632e97 [2026-06-16 20:34:29 UTC]
[From textarea (line 29) ]
 
@startuml
 
start
 
if (multimedia?) then (yes)
  fork
    :audio;
    if (subtitle?) then (yes)
      fork
        :transcript;
        if (translate?) then (yes)
          fork
            :Japanese;
          fork again
            :Chinese;
          fork again
            :English;
          fork again
            :Spanish;
          end fork       
        else (no)
          :original;
        endif
      fork again
        :text formatting; '' Added a secondary path to make the transcript fork valid
      end fork
    else (no)
      :No action;
    endif
 Cannot find if (Assumed diagram type: activity)
 
