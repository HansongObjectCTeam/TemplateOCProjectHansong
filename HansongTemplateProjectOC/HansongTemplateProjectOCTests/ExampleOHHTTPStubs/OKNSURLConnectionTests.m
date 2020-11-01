//
//  OKNSURLConnectionTests.m
//  HansongTemplateProjectOCTests
//
//  Created by hansong on 11/1/20.
//
#import <Availability.h>
#import <XCTest/XCTest.h>
#import "HTTPStubs.h"



@interface OKNSURLConnectionTests : XCTestCase;@end
static const NSTimeInterval kResponseTimeMaxDelay = 2.5;
@implementation OKNSURLConnectionTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    [HTTPStubs removeAllStubs];
}
static const NSTimeInterval kRequestTime = 0.1;
static const NSTimeInterval kResponseTime = 0.5;

-(void)test_NSURLConnection_sendSyncronousRequest_mainQueue{
    NSData* testData = [NSStringFromSelector(_cmd) dataUsingEncoding:NSUTF8StringEncoding];

    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
        return [[HTTPStubsResponse responseWithData:testData
                                           statusCode:200
                                              headers:nil]
                requestTime:kRequestTime responseTime:kResponseTime];
    }];

    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.iana.org/domains/example/"]];
    NSDate* startDate = [NSDate date];

    NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:NULL error:NULL];

    XCTAssertEqualObjects(data, testData, @"Invalid data response");
    XCTAssertGreaterThan(-[startDate timeIntervalSinceNow], kRequestTime+kResponseTime, @"Invalid response time");
}

-(void)test_NSURLConnection_sendSyncronousRequest_parallelQueue
{
    XCTestExpectation* expectation = [self expectationWithDescription:@"Synchronous request completed"];
    [[NSOperationQueue new] addOperationWithBlock:^{
        [self test_NSURLConnection_sendSyncronousRequest_mainQueue];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:kRequestTime+kResponseTime+kResponseTimeMaxDelay handler:nil];
}
///////////////////////////////////////////////////////////////////////////////////
#pragma mark Single [NSURLConnection sendAsynchronousRequest:queue:completionHandler:]
///////////////////////////////////////////////////////////////////////////////////

-(void)_test_NSURLConnection_sendAsyncronousRequest_onOperationQueue:(NSOperationQueue*)queue
{
    NSData* testData = [NSStringFromSelector(_cmd) dataUsingEncoding:NSUTF8StringEncoding];

    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
        return [[HTTPStubsResponse responseWithData:testData
                                           statusCode:200
                                              headers:nil]
                requestTime:kRequestTime responseTime:kResponseTime];
    }];

    XCTestExpectation* expectation = [self expectationWithDescription:@"Asynchronous request finished"];

    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.iana.org/domains/example/"]];
    NSDate* startDate = [NSDate date];

    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse* resp, NSData* data, NSError* error)
     {
         XCTAssertEqualObjects(data, testData, @"Invalid data response");
         XCTAssertGreaterThan(-[startDate timeIntervalSinceNow], kRequestTime+kResponseTime, @"Invalid response time");

         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:kRequestTime+kResponseTime+kResponseTimeMaxDelay handler:nil];
}
-(void)test_NSURLConnection_sendAsyncronousRequest_mainQueue
{
    [self _test_NSURLConnection_sendAsyncronousRequest_onOperationQueue:NSOperationQueue.mainQueue];
}


-(void)test_NSURLConnection_sendAsyncronousRequest_parallelQueue
{
    [self _test_NSURLConnection_sendAsyncronousRequest_onOperationQueue:[NSOperationQueue new]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}
///////////////////////////////////////////////////////////////////////////////////
#pragma mark Multiple Parallel [NSURLConnection sendAsynchronousRequest:queue:completionHandler:]
///////////////////////////////////////////////////////////////////////////////////

-(void)_test_NSURLConnection_sendMultipleAsyncronousRequestsOnOperationQueue:(NSOperationQueue*)queue
{
    __block BOOL testFinished = NO;
    NSData* (^dataForRequest)(NSURLRequest*) = ^(NSURLRequest* req) {
        return [[NSString stringWithFormat:@"<Response for URL %@>",req.URL.absoluteString] dataUsingEncoding:NSUTF8StringEncoding];
    };

    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
        NSData* retData = dataForRequest(request);
        NSTimeInterval responseTime = [request.URL.lastPathComponent doubleValue];
        return [[HTTPStubsResponse responseWithData:retData
                                           statusCode:200
                                              headers:nil]
                requestTime:responseTime*.1 responseTime:responseTime];
    }];

    // Reusable code to send a request that will respond in the given response time
    void (^sendAsyncRequest)(NSTimeInterval) = ^(NSTimeInterval responseTime)
    {
        NSString* desc = [NSString stringWithFormat:@"Asynchronous request with response time %.f finished", responseTime];
        XCTestExpectation* expectation = [self expectationWithDescription:desc];

        NSString* urlString = [NSString stringWithFormat:@"http://dummyrequest/concurrent/time/%f",responseTime];
        NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//        [SenTestLog testLogWithFormat:@"== Sending request %@\n", req];
        NSDate* startDate = [NSDate date];
        [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse* resp, NSData* data, NSError* error)
         {
//             [SenTestLog testLogWithFormat:@"== Received response for request %@\n", req];
             XCTAssertEqualObjects(data, dataForRequest(req), @"Invalid data response");
             XCTAssertGreaterThan(-[startDate timeIntervalSinceNow], (responseTime*.1)+responseTime, @"Invalid response time");

             if (!testFinished) [expectation fulfill];
         }];
    };

    static NSTimeInterval time3 = 1.5, time2 = 1.0, time1 = 0.5;
    sendAsyncRequest(time3); // send this one first, should receive last
    sendAsyncRequest(time2); // send this one next, shoud receive 2nd
    sendAsyncRequest(time1); // send this one last, should receive first

    [self waitForExpectationsWithTimeout:MAX(time1,MAX(time2,time3))+kResponseTimeMaxDelay handler:nil];
    testFinished = YES;
}

-(void)test_NSURLConnection_sendMultipleAsyncronousRequests_mainQueue
{
    [self _test_NSURLConnection_sendMultipleAsyncronousRequestsOnOperationQueue:NSOperationQueue.mainQueue];
}

-(void)test_NSURLConnection_sendMultipleAsyncronousRequests_parallelQueue
{
    [self _test_NSURLConnection_sendMultipleAsyncronousRequestsOnOperationQueue:[NSOperationQueue new]];
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
