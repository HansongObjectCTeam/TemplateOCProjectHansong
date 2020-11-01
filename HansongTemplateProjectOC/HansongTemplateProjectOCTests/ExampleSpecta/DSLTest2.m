//
//  DSLTest2.m
//  HansongTemplateProjectOCTests
//
//  Created by hansong on 11/1/20.
//

#import <XCTest/XCTest.h>
#import "TestHelper.h"
#import "SPTTestSuite.h"
#import "SPTExampleGroup.h"
#import "SPTExample.h"

static SPTVoidBlock
  block1 = ^{
      NSLog(@"as");
  }
, block2 = ^{
    NSLog(@"asd");
}
, block3 = ^{
    NSLog(@"asds");
}
, block4 = ^{
    NSLog(@"asdsd");
}
, block5 = ^{
    NSLog(@"asdsds");
}
, block6 = ^{
    NSLog(@"asdsdsd");
}
, block7 = ^{
    NSLog(@"asdsdsdd");
}
, block8 = ^{
    NSLog(@"asdsdsds");
}
;

SpecBegin(_DSLTest2)

describe(@"group", ^{
  beforeAll(block1);
  beforeEach(block2);
  afterEach(block3);
  afterAll(block4);
    
  beforeAll(block5);
  beforeEach(block6);
  afterEach(block7);
  afterAll(block8);
});

SpecEnd
@interface DSLTest2 : XCTestCase

@end

@implementation DSLTest2

- (void)testBeforeAndAfterHooks {
  SPTExampleGroup *rootGroup = [_DSLTest2Spec spt_testSuite].rootGroup;
  SPTExampleGroup *group = rootGroup.children[0];

  assertEqual([group.beforeAllArray count], 2);
  assertEqual([group.beforeEachArray count], 2);
  assertEqual([group.afterEachArray count], 2);
  assertEqual([group.afterAllArray count], 2);

  assertEqualObjects(group.beforeAllArray[0], block1);
  assertEqualObjects(group.beforeEachArray[0], block2);
  assertEqualObjects(group.afterEachArray[0], block3);
  assertEqualObjects(group.afterAllArray[0], block4);

  assertEqualObjects(group.beforeAllArray[1], block5);
  assertEqualObjects(group.beforeEachArray[1], block6);
  assertEqualObjects(group.afterEachArray[1], block7);
  assertEqualObjects(group.afterAllArray[1], block8);
}

@end
