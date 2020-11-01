#import <Kiwi/Kiwi.h>
#import <Nocilla/Nocilla.h>
#import <AFNetworking/AFNetworking.h>
SPEC_BEGIN(AFNetworkingStubbingSpec)
beforeEach(^{
    [[LSNocilla sharedInstance] start];
});
afterEach(^{
    [[LSNocilla sharedInstance] stop];
    [[LSNocilla sharedInstance] clearStubs];
});
context(@"AFNetworking", ^{
    it(@"should stub the request", ^{
        stubRequest(@"POST", @"https://example.com/say-hello").
        withHeader(@"Content-Type", @"text/plain").
        withHeader(@"X-MY-AWESOME-HEADER", @"sisisi").
        withBody(@"Adios!").
        andReturn(200).
        withHeader(@"Content-Type", @"text/plain").
        withBody(@"hola");
        
        NSURL *url = [NSURL URLWithString:@"https://example.com/say-hello"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"sisisi" forHTTPHeaderField:@"X-MY-AWESOME-HEADER"];
        [request setHTTPBody:[@"Adios!" dataUsingEncoding:NSASCIIStringEncoding]];
        AFHTTPRequestSerializer *operation = [[AFHTTPRequestSerializer alloc]init];
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//        [operation start];
//
        
//        [operation waitUntilFinished];
//
//        [operation.error shouldBeNil];
//        [[operation.responseString should] equal:@"hola"];
//        [[theValue(operation.response.statusCode) should] equal:theValue(200)];
//        [[[operation.response.allHeaderFields objectForKey:@"Content-Type"] should] equal:@"text/plain"];
    });
    
});


SPEC_END
