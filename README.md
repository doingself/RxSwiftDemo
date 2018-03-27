# RxSwift

[Rx](http://reactivex.io) 是 ReactiveX 的缩写，简单来说就是基于异步 Event（事件）序列的响应式编程。
Rx 可以简化异步编程方法，并提供更优雅的数据绑定。让我们可以时刻响应新的数据同时顺序地处理它们。

# RxSwiftDemo

## 集成 RxSwift

1. 把现有的 Rx.xcodeproj 拖拽至你的工程中
2. `工程` -> `General` -> `TARGETS` -> `Embedded Binaries` 项，把 iOS 版的 `RxSwift.framework`、`RxCocoa.framework` 添加进来
	+ `RxSwift` 只是基于 Swift 语言的 Rx 标准实现接口库，所以 RxSwift 里不包含任何 Cocoa 或者 UI 方面的类。
	+ `RxCocoa` 是基于 RxSwift 针对于 iOS 开发的一个库，它通过 Extension 的方法给原生的比如 UI 控件添加了 Rx 的特性，使得我们更容易订阅和响应这些控件的事件。
3. 在使用的地方 
```
import RxSwift
import RxCocoa
```




---

鸣谢

+ http://www.hangge.com/blog/cache/detail_1917.html