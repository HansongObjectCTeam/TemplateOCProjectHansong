//
//  Fixtures.h
//  HansongTemplateProjectOCTests
//
//  Created by hansong on 11/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Protocol <NSObject>
@end


@interface Foo :NSObject
- (void)fooMethod;
@end

@interface Bar : Foo
@end

@interface Baz : NSObject<Protocol>
+ (void)bazClassMethod;
- (void)bazInstanceMethod;
@end

NS_ASSUME_NONNULL_END
