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
+ `Observable<Int>.timer(5, scheduler: MainScheduler.instance)` 延时5秒种后, 发出唯一的一个元素0
+ `Observable<Int>.timer(5, period: 2, scheduler: MainScheduler.instance)` 延时5秒种后，每隔2秒钟发出一个元素

### 订阅 Observable

+ `subscribe(_ on: @escaping (RxSwift.Event<Self.E>) -> Swift.Void) -> Disposable` 订阅了一个 Observable 对象，该方法的 block 的回调参数就是被发出的 event 事件
+ `subscribe(onNext: ((Self.E) -> Swift.Void)? = default, onError: ((Error) -> Swift.Void)? = default, onCompleted: (() -> Swift.Void)? = default, onDisposed: (() -> Swift.Void)? = default) -> Disposable` 可以只处理 onNext

### doOn 监听生命周期

一个 Observable 序列被创建出来后它不会马上就开始被激活从而发出 Event，而是要等到它被某个人订阅了才会激活它。激活之后要一直等到它发出了 .error 或者 .completed 的 event 后，它才被终结。

doOn 方法来监听事件的生命周期，它会在每一次事件发送前被调用。参数同subscribe

```
let obs = Observable.of(1,2,3)
        
obs.do(onNext: { (a) in
	    print("do onNext \(a)")
	}, onError: { (e) in
	    
	}, onCompleted: {
	    print("do onCompleted")
	}, onSubscribe: {
	    print("do onSubscribe")
	}, onSubscribed: {
	    print("do onSubscribed")
	}, onDispose: {
	    print("do onDispose")
	})
	.subscribe(onNext: { (element: Int) in
	    print("subscribe onNext \(element)")
	}, onError: { (err: Error) in
	    print(err)
	}, onCompleted: {
	    print("subscribe onCompleted")
	}, onDisposed: {
	    print("subscribe onDisposed")
	})
```

```
do onSubscribe
do onSubscribed
do onNext 1
subscribe onNext 1
do onNext 2
subscribe onNext 2
do onNext 3
subscribe onNext 3
do onCompleted
subscribe onCompleted
subscribe onDisposed
do onDispose
```

### Observable 的销毁

+ `sub.disposed(by: DisposeBag())` DisposeBag 来管理多个订阅行为的销毁
+ `sub.dispose()` 方法把这个订阅给销毁掉

## Observer 观察者

观察者（Observer）的作用就是监听事件，然后对这个事件做出响应。

### 创建观察者

http://www.hangge.com/blog/cache/detail_1941.html

+ `subscribe` + block
+ `bind` + block
+ `AnyObserver` + subscribe / bindTo
+ `Binder` + subscribe / bindTo

接下来,我已经开始看不懂了....😂😂😂😂


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