alias mkdir='mkdir -p'

mkcd() {
   if is-gnu mkdir || is-busybox mkdir
      then mkdir -pv "$@"
      else mkdir -p  "$@"
   fi || return

   local i
   local dir
   if command -v fzf >/dev/null; then
      dir=$(for i; do
               printf '%s\n' "$i"
            done               |
            fzf --prompt 'cd ' \
                --select-1     )
   else
      dir=$1
   fi

   [ -z "$dir" ] && return
   cd "$dir"
}
