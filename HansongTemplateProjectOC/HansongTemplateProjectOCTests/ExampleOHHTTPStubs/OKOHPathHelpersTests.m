//
//  OKOHPathHelpersTests.m
//  HansongTemplateProjectOCTests
//
//  Created by hansong on 11/1/20.
//

#import <XCTest/XCTest.h>
#import "HTTPStubs.h"
#import "HTTPStubsPathHelpers.h"
@interface OKOHPathHelpersTests : XCTestCase

@end

@implementation OKOHPathHelpersTests

- (void)testOHResourceBundle {
    NSBundle *classBundle = [NSBundle bundleForClass:self.class];
    NSBundle *expectedBundle = [NSBundle bundleWithPath:[classBundle pathForResource:@"empty"
                                                                              ofType:@"bundle"]];

    XCTAssertEqual(OHResourceBundle(@"empty", self.class), expectedBundle);
}

@end
