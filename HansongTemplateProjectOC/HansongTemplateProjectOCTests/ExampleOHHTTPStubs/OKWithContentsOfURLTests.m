//
//  OKWithContentsOfURLTests.m
//  HansongTemplateProjectOCTests
//
//  Created by hansong on 11/1/20.
//

#import <XCTest/XCTest.h>
#import "HTTPStubs.h"
@interface OKWithContentsOfURLTests : XCTestCase

@end
static const NSTimeInterval kResponseTimeMaxDelay = 2.5;
@implementation OKWithContentsOfURLTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [HTTPStubs removeAllStubs];

}
static const NSTimeInterval kRequestTime = 0.1;
static const NSTimeInterval kResponseTime = 0.5;
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
#pragma mark [NSString stringWithContentsOfURL:encoding:error:]
///////////////////////////////////////////////////////////////////////////////////

-(void)test_NSString_stringWithContentsOfURL_mainQueue
{
    NSString* testString = NSStringFromSelector(_cmd);

    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
        return [[HTTPStubsResponse responseWithData:[testString dataUsingEncoding:NSUTF8StringEncoding]
                                           statusCode:200
                                              headers:nil]
                requestTime:kRequestTime responseTime:kResponseTime];
    }];

    NSDate* startDate = [NSDate date];

    NSString* string = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.iana.org/domains/example/"]
                                            encoding:NSUTF8StringEncoding
                                               error:NULL];

    XCTAssertEqualObjects(string, testString, @"Invalid returned string");
    XCTAssertGreaterThan(-[startDate timeIntervalSinceNow], kResponseTime+kRequestTime, @"Invalid response time");
}

-(void)test_NSString_stringWithContentsOfURL_parallelQueue
{
    XCTestExpectation* expectation = [self expectationWithDescription:@"Synchronous download finished"];
    [[NSOperationQueue new] addOperationWithBlock:^{
        [self test_NSString_stringWithContentsOfURL_mainQueue];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:kRequestTime+kResponseTime+kResponseTimeMaxDelay handler:nil];
}

///////////////////////////////////////////////////////////////////////////////////
#pragma mark [NSData dataWithContentsOfURL:]
///////////////////////////////////////////////////////////////////////////////////

-(void)test_NSData_dataWithContentsOfURL_mainQueue
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

    NSDate* startDate = [NSDate date];

    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.iana.org/domains/example/"]];

    XCTAssertEqualObjects(data, testData, @"Invalid returned string");
    XCTAssertGreaterThan(-[startDate timeIntervalSinceNow], kRequestTime+kResponseTime, @"Invalid response time");
}

-(void)test_NSData_dataWithContentsOfURL_parallelQueue
{
    XCTestExpectation* expectation = [self expectationWithDescription:@"Synchronous download finished"];
    [[NSOperationQueue new] addOperationWithBlock:^{
        [self test_NSData_dataWithContentsOfURL_mainQueue];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:kRequestTime+kResponseTime+kResponseTimeMaxDelay handler:nil];
}
@end
