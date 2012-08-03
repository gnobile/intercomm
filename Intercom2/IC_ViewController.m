//
//  IC_ViewController.m
//  Intercom2
//
//  Created by Giorgio Nobile on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IC_ViewController.h"
#import <GameKit/GameKit.h>
#import <AVFoundation/AVFoundation.h>



@implementation IC_ViewController

@synthesize locManager, btnConnect, btnDisconnect, connected, disconnected, settings, text, settingViewController, currentSession, volume, speed;

GKPeerPickerController *picker;
NSString *recorderFilePath;
BOOL autoVolume;
AVAudioPlayer *audioPlayer;
NSString *velocita;

static IC_ViewController *shAccess = nil;

+ (IC_ViewController *) shared {
    if (!shAccess) {
        shAccess = [[IC_ViewController alloc] init];
    }
    return shAccess;
}


- (void)dealloc
{
    [super dealloc];
    if (currentSession) [currentSession release];
    [locManager release];
    [velocita release];
    [recorderFilePath release];
    [audioPlayer release];
    [picker release];
}

-(void)viewDidUnload 
{
    [super viewDidUnload];
    [locManager stopUpdatingLocation];
    self.locManager = nil;
    currentSession = nil;
    recorderFilePath = nil;
    audioPlayer = nil;
    velocita = nil;
    picker = nil;
    
}

- (void)viewDidLoad
{    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willResume:)
                                                 name:GKSessionErrorDomain
                                               object:nil];
    
    UIFont *textFont = [UIFont fontWithName:@"DigitaldreamSkewNarrow" size:31.0f];
    UIColor *theRedColor = [UIColor colorWithRed:170.0f/255.0f green:24.0f/255.0f blue:24.0f/255.0f alpha:1.0];
    text.text=[NSString stringWithFormat:@"%@", NSLocalizedString(@"mDisconnect", @"")];
    text.font = textFont;
    text.textColor = theRedColor;
    [connected setImage:[UIImage imageNamed:@"greenoff"]];
    [disconnected setImage:[UIImage imageNamed:@"redon"]];
    [btnConnect setImage:[UIImage imageNamed:@"buttonoff"] forState:UIControlStateNormal];
    [btnDisconnect setImage:[UIImage imageNamed:@"buttonon"] forState:UIControlStateNormal];
    [btnConnect setHidden:NO];
    [btnDisconnect setHidden:YES];
    [super viewDidLoad];
    
    
}


-(void)viewDidAppear:(BOOL)animated 

{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	autoVolume = [defaults boolForKey:kSpeedAuto];
    if (autoVolume == YES && (!self.locManager) ){
        NSLog(@"Attivo localizzazione speed");
        self.locManager = [[CLLocationManager alloc] init];
        //definisco delegate x accedere ai suoi metodi
        locManager.delegate = self;
        locManager.distanceFilter = 10.0f;
        locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [self.locManager startUpdatingLocation];
        NSLog(@"LocManager Startata");
    } else if (autoVolume == YES && (self.locManager) ){
        NSLog(@"Attivo localizzazione speed 2");
        locManager.delegate = nil;
        [locManager stopUpdatingLocation];
        self.locManager = nil;
        [locManager release];
        self.locManager = [[CLLocationManager alloc] init];
        //definisco delegate x accedere ai suoi metodi
        locManager.delegate = self;
        locManager.distanceFilter = 10.0f;
        locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [self.locManager startUpdatingLocation];
        NSLog(@"LocManager Startata 2");
    }
    
    if ((autoVolume == NO) && (locManager)){
        NSLog(@"Disattivo localizzazione speed");
        self.locManager.delegate = nil;
        [self.locManager stopUpdatingLocation];
        self.locManager = nil;
        [locManager release];
        NSLog(@"locManager Rimosso");
    }
    [super viewDidAppear:animated];
    
}

/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 return (interfaceOrientation != UIInterfaceOrientationPortrait);
 }*/

#pragma - PickerControllerDelegate

- (void)peerPickerController:(GKPeerPickerController *)picker 
              didConnectPeer:(NSString *)peerID 
                   toSession: (GKSession *) session {
    
    self.currentSession = session;
    session.delegate = self;
    session.available = YES;
    session.disconnectTimeout = 1.0;
    [session setDataReceiveHandler: self withContext:nil];
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];    
    
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
    
    picker.delegate = nil;
    [picker autorelease];
    
    [connected setImage:[UIImage imageNamed:@"greenoff"]];
    [disconnected setImage:[UIImage imageNamed:@"redon"]];
    [btnConnect setHidden:NO];
    [btnDisconnect setHidden:YES];
    UIFont *textFont = [UIFont fontWithName:@"DigitaldreamSkewNarrow" size:31.0f];
    UIColor *theRedColor = [UIColor colorWithRed:170.0f/255.0f green:24.0f/255.0f blue:24.0f/255.0f alpha:1.0];
    text.text=[NSString stringWithFormat:@"%@", NSLocalizedString(@"mDisconnect", @"")];
    text.font = textFont;
    text.textColor = theRedColor;
    
    
}

#pragma - GkSession

-(NSString *) participantID
{
    return currentSession.peerID;
}

-(void) voiceChatService:(GKVoiceChatService *) voiceChatService
                sendData:(NSData *) data
         toParticipantID:(NSString *)participantID {
    
    [currentSession sendData:data toPeers:
     [NSArray arrayWithObject:participantID] 
                withDataMode:GKSendDataReliable error:nil];
    
}

- (void)session:(GKSession *)session 
           peer:(NSString *)peerID 
 didChangeState:(GKPeerConnectionState)state {
    //da rivedere
    //
    
    switch (state)
    {
        case GKPeerStateUnavailable :
        case GKPeerStateConnecting :
            //da rivedere questo case
            
		case GKPeerStateAvailable:
        {
			[currentSession connectToPeer:peerID withTimeout:0];
			break;
        }
        case GKPeerStateConnected:
        {            

            NSString *audioLocal = [NSString stringWithFormat:@"%@", NSLocalizedString(@"beep", @"")];
            
            NSString *soundFilePath = [[NSBundle mainBundle] 
                                       pathForResource:audioLocal ofType:@"wav"];
            
            NSURL *fileURL = [[NSURL alloc] 
                              initFileURLWithPath: soundFilePath];
            
            AVAudioPlayer *audioPlayer =
            [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL 
                                                   error:nil];
            
            [fileURL release];
            [audioPlayer play];
            //Verificare se spacca
            //[audioPlayer release];
            
            NSError *error;
            AVAudioSession *audioSession = 
            [AVAudioSession sharedInstance];
            
            [audioSession setMode: AVAudioSessionModeVoiceChat error:NULL];

            
            if (![audioSession  
                  setCategory:AVAudioSessionCategoryPlayAndRecord 
                  error:&error]) {
                NSLog(@"Errore istanziando la categoria AVAudioSessionCategoryPlayAndRecord: %@", 
                      [error localizedDescription]);
            }
            
            if (![audioSession setActive: YES error: &error]) {
                NSLog(@"Errore attivando AudioSession: %@", 
                      [error description]);
            }
            
            [GKVoiceChatService defaultVoiceChatService].client = self;
            
            //---inizializzo voice chat
            if (![[GKVoiceChatService defaultVoiceChatService] 
                  startVoiceChatWithParticipantID:peerID error:&error]) {
                NSLog(@"Error starting startVoiceChatWithParticipantID: %@", 
                      [error userInfo]);
            }
            
            [connected setImage:[UIImage imageNamed:@"greenon"]];
            [disconnected setImage:[UIImage imageNamed:@"redoff"]];
            [btnConnect setHidden:YES];
            [btnDisconnect setHidden:NO];
            
            UIFont *textFont = [UIFont fontWithName:@"DigitaldreamSkewNarrow" size:31.0f];
            UIColor *theGreenColor = [UIColor colorWithRed:41.0f/255.0f green:170.0f/255.0f blue:24.0f/255.0f alpha:1.0];
            text.text=[NSString stringWithFormat:@"%@", NSLocalizedString(@"mConnect", @"")];
            text.font = textFont;
            text.textColor = theGreenColor;
            NSLog(@"Connesso in GKStateConnected");
                        
        } break;
            
        case GKPeerStateDisconnected:
        {
            [[GKVoiceChatService defaultVoiceChatService] 
             stopVoiceChatWithParticipantID:peerID];
            self.currentSession.delegate = nil;
            [currentSession setDataReceiveHandler:nil withContext:nil];
            [self.currentSession release];
            currentSession = nil;
            
            [connected setImage:[UIImage imageNamed:@"greenoff"]];
            [disconnected setImage:[UIImage imageNamed:@"redon"]];
            [btnConnect setHidden:NO];
            [btnDisconnect setHidden:YES];
            UIFont *textFont = [UIFont fontWithName:@"DigitaldreamSkewNarrow" size:31.0f];
            UIColor *theRedColor = [UIColor colorWithRed:170.0f/255.0f green:24.0f/255.0f blue:24.0f/255.0f alpha:1.0];
            text.text=[NSString stringWithFormat:@"%@", NSLocalizedString(@"mDisconnect", @"")];
            text.font = textFont;
            text.textColor = theRedColor;
            NSLog(@"Disconnesso in GKStateDisconnected");
        } break;
    }
}
//da rivedere questo metodo
- (void)session:(GKSession*) session didReceiveConnectionRequestFromPeer:(NSString*) peerID {
	
    [session acceptConnectionFromPeer:peerID error:nil];
}

- (void) receiveData:(NSData *)data 
            fromPeer:(NSString *)peer 
           inSession:(GKSession *)session 
             context:(void *)context {
    
    //---inizio la voice chat vera e propria---
    [[GKVoiceChatService defaultVoiceChatService] 
     receivedData:data fromParticipantID:peer];
    
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
    NSLog(@"connectionWithPeerFailed: %@", [error description]);
    
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error{
    
    NSLog(@"DidFailWithError: %@", [error description]);
    
}

#pragma Connessioni-Disconnessioni-Auto

-(IBAction) disconnectedToConnected:(id) sender{
    
    picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;  
    [picker show];    
    
}
-(IBAction) connectedToDisconnected:(id) sender {
    
    [self.currentSession disconnectFromAllPeers];
    //[self.currentSession release];
    [self.currentSession release];
    currentSession = nil;
    [connected setImage:[UIImage imageNamed:@"greenoff"]];
    [disconnected setImage:[UIImage imageNamed:@"redon"]];
    [btnConnect setHidden:NO];
    [btnDisconnect setHidden:YES];
    UIFont *textFont = [UIFont fontWithName:@"DigitaldreamSkewNarrow" size:31.0f];
    UIColor *theRedColor = [UIColor colorWithRed:170.0f/255.0f green:24.0f/255.0f blue:24.0f/255.0f alpha:1.0];
    text.text=[NSString stringWithFormat:@"%@", NSLocalizedString(@"mDisconnect", @"")];
    text.font = textFont;
    text.textColor = theRedColor;
    //Posso settarmi uno stato di disconnessione se premo il bottone
}

-(void)autoReconnect {
    if (currentSession) {
        currentSession.delegate = nil;
        //[self.currentSession release];
        [currentSession setDataReceiveHandler:nil withContext:nil];
        [currentSession release];
    }

        currentSession = [[GKSession alloc] initWithSessionID:@"com.loadingzero.Intercom" displayName:nil sessionMode:GKSessionModePeer];
        currentSession.delegate = self;
        currentSession.available = YES;
        currentSession.disconnectTimeout = 1.0;
        [currentSession setDataReceiveHandler: self withContext:nil];    
}


#pragma SettingsView
-(IBAction)settingPress:(id)sender {
    SettingsViewController *viewSet = [[SettingsViewController alloc] 
                                       initWithNibName:@"SettingsViewController" 
                                       bundle:[NSBundle mainBundle]];
    self.settingViewController = viewSet;
    [viewSet release];
    [[self navigationController] pushViewController:settingViewController animated:YES];
    settingViewController.navigationController.navigationBarHidden = NO;
    
    settingViewController.navigationItem.title=[NSString stringWithFormat:@"%@", NSLocalizedString(@"sTitolo", @"")];
    
    
    
}

#pragma Core Location

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    velocita = [[NSString alloc] initWithFormat:@"%3.0f", newLocation.speed];
    if ([velocita intValue] < 10){
        [GKVoiceChatService defaultVoiceChatService].remoteParticipantVolume = 0.4f; 
        NSLog(@"Velocita < 10");
        NSLog(@"Audio %f", [GKVoiceChatService defaultVoiceChatService].remoteParticipantVolume);
    }
    if (([velocita intValue] > 10) && ([velocita intValue] < 30)){
        [GKVoiceChatService defaultVoiceChatService].remoteParticipantVolume = 0.5f; 
        NSLog(@"Velocita > 10 < 30");
        NSLog(@"Audio %f", [GKVoiceChatService defaultVoiceChatService].remoteParticipantVolume);
    }
    if (([velocita intValue] > 30) && ([velocita intValue] < 60)){
        [GKVoiceChatService defaultVoiceChatService].remoteParticipantVolume = 0.6f;
        NSLog(@"Velocita > 30 < 60");
        NSLog(@"Audio %f", [GKVoiceChatService defaultVoiceChatService].remoteParticipantVolume);
    }
    if (([velocita intValue] > 60) && ([velocita intValue] < 80)){
        [GKVoiceChatService defaultVoiceChatService].remoteParticipantVolume = 0.7f; 
        NSLog(@"Velocita > 60 < 80");
        NSLog(@"Audio %f", [GKVoiceChatService defaultVoiceChatService].remoteParticipantVolume);
    }
    if (([velocita intValue] > 80) && ([velocita intValue] < 100)){
        [GKVoiceChatService defaultVoiceChatService].remoteParticipantVolume = 0.8f; 
        NSLog(@"Velocita > 80 < 100");
        NSLog(@"Audio %f", [GKVoiceChatService defaultVoiceChatService].remoteParticipantVolume);
    }
    if (([velocita intValue] > 100) && ([velocita intValue] < 120)){
        [GKVoiceChatService defaultVoiceChatService].remoteParticipantVolume = 0.9f; 
        NSLog(@"Velocita > 100 < 120");
        NSLog(@"Audio %f", [GKVoiceChatService defaultVoiceChatService].remoteParticipantVolume);
    }
    if ([velocita intValue] > 120){
        [GKVoiceChatService defaultVoiceChatService].remoteParticipantVolume = 1.0f; 
        NSLog(@"Velocita > 120");
        NSLog(@"Audio %f", [GKVoiceChatService defaultVoiceChatService].remoteParticipantVolume);
    }
    
    
}

- (void)locationManager: (CLLocationManager *)manager
	   didFailWithError: (NSError *)error {
	switch([error code])
	{
		case kCLErrorNetwork: // general, network-related error
		{
			NSLog(@"NTWK error");
		}
			break;
		case kCLErrorDenied:{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@" , NSLocalizedString(@"errkey", @"")] message:[NSString stringWithFormat:@"%@" , NSLocalizedString(@"denykey", @"")] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
		}
			break;
		default:
		{
			NSLog(@"Unkown Error");
		}
			break;
	}
}

#pragma BackgroundCheck

- (void)switchToBackgroundMode:(BOOL)background
{    
    if (background)
    {
        NSLog(@"Switch to background");
        if (autoVolume) {
            [locManager stopUpdatingLocation];
            [locManager startMonitoringSignificantLocationChanges];
            NSLog(@"start Significant Location Changes");
        }
    }
    else
    {
        NSLog(@"Switch to Foreground");
        if (autoVolume) {
            [locManager stopMonitoringSignificantLocationChanges];
            [locManager startUpdatingLocation];
            NSLog(@"start Location Update");
        }
    }
}

@end
