//
//  UIEditCamDetailViewController.h
//  Sentinel
//
//  Created by SentinelTeam on 11/10/11.
//  Copyright 2011 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface UIEditCamDetailViewController : UIViewController {
	IBOutlet UIScrollView *cameraParamsScrollView;
	IBOutlet UITextField *ipaddress;
	IBOutlet UITextField *username;
	IBOutlet UITextField *password;
	IBOutlet UITextField *cameraname;
	IBOutlet UIButton *deleteCamera;
	IBOutlet UILabel *deleteCameraButtonStat;
	IBOutlet UISwitch *alarmEnableSwitch;
	NSManagedObjectContext *context;
	NSManagedObjectContext *contextnew;
	int cameraIndex;
}

- (IBAction) ipaddressEntry:(id)sender;
- (IBAction) usernameEntry:(id)sender;
- (IBAction) passwordEntryStart:(id)sender;
- (IBAction) cameranameEntryStart:(id)sender;

- (IBAction) onTouchOutsideCameraName:(id)sender;
- (IBAction) onTouchOutsidePassword:(id)sender;
- (IBAction) onTouchOutsideIPaddress:(id)sender;
- (IBAction) onTouchOutsideUserName:(id)sender;
- (IBAction) onTouchalarmSwitch:(id)sender;
- (IBAction) onTouchDeleteCamera:(id)sender;

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSManagedObjectContext *contextnew;

@end