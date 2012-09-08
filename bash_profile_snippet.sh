# ============================================================================
# This is a snippet of code to be placed inside your .bash_profile

# ============================================================================
# Bash convenience
#   -F  Append /: path, *: executable, @: symlink, |: FIFO
#   -G  Enable colorized output
#   -h  if -l, use unit suffixes for file sizes
#   -k  if -s, print size allocation in kilobytes, not blocks.
alias ls='ls -FGk' 
function ll() { 
    ls -lFGkha $1 | less
}


# ============================================================================
# SML: Color Prompt for virtualenv  
# 
source ~/bin/colorprompt.sh
# PROMPT_COMMAND=update_prompt

# file color highlights
export CLICOLOR=1

# Force color output even if not outputting to terminal (e.g. less)
export CLICOLOR_FORCE=1

# Default colors: exfxcxdxbxegedabagacad
# Current colors: Exfxbxdxcxegedabagacad
#   a black   c green   e blue     g cyan
#   b red     d brown   f magenta  h light grey
#   --- +++   
#   ex  Ex    1.   directory
#   fx  fx    2.   symbolic link
#   cx  bx    3.   socket
#   dx  dx    4.   pipe
#   bx  cx    5.   executable
#   eg  eg    6.   block special
#   ed  ed    7.   character special
#   ab  ab    8.   executable with setuid bit set
#   ag  ag    9.   executable with setgid bit set
#   ac  ac    10.  directory writable to others, with sticky bit
#   ad  ad    11.  directory writable to others, without sticky bit
export LSCOLORS=Exfxbxdxcxegedabagacad