RED='\033[0;31m'
YELLOW='\033[1;33m'
LGREEN='\033[1;32m'
LBLUE='\033[1;34m'
NC='\033[00m' # No Color
START_NP='\001' # start of non printable chars%
STOP_NP='\002' # stop of non printable chars%

git_branch() {
  if [[ -n $(echo $(__git_ps1)) ]]
  then
    # if master branch color RED
    if [[ "(master)" == $(echo $(__git_ps1)) ]]
    then
        branch=" -${START_NP}${RED}${STOP_NP}$(__git_ps1)${START_NP}${NC}${STOP_NP}"
    else
        #if git but not master no color
        branch=" -$(__git_ps1) "
    fi
    #show dirty files if any
    #show dirty files if any
    dirty=$(git status -s | wc -l | tr -d '[:space:]')
    if [[ $dirty -gt 0 ]]
    then
        branch="$branch ${START_NP}${YELLOW}${STOP_NP}${dirty}*${START_NP}${NC}${STOP_NP}"
    fi

    commits=$(git status -sb)
    #show ahead
    ahead=$(echo $commits | perl -nle 'print $& if m{ahead \K\w}')
    if [[ $ahead -gt "0" ]]
    then
        branch="$branch ${START_NP}${LGREEN}${STOP_NP}${ahead}↑${START_NP}${NC}${STOP_NP}"
    fi
    #show behind
    behind=$(echo $commits | perl -nle 'print $& if m{behind \K\w}')
    if [[ $behind -gt "0" ]]
    then
        branch="$branch ${START_NP}${LBLUE}${STOP_NP}${behind}↓${START_NP}${NC}${STOP_NP}"
    fi
  fi
  #else nothing

  #print result
  printf "$branch"

}
