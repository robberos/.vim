#!/bin/sh

file=$1
line=$2
search_string=$(echo "$3" | sed -e 's/</\\</g' -e 's/>/\\>/g')

session=0
# Fix for "Press any key"
tmux send-keys Enter
for row in `tmux list-panes -F '#{session_name};#{window_index};#{pane_active};#{pane_pid}'`;
do
  args=(${row//;/ })
  echo $args
  active=${args[2]}
  pane="${args[1]}.$session"
  has_vim=`ps --ppid ${args[3]} | grep -c vim`

  # choose first inactive pane running vim
  # FIXME if no pane has vim, start it?
  # FIXME if multiple panes running vim, toggle better where to open file?
  if [ $active == '0' ] && [ $has_vim == '1' ]; then
    tmux send-keys -t $pane Escape
    tmux send-keys -t $pane :tabnew Space $file Enter
    tmux send-keys -t $pane /"$search_string" Enter
    tmux send-keys -t $pane :$line Enter zz
    tmux select-pane -t $pane
    break
  fi

  session=`expr $session + 1`

done
