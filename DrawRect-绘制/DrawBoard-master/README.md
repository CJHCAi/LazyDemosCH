# DrawBoard
iOS 画板的实现，具有颜色和线宽选择，橡皮、撤销和清屏功能
***
实现效果如图：<br>
![](https://github.com/nongchaozhe/DrawBoard/raw/master/gif/drawBoard.gif)  <br>
***
代码架构主要以MVC形式为主<br>
***
Modal<br>
* 包含color，width，path三个成员变量<br>

***
View<br>
 *  工具栏实现的基本思路:<br>
                      1、功能选择，颜色选择，线宽选择等，都是将不同选择的button添加到view上面，并且添加动作<br>
                      2、为了更高效循环添加button，动作响应根据tag来判断是哪个button，从而做出不同的响应<br>
                      3、功能选择动作响应：不同的button响应不同的block<br>
                      4、颜色和线宽响应：不同的button响应后设置颜色/线宽<br>
                      5、添加一个背景图片，当选择某一个button时，这个图片也会移动到该button上方（block来实现）<br>

 *  画板实现的基本思路:<br>
                    1、当touchesBegan时，创建路径，并将该点作为路径的起始点；<br>
                    2、当touchesMove时，不断在该路径上添加line，调用[self setNeedsDisplay]<br>
                    3、当touchesEnd时，将path作为modal的一个成员变量保存在modal中，此次的modal放在PathModalArray中，释放路径<br>
                    4、drawRect绘制路径时，不仅要画这次的路径，还要画之前的路径，就是遍历pathModalArray来调用<br>
                    5、撤销动作undoAction，即移除pathModalArray中的最后一个object，并且调用[self setNeedsDisplay]<br>
                    6、清屏动作clearAction，即移除pathModalArray中的所有object，并且调用[self setNeedsDisplay]<br>

***
Controller<br>
 *  控制器实现基本思路：<br>
 *  1、添加工具栏和画板<br>
    2、ToolView中block的定义，colorBlock，widthBlock就是设置drawView的color；eraseBlock就设置其lineWidth和lineColor的具体值；undoBlock，clearBlock调用DrawView的函数<br>




