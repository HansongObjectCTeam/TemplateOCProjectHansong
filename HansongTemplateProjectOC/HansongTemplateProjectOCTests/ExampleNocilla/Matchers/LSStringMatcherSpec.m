#import <Kiwi/Kiwi.h>
#import <Nocilla/Nocilla.h>
SPEC_BEGIN(LSStringMatcherSpec)
__block LSMatcher *matcher = nil;
beforeEach(^{
    matcher = [@"foo" matcher];
});

context(@"when both strings are equal", ^{
    it(@"matches", ^{
        [[theValue([matcher matches:@"foo"]) should] beYes];
    });
});

context(@"when both strings are different", ^{
    it(@"does not match", ^{
        [[theValue([matcher matches:@"bar"]) should] beNo];
    });
});

describe(@"isEqual:", ^{
    it(@"is equal to another string matcher with the same string", ^{
        LSMatcher *matcherA = [@"some" matcher];
        LSMatcher *matcherB =[@"same" matcher];
        [[matcherA shouldNot] equal:matcherB];
    });

    it(@"is not equal to another string matcher with a different string", ^{
        LSMatcher *matcherA = [@"omg" matcher];
        LSMatcher *matcherB =[@"different" matcher];
        [[matcherA shouldNot] equal:matcherB];
    });
});
SPEC_END
