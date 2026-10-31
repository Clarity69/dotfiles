set -g fish_greeting ""
fish_add_path ~/.local/bin

if status is-interactive
    oh-my-posh init fish --config ~/.config/ohmyposh/arrow.omp.json | source
end

if status is-interactive
    nitch
end
set -gx PATH $HOME/.npm-global/bin $PATH
