# Fun with docker networks


## Host

You can follow along on any linux machine. I run the commands on ubuntu 20.04 on vagrant on VirtualBox.

If you're on macOS and want to have the same environment run:

```sh
# Install VirtualBox
# .. left as an excercise for the reader


# Install vagrant
brew bundle

# Power up the box
vagrant up

# SSH to the box
vagrant ssh
```

You can carry on on the shell session to the vagrant box.

Don't forget to power down everything at the end:
```sh
vagrant halt
```

## Create the docker containers

```sh
$ cd ~src
$ docker-compose up
..
server-bridge-network-no-ports           | 2021/03/20 23:04:32 Listening on :8081
server-bridge-network-published-ports    | 2021/03/20 23:04:32 Listening on :8082
server-host-network                      | 2021/03/20 23:04:32 Listening on :8083
server-no-network                        | 2021/03/20 23:04:32 Listening on :8084
```

## Various types of container networks

```sh
$ docker ps -a
CONTAINER ID   IMAGE                                    COMMAND                  CREATED         STATUS         PORTS                    NAMES
a0e3ace002ac   ghcr.io/igor-kupczynski/netutil:latest   "/app/netutil-serve …"   8 minutes ago   Up 8 minutes                            server-no-network
ee9448cdcb86   ghcr.io/igor-kupczynski/netutil:latest   "/app/netutil-serve …"   9 minutes ago   Up 8 minutes                            server-bridge-network-no-ports
61dad5eb2c47   ghcr.io/igor-kupczynski/netutil:latest   "/app/netutil-serve …"   9 minutes ago   Up 8 minutes                            server-host-network
d688eabec6a5   ghcr.io/igor-kupczynski/netutil:latest   "/app/netutil-serve …"   9 minutes ago   Up 8 minutes   0.0.0.0:8082->8082/tcp   server-bridge-network-published-ports
```

The containers are created with different network options:
1. Virtual _bridge_ network with containers: `server-bridge-network-no-ports` and `server-bridge-network-published-ports`
	- additionally server-bridge-network-published-ports` exposes it's `:8082` on the host.
2. Host network with container: `server-host-network`.
3. No network for container: `server-no-network`.


### Try to reach the containers on the host address, from the host

We are on the host.

Let's ping the containers on the host and their port and see which one of them is reachable:
```sh
for p in 8081 8082 8083 8084
	do ADDR="localhost:$p"
	curl -s "$ADDR/quote" -o /dev/null && echo "[ OK ] Connected to $ADDR" || echo "[FAIL] Can't connect to $ADDR"
done
```

Result:
```
[FAIL] Can't connect to localhost:8081
[ OK ] Connected to localhost:8082
[ OK ] Connected to localhost:8083
[FAIL] Can't connect to localhost:8084
```

We can reach:
- `:8082` `server-bridge-network-published-ports`  -- the container is on its own virtual network, but we've instructed docker to expose its port on the host: `0.0.0.0:8082->8082/tcp` 
- `:8083` `server-host-network` -- the container doesn't have its own network space, it shares the network stack with the host. Unsurprisingly, we can successfully reach its port.
