//
//  SettingsViewController.m
//  Intercom2
//
//  Created by Giorgio Nobile on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "IC_ViewController.h"

//@interface SettingsViewController ()

//@end

@implementation SettingsViewController

@synthesize speedAuto;
@synthesize tableView, Nav;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    //self.navigationItem.title = [NSString stringWithFormat:@"%@", NSLocalizedString(@"sTitolo", @"")];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	speedAuto.on = [defaults boolForKey:kSpeedAuto];
    
}

- (void)vieWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];     
	speedAuto.on = [defaults boolForKey:kSpeedAuto];
}


- (void)viewDidAppear :(BOOL)animated { 
    NSLog(@"Accedo a viewDidAppear");
    [super viewDidAppear:animated];
    //self.navigationController.navigationBarHidden = FALSE;
    
    //self.navigationItem.title=[NSString stringWithFormat:@"%@", NSLocalizedString(@"sTitolo", @"")];
    self.navigationItem.hidesBackButton = FALSE;
    
    
	//acceto al plist dei settaggi e lo leggo
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	speedAuto.on = [defaults boolForKey:kSpeedAuto];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = TRUE;
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:speedAuto.on forKey:kSpeedAuto]; 
	[defaults synchronize];
    if (speedAuto.on) {
        NSLog(@"Autospeed Attivato");
    } else {
        NSLog(@"Autospeed' Disattivato");
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *head = [NSString stringWithFormat:@"%@", NSLocalizedString(@"aCosa", @"")];
    return head;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"aVolume", @"")];
    //cell.textLabel.text =@"Volume Automatico";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    speedAuto = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = speedAuto;
    //[caca setOn:NO animated:NO];
    [speedAuto setOn:NO animated:NO];
    [speedAuto addTarget:self action:@selector(speedAutoChange:) forControlEvents:UIControlEventValueChanged];
    [speedAuto release];
    
    return cell;
}

- (void) speedAutoChange:(id)sender {
    UISwitch* switchControl = sender;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog( @"SpeedAuto %@", switchControl.on ? @"ON" : @"OFF" );
    [defaults setBool:speedAuto.on forKey:kSpeedAuto]; 
    [defaults synchronize];
}


-(void)dealloc {
    [speedAuto release];
    [tableView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    speedAuto = nil;
    self.tableView = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
