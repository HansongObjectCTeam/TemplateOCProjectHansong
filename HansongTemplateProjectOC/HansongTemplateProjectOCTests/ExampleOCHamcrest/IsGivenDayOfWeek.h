//
//  IsGivenDayOfWeek.h
//  HansongTemplateProjectOCTests
//
//  Created by hansong on 10/31/20.
//

#import <OCHamcrest/OCHamcrest.h>

NS_ASSUME_NONNULL_BEGIN

@interface IsGivenDayOfWeek : HCBaseMatcher
@property (nonatomic, readonly, assign) NSInteger dayOfWeek;  // Sunday is 1, Saturday is 7
- (instancetype)initWithDayOfWeek:(NSInteger)dayOfWeek;
@end

NS_ASSUME_NONNULL_END
FOUNDATION_EXPORT id _Nonnull onASaturday(void);
