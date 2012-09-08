![Screenshot of iTerm](http://github.com/seeminglee/smlcandy/raw/master/img/screenshot-iterm.png)


## Introduction

I am not a super geek so I can't just work inside a default black and white terminal with a dollar sign, so I customized mine to suit my needs. This started first for fun when I was playing with Linux a while back, and I gradually improved on it as I find myself using the shell more and more working on both Mac and Linux platforms. 

It tries to do the following things:


### Differentiate between files, folders and symbolic links

Insert relevant bits from [bash_profile_snippet.sh](https://github.com/seeminglee/smlcandy/blob/master/bash_profile_snippet.sh) into your ~/.bash_profile config file.

<dl>
    <dt>ls</dt>
    <dd>I use aliases to change the default behavior of ls to append suffix (-F), enable colorized output (-G).</dd>
    <dt>ll</dt>
    <dd>I assign a function to ll for long listings. Normally when you do an ls -l you would want to pipe it to less anyway so it is included. The additional flags just utilize the same flags I used for ls as well as displaying file size allocation in human readable units like kilobytes as opposed to the default which is in blocks.</dd>
</dl>


### Wayfinding

Display additional metadata about the folder I am in and when I have invoked those commands when I scroll through the terminal history. 

<dl>
    <dt>sml@sml-mac</dt>
    <dd>[username]@[hostname]</dd>

    <dt>( smlpy )</dt>
    <dd>Name of the virtualenv project I am currently working on. If you don't use virtualenv, just remove the relevant bits.</dd>

    <dt>[git:master+?]</dt>
    <dd>Status of the git repo. Tihs is made possible by using Armin Ronacher (mitsuhiko)'s excellent vcprompt https://bitbucket.org/mitsuhiko/vcprompt.</dd>

    <dt>Wed Mar 14 03:33:15</dt>
    <dd>The date, obviously. I use this because often I have no idea when I last typed that something inside the Terminal. Was is an hour ago, a day ago or a month ago? On my Mac and especially when I'm inside Linux, the OS runs for so long that it is easier for me to tell when something was run.</dd>

    <dt>~/lib/python/scipy-1.0dev/</dt>
    <dd>The current folder aka $PWD. It's good to know where you are. I separate this out onto its own line because it gets unwieldingly long.</dd>
</dl>


### Shell history as number prefix

Picking up a cue from [iPython](http://ipython.org), the awesome Python shell for humans, I added number prefixes to my command line as an ambient device to know how long that shell has been running for. I had meant for the number to reflect the same number used when invoking history but I haven't been able to figure out how yet. So if you know, let me know!


### Differentiate between normal user and super user logins 

Sometimes when you are sysadmin'ing, you need to invoke a lot of sudo commands, and if you know what are doing, often it's just easier to go into super user mode by invoking sudo su. Staying in this mode is dangeous, as you can often seriously damage your system. So I change color scheme to my candy prompt to a haunting red so I will be cautious when I am in this mode. This is achieved by using the SUDO_PS1 and SUDO_PS2 environment variables.


### Change default unix colors to more sensible choices

The default unix colors designates the color red for executable. I tend not to use red for anything that is within normal flow. I changed the default to green instead. Green = go = execute is the mnemonic I use.

If you prefer things the way they are, by all means, comment out the export LSCOLORS bit.

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


### Color palette for iTerm

If you are on the Mac and you don't already use iTerm, use it. It's awesome. Go get it at http://iterm2.com

This palette is based on the [Tango palette](http://en.wikipedia.org/wiki/Tango_Desktop_Project#Palette) with some minor tweaks for better readability against a black background. To apply custom colors to iTerm, open up Preferences &gt; Colors:

![Screenshot: iTerm Color Preferences](http://github.com/seeminglee/smlcandy/raw/master/img/screenshot-iterm-pref-colors.png)

1. Click on the color cell of each item in Basic Colors and ANSI Colors. 
2. The Apple color palette will open up, where you can load up the file named [smlcandy.clr](https://github.com/seeminglee/smlcandy/blob/master/smlcandy.clr) 
3. Repeat the process until all the colors have changed.

![Screenshot: Color palette preview](http://github.com/seeminglee/smlcandy/raw/master/img/screenshot-smlcandy-colors.png)

Note: if the color doesn't seem to show up correctly, you may wish to adjust the Minimum contrast settings. Consult iTerm's manual for details.


### Everything together

The actual prompt is inside the file named [colorprompt.sh](https://github.com/seeminglee/smlcandy/blob/master/colorprompt.sh) where the whole thing is put together to give you the nice prompt for better usability. If you are not using VirtualEnv for Python and you don't want to show git status, just remove the relevant lines. The file is fairly verbose:

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


## Installation

1. Inside ~/.bash_profile, source the colorprompt.sh
2. Insert relevant bits of alias and unix LSCOLORS exports where nececessary.
3. There's no step 3.


## Licensing

You are free to use these code in anyway you wish. Feel free to give me credits but it's not necessary. I cannot be responsible for any potential system or data losses as a result of using this code. You are welcome to ask me questions on Twitter [@seeminglee](http://twitter.com/seeminglee) and I'll try to my best to answer them, but I won't be able to give you any extensive technical support. Thanks for checking this out!
