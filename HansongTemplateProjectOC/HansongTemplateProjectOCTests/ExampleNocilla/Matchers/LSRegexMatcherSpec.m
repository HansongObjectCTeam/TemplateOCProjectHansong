#import <Kiwi/Kiwi.h>
#import <Nocilla/Nocilla.h>

SPEC_BEGIN(LSRegexMatcherSpec)
__block LSMatcher *matcher = nil;
beforeEach(^{
    matcher = [@"Fo+".regex matcher];
//    [[LSRegexMatcher alloc] initWithRegex:@"Fo+".regex];
});

context(@"when the string matches the regex", ^{
    it(@"matches", ^{
        [[theValue([matcher matches:@"Fo"]) should] beYes];
        [[theValue([matcher matches:@"Foo"]) should] beYes];
        [[theValue([matcher matches:@"Foooooo"]) should] beYes];
    });
});

context(@"when string does not match", ^{
    it(@"does not match", ^{
        [[theValue([matcher matches:@"fo"]) should] beNo];
        [[theValue([matcher matches:@"F"]) should] beNo];
        [[theValue([matcher matches:@"bar"]) should] beNo];
    });
});

describe(@"isEqual:", ^{
    it(@"is equal to another regex matcher with the same regex", ^{
        LSMatcher *matcherA = [@"([same]+)".regex matcher];
        LSMatcher *matcherB = [@"([same]+)".regex matcher];

        [[matcherA should] equal:matcherB];
    });

    it(@"is not equal to another regex matcher with a different regex", ^{
        LSMatcher *matcherA = [@"([omg]+)".regex matcher];
        LSMatcher *matcherB = [@"([different]+)".regex matcher];
        [[matcherA shouldNot] equal:matcherB];
    });
});
SPEC_END
