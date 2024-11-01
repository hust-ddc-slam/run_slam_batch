#!/bin/bash

# give simulation folder, and file index
simulation_data_folder="/home/larry/QSQ_Share/NewSequence/"         # ChangeIt!
rosbag_output_folder="/home/larry/QSQ_Share/NewSequence/output/"    # ChangeIt!
rosbag_name_file="/home/larry/QSQ_Share/NewSequence/name.txt"       # ChangeIt!


if [[ ! -f "$rosbag_name_file" ]]; then
    echo "Error. Cannot find rosbag's names file."
    exit 1
fi

# save all rosbags name
bags=()
echo "Rosbags to create are: "
while IFS= read -r line; do
    bags+=("$line")
    echo "$line"
done < "$rosbag_name_file"


echo "--------------------  ----------------------------"
echo "Start to create all rosbags"
echo "------------------------------------------------"

for bag in "${bags[@]}"; do
    data_folder="${simulation_data_folder}${bag}/"
    echo "==> Process: ${data_folder}"
    
    # 0. start a tmux session
    tmux new-session -d -s mysession

    # 1. create rosbag
    output_bag="${rosbag_output_folder}${bag}.bag"
    gt_file_out="${rosbag_output_folder}gt_${bag}.txt"

    echo "-> Input folder: ${data_folder}"
    echo "-> Output file: ${output_bag}"
    tmux send-keys -t mysession "source /home/larry/chrono_ros_ws/devel/setup.bash" C-m  # source the workspace. # ChangeIt!
    
    tmux send-keys -t mysession "roslaunch create_rosbag create_rosbag.launch \
        sequence:=${bag} input_folder:=${data_folder} output_file:=${output_bag} output_gt:=${gt_file_out}; \
        tmux wait-for -S signal_bagfinish" C-m               # run roslaunch (This is one command, do not add any space after \).    # ChangeIt! 

    tmux wait-for signal_bagfinish
    echo "Done"

    # # 2. copy the gt and rename
    # TODO: removed, because the current `create_rosbag` node generate with rostime now.
    # tmux split-window -h -t mysession
    # sleep 1
    # gt_file_in="${data_folder}gt.csv"
    # gt_file_out="${rosbag_output_folder}gt_${bag}.txt"
    # echo "-> Copy ${gt_file_in} to ${gt_file_out}"
    # tmux send-keys -t mysession "cp ${gt_file_in} ${gt_file_out}" C-m
    # sleep 0.1
    tmux kill-session -t mysession
done 

