//
//  FakeTestCase.h
//  HansongTemplateProjectOCTests
//
//  Created by hansong on 11/1/20.
//
#import "TestHelper.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FakeTestCase : NSObject
- (void)recordFailureWithDescription:(NSString *)description
                              inFile:(NSString *)filename
                              atLine:(NSUInteger)lineNumber
                            expected:(BOOL)expected;
@end

NS_ASSUME_NONNULL_END
