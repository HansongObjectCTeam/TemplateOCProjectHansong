//
//  IsGivenDayOfWeek.m
//  HansongTemplateProjectOCTests
//
//  Created by hansong on 10/31/20.
//

#import "IsGivenDayOfWeek.h"
static NSString* const dayAsString[] =
        { @"ZERO", @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday" };

@implementation IsGivenDayOfWeek
- (instancetype)initWithDayOfWeek:(NSInteger)dayOfWeek{
    self = [super init];
    if (self) {
        _dayOfWeek = dayOfWeek;
    }
    return self;
}
- (BOOL)matches:(id)item{
    if (![item isKindOfClass:[NSDate class]]) {
        return  NO;
    }
    NSCalendar *gregorianCalender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [gregorianCalender component:NSCalendarUnitWeekday fromDate:item]  == self.dayOfWeek;
}
- (void)describeTo:(id<HCDescription>)description{
    [[description appendText:@"date falling on"] appendText:dayAsString[self.dayOfWeek]];
}

@end
id onASaturday(){
    return [[IsGivenDayOfWeek alloc]initWithDayOfWeek:7];
}
