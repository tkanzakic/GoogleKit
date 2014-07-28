//
//    Copyright (c) 2014 Max Sokolov (http://maxsokolov.net)
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "GKPlacesQuery.h"

static NSString *const kGKPlacesQueryNearbySearchURL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=%@";
static NSString *const kGKPlacesQueryTextSearchURL   = @"https://maps.googleapis.com/maps/api/place/textsearch/json?key=%@";
static NSString *const kGKPlacesQueryRadarSearchURL  = @"https://maps.googleapis.com/maps/api/place/radarsearch/json?key=%@";

@interface GKPlacesQuery ()

@property (nonatomic, strong) NSString *baseURL;

@end

@implementation GKPlacesQuery

- (id)init {
    
    self = [super init];
    if (self) {

        self.minprice = -1;
        self.maxprice = -1;
        self.radius = 1000;
        self.rankByDistance = YES;
    }
    return self;
}

#pragma mark - GKQueryProtocol

- (NSURL *)queryURL {

    NSMutableString *url = [NSMutableString stringWithFormat:self.baseURL, self.key];

    if (self.location.latitude != -1) {
        [url appendFormat:@"&location=%f,%f", self.location.latitude, self.location.longitude];
    }
    if (self.radius != 0) {
        [url appendFormat:@"&radius=%ld", self.radius];
    }
    if (self.rankByDistance) {
        [url appendString:@"&rankby=distance"];
    }
    else {
        [url appendString:@"&rankby=prominence"];
    }
    
    if (self.keyword) {
        [url appendFormat:@"&keyword=%@", self.keyword];
    }
    if (self.language) {
        [url appendFormat:@"&language=%@", self.language];
    }
    if (self.minprice != -1) {
        [url appendFormat:@"&minprice=%ld", self.minprice];
    }
    if (self.maxprice != -1) {
        [url appendFormat:@"&maxprice=%ld", self.maxprice];
    }
    if (self.name) {
        [url appendFormat:@"&name=%@", [self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    if (self.opennow) {
        [url appendString:@"&opennow=true"];
    }
    if (self.types) {
        [url appendFormat:@"&types=%@", [self.types componentsJoinedByString:@"|"]];
    }

    return [NSURL URLWithString:url];
}

- (void)handleQueryError:(NSDictionary *)response error:(NSError *)error {

    if (self.completionHandler)
        self.completionHandler(nil, error);
}

- (void)handleQueryResponse:(NSDictionary *)response {
    
    NSLog(@"%@", response);
    
    _pageToken = [response objectForKey:@"next_page_token"];
    
    NSArray *results = [response objectForKey:@"results"];
    NSMutableArray *places = [NSMutableArray array];

    for (NSDictionary *dictionary in results) {

        [places addObject:[[GKPlace alloc] initWithDictionary:dictionary]];
    }
    
    if (self.completionHandler)
        self.completionHandler(places, nil);
}

#pragma mark - Public methods

- (void)nearbySearch:(GKQueryCompletionBlock)completionHandler {

    _pageToken = nil;
    self.completionHandler = completionHandler;
    self.baseURL = kGKPlacesQueryNearbySearchURL;

    [self performQuery];
}

- (void)textSearch:(void (^)(NSArray *results, NSError *error))completionHandler {

    _pageToken = nil;
    self.completionHandler = completionHandler;
    self.baseURL = kGKPlacesQueryTextSearchURL;
    
    [self performQuery];
}

- (void)radarSearch:(GKQueryCompletionBlock)completionHandler {

    _pageToken = nil;
    self.completionHandler = completionHandler;
    self.baseURL = kGKPlacesQueryRadarSearchURL;

    [self performQuery];
}

- (BOOL)nextPage {
    
    if (!_pageToken) return NO;
    
    
    
    return YES;
}

@end