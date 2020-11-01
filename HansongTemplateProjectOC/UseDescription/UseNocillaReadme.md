#  Nocilla 使用说明

Stunning HTTP stubbing for iOS and OS X. Testing HTTP requests has never been easier.

This library was inspired by WebMock and it's using this approach to stub the requests.


## 特点
* Stub HTTP and HTTPS requests in your unit tests. 单元测试中的存根HTTP和HTTPS请求。
* Supports NSURLConnection, NSURLSession and ASIHTTPRequest. 支持NSURLConnection，NSURLSession和ASIHTTPRequest。
* Awesome DSL that will improve the readability and maintainability of your tests. 出色的DSL，可提高测试的可读性和可维护性。
* Match requests with regular expressions. 使用正则表达式匹配请求。
* Stub requests with errors. 存根有错误的请求。
* Tested. 经过测试。
* Fast. 快速
* Extendable to support more HTTP libraries. 可扩展以支持更多的HTTP库


## 用途
matcher 匹配 （data，string，regex）
stubs 存根（request,response）




⚠️使用注意
##  matcher 需要注意的地方


案例中
```
__block LSDataMatcher *matcher = nil;
__block NSData *data = nil;

beforeEach(^{
    const char bytes[] = { 0xF1, 0x00, 0xFF };
    data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    matcher = [[LSDataMatcher alloc] initWithData:data];
});
```
使用时
```
__block LSMatcher *matcher = nil;
__block NSData *data = nil;
beforeEach(^{
    const char bytes[] = { 0xF1, 0x00, 0xFF };
    data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    matcher = [data matcher];
});

```
