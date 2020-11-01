#import <Kiwi/Kiwi.h>
#import <Nocilla/Nocilla.h>
SPEC_BEGIN(LSDataMatcherSpec)
__block LSMatcher *matcher = nil;
__block NSData *data = nil;
beforeEach(^{
    const char bytes[] = { 0xF1, 0x00, 0xFF };
    data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    matcher = [data matcher];
});

context(@"when both data are equal", ^{
    it(@"matches", ^{
//        [[theBlock(^{
//            [matcher matchesData:[data copy]];
//        }) should] bytes];
        [[theValue([matcher matchesData:[data copy]]) should] beYes];
    });
});

context(@"when both data are different", ^{
    it(@"does not match", ^{
        const char other_bytes[] = {  0xA1, 0x00, 0xAF };
        NSData *other_data = [NSData dataWithBytes:other_bytes length:sizeof(other_bytes)];
        [[theValue([matcher matchesData:other_data]) should] beNo];
    });
});
describe(@"isEqual:", ^{
    it(@"is equal to another data matcher with the same data", ^{
        LSMatcher *matcherA =  [[@"same" dataUsingEncoding:NSUTF8StringEncoding] matcher];
        LSMatcher *matcherB = [[@"same" dataUsingEncoding:NSUTF8StringEncoding] matcher];

        [[matcherA should] equal:matcherB];
    });

    it(@"is not equal to another data matcher with a different data", ^{
        LSMatcher *matcherA =  [[@"omg" dataUsingEncoding:NSUTF8StringEncoding] matcher];
        LSMatcher *matcherB = [[@"different" dataUsingEncoding:NSUTF8StringEncoding] matcher];
        [[matcherA shouldNot] equal:matcherB];
    });
});
SPEC_END
