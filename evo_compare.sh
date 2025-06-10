#!/bin/bash

# give simulation folder, and file index
rosbag_name_file="/home/larry/data/3dof_street_0423/name.txt"       # ChangeIt!
trajectory_folder="/home/larry/data/3dof_street_0423/evo_compare/"

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

for bag in "${bags[@]}"; do

    # conda activate py36
    # conda activate py39
    
    gt_file="${trajectory_folder}gt_${bag}.txt"
    slam_file="${trajectory_folder}fastlio_${bag}.txt"

    # Output single compare result. For debug/test
    # evo_ape tum ${gt_file} ${slam_file} -a --t_max_diff=1 

    # Project to xy-plane
    evo_rpe tum ${gt_file} ${slam_file} -a --t_max_diff=1 --project_to_plane xy           # only works for py39 env.


    # result_file="${trajectory_folder}res-fastlio_${bag}.zip"
    # evo_ape tum ${gt_file} ${slam_file} -a --t_max_diff=1 --t_offset 0.5 --save_result ${result_file}
    # echo "-->saved result to: ${result_file}"

    # table_file="${trajectory_folder}res-fastlio_${bag}.csv"
    # evo_res ${result_file} --save_table ${table_file}
    # echo "-->saved table to: ${table_file}"

done 

