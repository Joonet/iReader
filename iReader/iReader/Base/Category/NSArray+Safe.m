//
//  NSArray+Safe.m
//  iReader
//
//  Created by zzyong on 2018/6/5.
//  Copyright © 2018年 zzyong. All rights reserved.
//

#import "NSArray+Safe.h"

@implementation NSArray (Safe)

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (DEBUG) {
        return [self objectAtIndex:index];
    } else {
        if (self.count > index) {
            return [self objectAtIndex:index];
        }
        return nil;
    }
}

@end

@implementation NSMutableArray (Safe)

- (void)safeAddObject:(id)anObject
{
    if (DEBUG) {
        [self addObject:anObject];
    } else {
        if (anObject) {
            [self addObject:anObject];
        }
    }
}

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (DEBUG) {
        [self insertObject:anObject atIndex:index];
    } else {
        if (anObject && self.count >= index) {
            [self insertObject:anObject atIndex:index];
        }
    }
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index
{
    if (DEBUG) {
        [self removeObjectAtIndex:index];
    } else {
        if (self.count > index) {
            [self removeObjectAtIndex:index];
        }
    }
}

- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (DEBUG) {
        [self replaceObjectAtIndex:index withObject:anObject];
    } else {
        if (anObject && self.count > index) {
            [self replaceObjectAtIndex:index withObject:anObject];
        }
    }
}

@end
