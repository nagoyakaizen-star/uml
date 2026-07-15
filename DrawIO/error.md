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
