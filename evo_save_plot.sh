#!/bin/bash

# Define datasets
datasets=(
    "yujiashan_collision1"
    "yujiashan_fast"
    "yujiashan_sharpturn1"
    "yujiashan_slow"
    "huxihe_lowspeed"
    "huxihe_midspeed"
    "huxihe5"
    "huxihe6"
    "huxihe7"
    "huxihe8"
    "dongjiu_collision1"
    "dongjiu_fast"
    "dongjiu_sharpturn1"
    "dongjiu_slow"
)

# Loop through each dataset and run evo_traj
for dataset in "${datasets[@]}"; do
    echo "Processing dataset: $dataset"
    evo_traj tum --ref "gt_${dataset}.txt" \
                 "fastlio_${dataset}.txt" \
                 "pointlio_${dataset}.txt" \
                 "liosam_${dataset}.txt" \
                 "liolivox_${dataset}.txt" \
                 --plot_mode xy --save_plot plot_${dataset}.pdf \
                 -p -a --t_max_diff 0.1 --n_to_align 300
    echo "----------------------------------"
done

echo "All 14 evo_traj commands executed!"