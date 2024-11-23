# Nixos Silly
## this is a fork version from ZaneyOS 2.2
this version is mainly configured for Rust & TypeScript developer, what you will got with this setup are:
- Android Studio
- PNPM
- React Native/Expo
- NodeJS v22
- NVM/Node Version Manager
- Rustup
- Docker
- Zed Editor

## A couple things need to do are:
### add some required environment variables
Create .bashrc-personal
```bash
touch ~/.bashrc-personal
```
put this
```bash
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$PATH:$HOME/.local/share/pnpm/global/5/bin"
```

### Create a wrapper for adb in order to run your React Native Project
rename adb to adb.real
```bash
mv ~/Android/Sdk/platform-tools/adb ~/Android/Sdk/platform-tools/adb.real
```
Create a new adb script that wraps the original binary with steam-run
```bash
nvim ~/Android/Sdk/platform-tools/adb
```
put this
```bash
#!/usr/bin/env bash
steam-run ~/Android/Sdk/platform-tools/adb.real "$@"
```
make the script to be executable:
```bash
chmod +x ~/Android/Sdk/platform-tools/adb
```
### Setup pnpm global store
check is bin folder exit or not
```bash
ls -la ~/.local/share/pnpm/global/5
```
create bin folder if doesn't exit
```bash
mkdir ~/.local/share/pnpm/global/5/bin
```
set global store location
```bash
pnpm config set global-bin-dir ~/.local/share/pnpm/global/5/bin
```
check the global store location, is the path the same?
```bash
pnpm config get global-bin-dir
```
### install rust?
```bash
rustup default stable
```
