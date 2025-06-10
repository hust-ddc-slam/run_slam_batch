#!/bin/bash

# give simulation folder, and file index
rosbag_name_file="/media/larry/M2-SSD/0507-pitch10deg/compare/name-process.txt"       # ChangeIt!

# name-7KeyTest
# name-Fastlio-Liosam

trajectory_folder_base="/home/larry/chrono-paper/chrono_freq_amp_res/"
gt_folder="/media/larry/M2-SSD/0507-pitch10deg/compare/"

# SLAM_name="pointlio"
# SLAM_name="pointlio"
# SLAM_name="liomapping"
# SLAM_name="loam"
SLAM_name="cticp"
# SLAM_name="fastlio"


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




echo "------------------------------------------------"
echo "Start to compare evo"
echo "------------------------------------------------"

counter=1


# Outer loop to repeat the inner loop 4 times
for counter in {1..50}; do
    
    echo "---------- LOOP ${counter}   ------------------"

    trajectory_folder=${trajectory_folder_base}${SLAM_name}/${SLAM_name}_output${counter}/
    echo "--> trajectory_folder: $trajectory_folder"

    for bag in "${bags[@]}"; do

        # conda activate py36
        
        gt_file="${gt_folder}gt_${bag}.txt"
        slam_file="${trajectory_folder}${SLAM_name}_${bag}.txt"

        # Output single compare result. For debug/test
        # evo_ape tum ${gt_file} ${slam_file} -a --t_max_diff=1 

        #10m
        result_file="${trajectory_folder}res_rpe-trans-10m-${SLAM_name}_${bag}.zip"
        # evo_rpe tum ${gt_file} ${slam_file} -a --t_max_diff=1 --delta 10 --delta_unit m --save_result ${result_file}  --save_plot ${trajectory_folder}res_rpe-trans-10m-${SLAM_name}_${bag}.pdf
        evo_rpe tum ${gt_file} ${slam_file} -a --t_max_diff=1 --delta 10 --delta_unit m --save_result ${result_file}
        echo "-->saved result to: ${result_file}"

        table_file="${trajectory_folder}res_rpe-trans-10m-${SLAM_name}_${bag}.csv"
        evo_res ${result_file} --save_table ${table_file}
        echo "-->saved table to: ${table_file}"

        #10m
        result_file="${trajectory_folder}res_ape-trans-10m-${SLAM_name}_${bag}.zip"
        evo_ape tum ${gt_file} ${slam_file} -a --save_result ${result_file}

        table_file="${trajectory_folder}res_ape-trans-10m-${SLAM_name}_${bag}.csv"
        evo_res ${result_file} --save_table ${table_file}
        echo "-->saved table to: ${table_file}"

        # #rot
        # result_file="${trajectory_folder}res_rpe-rot-10m-${SLAM_name}_${bag}.zip"
        # evo_rpe tum ${gt_file} ${slam_file} -a --pose_relation angle_rad --t_max_diff=1 --delta 10 --delta_unit m --save_result ${result_file}  --save_plot ${trajectory_folder}res_rpe-rot-10m-${SLAM_name}_${bag}.pdf
        # echo "-->saved result to: ${result_file}"

        # table_file="${trajectory_folder}res_rpe-rot-10m-${SLAM_name}_${bag}.csv"
        # evo_res ${result_file} --save_table ${table_file}
        # echo "-->saved table to: ${table_file}"

    done 

done