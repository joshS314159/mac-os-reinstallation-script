# UNDER DEVELOPMENT

# Installing a Fresh OS

## Part 1
1. Log into 1Password.com
2. Log into Mac App Store

## Part 2
1. Install Homebrew via web (https://brew.sh)
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
2. Install bootstrap dependencies via homebrew


```
brew install \
  ansible \
  op 

```

3. Configure `/usr/local/bin/op`
```
op signin <signinaddress> <emailaddress> <secretkey>
```

## Part 3
1. Run ansible here (??)
#1. Copy mackup.cfg in Dropbox to home directory
#2. Change to home dir
#3. Run `mackup restore`
#4. Run `brew bundle`

## Part 4
1. Log into 1Password.app
2. Log into iCloud
3. Reconfigure email accounts
4. Configure Arq
#3. Restore SSH keys from Arq -- HANDLED BY ANSIBLE
5. Install Little Snitch from Home-brew downloaded DMG
6. Restore Little Snitch Settings

## Part 5
1. Reboot
2. Configure Devonthink


## @TODO
* Prevent need to run `mackup restore` several times
