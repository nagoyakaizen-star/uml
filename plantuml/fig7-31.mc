@startuml

loop 

par successful case

critical 

[-> ChatServer 

ChatServer -> TextQueue: input the Queue(text)

end


else some kind of failure

    ChatServer -> TextQueue: Authentication Failure


   ChatServer -> ClientA : Log attack end
    

   ChatServer -> ClientB: Please repeat

end

end
@enduml



