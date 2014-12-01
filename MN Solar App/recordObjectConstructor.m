//
//  recordObjectConstructor.m
//  MN Solar App
//
//  Created by Chris Martin on 11/28/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "recordObjectConstructor.h"

@implementation recordObjectConstructor
@synthesize category;
@synthesize name;
@synthesize address;
@synthesize lat;
@synthesize lng;

+(id)nameOfCategory:(NSString *)category name:(NSString *)name address:(NSString *)address lat:(NSString *)lat lng:(NSString *)lng
{
    recordObjectConstructor *newRecord = [[self alloc]init];
    newRecord.category = category;
    newRecord.name = name;
    newRecord.address = address;
    newRecord.lat = lat;
    newRecord.lng = lng;
    return newRecord;
}

@end
