#!/bin/bash

sudo apt update

# test requirements
if [ ! -x "$(command -v curl)" ]; then
  sudo apt install curl
fi

# git is required
if [ ! -x "$(command -v git)" ]; then
  sudo apt install git
fi

# zsh and oh-my-zsh
if [ ! -x "$(command -v zsh)" ]; then
  sudo apt install zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  # install zsh plugins
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
  sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting z extract web-search)/' "$HOME"/.zshrc
fi

# direnv
if [ ! -x "$(command -v direnv)" ]; then
  curl -sfL https://direnv.net/install.sh | bash
  echo eval "$(direnv hook zsh)" >>~/.zshrc
fi

# go
if [ ! -x "$(command -v go)" ]; then
  curl -Lo go.tar.gz https://go.dev/dl/go1.24.4.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf go.tar.gz
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >>"$HOME"/.zshrc
  export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
  rm go.tar.gz
fi

# nvm and node
if [ ! -x "$(command -v node)" ]; then
  export PROFILE="$HOME/.zshrc"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
  nvm install --lts                                                  # install the lts node
fi

# rust
if [ ! -x "$(command rustup)" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  echo "export PATH=$PATH:$HOME/.cargo/bin" >>~/.zshrc
  export PATH=$PATH:$HOME/.cargo/bin
fi

# auto install tools
# 1. neovim
if [ ! -x "$(command -v nvim)" ]; then
  curl -Lo nvim.tar.gz https://github.com/neovim/neovim-releases/releases/download/stable/nvim-linux-x86_64.tar.gz
  sudo tar -C /usr/local -xzf nvim.tar.gz
  echo "export PATH=$PATH:/usr/local/nvim-linux-x86_64/bin" >>"$HOME"/.zshrc
  export PATH=$PATH:/usr/local/nvim-linux-x86_64/bin
  rm nvim.tar.gz
fi
# 2. ripgrep
if [ ! -x "$(command -v rg)" ]; then
  cargo install ripgrep --locked
fi
# 3. lazygit
if [ ! -x "$(command -v lazygit)" ]; then
  go install github.com/jesseduffield/lazygit@latest
fi
# 4. go DiskUsage
if [ ! -x "$(command -v gdu)" ]; then
  go install github.com/dundee/gdu/v5/cmd/gdu@latest
fi
# 5. bottom
if [ ! -x "$(command -v btm)" ]; then
  cargo install bottom --locked
fi
# 6. pyenv
if [ ! -x "$(command -v pyenv)" ]; then
  curl -fsSL https://pyenv.run | bash
  {
    echo "export PYENV_ROOT=\"\$HOME/.pyenv\""
    echo "[[ -d \$PYENV_ROOT/bin ]] && export PATH=\"\$PYENV_ROOT/bin:\$PATH\""
    echo "eval \"\$(pyenv init - zsh)\""
  } >>"$HOME"/.zshrc
fi
# 7. fd-find
if [ ! -x "$(command -v fd)" ]; then
  cargo install fd-find --locked
fi

# source zsh (only if .zshrc exists)
if [ -f "$HOME/.zshrc" ]; then
  source "$HOME"/.zshrc
fi
