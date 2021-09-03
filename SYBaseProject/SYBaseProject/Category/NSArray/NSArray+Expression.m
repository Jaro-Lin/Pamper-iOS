//
//  NSArray+Expression.m
//  SYBaseProject
//
//  Created by sy on 2020/7/5.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "NSArray+Expression.h"

@implementation NSArray (Expression)

-(NSArray*)filterWithString:(NSString*)text{
    if(!text||text.length<=0)
    {
        return self;
    }
    NSString *searchText =   text;//searchController.searchBar.text;
    NSMutableArray *searchResults = [self mutableCopy];
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }

   // build all the "AND" expressions for each value in the searchString
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {

     NSMutableArray *searchItemsPredicate = [NSMutableArray array];

        NSExpression*lhs;
        NSExpression*rhs;
        NSPredicate*finalPredicate;
        {
            lhs = [NSExpression expressionForKeyPath:@"userName"];//名字
            rhs = [NSExpression expressionForConstantValue:searchString];
            finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        }

       {
            lhs = [NSExpression expressionForKeyPath:@"job"];//职位
            rhs = [NSExpression expressionForConstantValue:searchString];
            finalPredicate = [NSComparisonPredicate
                              predicateWithLeftExpression:lhs
                              rightExpression:rhs
                              modifier:NSDirectPredicateModifier
                              type:NSContainsPredicateOperatorType
                              options:NSCaseInsensitivePredicateOption];
            [searchItemsPredicate addObject:finalPredicate];
        }

       {
            lhs = [NSExpression expressionForKeyPath:@"upCompany"];//职位
            rhs = [NSExpression expressionForConstantValue:searchString];
            finalPredicate = [NSComparisonPredicate
                              predicateWithLeftExpression:lhs
                              rightExpression:rhs
                              modifier:NSDirectPredicateModifier
                              type:NSContainsPredicateOperatorType
                              options:NSCaseInsensitivePredicateOption];
            [searchItemsPredicate addObject:finalPredicate];
        }

        NSNumber*targetNumber=@([searchString integerValue]*100);
        if (targetNumber != nil&&targetNumber.integerValue!=0) {   // searchString may not convert to a number
            lhs = [NSExpression expressionForKeyPath:@"price"];
            rhs = [NSExpression expressionForConstantValue:targetNumber];
            finalPredicate = [NSComparisonPredicate
                              predicateWithLeftExpression:lhs
                              rightExpression:rhs
                              modifier:NSDirectPredicateModifier
                              type:NSEqualToPredicateOperatorType
                              options:NSCaseInsensitivePredicateOption];
            [searchItemsPredicate addObject:finalPredicate];
 }

 // at this OR predicate to our master AND predicate
  NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }

 // match up the fields of the Product object
    NSCompoundPredicate *finalCompoundPredicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];

    return searchResults;
}
- (NSArray*)filterPredicateContainsWithKeyWord:(NSString*)keyWord{
    
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"varieties_name contains %@",keyWord];
    return [self filteredArrayUsingPredicate:filterPredicate];
}

@end
