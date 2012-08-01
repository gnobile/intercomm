//
//  IC_ViewController.h
//  Intercom2
//
//  Created by Giorgio Nobile on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import <CoreLocation/CoreLocation.h> 
#import <GameKit/GameKit.h>
#import <AVFoundation/AVFoundation.h>


@interface IC_ViewController : UIViewController<CLLocationManagerDelegate, GKSessionDelegate,GKVoiceChatClient,GKPeerPickerControllerDelegate> {
    
    CLLocationManager	         *locManager; 
    IBOutlet UIImageView         *connected;
    IBOutlet UIImageView         *disconnected;
    IBOutlet UIButton            *settings;
    IBOutlet UIButton            *btnConnect;
    IBOutlet UIButton            *btnDisconnect;
    IBOutlet UILabel             *text;
    SettingsViewController *settingViewController;
    GKSession *currentSession;
    IBOutlet UILabel            *speed;
    IBOutlet UILabel            *volume;
    
    
}

@property (assign, nonatomic) CLLocationManager *locManager;
@property (nonatomic, retain) IBOutlet UIImageView *connected;
@property (nonatomic, retain) IBOutlet UIImageView *disconnected;
@property (nonatomic, retain) IBOutlet UIButton    *settings;
@property (nonatomic, retain) IBOutlet UIButton    *btnConnect;
@property (nonatomic, retain) IBOutlet UIButton    *btnDisconnect;
@property (nonatomic, retain) IBOutlet UILabel *text;
@property (nonatomic, retain) IBOutlet UILabel *speed;
@property (nonatomic, retain) IBOutlet UILabel *volume;
@property (nonatomic, retain)  SettingsViewController *settingViewController;
@property (nonatomic, retain) GKSession *currentSession;

+(IC_ViewController *)shared;

- (void)switchToBackgroundMode:(BOOL)background;

-(IBAction) disconnectedToConnected:(id) sender;
-(IBAction) connectedToDisconnected:(id) sender;
-(IBAction) settingPress:(id)sender;



@end
