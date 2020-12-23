# Calculator

Calculator仿ios原生计算器，实现如下主要功能：  
1. 基本的加减乘除算法，可连续加减，并实时显示结果；同时可以改变正负号以及添加百分号。  
2. 使用AutoLayout对界面进行布局，横屏时加入更多计算功能，类似原生计算器，布局稳定。  

# 使用说明

1. 界面元素位于Main.storyboard中，包括竖屏时的界面以及横屏时需要加入的界面以及constrains。  
2. 基本的运算算法在CalculateMethod类中，与界面独立。  
