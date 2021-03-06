////
////  LSHTTPRequestDSLRepresentationSpec.m
////  HansongTemplateProjectOCTests
////
////  Created by hansong on 11/1/20.
////
//
//#import <XCTest/XCTest.h>
//
//@interface LSHTTPRequestDSLRepresentationSpec : XCTestCase
//
//@end
//
//@implementation LSHTTPRequestDSLRepresentationSpec
//
//- (void)setUp {
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//}
//
//- (void)tearDown {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//}
//
//- (void)testExample {
//    // This is an example of a functional test case.
//    // Use XCTAssert and related functions to verify your tests produce the correct results.
//}
//
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}
//
//@end

#import <Kiwi/Kiwi.h>
#import <Nocilla/Nocilla.h>

SPEC_BEGIN(LSHTTPRequestDSLRepresentationSpec)
describe(@"description", ^{
//    __block LSHTTPRequestDSLRepresentation *dsl = nil;
//    describe(@"a request with a GET method and url", ^{
//        beforeEach(^{
//            LSTestRequest *request = [[LSTestRequest alloc] initWithMethod:@"GET" url:@"http://www.google.com"];
//            dsl = [[LSHTTPRequestDSLRepresentation alloc] initWithRequest:request];
//        });
//        it(@"should return the DSL representation", ^{
//            [[[dsl description] should] equal:@"stubRequest(@\"GET\", @\"http://www.google.com\");"];
//        });
//    });
//    describe(@"a request with a POST method and a url", ^{
//        beforeEach(^{
//            LSTestRequest *request = [[LSTestRequest alloc] initWithMethod:@"POST" url:@"http://luissolano.com"];
//            dsl = [[LSHTTPRequestDSLRepresentation alloc] initWithRequest:request];
//
//        });
//        it(@"should return the DSL representation", ^{
//            [[[dsl description] should] equal:@"stubRequest(@\"POST\", @\"http://luissolano.com\");"];
//        });
//    });
//    describe(@"a request with one header", ^{
//        beforeEach(^{
//            LSTestRequest *request = [[LSTestRequest alloc] initWithMethod:@"POST" url:@"http://luissolano.com"];
//            [request setHeader:@"Accept" value:@"text/plain"];
//            dsl = [[LSHTTPRequestDSLRepresentation alloc] initWithRequest:request];
//        });
//        it(@"should return the DSL representation", ^{
//            [[[dsl description] should] equal:@"stubRequest(@\"POST\", @\"http://luissolano.com\").\nwithHeaders(@{ @\"Accept\": @\"text/plain\" });"];
//        });
//    });
//    describe(@"a request with 3 headers", ^{
//        beforeEach(^{
//            LSTestRequest *request = [[LSTestRequest alloc] initWithMethod:@"POST" url:@"http://luissolano.com"];
//            [request setHeader:@"Accept" value:@"text/plain"];
//            [request setHeader:@"Content-Length" value:@"18"];
//            [request setHeader:@"If-Match" value:@"a8fhw0dhasd03qn02"];
//            dsl = [[LSHTTPRequestDSLRepresentation alloc] initWithRequest:request];
//
//        });
//        it(@"should return the DSL representation", ^{
//            NSString *expected = @"stubRequest(@\"POST\", @\"http://luissolano.com\").\nwithHeaders(@{ @\"Accept\": @\"text/plain\", @\"Content-Length\": @\"18\", @\"If-Match\": @\"a8fhw0dhasd03qn02\" });";
//            [[[dsl description] should] equal:expected];
//        });
//    });
//    describe(@"when a header contains a double quoute", ^{
//        beforeEach(^{
//            LSTestRequest *request = [[LSTestRequest alloc] initWithMethod:@"POST" url:@"http://luissolano.com"];
//            [request setHeader:@"X-MY-HEADER" value:@"quote\"quoute"];
//            dsl = [[LSHTTPRequestDSLRepresentation alloc] initWithRequest:request];
//        });
//        it(@"should escape the result", ^{
//            [[[dsl description] should] equal:@"stubRequest(@\"POST\", @\"http://luissolano.com\").\nwithHeaders(@{ @\"X-MY-HEADER\": @\"quote\"quoute\" });"];
//        });
//    });
//    describe(@"a request with headers and body", ^{
//        beforeEach(^{
//            LSTestRequest *request = [[LSTestRequest alloc] initWithMethod:@"POST" url:@"http://luissolano.com"];
//            [request setHeader:@"Accept" value:@"text/plain"];
//            [request setHeader:@"Content-Length" value:@"18"];
//            [request setHeader:@"If-Match" value:@"a8fhw0dhasd03qn02"];
//            [request setBody:[@"The body of a request, yeah!" dataUsingEncoding:NSUTF8StringEncoding]];
//            dsl = [[LSHTTPRequestDSLRepresentation alloc] initWithRequest:request];
//
//        });
//        it(@"should return the DSL representation", ^{
//            NSString *expected = @"stubRequest(@\"POST\", @\"http://luissolano.com\").\nwithHeaders(@{ @\"Accept\": @\"text/plain\", @\"Content-Length\": @\"18\", @\"If-Match\": @\"a8fhw0dhasd03qn02\" }).\nwithBody(@\"The body of a request, yeah!\");";
//            [[[dsl description] should] equal:expected];
//        });
//    });
//    context(@"when the body contain double quotes", ^{
//        beforeEach(^{
//            LSTestRequest *request = [[LSTestRequest alloc] initWithMethod:@"POST" url:@"http://luissolano.com"];
//            [request setBody:[@"{\"text\":\"adios\"}" dataUsingEncoding:NSUTF8StringEncoding]];
//            dsl = [[LSHTTPRequestDSLRepresentation alloc] initWithRequest:request];
//        });
//        it(@"should return the DSL representation", ^{
//            NSString *expected = @"stubRequest(@\"POST\", @\"http://luissolano.com\").\nwithBody(@\"{\\\"text\\\":\\\"adios\\\"}\");";
//            [[[dsl description] should] equal:expected];
//        });
//    });
});
SPEC_END
