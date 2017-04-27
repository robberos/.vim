#!/bin/sh

#FIXME necessary?
#file=$(echo $1 | sed s~$AXIS_TOP_DIR~$NB_BUILD_DIR~g)
file=$1
line=$2
search_string=$(echo "$3" | sed -e 's/</\\</g' -e 's/>/\\>/g')

session=0
# Fix for "Press any key"
tmux send-keys Enter
for row in `tmux list-panes -F '#{session_name}:#{window_name},#{pane_active}'`;
do
  active=$(echo $row | sed 's/.*,//')
  pane=$(echo $row | sed "s/\(.*\),.*/\1.$session/")

  # choose first inactive pane
  #FIXME toggle between panes better?
  # not just first inactive chosen, OK if only two..
  if [ $active == '0' ]; then
    #FIXME verify that vim is running - get pane pid, and use pstree?
    #FIXME if not vim, only shell, start vim?
    tmux send-keys -t $pane Escape
    tmux send-keys -t $pane :tabnew Space $file Enter
    tmux send-keys -t $pane /"$search_string" Enter
    tmux send-keys -t $pane :$line_number Enter zz
    tmux select-pane -t $pane
    break
  fi

  session=`expr $session + 1`

done
