if status is-interactive
    function lf
        export LF_CD_FILE="/var/tmp/.lfcd-$fish_pid"
        command lf "$argv"
        if [ -s "$LF_CD_FILE" ]
            set dir "$(realpath -- "$(cat -- "$LF_CD_FILE")")"
            if [ "$dir" != "$PWD" ]
                printf 'cd to %s\n' "$dir"
                cd "$dir"
            end
            rm "$LF_CD_FILE"
        end
    set -e LF_CD_FILE
    end
end
