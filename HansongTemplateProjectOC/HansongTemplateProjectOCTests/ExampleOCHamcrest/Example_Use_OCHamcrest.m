//
//  Example_Use_OCHamcrest.m
//  HansongTemplateProjectOCTests
//
//  Created by hansong on 10/31/20.
//

#import <XCTest/XCTest.h>
#import "IsGivenDayOfWeek.h"
#import "SceneDelegate.h"
@import OCHamcrest;
/// 使用OCHamcrest示例
@import  XCTest;
@interface Example_Use_OCHamcrest : XCTestCase

@end

@implementation Example_Use_OCHamcrest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self useObject];
    [self useNumber];
    [self useText];
    [self useLogic];
    [self useCollection];
    [self useDecorator];
}
#pragma mark -  Object
- (void)useObject{
//    conformsTo - match object that conforms to protocol
    
//    equalTo - match equal object
    
//    hasDescription - match object's -description
    
//    hasProperty - match return value of method with given name
    
//    instanceOf - match object type
    
//    isA - match object type precisely, no subclasses
    
//    nilValue, notNilValue - match nil, or not nil
    
//    sameInstance - match same object
    
//    throwsException - match block that throws an exception
    
//    HCArgumentCaptor - match anything, capturing all values
    
}
#pragma mark - Number
- (void)useNumber{
//    closeTo - match number close to a given value
    
//    greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo - match numeric ordering
    
//    isFalse - match zero
    
//    isTrue - match non-zero
}
#pragma mark - Text
- (void)useText{
//    containsSubstring - match part of a string
    
//    endsWith - match the end of a string
    
//    equalToIgnoringCase - match the complete string but ignore case
    
//    equalToIgnoringWhitespace - match the complete string but ignore extra whitespace
    
//    startsWith - match the beginning of a string
    
//    stringContainsInOrder, stringContainsInOrderIn - match parts of a string, in relative order
    
}
#pragma mark - Logic
- (void)useLogic{
//    allOf, allOfIn - "and" together all matchers
    
//    anyOf, anyOfIn - "or" together all matchers
    
//    anything - match anything (useful in composite matchers when you don't care about a particular value)
    
//    isNot - negate the matcher
}
#pragma mark - Collection
- (void)useCollection{
//    contains, containsIn - exactly match the entire collection
    
//    containsInAnyOrder, containsInAnyOrderIn - match the entire collection, but in any order
    
//    containsInRelativeOrder, containsInRelativeOrderIn - match collection containing items in relative order
    
//    everyItem - match if every item in a collection satisfies a given matcher
    
//    hasCount - match number of elements against another matcher
    
//    hasCountOf - match collection with given number of elements
    
//    hasEntries - match dictionary with key-value pairs in a dictionary
    
//    hasEntriesIn - match dictionary with key-value pairs in a list
    
//    hasEntry - match dictionary containing a key-value pair
    
//    hasItem - match if given item appears in the collection
    
//    hasItems, hasItemsIn - match if all given items appear in the collection, in any order
    
//    hasKey - match dictionary with a key
    
//    hasValue - match dictionary with a value
    
//    isEmpty - match empty collection
    
//    isIn - match when object is in given collection
    
//    onlyContains, onlyContainsIn - match if collection's items appear in given list
    
}
#pragma mark - Decorator
- (void)useDecorator{
//    describedAs - give the matcher a custom failure description

//    is - decorator to improve readability - see "Syntactic sugar" below
    NSDateComponents *dateCom = [[NSDateComponents alloc]init];
    dateCom.day = 26;
    dateCom.month = 4;
    dateCom.year = 2008;
    NSCalendar *gream = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gream dateFromComponents:dateCom];
    assertThat(date, is(onASaturday()));

    assertThat(@"xx", is(@"xx"));
    assertThat(@"yy", isNot(@"xx"));
    assertThat(@"i like cheese", containsSubstring(@"cheese"));
}
@end
