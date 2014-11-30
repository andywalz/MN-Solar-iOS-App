//
//  recordObjectConstructor.h
//  MN Solar App
//
//  Created by Chris Martin on 11/28/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface recordObjectConstructor : NSObject {
    NSString *category;
    NSString *name;
    NSString *address;
    NSString *lat;
    NSString *lng;
}

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;

+ (id)nameOfCategory:(NSString*)category name:(NSString*)name address:(NSString *)address lat:(NSString *)lat lng:(NSString *)lng;

@end
