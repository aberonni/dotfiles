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

function execute() {

    local -r CMDS="$1"
    local -r MSG="${2:-$1}"
    local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

    local exitCode=0
    local cmdsPID=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If the current process is ended,
    # also end all its subprocesses.

    set_trap "EXIT" "kill_all_subprocesses"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Execute commands in background

    eval "$CMDS" \
        &> /dev/null \
        2> "$TMP_FILE" &

    cmdsPID=$!

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Show a spinner if the commands
    # require more time to complete.

    show_spinner "$cmdsPID" "$CMDS" "$MSG"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait for the commands to no longer be executing
    # in the background, and then get their exit code.

    wait "$cmdsPID" &> /dev/null
    exitCode=$?

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Print output based on what happened.

    message "$MSG"

    if [ $exitCode -ne 0 ]; then
        print_error_stream < "$TMP_FILE"
    fi

    rm -rf "$TMP_FILE"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    return $exitCode

}

function show_spinner() {
    local -r FRAMES='/-\|'

    # shellcheck disable=SC2034
    local -r NUMBER_OR_FRAMES=${#FRAMES}

    local -r CMDS="$2"
    local -r MSG="$3"
    local -r PID="$1"

    local i=0
    local frameText=""

    # Note: In order for the Travis CI site to display
    # things correctly, it needs special treatment, hence,
    # the "is Travis CI?" checks.
    if [ "$TRAVIS" != "true" ]; then
        # Provide more space so that the text hopefully
        # doesn't reach the bottom line of the terminal window.
        #
        # This is a workaround for escape sequences not tracking
        # the buffer position (accounting for scrolling).
        #
        # See also: https://unix.stackexchange.com/a/278888

        printf "\n\n\n"
        tput cuu 3

        tput sc
    fi

    # Display spinner while the commands are being executed.
    while kill -0 "$PID" &>/dev/null; do

        frameText="   [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Print frame text.

        if [ "$TRAVIS" != "true" ]; then
            printf "%s\n" "$frameText"
        else
            printf "%s" "$frameText"
        fi

        sleep 0.2

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Clear frame text.

        if [ "$TRAVIS" != "true" ]; then
            tput rc
        else
            printf "\r"
        fi

    done

}

function set_trap() {
    trap -p "$1" | grep "$2" &> /dev/null \
        || trap '$2' "$1"
}
