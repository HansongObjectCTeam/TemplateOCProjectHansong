//
//  FakeTestCase.m
//  HansongTemplateProjectOCTests
//
//  Created by hansong on 11/1/20.
//

#import "FakeTestCase.h"

@implementation FakeTestCase
- (void)recordFailureWithDescription:(NSString *)description
                              inFile:(NSString *)filename
                              atLine:(NSUInteger)lineNumber
                            expected:(BOOL)expected{
    [NSException raise:description format:@""];
}
@end
