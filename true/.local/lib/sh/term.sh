#!/bin/sh

# Terminal functions (mostly using escape sequences)


# Usage: term_set_color n RRGGBB
# Set terminal color n to the given rgb color
term_set_color() {
   # Many terminals have some OSC (Operating System Command)
   # escape sequences to modify their palette colors.
   if [ "$TERM" = linux ]; then
      # Linux (is the ending \007 needed?, maybe not)
      printf '\033]P%d%s\007' "$1" "$2"
   else
      # Modern (xterm-compatible) terminals typically accept
      #    ESC]4;<index>;<color>BEL
      # or ESC]4;<index>;<color>ESC
      # where <color> is RRGGBB or rgb:RR/GG/BB
      printf '\033]4;%d;#%s\007' "$1" "$2"
   fi
}

# Usage: term_set_color_fg RRGGBB
# Set the terminal's default background color to the given rgb color
term_set_color_fg() {
   if [ "$TERM" = linux ]
      then term_set_color 7 "$1"
      else printf '\033]10;#%s\007' "$1"
   fi
}

# Usage: term_set_color_bg RRGGBB
# Set the terminal's default background color to the given rgb color
term_set_color_bg() {
   if [ "$TERM" = linux ]
      then term_set_color 0 "$1"
      else printf '\033]11;#%s\007' "$1"
   fi
}

# Usage: term_set_color_bg_selection RRGGBB
# Set the terminal's selection background color to the given rgb color
term_set_color_bg_selection() {
   [ "$TERM" = linux ] || printf '\033]17;#%s\007' "$1"
}

# Usage: term_set_color_fg_selection RRGGBB
# Set the terminal's selection foreground color to the given rgb color
term_set_color_fg_selection() {
   [ "$TERM" = linux ] || printf '\033]19;#%s\007' "$1"
}

# Usage: term_set_color_bg_cursor RRGGBB
# Set the terminal's cursor color to the given rgb color
term_set_color_bg_cursor() {
   [ "$TERM" = linux ] || printf '\033]12;#%s\007' "$1"
}

# Usage: term_set_color_fg_cursor RRGGBB
# Set the terminal's character color for when cursor is on it
term_set_color_fg_cursor() {
   # Do nothing as there's no common OSC sequence for cursor foreground.
   # Terminals seem to somehow determine a sensible color on their own, perhaps
   # deriving it from terminal's background color and/or from the cursor's color
   return 0
}
