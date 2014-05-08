//
//  JFViewController.m
//  JFMapViewExample
//
//  Created by Jonathan Field on 15/09/2013.
//  Copyright (c) 2013 Jonathan Field. All rights reserved.
//

#import "JFViewController.h"

@interface JFViewController ()

@end

@implementation JFViewController

NSString *const QQURL = @"http://www.quintenquestel.com/portals/0/images/json/capitals.json";

/*
 Establish MapView delegate
 Add the Gesture Recogniser to the Map
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.mapView setDelegate:self];
    [self addGestureRecogniserToMapView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self downloadAndParseJSONCities:^(NSArray *annotations) {
            
            [self.mapView addAnnotations:annotations];
            
        } :^(NSError *error) {
            
            NSLog(@"There was an error downloading annotations from the server %@",[error localizedDescription]);
            
        }];
        
    });
    
}


/*
 Add a Gesture Recogniser that determines when the user has pressed the map for more than 0.5 seconds
 When that action is detected, call a function to add a pin at that location
 */
- (void)addGestureRecogniserToMapView{
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(addPinToMap:)];
    lpgr.minimumPressDuration = 0.5; //
    [self.mapView addGestureRecognizer:lpgr];
    
}

/*
 Called from LongPress Gesture Recogniser, convert Screen X+Y to Longitude and Latitude then add a standard Pin at that Location.
 The pin has its Title and SubTitle set to Placeholder text, you can modify this as you wish, a good idea would be to run a Geocoding block and put the street address in the SubTitle.
 */
- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    JFMapAnnotation *toAdd = [[JFMapAnnotation alloc]init];
    
    toAdd.coordinate = touchMapCoordinate;
    toAdd.subtitle = @"Subtitle";
    toAdd.title = @"Title";
    

    
    [self.mapView addAnnotation:toAdd];
    
}

/*
 On the background thread, retrieve the Array of Annotations from the Server as a JSON Representation.
 */
- (IBAction)addCitiesToMap:(id)sender{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self downloadAndParseJSONCities:^(NSArray *annotations) {
            
            [self.mapView addAnnotations:annotations];
            
        } :^(NSError *error) {
            
            NSLog(@"There was an error downloading annotations from the server %@",[error localizedDescription]);
            
        }];
        

    });
    
}

/*
 Physically download the JSON files from the Server, call jsonToAnnotation function to convert the JSON objects in Objects that confirm to MKAnnotation
 Call relevant Completion or Failure Blocks
 */
- (void)downloadAndParseJSONCities:(void (^)(NSArray *))completionBlock :(void (^)(NSError *))failureBlock{
    
    NSURL *destinationUrl = [NSURL URLWithString:QQURL];
    NSLog(@"Will retrieve JSON Capitals from %@",destinationUrl);
    
        NSURLRequest *request = [NSURLRequest requestWithURL:destinationUrl];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Retrieved response from API \n %@",responseObject);
                completionBlock([self jsonToAnnotation:(NSMutableArray *)responseObject]);
            }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error while performing API Retrieval Request \n%@\n%@",[error localizedDescription],[error localizedFailureReason]);
                  failureBlock(error);
                  }];
        [[NSOperationQueue mainQueue] addOperation:op];
}

- (NSMutableArray *)jsonToAnnotation:(NSMutableArray *)json{
    NSMutableArray *retval = [[NSMutableArray alloc]initWithCapacity:[json count]];
    for (JFMapAnnotation *record in json) {
        
        JFMapAnnotation *temp = [[JFMapAnnotation alloc]init];
        [temp setTitle:[record valueForKey:@"Capital"]];
        [temp setSubtitle:[record valueForKey:@"Country"]];
        [temp setCoordinate:CLLocationCoordinate2DMake([[record valueForKey:@"Latitude"]floatValue], [[record valueForKey:@"Longitude"]floatValue])];
        [retval addObject:temp];
        
        
           
    }
    return retval;
}
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *mapPin = nil;
    if(annotation != map.userLocation)
    {
        static NSString *defaultPinID = @"defaultPin";
        mapPin = (MKPinAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (mapPin == nil )
            mapPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        mapPin.canShowCallout = YES;
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        mapPin.rightCalloutAccessoryView = infoButton;
        
        
    }
    return mapPin;
    
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // here we illustrate how to detect which annotation type was clicked on for its callout
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[JFMapAnnotation class]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://apple.com"]];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
