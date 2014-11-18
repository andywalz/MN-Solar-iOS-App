//
//  GCGeocodingService.m
//  MN Solar App
//
//  Created by Chris Martin on 11/18/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "GCGeocodingService.h"

@interface GCGeocodingService ()

@end

@implementation GCGeocodingService

- (id) init{
    self = [super init];
    self.geocode = [[NSDictionary alloc] initWithObjectsAndKeys:@"0.0",@"lat",@"0.0",@"lng",@"Null Island",@"address", nil];
    return self;
}

- (void) geocodeAddress:(NSString *)address{
    NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
    NSString *url = [NSString stringWithFormat:@"%@address=%@&sensor=false", geocodingBaseUrl, address];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *queryUrl = [NSURL URLWithString:url];
    dispatch_sync(kBgqueue, ^{
        
        NSData *data = [NSData dataWithContentsofURL:queryUrl];
        
        [self fetchedData:data];
    });
}

// Callback
- (void) fetchedData:(NSData *) data {
    
    NSError* error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    NSArray *results = [json objectForKey:@"results"];
    
    // Grad first result
    NSDictionary *result = [results objectAtIndex:0];
    NSString *address = [result objectForKey:@"formatted_address"];
    NSDictionary *geometry = [result objectForKey:@"geometry"];
    NSDictionary *location = [geometry objectForKey:@"location"];
    NSString *lat = [location objectForKey:@"lat"];
    NSString *lng = [location objectForKey:@"lng"];
    
    NSDictionary *gc = [[NSDictionary alloc]initWithObjectsAndKeys:lat, @"lat", lng, @"lng", address, @"address", nil];
    
    self.geocode = gc;
    }

@end
