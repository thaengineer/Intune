# Git

#### ssh keygen
```bash
ssh-keygen -t ed25519 -C "USER_NAME" -f ~/.ssh/id_ed25519
```

#### Setup globals
```bash
# ssh keygen
ssh-keygen -t ed25519 -C "USER_NAME" -f ~/.ssh/id_ed25519

# set globals
git config --global user.name "USER_NAME"
git config --global user.email "EMAIL_ADDRESS"
git config --global url."git@github.com:".insteadOf "https://github.com/"
git config --global pull.rebase false # always merge
git config --global init.defaultBranch main
git config --global core.editor "nvim" # or vim or code --wait
git config --global push.autoSetupRemote true # local/remote branch upstream tracking

# verify globals
git config --global --list
```

#### Initialize repo
```bash
git init
```

#### Clone repo
```bash
git clone REPO_URL

# via ssh key auth
git clone https://github.com/USERNAME/REPO.git
```

#### 1. Pull from main
```bash
git checkout main
git pull
```

#### 2. Commit
```bash
# check status
git status

# stage changes
git add .

# check status
git status

# commit changes
git commit -m "message"
```

#### 3. Push to main
```bash
git push

# overwrite remote
git push --force-with-lease
```

