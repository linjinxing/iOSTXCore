//
//  NSObject+Persistence.m
//  SCar
//
//  Created by Mobo360 on 15/4/16.
//  Copyright (c) 2015年 mobo. All rights reserved.
//

#import "NSObject+Persistence.h"
#import "NSObject+Runtime.h"

//@implementation NSObject (Persistence)
//
//- (NSArray*)supprotProperties
//{
//	NSArray* supprotTypes = @[@"NSString", @"NSNumber", @"NSDate", @"NSData", @"NSArray", @"NSDictionary"];
//	unsigned count;
//	objc_property_t *properties = class_copyPropertyList([self class], &count);
//	
//	NSMutableArray *rv = [NSMutableArray array];
//	
//	unsigned i;
//	for (i = 0; i < count; i++)
//		{
//		objc_property_t property = properties[i];
//		NSString *name = [NSString stringWithUTF8String:property_getName(property)];
//		NSString *type = [NSString stringWithUTF8String:property_getAttributes(property)];
//		//		NSLog(@"name:%@, type:%@\n", name, [type substringBetweenStrings:@"T@\"" anotherString:@"\""]);
//		enum { MinObjectLength = 12};
//		if ([type length] >= MinObjectLength
//			&& [supprotTypes containsObject:[type substringBetweenStrings:@"T@\"" anotherString:@"\""]]) {
//			[rv addObject:name];
//		}
//		}
//	printf("\n\n\n");
//	free(properties);
//	[rv removeObjectsInArray:@[@"hash", @"superclass", @"description", @"debugDescription"]];
//	return [rv copy];
//}
//
//- (void)encodePropertiesWithCoder:(NSCoder *)aCoder
//{
//	[[self supprotProperties] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//		[aCoder encodeObject:[self valueForKey:obj] forKey:obj];
//	}];
//}
//
//- (void)decodePropertiesWithCoder:(NSCoder *)aCoder
//{
//	[[self supprotProperties] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//		[self setValue:[aCoder decodeObjectForKey:obj] forKey:obj];
//	}];
//}
//
//@end



