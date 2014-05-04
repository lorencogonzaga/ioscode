#import "HMSBViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "HMSBCustomInfoWindow.h"


@interface HMSBViewController () <GMSMapViewDelegate> 

@property (strong, nonatomic) UIView *displayedInfoWindow;
@property BOOL markerTapped;
@property BOOL idleAfterMovement;
@property BOOL cameraMoving;
@property UIWebView *pcWeb;


@property (strong, nonatomic) GMSMarker *currentlyTappedMarker;


@end

@implementation HMSBViewController {
    GMSMapView *mapView_;
}



- (void)viewDidLoad {
  [super viewDidLoad];
  
    self.markerTapped = NO;
    self.cameraMoving = NO;
    self.idleAfterMovement = NO;
    
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:-14.2400732
                                                            longitude:-53.1805017
                                                                 zoom:5];
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    GMSMarker *marker1 = [[GMSMarker alloc] init];
    marker1.position = CLLocationCoordinate2DMake(-18.911696, -48.232149);
    marker1.title = @"Ticket Disponível. CLique no link Ao lado para acessar seu Ticket";
    marker1.icon = [UIImage imageNamed:@"flag_icon"];
    marker1.map = self.mapView;
    
    GMSMarker *marker2 = [[GMSMarker alloc] init];
    marker2.position = CLLocationCoordinate2DMake(-18.917249, -48.284156);
    marker2.title = @"http://viamobil.com.br";
    marker2.map = self.mapView;
    
    
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;

    CLLocationCoordinate2D currentPosition = mapView_.myLocation.coordinate;
    [self.view addSubview:self.mapView];
    self.mapView.settings.myLocationButton = YES;
  }

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
   
    HMSBCustomInfoWindow *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
    infoWindow.name.text = @"Promocrata";
    infoWindow.address.text = @"Pass Disponível";
    infoWindow.photo.image = [UIImage imageNamed:@"promocrataIcon200Trans"];
    
       
    return infoWindow;
}


-(BOOL)prefersStatusBarHidden {
    return YES;

}

@end
