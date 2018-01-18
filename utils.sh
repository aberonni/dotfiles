ESC_SEQ="\x1b["
COL_RESET=${ESC_SEQ}"39;49;00m"
COL_RED=${ESC_SEQ}"31;01m"
COL_GREEN=${ESC_SEQ}"32;01m"
COL_YELLOW=${ESC_SEQ}"33;01m"
COL_BLUE=${ESC_SEQ}"34;01m"
COL_MAGENTA=${ESC_SEQ}"35;01m"
COL_CYAN=${ESC_SEQ}"36;01m"

function run(){
    echo -e "${COL_MAGENTA} ⇒ ${COL_RESET}$1..."
}

function message(){
    echo -e "${COL_BLUE}[INFO] - ${COL_RESET}$1..."
}

function warn(){
    echo -e "${COL_YELLOW}[WARNING] - ${COL_RESET} "$1
}

function error(){
    echo -e "${COL_RED}[ERROR] - ${COL_RESET} "$1
}

# Test whether a command exists
# $1 - cmd to test
function command_exists(){
    if [ $(type -P $1) ]; then
      return 0
    fi
    return 1
}

function link(){
    # Force create/replace the symlink.
    ln -fs ${1} ${2}
}
