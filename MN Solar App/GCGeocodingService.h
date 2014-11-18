//
//  GCGeocodingService.h
//  MN Solar App
//
//  Created by Chris Martin on 11/18/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCGeocodingService : NSObject

-(id) init;
-(void) geocodeAddress:(NSString *)address;

@property (strong,nonatomic) NSDictionary *geocode;
@end
