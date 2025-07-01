function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ $(tag_from_email):\1$(parse_git_dirty)/"
}
export PS1='[\[\033[01;32m\]\u:\[\033[01;34m\]\w\[\033[33m\]$(parse_git_branch)\[\033[00m\]]\[\033[35m\]$\[\033[00m\] '

function cd () {
    builtin cd "$@" && ls;
}
alias ..='cd ..'
export BASH_SILENCE_DEPRECATION_WARNING=1

git config --global user.name "Ethan Siegel"
git config --global user.email "ewsiegel@mit.edu"
git config --global github.user "ewsiegel"    

function creds () {
  echo "Name: $(git config --global user.name)" 
  echo "Email: $(git config --global user.email)" 
  echo "Github User: $(git config --global github.user)" 
}

function toggle () {
  to=$1
  if [[ $to == 'personal' ]]; then
    git config --global user.name "Ethan Siegel"
    git config --global user.email "ewsiegel@gmail.com"
    git config --global github.user "ewsiegel"
  elif [[ $to == 'mit' ]]; then
    git config --global user.name "Ethan Siegel"
    git config --global user.email "ewsiegel@mit.edu"
    git config --global github.user "ewsiegel"  
  else
    echo "Could not toggle to '$to'"
  fi
  echo "Toggled creds to:"
  creds
}

function tag_from_email () {
  email=$(git config --global user.email)
  if [[ $email == 'ewsiegel@gmail.com' ]]; then
    echo "personal"
  elif [[ $email == 'ewsiegel@mit.edu' ]]; then
    echo "mit"
  else
    echo "unknown"
  fi
}

function env() {
    if [ "$#" -lt 2 ]; then
        echo "Usage: env /path/to/env/file command [args...]"
        return 1
    fi

    env_file="$1"
    shift
    command="$@"

    if [ ! -f "$env_file" ]; then
        echo "Environment file not found: $env_file"
        return 1
    fi

    # Create a subshell to isolate the environment changes
    (
        # Source the environment file
        set -a
        source "$env_file"
        set +a

        # Execute the command
        eval "$command"
    )
}

