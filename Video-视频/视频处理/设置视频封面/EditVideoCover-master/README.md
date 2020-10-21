### 仿抖音视频封面选择的demo

本Demo是用在学习抖音的项目[Alpface](https://github.com/alpface/alpface)中

原理：通过cover控件相对父控件frame的比例，计算出视频封面动图的起始和结束时间，并开启定时间监听视频播放的时间进度，当播放到封面结束时间时，将视频seek到封面的起始时间，以达到重复播放动图的效果。

<img src = "https://github.com/alpface/EditVideoCover/blob/master/EditVdeoCover/demo.gif?raw=true" width = "294" height = "640" alt = "demo.gif"/>

