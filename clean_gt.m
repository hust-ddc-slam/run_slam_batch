clc;clear;close all;

name = "gt_force-A90F10-2024.10.18.txt";
% Read the data from 'a.csv'
data = readtable(name);

% Extract the specified columns: 
% 'Timestamp', 'IMU_pos_x', 'IMU_pos_y', 'IMU_pos_z', 'IMU_qx', 'IMU_qy', 'IMU_qz', 'IMU_qw'
outputData = data(:, 1:8);

% Write the extracted data to 'output.csv' with space-separated values
writetable(outputData, name, 'Delimiter', ' ', 'WriteVariableNames', false);
