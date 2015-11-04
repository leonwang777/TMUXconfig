#!/bin/bash
# create a detached  session which is named jumphost

# for (( i=1; i <=5 ; i++)) ; do echo newwin ${i} ; tmux new-window -n termwin${i} -t tst:${i} ;  done
# ssh -A leonwang@exploringboring.corp.sg3.yahoo.com -t 'ssh leonwang@moorepoor.corp.gq1.yahoo.com -A'

function msessions()
{

  cluster='bm1'
  zone='prod'
  jumphost='exploringboring.corp.sg3.yahoo.com'
  # session name
  tmuxsession="$cluster#$zone" # . is bad for seesion name
  # 256 colors UTF8 detached session -2u
  tmux new-session -d -s $tmuxsession # Don't use -C control mode or the pane will be screwed up

  toDebug='Y'
  if [[ $toDebug == 'Y' ]]; then
    # creates panes on window 0 "^"
    # split vertical wins from very first win for L-pane 10%, R-pane 90%
    tmux splitw -h -p 90 -t:0.0
    # split R-pane even horizontally
    tmux splitw -v -t:0.1
    # split top pane to 3 even panes vertically
    tmux splitw -h -p 33 -t:0.1 ssh -A $user_jump
    tmux splitw -h -p 50 -t:0.1 ssh -A $user_jump
    # split bottom pane to 2 even panes vertically
    tmux splitw -h -p 33 -t:0.2 ssh -A $user_jump
    tmux splitw -h -p 50 -t:0.2 ssh -A $user_jump

    tmux -2 attach-session -t $tmuxsession
  fi

  for colo in bf1 bf2 ne1 gq1 tw1 tp2 ir2 sg3 ch1; do
    tmuxsession="$cluster#$zone#$colo" # . is bad for seesion name
    echo Initing tmux with a session of $tmuxsession ................
    tmux new-session -d -s $tmuxsession # Don't use -C control mode or the pane will be screwed up
  done

  for colo in bf1 bf2 ne1 gq1 tw1 tp2 ir2 sg3 ch1 ; do
    tmuxsession=$cluster#$zone#$colo # . is bad for seesion name
    apihost=api1.ostk.$cluster.$zone.$colo.yahoo.com
    toolhost=tool1.ops.$colo.yahoo.com
    user_jump=`whoami`@$jumphost
    echo ssh to $user_jump
    user_api=`whoami`@$apihost
    echo ssh to $user_api
    user_tool=`whoami`@$toolhost
    echo ssh to $user_tool

    # Create a new window with target session and window name
    tmux new-window -P -t $tmuxsession -n $tmuxsession

    # split vertical wins L-pane 20%, R-pane 80%
    tmux splitw -h -p 80 -t:$tmuxsession.0 ssh -A $user_jump -t ssh $user_tool -A
    # split R-pane even horizontally
    tmux splitw -v -t:$tmuxsession.1 ssh -A $user_jump -t ssh $user_tool -A
    # split top pane to 2 even panes vertically
    tmux splitw -h -t:$tmuxsession.1 ssh -A $user_jump -t ssh $user_api -A
    # split bottom pane to 2 even panes vertically
    tmux splitw -h -t:$tmuxsession.2 ssh -A $user_jump -t ssh $user_api -A

    #tmux selectw -t $tmuxsession
    #tmux -2 attach-session -t $tmuxsession
  done
}

function m1session()
{
  waiting=0.7 # waiting time in seconds
  cluster='bm1'
  zone='prod'
  jumphost='exploringboring.corp.sg3.yahoo.com'
  # session name
  tmuxsession="$cluster#$zone" # . is bad for seesion name
  # 256 colors UTF8 detached session -2u
  tmux new-session -d -s $tmuxsession # Don't use -C control mode or the pane will be screwed up

  toDebug='Y'
  if [[ $toDebug == 'Y' ]]; then
    # creates panes on window 0 "^"
    # split vertical wins from very first win for L-pane 10%, R-pane 90%
    tmux splitw -h -p 90 -t:0.0
    # split R-pane even horizontally
    tmux splitw -v -t:0.1
    # split top pane to 3 even panes vertically
    tmux splitw -h -p 33 -t:0.1 ssh -A $user_jump
    tmux splitw -h -p 50 -t:0.1 ssh -A $user_jump
    # split bottom pane to 2 even panes vertically
    tmux splitw -h -p 33 -t:0.2 ssh -A $user_jump
    tmux splitw -h -p 50 -t:0.2 ssh -A $user_jump

  fi

  for colo in bf1 bf2 ne1 gq1 tw1 tp2 ir2 sg3 ch1 ; do

    apihost=api1.ostk.$cluster.$zone.$colo.yahoo.com
    toolhost=tool1.ops.$colo.yahoo.com
    user_jump=`whoami`@$jumphost
    echo ssh to $user_jump
    user_api=`whoami`@$apihost
    echo ssh to $user_api
    user_tool=`whoami`@$toolhost
    echo ssh to $user_tool

    # Create a new window with target session and window name
    tmux new-window -P -t $tmuxsession -n $colo

    # split vertical wins L-pane 20%, R-pane 80%
    tmux splitw -h -p 80 -t:$tmuxsession.0 ssh -A $user_jump -t ssh $user_tool -A
    # split R-pane even horizontally
    tmux splitw -v -t:$tmuxsession.1 ssh -A $user_jump -t ssh $user_tool -A
    # split top pane to 2 even panes vertically
    tmux splitw -h -t:$tmuxsession.1 ssh -A $user_jump -t ssh $user_api -A
    # split bottom pane to 2 even panes vertically
    tmux splitw -h -t:$tmuxsession.2 ssh -A $user_jump -t ssh $user_api -A

    sleep $waiting

  done

  # create a local work windows
  tmux new-window -P -t $tmuxsession -n MyWork -c ~/WorkSpace/VMdotfile # 'cd ~/WorkSpace/VMdotfile'
  tmux splitw -h -p 60 -t:$tmuxsession.0
  tmux splitw -v -t:$tmuxsession.1


  if [[ -z $1 ]]; then
    defaultWin=$tmuxsession:0               # the bash window
  else
    defaultWin=$tmuxsession:$1              # the sepecified colo window
  fi
  defaultPane=$defaultWin.0

  echo the default pane is $defaultPane......
  tmux selectw -t $defaultWin
  tmux selectp -t $defaultPane

  tmux -2 attach-session -t $tmuxsession
}


#tmux new-window -t jumphost:2 -n 'didactictactic' 'ssh -A leonwang@didactictactic.corp.sg3.yahoo.com'
#tmux new-window -t jumphost:3 -n 'streettreat' 'ssh -A leonwang@streettreat.corp.gq1.yahoo.com'
#tmux new-window -t jumphost:4 -n 'moorepoor' 'ssh -A leonwang@moorepoor.corp.gq1.yahoo.com'
#tmux new-window -t jumphost:5 -n 'charon-gq1' 'ssh -A leonwang@chron.ops.corp.gq1.yahoo.com'
#tmux new-window -t jumphost:6 -n 'charon-bf1' 'ssh -A leonwang@chron.ops.corp.bf1.yahoo.com'
#tmux new-window -t jumphost:7 -n 'charon-bm' 'ssh -A leonwang@charon-bm.corp.corp.ne1.yahoo.com'

# activate the window
# tmux select-window -t jumphost:1
# tmux -2 attach-session -t jumphost
