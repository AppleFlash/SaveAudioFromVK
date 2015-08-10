//
//  ViewController.h
//  SaveAudioVK
//
//  Created by Admin on 28.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>
@interface ViewController : UIViewController <VKSdkDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *signInSignOutButton;
- (IBAction)signInSignOut:(id)sender;


@end

