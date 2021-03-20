# Fun with docker networking


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
vagrant down
```