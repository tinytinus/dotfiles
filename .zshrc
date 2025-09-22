HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t default || tmux new-session -s default
fi

eval "$(starship init zsh)"

alias cat="batcat --theme ansi --style numbers,header"
alias ls="eza"
alias la="eza -la"
alias tree="eza --tree"
alias grep="rg"

setopt append_history inc_append_history share_history hist_verify
setopt auto_menu menu_complete
setopt autocd
setopt auto_param_slash
setopt no_case_glob no_case_match
setopt globdots 
setopt extended_glob
setopt interactive_comments
unsetopt prompt_sp 
unsetopt beep

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

goto() {
  local directories=(~/Documents ~/dev ~/vimwiki)
  local place=$(find "${directories[@]}" -type d -not -path '*/[@.]*' 2>/dev/null)
	cd "$(echo $place | fzf --preview 'eza --tree {}')"
}


# !! Automated things below

export PATH="$PATH:/home/bread/.local/bin"

