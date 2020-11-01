#  Expecta

Expecta 是基于 Objective-C／Cocoa 的断言框架，XCTest 自带的断言 XCAssert 有好几个基础操作，不过基础的断言不太丰富，和 Specta 也没有很适配。 Expecta 不一样，将匹配过程从断言中剥离开，可以很好地适配 Specta 的 DSL 断言块。

## 特点

* 没有类型限制，比如数值 1，并不用关心它是整形还是浮点数
* 没有类型限制，比如数值 1，并不用关心它是整形还是浮点数
* 反向匹配，断言不匹配只需加上 .notTo 或者 .toNot，如：expect(x).notTo.equal(y)
* 延时匹配，可以在链式表达式中加入 .will、.willNot、.after(interval) 等操作来延时匹配
* 可扩展，支持增加自定义匹配

### 基础匹配 API：
```
expect(x).to.equal(y); // x 与 y 相等
expect(x).to.beIdenticalTo(y); // x 与 y 相等且内存地址相同
expect(x).to.beNil(); // x 为 nil
expect(x).to.beTruthy(); // x 为 true（非 0）
expect(x).to.beFalsy(); // x 为 false（0 值）

```
### 异步匹配
```
describe(@"WebImage", ^{
    beforeAll(^{
        // 设置默认延时匹配时间
        [Expecta setAsynchronousTestTimeout:2];
    });

    it(@"will not be nil", ^{
        //    使用默认延时匹配
        expect(webImage).willNot.beNil();
    });

    it(@"should equal 42 after 3 seconds", ^{
        // 不使用默认延时匹配，手动设置为3秒
        expect(webImage).after(3).to.equal(42);
    });
});

```
### 自定义使用
```
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import "ImageModel.h"

SpecBegin(ImageModel);

__block ImageModel *model;

beforeEach(^{
    model = [[ImageModel alloc] initWithUrl:@"http://pic37.nipic.com/20140113/8800276_184927469000_2.png" title:@"天空独角马" described:@"在黄色的沙漠里，特别突兀"];
});

it(@"should not nil", ^{
    expect(model).toNot.beNil();
});

it(@"equal", ^{
    expect(model.url).to.equal(@"http://pic37.nipic.com/20140113/8800276_184927469000_2.png");
    expect(model.title).to.equal(@"天空独角马");
    expect(model.described).to.equal(@"在黄色的沙漠里，特别突兀");
});

SpecEnd;

```
