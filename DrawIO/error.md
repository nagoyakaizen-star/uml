https://github.com/nagoyakaizen-star/uml/blob/main/plantuml/os.md

でDrawIOの図

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
をMermaidとして入力したら次のエラーがでた。
                                   
<img width="397" height="175" alt="image" src="https://github.com/user-attachments/assets/b9a383e5-5d5b-489c-b3fa-999c8ca49fd5" />

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




<img width="391" height="181" alt="image" src="https://github.com/user-attachments/assets/0a0b7c00-f7c0-4c67-a31a-f986f390b7f6" />
