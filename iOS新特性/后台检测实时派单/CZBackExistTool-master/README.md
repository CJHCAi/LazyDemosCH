# SoundBackProject
后台长时间执行程序而不被杀死的Demo版【AppStore上架成功】

项目需求：当锁屏状态下需要监听是否有新的订单，然后唤醒手机进行一些逻辑.
那么就涉及到如何让app可以在后台更久的运行。


因为我们项目特殊用到这一块，属于打擦边球。不适用于所有项目。
解决方案：

使用的是： Long-running background task + 播放无声音乐 双重调起方法。

博客地址(简书)：

 http://www.jianshu.com/p/033b8a533e44
