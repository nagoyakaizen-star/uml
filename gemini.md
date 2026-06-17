Q1 In the planguml, the script below has a error.

How can I fixed the error.

@startuml



start



if (multimedia?) then (yes)

  fork

    :audio ;

　　if (subtitle?) then (yes)

      fork

　　　  :transcript;

         if (translate?) then (yes)

            fork

             : Japanese;

  fork again

             : Chinese;

  fork again

             : English;

  fork again

             : Spanish;

             endfork       

           else (no)

             : original;

           endif

        endfork

     else (no)

     : No action;

     endif

  fork again

    :video ;

  end fork

else (no)

  : No action;

endif



@enduml



------

error:

PlantUML version 1.2026.7beta3 / 2632e97 [2026-06-16 20:34:29 UTC][From textarea (line 8) ] @startuml start if (multimedia?) then (yes) fork :audio ;　　if (subtitle?) then (yes) Syntax Error? (Assumed diagram type: activity) 

A1 by gemini


The main issue causing the syntax error in your PlantUML script comes down to two things: **invisible full-width spaces (ideographic spaces)** and **unclosed `fork` blocks**.

PlantUML is highly sensitive to whitespace characters. In lines 6, 7, and 8, you have Japanese full-width spaces (` `) instead of normal spaces. Additionally, you opened multiple `fork` structures but didn't cleanly provide their `fork again` or `end fork` counterparts before closing the parent `if` blocks.

Here is the fully corrected and formatted script:

```plantuml
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

```

### What changed to fix it?

* **Cleaned Whitespace:** Removed all hidden, full-width Japanese spaces (` `) and replaced them with standard standard spaces.
* **Fixed the `transcript` Fork:** In PlantUML, a `fork` structurally implies that multiple parallel tracks are happening at the same time. If you use a `fork`, you *must* have at least one `fork again` section. I added a placeholder (`:text formatting;`) to make the transcript fork syntactically valid.
* *Note: If you didn't actually want parallel processing there, you can safely remove `fork`, `fork again`, and `end fork` from around the transcript section entirely.*


* **Unified Keyword Spacing:** Standardized `end fork` (with a space) for consistency across the nested blocks.
* **Added `stop`:** Placed a proper `stop` node at the end to cleanly terminate the activity flow.
