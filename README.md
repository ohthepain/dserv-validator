# canton-console

I was able to get it to run with

> docker compose up -d canton-console-app-user
> docker attach $(docker compose ps -q canton-console-app-user)

or

> docker compose up -d canton-console-app-provider
> docker attach $(docker compose ps -q canton-console-app-provider)

then you can run:

participant
participants.remote(0)
participants.remote(0).health.status
participants.remote(0).parties.list()
participants.remote(0).parties.find("dserv-validator-1")
participants.remote(0).packages.list()
participants.remote(0).ledger_api
participants.remote(0).help
participant help  
participants.remote(0).help
participants.remote(0).ledger_api.help

app_provider_dserv-validator-1::1220082dccd8ff6aeee648630d542ebd7ed6141951210aa86652fc10c7253fd17402

participant.user_management.grant_read_as(
  user_id = "0145df12-c560-40fa-bef3-caff2c5c2224",
  party = "app_provider_dserv-validator-1::1220082dccd8ff6aeee648630d542ebd7ed6141951210aa86652fc10c7253fd17402"
)

participant.user_management.grant_read_as(
  user_id = "0145df12-c560-40fa-bef3-caff2c5c2224",
  party = partyId.toProtoPrimitive
)

participants.remote(0).user_management.grant_read_as("0145df12-c560-40fa-bef3-caff2c5c2224", participants.remote(0).parties.find("app_provider_dserv"))

participants.remote(0).parties.find("app_provider_dserv-validator-1::1220082dccd8ff6aeee648630d542ebd7ed6141951210aa86652fc10c7253fd17402")

participants.remote(0).ledger_api.users.rights.grant("0145df12-c560-40fa-bef3-caff2c5c2224", "app_provider_dserv-validator-1::1220082dccd8ff6aeee648630d542ebd7ed6141951210aa86652fc10c7253fd17402")