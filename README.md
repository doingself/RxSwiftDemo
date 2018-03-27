# RxSwift

[Rx](http://reactivex.io) 是 ReactiveX 的缩写，简单来说就是基于异步 Event（事件）序列的响应式编程。
Rx 可以简化异步编程方法，并提供更优雅的数据绑定。让我们可以时刻响应新的数据同时顺序地处理它们。

## Observable

`Observable<T>` 这个类就是 Rx 框架的基础，我们可以称它为可观察序列。它的作用就是可以异步地产生一系列的 Event（事件），即一个 Observable<T> 对象会随着时间推移不定期地发出 event(element : T) 这样一个东西。
还需要有一个 Observer（订阅者）来订阅 Observable<T> 不时发出的 Event。

### 初始化 Observable

+ `Observable<Int>.empty()` 创建一个空内容的 Observable 序列
+ `Observable<Int>.just(5)` 通过传入一个默认值来初始化
+ `Observable.of("A", "B", "C")` 接受可变数量的参数（必需要是同类型的）
+ `Observable.from(["A", "B", "C"])` 同 `of`
+ `Observable.range(start: 1, count: 5)` == `Observable.of(1,2,3,4,5)`
+ `Observable.generate(initialState: 0, condition: { $0 <= 10 }, iterate: { $0 + 2 })` == `of(0,2,4,6,8,10)`
+ `Observable.repeatElement(1)` 一个可以无限发出给定元素的 Event 的 Observable 序列（永不终止）。 
+ `Observable<Int>.never()` 一个永远不会发出 Event（也不会终止）的 Observable 序列
+ `Observable<Int>.error()` 一个不做任何操作，而是直接发送一个错误的 Observable 序列。
+ `create` 和 `deferred` 参数为 block
+ `Observable<Int>.interval(1, scheduler: MainScheduler.instance)` 每1秒发送一次，并且是在主线程（MainScheduler）发送。interval创建的 Observable 序列每隔一段设定的时间，会发出一个索引数的元素。而且它会一直发送下去。
+ `Observable<Int>.timer(5, scheduler: MainScheduler.instance)` 5秒种后发出唯一的一个元素0
+ `Observable<Int>.timer(5, period: 1, scheduler: MainScheduler.instance)` 延时5秒种后，每隔1秒钟发出一个元素





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