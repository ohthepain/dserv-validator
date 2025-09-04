### Multiple Repos Architecture

- this repo contains 3rd party services
- the dfront project and repo contain the front end
- the deserve project and repo contains the backend

### Environment Configurations by Scenario

#### Scenario 1: Remote Development

All 3 repos are deployed to our ubuntu server. 

```env
KEYCLOAK_URL=https://keycloak.dserv.io:8082
DATABASE_URL=postgresql://cnadmin:supersafe@138.201.22.153:5432/dserv
PROVIDER_VALIDATOR_URL=http://138.201.22.153:37575
USER_VALIDATOR_URL=http://138.201.22.153:27575
```

#### Scenario 2: Local client and remote backend and services

This and deserv repos are deployed to our ubuntu server. Frontend (dfront) runs locally.
We run a local proxy to keycloak for the dfront

```env
KEYCLOAK_URL=http://keycloak.localhost:8083
DATABASE_URL=postgresql://cnadmin:supersafe@138.201.22.153:5432/dserv
PROVIDER_VALIDATOR_URL=http://localhost:37575
USER_VALIDATOR_URL=http://localhost:27575
```

#### Scenario 3: Full Local Development

We run the services in this dserv-validator project with docker compose, all local.
We run this project from the debugger, with a configuration in launch.json.
We run the front end from the debugger, with a configuration in that project's launch.json.

```env
KEYCLOAK_URL=http://keycloak.localhost:8082
DATABASE_URL=postgresql://cnadmin:supersafe@localhost:5432/dserv
PROVIDER_VALIDATOR_URL=http://localhost:37575
USER_VALIDATOR_URL=http://localhost:27575
```
