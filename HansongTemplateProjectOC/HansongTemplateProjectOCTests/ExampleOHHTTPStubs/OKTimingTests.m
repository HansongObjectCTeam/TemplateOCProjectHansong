//
//  OKTimingTests.m
//  HansongTemplateProjectOCTests
//
//  Created by hansong on 11/1/20.
//
#import <Availability.h>
#import <XCTest/XCTest.h>
#import "HTTPStubs.h"
@interface OKTimingTests : XCTestCase
{
    NSMutableData* _data;
    NSError* _error;
    XCTestExpectation* _connectionFinishedExpectation;

//    NSDate* _didReceiveResponseTS;
    NSDate* _didFinishLoadingTS;
}
@end

@implementation OKTimingTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _data = [NSMutableData new];
    _error = nil;
//    _didReceiveResponseTS = nil;
    _didFinishLoadingTS = nil;
    [HTTPStubs removeAllStubs];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data.length = 0U;
    // NOTE: This timing info is not reliable as Cocoa always calls the connection:didReceiveResponse: delegate method just before
    // calling the first "connection:didReceiveData:", even if the [id<NSURLProtocolClient> URLProtocol:didReceiveResponse:…] method was called way before. So we are not testing this
//    _didReceiveResponseTS = [NSDate date];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _error = error; // keep strong reference
    _didFinishLoadingTS = [NSDate date];
    [_connectionFinishedExpectation fulfill];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _didFinishLoadingTS = [NSDate date];
    [_connectionFinishedExpectation fulfill];
}


///////////////////////////////////////////////////////////////////////////////////////
static NSTimeInterval const kResponseTimeMaxDelay = 2.5;
static NSTimeInterval const kSecurityTimeout = 5.0;

-(void)_testWithData:(NSData*)stubData requestTime:(NSTimeInterval)requestTime responseTime:(NSTimeInterval)responseTime
{
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
        return [[HTTPStubsResponse responseWithData:stubData
                                           statusCode:200
                                              headers:nil]
                requestTime:requestTime responseTime:responseTime];
    }];

    _connectionFinishedExpectation = [self expectationWithDescription:@"NSURLConnection did finish (with error or success)"];

    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.iana.org/domains/example/"]];
    NSDate* startTS = [NSDate date];

    [NSURLConnection connectionWithRequest:req delegate:self];

    [self waitForExpectationsWithTimeout:requestTime+responseTime+kResponseTimeMaxDelay+kSecurityTimeout handler:nil];

    XCTAssertEqualObjects(_data, stubData, @"Invalid data response");

    XCTAssertGreaterThan([_didFinishLoadingTS timeIntervalSinceDate:startTS], requestTime + responseTime, @"Invalid response time");

    [NSThread sleepForTimeInterval:0.01]; // Time for the test to wrap it all (otherwise we may have "Test did not finish" warning)
}



-(void)test_RequestTime0_ResponseTime0
{
    NSData* testData = [NSStringFromSelector(_cmd) dataUsingEncoding:NSUTF8StringEncoding];
    [self _testWithData:testData requestTime:0 responseTime:0];
}

-(void)test_SmallDataLargeTime_CumulativeAlgorithm
{
    NSData* testData = [NSStringFromSelector(_cmd) dataUsingEncoding:NSUTF8StringEncoding];
    // 21 bytes in 23/4 of a second = 0.913042 byte per slot: we need to check that the cumulative algorithm works
    [self _testWithData:testData requestTime:0 responseTime:5.75];
}

-(void)test_RequestTime1_ResponseTime0
{
    NSData* testData = [NSStringFromSelector(_cmd) dataUsingEncoding:NSUTF8StringEncoding];
    [self _testWithData:testData requestTime:1 responseTime:0];
}

-(void)test_LongData_RequestTime1_ResponseTime5
{
    static NSUInteger const kDataLength = 1024;
    NSMutableData* testData = [NSMutableData dataWithCapacity:kDataLength];
    NSData* chunk = [[NSProcessInfo.processInfo globallyUniqueString] dataUsingEncoding:NSUTF8StringEncoding];
    while(testData.length<kDataLength)
    {
        [testData appendData:chunk];
    }
    [self _testWithData:testData requestTime:1 responseTime:5];
}

-(void)test_VeryLongData_RequestTime1_ResponseTime0
{
    static NSUInteger const kDataLength = 609792;
    NSMutableData* testData = [NSMutableData dataWithCapacity:kDataLength];
    NSData* chunk = [[NSProcessInfo.processInfo globallyUniqueString] dataUsingEncoding:NSUTF8StringEncoding];
    while(testData.length<kDataLength)
    {
        [testData appendData:chunk];
    }
    [self _testWithData:testData requestTime:1 responseTime:0];
}

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
