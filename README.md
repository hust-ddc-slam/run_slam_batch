# run_slam_batch
SLAM算法运行、比较的一些批量化处理操作。具体包括：
1. 从chrono仿真程序的输出，打包rosbag的脚本：`create_bags_from_simulation`
2. 运行rosbag，并运行SLAM算法，并录制导出数据的脚本：`run_slam_batch`
3. 利用evo输出对比数据的脚本：`evo_compare`

---

## run_slam_batch
### 基本原理
使用`tmux`终端，创建一个session，先后创建多个窗口。  
对于每一个rosbag，依次执行：
1. 运行算法的launch文件
2. 新建一个pane，启动导出轨迹的ros程序
3. 新建一个pane，运行rosbag
4. 等待rosbag运行结束，并等待一小段时间，确保算法launch运行完成
5. 发布“导出轨迹ros程序”的停止指令，保存数据到指定路径
6. 结束这个session，自动退出所有pane


### 使用（算法配置者）
请每个人根据自己的虚拟机，配置这个运行脚本。具体如下：

1. 安装tmux
```bash
sudo apt install tmux
```
2. 下载轨迹导出代码: [trajectory_map_io](https://github.com/hust-ddc-slam/slam-utils/tree/main/trajectory_map_io)
3. 添加执行权限
```bash
sudo chmod 777 run_all.sh
```
4. 修改文件中的所有`ChangeIt`为自己的路径。
- `rosbag_name_file`: 该文件保存所有rosbag的名称，不带路径、不带.bag后缀
- `algorithm_prefix`: 所运行算法的前缀，所有输出的轨迹一律为：这个"{prefix}_{bag}.txt"，bag为`rosbag_name_file`中的命名
- `rosbag_folder`: 从这个路径下，加载`rosbag_name_file`文本中的所有rosbag，请确保路径存在，且路径末尾记得添加"/"
- `trajectory_output_folder`: 输出路径，在这个路径中输出所有的轨迹

> 除上述变量外，执行程序时，还需要每次source一下slam算法和数据导出程序的环境变量、运行相应的launch文件。  
由于这部分不涉及对外（其他调用的人）的接口，所以没有写变量，在脚本的#1和#2中需要自己修改。  
这样代码在第三者使用时，只需要修改变量部分，而不需要修改roslaunch部分的代码，实现了封装。

5. 修改等待时间  
由于有些算法运行的实时性较差，可能会在rosbag运行结束后，仍然没有结束运行。  
因此，需要在脚本中的第一个`sleep x`中修改x的值，确保算法的launch文件可以执行完成。

6. 注意事项  
由于脚本运行时所有原本launch的输出都被tmux放到了后台运行，因此看不到。   
所以配置时，请先正确配置自己的slam算法，然后测试一下rosbag运行结束后大概多久，能够完成launch。  
之后再修改脚本文件。


### 使用（算法调用者）
调用者只需要修改所有变量即可，理论上不需要修改内部脚本。


### 注意事项
- 代码运行时，只有脚本的输出，并没有原始slam算法的输出，因此需先确保slam算法可以正确执行。  
- 所有路径都应该存在。路径不存在时，不会输出最后结果，但脚本不会有任何提示。


---

## create_bags_from_simulation
从仿真数据路径，批量创建rosbag。同时拷贝gt文件。

### 使用
修改：
`simulation_data_folder`: 仿真数据的根路径  
`rosbag_output_folder`: 所有rosbag要输出的路径
`rosbag_name_file`: 保存了所有仿真数据名称的文件
以及脚本中，`create_rosbag`的工作路径，和launch文件的代码行。

脚本将从：`simulation_data_folder`路径下依次读取`rosbag_name_file`的每一行对应的路径，然后开始打包，输出rosbag到`rosbag_output_folder`路径，rosbag名称为`rosbag_name_file`中的名称。

注意：文件中每一行的名称 = 仿真数据的文件夹名 = 输出的rosbag（不带.bag）的文件名


---
## evo_compare



