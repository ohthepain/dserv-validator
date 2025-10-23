# canton-console

I was able to get it to run with

>docker compose up -d canton-console-app-user
>docker attach $(docker compose ps -q canton-console-app-user)

then you can run:

participant
participants.remote(0)
participants.remote(0).health.status 
participants.remote(0).parties.list()
participants.remote(0).packages.list()
participants.remote(0).ledger_api
participants.remote(0).help
participant help   
participants.remote(0).help
participants.remote(0).ledger_api.help

