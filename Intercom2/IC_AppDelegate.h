//
//  IC_AppDelegate.h
//  Intercom2
//
//  Created by Giorgio Nobile on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IC_ViewController;

@interface IC_AppDelegate : UIResponder <UIApplicationDelegate> {
    UIImageView *splashView;
        
}


@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) IC_ViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

+ (IC_ViewController *)get;


@end
