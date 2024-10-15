#!/bin/bash

# Load rosbag filename.
rosbag_name_file="/home/larry/codeGit/run_slam_batch/test_data/rosbag_names.txt"            # ChangeIt!
if [[ ! -f "$rosbag_name_file" ]]; then
    echo "Error. Cannot find rosbag's names file."
    exit 1
fi

# save all rosbags name
bags=()
echo "Rosbags to process are: "
while IFS= read -r line; do
    bags+=("$line")
    echo "--> $line.bag"
done < "$rosbag_name_file"



algorithm_prefix="fastlio"                                                              # ChangeIt! 
rosbag_folder="/home/larry/codeGit/run_slam_batch/test_data/"                           # ChangeIt!
trajectory_output_folder="/home/larry/codeGit/run_slam_batch/output/"                   # ChangeIt!


echo "------------------------------------------------"
echo "Start to process all rosbags"
echo "------------------------------------------------"


for bag in "${bags[@]}"; do
    full_rosbag_filename=${rosbag_folder}${bag}.bag
    echo "--> Process: $full_rosbag_filename"
    
    # 0. start a tmux session
    tmux new-session -d -s mysession

    # 1. run slam. In pane 0.1
    echo "1. run the slam launch"
    tmux send-keys -t mysession "source ~/fastlio_uncertainty_ws/devel/setup.bash" C-m  # source the workspace. # ChangeIt!
    tmux send-keys -t mysession "roslaunch fast_lio my_ouster.launch" C-m               # run launch.           # ChangeIt!

    # 2. create pane 0.2, to run trajectory_saver
    trajectory_save_filename=${algorithm_prefix}_${bag}
    echo "2. Run trajectory saver"
    tmux split-window -h -t mysession
    tmux send-keys -t mysession "source ~/fastlio_uncertainty_ws/devel/setup.bash" C-m  # source the trajector_saver    # ChangeIt!
    tmux send-keys -t mysession "roslaunch trajectory_saver save_trajectory.launch method:=$trajectory_save_filename output_folder:=$trajectory_output_folder" C-m
    echo "Output trajectory into: ${trajectory_output_folder}${trajectory_save_filename}.txt"
    
    
    # 3. Create pane 0.3, to play rosbag
    echo "3. Create a new pane and run rosbag"
    tmux split-window -h -t mysession
    tmux send-keys -t mysession "rosbag play ${full_rosbag_filename}; tmux wait-for -S signal_bagfinish" C-m      # ChangeIt!


    # 4. wait until the rosbag finished.
    tmux wait-for signal_bagfinish
    echo "4. rosbag play done"


    # 5. publish that string to save trajectory into file. Using the same pane, because rosbag play is finished.
    echo "5. pub stop-string to save trajectory"
    tmux send-keys -t mysession 'rostopic pub /cmd std_msgs/String "s" -1' C-m

    # 6. wait for some seconds to stop all file
    echo "6. this session will be killed in 5s..."
    sleep 5
    tmux kill-session -t mysession
done 