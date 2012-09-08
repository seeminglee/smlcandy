## Screenshots

### Result

![SML iTerm Screenshot](http://github.com/seeminglee/smlcandy/raw/master/img/screenshot-iterm.png)

### Color palette

This palette is largely based on the Tango palette with some tweaks for better readability against black background.

![SML iTerm Screenshot](http://github.com/seeminglee/smlcandy/raw/master/img/screenshot-iterm-pref-colors.png)

## List of Files

### bash_profile_snippets.sh

Snippets of code to be inserted into your .bash_profile

```shell

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
```

### colorprompt.sh

The actual prompt. If you are not using VirtualEnv for Python and you don't want to show git status, just remove the relevant lines. The file is fairly verbose:

```shell
    #!/usr/bin/env bash

    # ============================================================================
    # SML: Color Prompt for virtualenv  
    #
    function update_prompt() {

        local         Reset="\[\033[0m\]"     # \[...\] so line-wrap won't break
        local     color_fmt="\[\033[0;3%dm\]" # foreground color: 0;30 + color number
        local brt_color_fmt="\[\033[1;3%dm\]" # bright fg color : 1;30 + color number
        local  bg_color_fmt="\[\033[4%dm\]"   # background color:   40 + color number
        
        local colors=( Black Red Green Yellow Blue Magenta Cyan White )
        local index=0
        for c in "${colors[@]}"
        do
            # Color (Foreground)
            declare       "${colors[index]}"="$(printf $color_fmt $index)"
            # BrightColor (Foreground)
            declare "Bright${colors[index]}"="$(printf $brt_color_fmt $index)"
            # ColorBG
            declare     "${colors[index]}BG"="$(printf $bg_color_fmt $index)"
            ((index++))
        done
        
        # ------------------------------------------------------------------------
        # VirtuelEnv prompt
        local venv=${VIRTUAL_ENV##/*/}
        local venv_ps=""
        
        if [ "$venv" = "" ]; then
            venv_ps=":::SYS ENV:::"
        else
            venv_ps="$venv"
        fi
        venv_ps="${Yellow}( ${BrightYellow}${venv_ps} ${Yellow})"
        
        # ------------------------------------------------------------------------
        # VC Prompt                      https://bitbucket.org/mitsuhiko/vcprompt
        # 
        #   vcprompt -f "%b"
        #   VCPROMPT_FORMAT="%b" vcprompt
        #
        #   %n  name of the VC system managing the current directory
        #       (e.g. "cvs", "hg", "git", "svn")
        #   %b  current branch name
        #   %r  current revision
        #   %u  ? if there are any unknown files
        #   %m  + if there are any uncommitted changes (added, modified, or
        #       removed files)
        #   %%  a single % character    
        local vcp="\$(vcprompt -f [%n:%b%m%u])" # \$() ensures exec every prompt
        
        # ------------------------------------------------------------------------
        # Cursor position
        local SaveCursor='\[\033[s\]'
        local LoadCursor='\[\033[u\]'
        local CursorDown='\[\033[1B\]'
        local CursorBack3='\[\033[3D\]'
        local CursorForw='\[\033[1C\]'
        local   CursorUp='\[\033[1A\]'
        
        # ------------------------------------------------------------------------
        # Regular prompt
        local user_host="${Green}\u@\h"
        local date="${Magenta}\d \t"
        local path="${BrightBlue}\w/"
        local hist="${Blue}[${BrightBlue}\#${Blue}]:"
        local  uid="${Blue}\$"
        
        PS1="${Reset}"
        PS1+="\n${user_host} ${venv_ps} ${vcp} ${date} ${Reset}"
        PS1+="\n${path} ${Reset}"
        PS1+="\n${hist}${uid}${SaveCursor}${Reset} "
        export PS1
        PS2="${Blue}${LoadCursor}${CursorDown}${CursorBack3}...${SaveCursor}${Reset} "
        export PS2
        
        # ------------------------------------------------------------------------
        # Sudo prompt: evoked when running sudo -s
        #   Strangely although color changed, \$ did not get updated to #
        #   So hard-coding it here
        local sudo_uid="${Red}#"
        local sudo_host="${Red}\u@\h"
        local date="${Yellow}\d \t"
        local path="${Yellow}\w/"
        local hist="${Yellow}[${BrightYellow}\#${Yellow}]:"
        
        SUDO_PS1="${Reset}"
        SUDO_PS1+="\n${sudo_host} ${venv_ps} ${vcp}${date} ${Reset}"
        SUDO_PS1+="\n${path} ${Reset}"
        SUDO_PS1+="\n${hist}${sudo_uid}${SaveCursor}${Reset} "
        export SUDO_PS1
        SUDO_PS2="${Blue}${LoadCursor}${CursorDown}${CursorBack3}...${SaveCursor}${Reset} "
        export SUDO_PS2
        
    }
    # PROMPT_COMMAND=update_prompt
    update_prompt
```
