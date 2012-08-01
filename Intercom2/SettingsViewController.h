//
//  SettingsViewController.h
//  Intercom2
//
//  Created by Giorgio Nobile on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IC_AppDelegate.h"

#define kSpeedAuto		@"speed"


@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UISwitch *speedAuto;
    UITableView *tableView;
    IC_AppDelegate *Nav;
    
    
}

@property (nonatomic, retain) IBOutlet UISwitch *speedAuto;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet IC_AppDelegate *Nav;



@end
