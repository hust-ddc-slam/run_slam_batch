#!/bin/bash

# give simulation folder, and file index
rosbag_name_file="/media/larry/M2-SSD/Trajectory/all/name.txt"       # ChangeIt!

# name-7KeyTest
# name-Fastlio-Liosam

trajectory_folder="/media/larry/M2-SSD/Trajectory/all/"
gt_folder="/media/larry/M2-SSD/Trajectory/all/"


if [[ ! -f "$rosbag_name_file" ]]; then
    echo "Error. Cannot find sequence names file."
    exit 1
fi

# save all rosbags name
bags=()
echo "Sequences for evo compare are: "
while IFS= read -r line; do
    bags+=("$line")
    echo "$line"
done < "$rosbag_name_file"


SLAM_name="pointlio"
SLAM_name="fastlio"
SLAM_name="liosam"
SLAM_name="liolivox"
SLAM_name="odom"

# SLAM_name="liomapping"
# SLAM_name="loam"
# SLAM_name="cticp"


echo "------------------------------------------------"
echo "Start to compare evo"
echo "------------------------------------------------"

for bag in "${bags[@]}"; do

    # conda activate py36
    
    gt_file="${gt_folder}gt_${bag}.txt"
    slam_file="${trajectory_folder}${SLAM_name}_${bag}.txt"


    # ape:
    result_file="${trajectory_folder}res_ape-${SLAM_name}_${bag}.zip"
    # evo_rpe tum ${gt_file} ${slam_file} -a --t_max_diff=1 --delta 1 --delta_unit m --save_result ${result_file}  --save_plot ${trajectory_folder}res_rpe-trans-10m-${SLAM_name}_${bag}.pdf
    evo_ape tum ${gt_file} ${slam_file} --project_to_plane xy  -a --t_max_diff 0.1 --save_result ${result_file}  --save_plot ${trajectory_folder}res_ape-${SLAM_name}_${bag}.pdf

    table_file="${trajectory_folder}res_ape-${SLAM_name}_${bag}.csv"
    evo_res ${result_file} --save_table ${table_file}
    echo "-->saved table to: ${table_file}"


    # rpe
    result_file="${trajectory_folder}res_rpe-${SLAM_name}_${bag}.zip"
    evo_rpe tum ${gt_file} ${slam_file} --project_to_plane xy  -a --t_max_diff 0.1 --save_result ${result_file}  --save_plot ${trajectory_folder}res_rpe-${SLAM_name}_${bag}.pdf

    table_file="${trajectory_folder}res_rpe-${SLAM_name}_${bag}.csv"
    evo_res ${result_file} --save_table ${table_file}
    echo "-->saved table to: ${table_file}"


    # #rot
    # result_file="${trajectory_folder}res_rpe-rot-10m-${SLAM_name}_${bag}.zip"
    # evo_rpe tum ${gt_file} ${slam_file} -a --pose_relation angle_rad --t_max_diff=1 --delta 1 --delta_unit m --save_result ${result_file}  --save_plot ${trajectory_folder}res_rpe-rot-10m-${SLAM_name}_${bag}.pdf
    # echo "-->saved result to: ${result_file}"

    # table_file="${trajectory_folder}res_rpe-rot-10m-${SLAM_name}_${bag}.csv"
    # evo_res ${result_file} --save_table ${table_file}
    # echo "-->saved table to: ${table_file}"


    # save plot
    # evo_traj tum --ref gt_$bag.txt fastlio_$bag.txt pointlio_$bag.txt liolivox_$bag.txt liolivox_$bag.txt -p -a --t_max_diff 0.1 --n_to_align 300 --plot_mode xy --save_plot $bag.pdf


done 
