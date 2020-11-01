#import <Kiwi/Kiwi.h>
#import <Nocilla/Nocilla.h>
SPEC_BEGIN(NSURLSessionStubbingSpec)
if(NSClassFromString(@"NSURLSession") == nil) return;
beforeEach(^{
    [[LSNocilla sharedInstance] start];
});
afterEach(^{
    [[LSNocilla sharedInstance] stop];
    [[LSNocilla sharedInstance] clearStubs];
});
it(@"stubs NSURLSessionDataTask", ^{
    stubRequest(@"GET", @"http://example.com")
    .andReturn(200)
    .withBody(@"this is a counter example.");
    __block BOOL done = NO;
    __block NSData *capturedData;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    NSURLSession *urlsession = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *datatask = [urlsession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        done = YES;
        capturedData = data;
    }];
    [datatask resume];


    [[expectFutureValue(theValue(done)) shouldEventually] beYes];
    [[[[NSString alloc] initWithData:capturedData encoding:NSUTF8StringEncoding] should] equal:@"this is a counter example."];
});
SPEC_END

