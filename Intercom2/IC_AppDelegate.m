//
//  IC_AppDelegate.m
//  Intercom2
//
//  Created by Giorgio Nobile on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IC_AppDelegate.h"
#import "IC_ViewController.h"
#import "Appirater.h"


@implementation IC_AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navigationController;
bool volumeAuto;

+ (IC_ViewController *)get {
    return (IC_ViewController *) [[UIApplication sharedApplication] delegate];
}


- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[IC_ViewController alloc] initWithNibName:@"IC_ViewController" bundle:nil] autorelease];
    navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    self.window.rootViewController = self.viewController;
    [navigationController setNavigationBarHidden:YES];
    
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    [Appirater appLaunched];
    splashView = [[UIImageView alloc] init];
    splashView.image = [UIImage imageNamed:@"Default"];
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];
    sleep(1);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"ResigneActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"DidEnterBackground");
    IC_ViewController *view = (IC_ViewController*) self.window.rootViewController;
    [view switchToBackgroundMode:YES];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"DidEnterForeground");
    IC_ViewController *view = (IC_ViewController*) self.window.rootViewController;
    [view switchToBackgroundMode:NO];


}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"DidBecomeActive");

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"Entrato in applicationWillTerminate");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	volumeAuto = [defaults boolForKey:kSpeedAuto];
    
    if (volumeAuto == YES) {
        [[IC_ViewController shared].locManager stopUpdatingLocation];
        [[IC_ViewController shared].locManager stopMonitoringSignificantLocationChanges];
        NSLog(@"Ho stoppato i servizi di localizzazione in quanto app terminata");
    }


}

@end
