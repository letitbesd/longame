PlusNumUp
PostBox
SimpleGraphic
ToolTip
是继承Sprite的，starling化

ui的starling渲染
假设一个MC分多层，内有多个元件，考虑一帧的情况，从0到numChildren-1遍历child,一直碰到第N个child有名字，则把前面N-1个child
合并渲染成位图（便于starling，得有个位置-left,-top)，如果一直没有碰到有名字的child，整个弄成位图ok了。对于有名字的child，如果
有child标签指定其类型，则转换之进入下一个循环，否则按照对应类型转成starling的显示类型。注意层级排序就ok。

对于多帧的情况，类似于上，只是每到新的一帧，旧帧的所有元素都会被删除，添加新帧的元素，做个缓存，如果是旧帧有的东西，直接别删，拿来用好了