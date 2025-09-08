#!/bin/bash

set -e # 遇到错误时退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Function to add path to zshrc if not already present
add_to_path() {
  local new_path="$1"
  local zshrc_file="$HOME/.zshrc"

  # 创建 .zshrc 如果不存在
  touch "$zshrc_file"

  # Check if path is already in zshrc
  if ! grep -q "export PATH.*$new_path" "$zshrc_file" 2>/dev/null; then
    echo "export PATH=\"\$PATH:$new_path\"" >>"$zshrc_file"
    log_info "Added $new_path to PATH"
  else
    log_info "Path $new_path already in .zshrc"
  fi
}

# 检查是否为 root 用户
if [[ $EUID -eq 0 ]]; then
  log_error "This script should not be run as root"
  exit 1
fi

log_info "Updating package list..."
sudo apt update

# 安装基础工具
log_info "Installing basic tools..."
sudo apt install -y curl git build-essential

# test requirements
if [ ! -x "$(command -v curl)" ]; then
  sudo apt install -y curl
else
  log_info "curl already installed, skipping..."
fi

# git is required
if [ ! -x "$(command -v git)" ]; then
  sudo apt install -y git
else
  log_info "git already installed, skipping..."
fi

# zsh and oh-my-zsh
if [ ! -x "$(command -v zsh)" ]; then
  log_info "Installing zsh and oh-my-zsh..."
  sudo apt install -y zsh

  # 安装 oh-my-zsh (非交互式)
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # install zsh plugins
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting

  # 更新插件配置
  sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting z extract web-search)/' "$HOME/.zshrc"
else
  log_info "zsh already installed, skipping..."
fi

# direnv
if [ ! -x "$(command -v direnv)" ]; then
  log_info "Installing direnv..."
  curl -sfL https://direnv.net/install.sh | bash
  echo 'eval "$(direnv hook zsh)"' >>~/.zshrc
else
  log_info "direnv already installed, skipping..."
fi

# go - 获取最新版本
if [ ! -x "$(command -v go)" ]; then
  log_info "Installing Go..."
  GO_VERSION=$(curl -s https://go.dev/VERSION?m=text)
  curl -Lo go.tar.gz "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"
  sudo tar -C /usr/local -xzf go.tar.gz
  add_to_path "/usr/local/go/bin:\$HOME/go/bin"
  export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
  rm go.tar.gz
  log_info "Go installed successfully"
else
  log_info "go already installed, skipping..."
fi

# nvm and node
if [ ! -x "$(command -v node)" ]; then
  log_info "Installing Node.js via nvm..."
  export PROFILE="$HOME/.zshrc"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm install --lts
  log_info "Node.js installed successfully"
else
  log_info "node already installed, skipping..."
fi

# rust
if [ ! -x "$(command -v rustup)" ]; then
  log_info "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  add_to_path "\$HOME/.cargo/bin"
  export PATH=$PATH:$HOME/.cargo/bin
  source "$HOME/.cargo/env"
  log_info "Rust installed successfully"
else
  log_info "rustup already installed, skipping..."
fi

# 确保 Rust 环境可用
if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

# auto install tools
# 1. neovim
if [ ! -x "$(command -v nvim)" ]; then
  log_info "Installing Neovim..."
  curl -Lo nvim.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo tar -C /usr/local -xzf nvim.tar.gz --strip-components=1
  rm nvim.tar.gz
  log_info "Neovim installed successfully"
else
  log_info "neovim already installed, skipping..."
fi

# 2. ripgrep
if [ ! -x "$(command -v rg)" ]; then
  log_info "Installing ripgrep..."
  cargo install ripgrep --locked
else
  log_info "ripgrep already installed, skipping..."
fi

# 3. lazygit
if [ ! -x "$(command -v lazygit)" ]; then
  log_info "Installing lazygit..."
  go install github.com/jesseduffield/lazygit@latest
else
  log_info "lazygit already installed, skipping..."
fi

# 4. go DiskUsage
if [ ! -x "$(command -v gdu)" ]; then
  log_info "Installing gdu..."
  go install github.com/dundee/gdu/v5/cmd/gdu@latest
else
  log_info "gdu already installed, skipping..."
fi

# 5. bottom
if [ ! -x "$(command -v btm)" ]; then
  log_info "Installing bottom..."
  cargo install bottom --locked
else
  log_info "bottom already installed, skipping..."
fi

# 6. pyenv - 安装构建依赖
if [ ! -x "$(command -v pyenv)" ]; then
  log_info "Installing pyenv dependencies..."
  sudo apt install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev

  log_info "Installing pyenv..."
  curl -fsSL https://pyenv.run | bash
  {
    echo 'export PYENV_ROOT="$HOME/.pyenv"'
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"'
    echo 'eval "$(pyenv init - zsh)"'
  } >>"$HOME/.zshrc"
  log_info "pyenv installed successfully"
else
  log_info "pyenv already installed, skipping..."
fi

# 7. fd-find
if [ ! -x "$(command -v fd)" ]; then
  log_info "Installing fd-find..."
  cargo install fd-find --locked
else
  log_info "fd-find already installed, skipping..."
fi

log_info "Installation completed! Please restart your terminal or run 'source ~/.zshrc' to apply changes."
log_warn "You may want to change your default shell to zsh: chsh -s \$(which zsh)"
