//
//  CompilationTest1.m
//  HansongTemplateProjectOCTests
//
//  Created by hansong on 11/1/20.
//

#import <XCTest/XCTest.h>
#import "TestHelper.h"

static int example1Ran;

SpecBegin(_CompilationTest1)

describe(@"group", ^{
  it(@"example 1", ^{
    
      example1Ran ++;
      example1Ran = example1Ran + 1;
  });
});

SpecEnd

@interface CompilationTest1 : XCTestCase

@end

@implementation CompilationTest1
- (void)testSingleExample {
  example1Ran = 1;

    RunSpec(_CompilationTest1Spec);
//    assertEqual(example1Ran, 0);
    assertEqual(example1Ran, 1);
}


@end
