//
//  ViewCtrlTabMap.m
//  KeysToHana
//
//  Created by Prince on 10/25/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "ViewCtrlTabMap.h"

@interface ViewCtrlTabMap () <MKMapViewDelegate, CLLocationManagerDelegate, AVAudioPlayerDelegate, UIAlertViewDelegate> {
    
    IBOutlet MKMapView *        _mapView;
    IBOutlet UIButton *         _btnPlay;
    
    
    CLLocationManager *         _locationManager;
    CLLocation *                _curLocation;
    
    AVAudioPlayer *             _currentAudioPlayer;
    MdlGeofence *               _currentGeofence;
}

- (IBAction)onBtnPlay:(id)sender;

@end

@implementation ViewCtrlTabMap

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mapView.delegate = self;
    
    [self initLocation];
    [self setGeofencePoints];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - background functions -
- (void) initLocation {
    
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
        //[CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways
        ) {
        // Will open an confirm dialog to get user's approval
        [_locationManager requestWhenInUseAuthorization];
        //[_locationManager requestAlwaysAuthorization];
    } else {
        [_locationManager startUpdatingLocation]; //Will update location immediately
    }
    
    /*
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;  // kCLLocationAccuracyBestForNavigation  kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    
    if ([CLLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ) {
            // We never ask for authorization. Let's request it.
            [_locationManager requestWhenInUseAuthorization];
        } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
                   [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
            // We have authorization. Let's update location.
            [_locationManager startUpdatingLocation];
        } else {
            // If we are here we have no pormissions.
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No athorization"
                                                                message:@"Please, enable access to your location"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Open Settings", nil];
            [alertView show];
        }
    } else {
        // This is iOS 7 case.
        [_locationManager startUpdatingLocation];
    }
     */
}

- (void)setGeofencePoints {
    
    for (MdlGeofence* tempGeo in [[TestData getInstance] SampleGeofences]) {
        
        NSArray* tempArray = tempGeo.m_location;
        
        CLLocationCoordinate2D tempLoc = CLLocationCoordinate2DMake([[tempArray objectAtIndex:0] floatValue], [[tempArray objectAtIndex:1] floatValue]);
        
        MKCircle* circle = [MKCircle circleWithCenterCoordinate:tempLoc radius: 1000];
        circle.title = @"Available Location";
        
        [_mapView addOverlay:circle];
    }
}

- (void)checkCurrentLocation {
    if (_curLocation == nil) {
        return;
    }
    
    for (MdlGeofence* tempGeo in [[TestData getInstance] SampleGeofences]) {
        
        NSArray* tempArray = tempGeo.m_location;
        
        CLLocationCoordinate2D tempCoordinat = CLLocationCoordinate2DMake([[tempArray objectAtIndex:0] floatValue], [[tempArray objectAtIndex:1] floatValue]);
        CLLocation * tempLoc = [[CLLocation alloc] initWithLatitude:tempCoordinat.latitude longitude:tempCoordinat.longitude];
        
        CLLocationDistance distance = [tempLoc distanceFromLocation:_curLocation];
        
        if (distance < 100 || true) {  // To test
            
            _currentGeofence = tempGeo;
            
            if (_currentAudioPlayer == nil) {
                NSMutableArray* temp = [[TestData getInstance] SampleAudioFiles];
                MdlMusic* tempMusic = [temp firstObject];
                _currentAudioPlayer = [tempMusic createAudioPlayer:self];
                
                [_currentAudioPlayer play];
                
                [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Congratulations! You have arrived %@. \n Will you go into the detail screen?", _currentGeofence.m_title] message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] show];
            }
            
            _btnPlay.hidden = false;
            
        } else {
            if (_currentAudioPlayer != nil) {
                if ([_currentAudioPlayer isPlaying]) {
                    [_currentAudioPlayer stop];
                }
            }
            _currentAudioPlayer = nil;
            
            _btnPlay.hidden = true;
        }
    }
}

#pragma mark - MapView overlay delegate -
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
    MKCircle* circle = overlay;
    MKCircleView* circleView = [[MKCircleView alloc] initWithCircle:overlay];
    circleView.fillColor = [UIColor redColor];
    circleView.alpha = 1.0f;
    circleView.strokeColor = [UIColor redColor];
    circleView.lineWidth = 10.0f;
    
    return circleView;
}

#pragma mark - location manager delegate -
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    _curLocation = newLocation;
    
    if (newLocation.horizontalAccuracy <= 20 && newLocation.verticalAccuracy <= 20) {
        //  globData.curLocation = newLocation;
        //  [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"horizontal - %f,\n verical - %f", newLocation.horizontalAccuracy,newLocation.verticalAccuracy ] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
    
    
    /*
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark* placeMark = [placemarks objectAtIndex:0];
            NSLog(@"\nCurrent Location Decected\n");
            NSLog(@"placemark %@", placeMark);
            NSString* locateAt = [[placeMark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            NSString* address = [[NSString alloc] initWithString:locateAt];
            NSString* area = [[NSString alloc] initWithString:placeMark.locality];
            
            NSString* postCode = @"";
            if (placeMark.postalCode != nil) {
                postCode = [[NSString alloc] initWithString:placeMark.postalCode];
            }
            
            NSString* country = placeMark.administrativeArea;//[[NSString alloc] initWithString:placeMark.country];
            NSString* countArea = [NSString stringWithFormat:@"%@, %@ %@", area, country, postCode];
            
            NSLog(@"%@", countArea);
            
            
            NSArray* array = [address componentsSeparatedByString:@","];
            
            
            
        } else {
            NSLog(@"Geocode failed with error %@", error);
            NSLog(@"\n Current Location Not Detected \n");
        }
    }];
    */
    
    [self checkCurrentLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"Location manager did fail with error %@", error);
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [manager startUpdatingLocation];
    }
}

#pragma mark - AVAudioPlayer delegate -
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
}

#pragma mark - UIAlertView delegate -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) { // Cancel
        
        
    } else {
        
        [self.tabBarController setSelectedIndex:1];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Action delegate -
- (IBAction)onBtnPlay:(id)sender {
    if ([_currentAudioPlayer isPlaying]) {
        [_currentAudioPlayer pause];
        
        [_btnPlay setTitle:@"Play" forState:UIControlStateNormal];
    } else {
        [_currentAudioPlayer play];
        
        [_btnPlay setTitle:@"Pause" forState:UIControlStateNormal];
    }
}
@end
