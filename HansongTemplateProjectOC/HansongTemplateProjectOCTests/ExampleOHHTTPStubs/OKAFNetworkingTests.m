//
//  OKAFNetworkingTests.m
//  HansongTemplateProjectOCTests
//
//  Created by hansong on 11/1/20.
//

#import <XCTest/XCTest.h>
#import <Availability.h>
#import "HTTPStubs.h"
#import "HTTPStubsResponse+JSON.h"
#import "AFHTTPSessionManager.h"
static const NSTimeInterval kResponseTimeMaxDelay = 2.5;

@interface OKAFNetworkingTests : XCTestCase

@end

@implementation OKAFNetworkingTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [HTTPStubs removeAllStubs];

}
-(void)test_AFHTTPRequestOperation_success
{
    static const NSTimeInterval kRequestTime = 0.05;
    static const NSTimeInterval kResponseTime = 0.1;
    NSData* expectedResponse = [NSStringFromSelector(_cmd) dataUsingEncoding:NSUTF8StringEncoding];
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
        return [[HTTPStubsResponse responseWithData:expectedResponse statusCode:200 headers:nil]
                requestTime:kRequestTime responseTime:kResponseTime];
    }];

    XCTestExpectation* expectation = [self expectationWithDescription:@"AFHTTPRequestOperation request finished"];

    NSURL *URL = [NSURL URLWithString:@"http://www.iana.org/domains/example/"];

    __block __strong id response = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:URL.absoluteString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        response = responseObject; // keep strong reference
        [expectation fulfill];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XCTFail(@"Unexpected network failure");
        [expectation fulfill];
        
    }];

    [self waitForExpectationsWithTimeout:kRequestTime+kResponseTime+kResponseTimeMaxDelay handler:nil];

    XCTAssertEqualObjects(response, expectedResponse, @"Unexpected data received");
}
-(void)test_AFHTTPRequestOperation_multiple_choices
{
    static const NSTimeInterval kRequestTime = 0.05;
    static const NSTimeInterval kResponseTime = 0.1;
    NSData* expectedResponse = [NSStringFromSelector(_cmd) dataUsingEncoding:NSUTF8StringEncoding];
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
        return [[HTTPStubsResponse responseWithData:expectedResponse statusCode:300 headers:@{@"Location":@"http://www.iana.org/domains/another/example"}]
                requestTime:kRequestTime responseTime:kResponseTime];
    }];

    XCTestExpectation* expectation = [self expectationWithDescription:@"AFHTTPRequestOperation request finished"];

    NSURL *URL = [NSURL URLWithString:@"http://www.iana.org/domains/example/"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPResponseSerializer* serializer = [AFHTTPResponseSerializer serializer];
    [serializer  setAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 101)]];
    [manager setResponseSerializer:serializer];

    __block __strong id response = nil;
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * (NSURLSession * session, NSURLSessionTask * task, NSURLResponse * response, NSURLRequest * request) {
        if (response == nil) {
            return request;
        }
        XCTFail(@"Unexpected redirect");
        return nil;
    }];

    [manager GET:URL.absoluteString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        response = responseObject; // keep strong reference
        [expectation fulfill];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        XCTFail(@"Unexpected network failure");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:kRequestTime+kResponseTime+kResponseTimeMaxDelay handler:nil];

    XCTAssertEqualObjects(response, expectedResponse, @"Unexpected data received");
}

-(void)test_AFHTTPRequestOperation_redirect
{
    static const NSTimeInterval kRequestTime = 0.05;
    static const NSTimeInterval kResponseTime = 0.1;

    NSURL* redirectURL = [NSURL URLWithString:@"https://httpbin.org/get"];
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
        return [[HTTPStubsResponse responseWithData:[NSData data] statusCode:302 headers:@{@"Location":redirectURL.absoluteString}]
                requestTime:kRequestTime responseTime:kResponseTime];
    }];

    XCTestExpectation* redirectExpectation = [self expectationWithDescription:@"AFHTTPRequestOperation request was redirected"];
    XCTestExpectation* expectation = [self expectationWithDescription:@"AFHTTPRequestOperation request finished"];

    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://httpbin.org/redirect/1"]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndex:302];
    [manager setResponseSerializer:serializer];

    __block __strong NSURL* url = nil;
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * (NSURLSession * session, NSURLSessionTask * task, NSURLResponse * response, NSURLRequest * request) {
        if (response == nil) {
            return request;
        }
        url = request.URL;
        [redirectExpectation fulfill];
        return nil;
    }];
    [manager GET:req.URL.absoluteString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        // Expect the 302 response when the redirection block returns nil (don't follow redirects)

        [expectation fulfill];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XCTFail(@"Unexpected network failure");
              [expectation fulfill];
    }];


    [self waitForExpectationsWithTimeout:kRequestTime+kResponseTime+kResponseTimeMaxDelay handler:nil];

    XCTAssertEqualObjects(url, redirectURL, @"Unexpected data received");
}
/*
 * In order to establish that test_AFHTTPRequestOperation_redirect was incorrect and needed fixing, I needed
 * to demonstrate identical behaviour--that is, returning the redirect response itself to the success block--
 * when running without the NSURLProtocol stubbing the request. The test below, if enabled, establishes this,
 * as it is identical to test_AFHTTPRequestOperation_redirect except that it does not stub the requests.
 */
#if 0
-(void)test_AFHTTPRequestOperation_redirect_baseline
{
    NSURL* redirectURL = [NSURL URLWithString:@"https://httpbin.org/get"];

    XCTestExpectation* redirectExpectation = [self expectationWithDescription:@"AFHTTPRequestOperation request was redirected"];
    XCTestExpectation* expectation = [self expectationWithDescription:@"AFHTTPRequestOperation request finished"];

    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://httpbin.org/redirect/1"]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndex:302];
    [manager setResponseSerializer:serializer];

    __block __strong NSURL* url = nil;
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * (NSURLSession * session, NSURLSessionTask * task, NSURLResponse * response, NSURLRequest * request) {
        if (response == nil) {
            return request;
        }
        url = request.URL;
        [redirectExpectation fulfill];
        return nil;
    }];

    [manager GET:req.URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        // Expect the 302 response when the redirection block returns nil (don't follow redirects)
        [expectation fulfill];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        XCTFail(@"Unexpected network failure");
        [expectation fulfill];
    }];

    // Allow a longer timeout as this test actually hits the network
    [self waitForExpectationsWithTimeout:10 handler:nil];

    XCTAssertEqualObjects(url, redirectURL, @"Unexpected data received");
}
#endif
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

//#import "AFHTTPSessionManager.h"
//
//@interface AFNetworkingTests (NSURLSession) @end
//@implementation AFNetworkingTests (NSURLSession)
//- (void)test_AFHTTPURLSessionCustom
//{
//    if ([NSURLSession class] && [NSURLSessionConfiguration class])
//    {
//        static const NSTimeInterval kRequestTime = 0.1;
//        static const NSTimeInterval kResponseTime = 0.2;
//        NSDictionary *expectedResponseDict = @{@"Success" : @"Yes"};
//
//        [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
//            return [request.URL.scheme isEqualToString:@"stubs"];
//        } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
//            return [[HTTPStubsResponse responseWithJSONObject:expectedResponseDict statusCode:200 headers:nil]
//                    requestTime:kRequestTime responseTime:kResponseTime];
//        }];
//
//        XCTestExpectation* expectation = [self expectationWithDescription:@"AFHTTPSessionManager request finished"];
//
//        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//        NSURL* baseURL = [NSURL URLWithString:@"stubs://stubs/"];
//        AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL
//                                                                        sessionConfiguration:sessionConfig];
//
//        __block __strong id response = nil;
//        [sessionManager GET:@"foo"
//                 parameters:nil
//                   progress:nil
//                    success:^(NSURLSessionDataTask *task, id responseObject) {
//                        response = responseObject; // keep strong reference
//                        [expectation fulfill];
//                    }
//                    failure:^(NSURLSessionDataTask *task, NSError *error) {
//                        XCTFail(@"Unexpected network failure");
//                        [expectation fulfill];
//                    }];
//
//        [self waitForExpectationsWithTimeout:kRequestTime+kResponseTime+kResponseTimeMaxDelay handler:nil];
//
//        XCTAssertEqualObjects(response, expectedResponseDict, @"Unexpected data received");
//    }
//    else
//    {
//        NSLog(@"/!\\ Test skipped because the NSURLSession class is not available on this OS version. Run the tests a target with a more recent OS.\n");
//    }
//}
//@end
