//
//  OKNilValuesTests.m
//  HansongTemplateProjectOCTests
//
//  Created by hansong on 11/1/20.
//

#import <XCTest/XCTest.h>
#import <Availability.h>
#import "HTTPStubs.h"
#import "HTTPStubsPathHelpers.h"
@interface OKNilValuesTests : XCTestCase

@end
static const NSTimeInterval kResponseTimeMaxDelay = 2.5;

@implementation OKNilValuesTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [HTTPStubs removeAllStubs];

}
- (void)test_NilData
{
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
        return [HTTPStubsResponse responseWithData:nil statusCode:400 headers:nil];
#pragma clang diagnostic pop
    }];

    XCTestExpectation* expectation = [self expectationWithDescription:@"Network request's completionHandler called"];

    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.iana.org/domains/example/"]];

    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* resp, NSData* data, NSError* error)
     {
         XCTAssertEqual(data.length, (NSUInteger)0, @"Data should be empty");

         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:kResponseTimeMaxDelay handler:nil];
}
- (void)test_EmptyData
{
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
        return [[HTTPStubsResponse responseWithData:[NSData data] statusCode:400 headers:nil]
                requestTime:0.01 responseTime:0.01];
    }];

    XCTestExpectation* expectation = [self expectationWithDescription:@"Network request's completionHandler called"];

    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.iana.org/domains/example/"]];

    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* resp, NSData* data, NSError* error)
     {
         XCTAssertEqual(data.length, (NSUInteger)0, @"Data should be empty");

         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:kResponseTimeMaxDelay handler:nil];
}
- (void)test_NilPath
{
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
        return [[HTTPStubsResponse responseWithFileAtPath:nil statusCode:501 headers:nil]
                requestTime:0.01 responseTime:0.01];
#pragma clang diagnostic pop
    }];

    XCTestExpectation* expectation = [self expectationWithDescription:@"Network request's completionHandler called"];

    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.iana.org/domains/example/"]];

    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* resp, NSData* data, NSError* error)
     {
         XCTAssertEqual(data.length, (NSUInteger)0, @"Data should be empty");

         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:kResponseTimeMaxDelay handler:nil];
}

- (void)test_NilPathWithURL
{
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
        return [[HTTPStubsResponse responseWithFileURL:nil statusCode:501 headers:nil]
                requestTime:0.01 responseTime:0.01];
#pragma clang diagnostic pop
    }];

    XCTestExpectation* expectation = [self expectationWithDescription:@"Network request's completionHandler called"];

    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.iana.org/domains/example/"]];

    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* resp, NSData* data, NSError* error)
     {
         XCTAssertEqual(data.length, (NSUInteger)0, @"Data should be empty");

         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:kResponseTimeMaxDelay handler:nil];
}
- (void)test_InvalidPath
{
    XCTAssertThrowsSpecificNamed([HTTPStubsResponse responseWithFileAtPath:@"foo/bar" statusCode:501 headers:nil]
                                 , NSException, NSInternalInconsistencyException, @"An exception should be thrown if a non-file URL is given");
}
- (void)test_InvalidPathWithURL
{
    NSURL *httpURL = [NSURL fileURLWithPath:@"foo/bar"];
    NSAssert(httpURL, @"If the URL is nil an empty response is sent instead of an exception being thrown");
    XCTAssertThrowsSpecificNamed([HTTPStubsResponse responseWithFileURL:httpURL statusCode:501 headers:nil]
                                 , NSException, NSInternalInconsistencyException, @"An exception should be thrown if a non-file URL is given");
}
- (void)test_NonFileURL
{
    NSURL *httpURL = [NSURL URLWithString:@"http://www.iana.org/domains/example/"];
    NSAssert(httpURL, @"If the URL is nil an empty response is sent instead of an exception being thrown");
    XCTAssertThrowsSpecificNamed([HTTPStubsResponse responseWithFileURL:httpURL statusCode:501 headers:nil]
                                 , NSException, NSInternalInconsistencyException, @"An exception should be thrown if a non-file URL is given");
}

- (void)test_EmptyFile
{
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
        NSString* emptyFile = OHPathForFile(@"emptyfile.json", self.class);
        return [[HTTPStubsResponse responseWithFileAtPath:emptyFile statusCode:500 headers:nil]
                requestTime:0.01 responseTime:0.01];
    }];

    XCTestExpectation* expectation = [self expectationWithDescription:@"Network request's completionHandler called"];

    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.iana.org/domains/example/"]];

    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* resp, NSData* data, NSError* error)
     {
         XCTAssertEqual(data.length, (NSUInteger)0, @"Data should be empty");

         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:kResponseTimeMaxDelay handler:nil];
}
- (void)test_EmptyFileWithURL
{
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
        NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"emptyfile" withExtension:@"json"];
        return [[HTTPStubsResponse responseWithFileURL:fileURL statusCode:500 headers:nil]
                requestTime:0.01 responseTime:0.01];
    }];

    XCTestExpectation* expectation = [self expectationWithDescription:@"Network request's completionHandler called"];

    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.iana.org/domains/example/"]];

    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* resp, NSData* data, NSError* error)
     {
         XCTAssertEqual(data.length, (NSUInteger)0, @"Data should be empty");

         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:kResponseTimeMaxDelay handler:nil];
}
- (void)_test_NilURLAndCookieHandlingEnabled:(BOOL)handleCookiesEnabled
{
    NSData* expectedResponse = [NSStringFromSelector(_cmd) dataUsingEncoding:NSUTF8StringEncoding];

    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^HTTPStubsResponse *(NSURLRequest *request) {
        return [HTTPStubsResponse responseWithData:expectedResponse
                                          statusCode:200
                                             headers:nil];
    }];

    XCTestExpectation* expectation = [self expectationWithDescription:@"Network request's completionHandler called"];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:nil];
#pragma clang diagnostic pop
    req.HTTPShouldHandleCookies = handleCookiesEnabled;

    __block NSData* response = nil;

    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* resp, NSData* data, NSError* error)
     {
         response = data;
         [expectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:kResponseTimeMaxDelay handler:nil];

    XCTAssertEqualObjects(response, expectedResponse, @"Unexpected data received");
}

- (void)test_NilURLAndCookieHandlingEnabled
{
    [self _test_NilURLAndCookieHandlingEnabled:YES];
}

- (void)test_NilURLAndCookieHandlingDisabled
{
    [self _test_NilURLAndCookieHandlingEnabled:NO];
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
