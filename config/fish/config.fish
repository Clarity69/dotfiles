set -g fish_greeting ""
fish_add_path ~/.local/bin

if status is-interactive
    oh-my-posh init fish --config ~/.config/ohmyposh/arrow.omp.json | source
end
