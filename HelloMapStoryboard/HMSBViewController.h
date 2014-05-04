#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface HMSBViewController : UIViewController <GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;

@end
