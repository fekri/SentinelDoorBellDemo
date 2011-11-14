//
//  viewLiveFeed.m
//  navS
//
//  Created by Researcher on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UILiveFeedViewController.h"
#import "UIMainViewController.h"
#import "UISnapshotsViewController.h"
#import "ConfigAccess.h"

// This will be set from the core data when a user selects a camera. 
//static NSString* CURRENT_BASE_URL = @"http://128.238.151.253/";
//static NSString* CURRENT_BASE_URL = @"http://60.45.63.26";
static NSString* CURRENT_BASE_URL = @"http://62.131.113.213:81";
//static NSString* CURRENT_BASE_URL = @"http://96.242.83.3";

@implementation UILiveFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Live Feed";	
	
	theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:CURRENT_BASE_URL] 	  
								cachePolicy:NSURLRequestUseProtocolCachePolicy						  
							timeoutInterval:60.0];
	
	theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc]   
                             initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                             target:self   
                             action:@selector(OnSnapshot:)];
	self.navigationItem.rightBarButtonItem = item; 
	[item release];
	
	[theWebView addSubview:tmpview];
	
	UIBarButtonItem *leftitem = [[UIBarButtonItem alloc] 
                                 initWithTitle:@"Main Menu" 
                                         style:UIBarButtonItemStylePlain
                                        target:self   
                                        action:@selector(mainMenu:)];
	self.navigationItem.leftBarButtonItem = leftitem;
	[leftitem release];
}

-(void) OnViewSnapshotsClick:(id) sender
{
	UISnapshotsViewController *viewctr = [[UISnapshotsViewController alloc] 
                                          initWithNibName:@"UISnapshotsView" 
                                          bundle:nil];
    
	[self.navigationController pushViewController:viewctr animated:YES];
	[viewctr release];
}

-(void) mainMenu:(id)sender
{
	int count = [self.navigationController.viewControllers count];
	
	if(count > 1)
    {
		[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:count-3] animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
	if([theWebView isLoading])
		[theWebView stopLoading];
	
}

-(void)viewWillAppear :(BOOL)animated
{
	NSURL *url = [ConfigAccess urlForAction:CURRENT_BASE_URL
                                     action:@"Default"];
                  
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[theWebView loadRequest:requestObj];
    
    if (DEBUG)
    {
        NSLog(@"[Default]=%@", url);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge 
{
	if ([challenge previousFailureCount] == 0)
	{
		NSURLCredential *newCredential;
		newCredential=[NSURLCredential credentialWithUser:@"kongcao7bl"
												 password:@"Kongcao7BL"
											  persistence:NSURLCredentialPersistenceForSession];
		[[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
        
		NSURL *url = [ConfigAccess urlForAction:CURRENT_BASE_URL
                                         action:@"Default"];
		
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[theWebView loadRequest:requestObj];
		
        if (DEBUG)
        {
            NSLog(@"[Default]=%@", url);
        }
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Failure" 
														message:@"Invalid username/password."
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (IBAction) onTiltScanClick: (id) sender
{
	[ConfigAccess performAction:CURRENT_BASE_URL action:@"TiltScan"];
}

- (IBAction) onPanScanClick: (id) sender
{
    [ConfigAccess performAction:CURRENT_BASE_URL action:@"PanScan"];
}

- (IBAction) onBrightnessDarker:(id) sender
{
    [ConfigAccess performAction:CURRENT_BASE_URL action:@"BrightnessDarker"];
}

- (IBAction) onBrightnessReset:(id) sender
{
    [ConfigAccess performAction:CURRENT_BASE_URL action:@"BrightnessReset"];
}

- (IBAction) onBrightnessBrighter:(id) sender
{
    [ConfigAccess performAction:CURRENT_BASE_URL action:@"BrightnessBrighter"];
}


- (IBAction) OnNightModeSwitch: (id) sender
{
	UISwitch *nightSwitch = (UISwitch *) sender;

	if ([nightSwitch isOn] )
	{
        [ConfigAccess performAction:CURRENT_BASE_URL action:@"NightModeOn"];
	}
	else 
	{
        [ConfigAccess performAction:CURRENT_BASE_URL action:@"NightModeOff"];
	}
}

- (IBAction) OnAlarmClick: (id) sender
{
    [ConfigAccess performAction:CURRENT_BASE_URL action:@"Sound"];
}

- (IBAction) OnSnapshot: (id) sender
{
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"yyyyMMMdd_HH_mm_ss"];
	
	NSDate *now = [NSDate date];
	
	NSString *dateString = [format stringFromDate:now];
    
	NSURL *url = [ConfigAccess urlForAction:CURRENT_BASE_URL 
                                     action:@"Snapshot"];
	NSData *data = [NSData dataWithContentsOfURL:url];
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                          NSUserDomainMask, 
                                                          YES)
                      objectAtIndex:0];

	NSString *str = [[NSString alloc] initWithFormat:@"/%@.jpg", dateString];
	path = [path stringByAppendingString:str];
	[str release];
	
	[data writeToFile:path atomically:YES];
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    [super dealloc];
}

@end


@implementation SentinelTouchView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	CGPoint startLocation = [(UITouch*)[touches anyObject] locationInView:self];
	
	double x = startLocation.x;
	double y = startLocation.y;
	
	NSLog(@"%f %f", x, y);
	
	if(x >= 100 && x <= 210 && y >= 80 && y <= 160)
	{
		[self homePosition];
	}
	
	if (y >= 0 && y <= 80)
	{
		[self tiltUp];
	}
	else if(y >= 160 && y <= 240)
	{
		[self tiltDown];
	}
	
	if (x >= 0 & x <= 110)
	{
		[self PanLeft];
	}
	else if(x >= 210 && x <= 320)
	{
		[self PanRight];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	CGPoint startLocation = [(UITouch*)[touches anyObject] locationInView:self];
	
	double x = startLocation.x;
	double y = startLocation.y;
	
	NSLog(@"Ended: %f %f", x, y);
}

- (void) homePosition
{
    [ConfigAccess performAction:CURRENT_BASE_URL action:@"HomePosition"];
}

- (void) tiltUp
{
    [ConfigAccess performAction:CURRENT_BASE_URL action:@"TiltUp"];
}

- (void) tiltDown
{
    [ConfigAccess performAction:CURRENT_BASE_URL action:@"TiltDown"];
}

- (void) PanLeft
{
    [ConfigAccess performAction:CURRENT_BASE_URL action:@"PanLeft"];
}

- (void) PanRight
{
    [ConfigAccess performAction:CURRENT_BASE_URL action:@"PanRight"];
}

@end


