if status is-interactive
    # Commands to run in interactive sessions can go here

    fish_vi_key_bindings
    starship init fish | source
    fzf --fish | source

    for file in env/*.fish
        source $file
    end
end
