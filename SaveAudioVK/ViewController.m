//
//  ViewController.m
//  SaveAudioVK
//
//  Created by Admin on 28.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ViewController.h"
#import "AudioTableViewController.h"
#import <VKSdk.h>
#import <VKApi.h>

static NSArray *SCOPE = nil;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SCOPE = @[VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_FRIENDS];
    [VKSdk initializeWithDelegate:self andAppId:@"5011611"];
    [self updateButtonText];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"!!!");
    [self updateButtonText];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)getMenu:(id)sender {
//    [self.slidingViewController anchorTopViewToRightAnimated:YES];
//}

-(void) startWorking {
    NSLog(@"Out");
}

- (void)go:(id)sender {
    [VKSdk authorize:SCOPE revokeAccess:YES];
}

-(void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn: self];
}

-(void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    [self go: nil];
}

-(void)vkSdkUserDeniedAccess:(VKError *)authorizationError{
    [[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

-(void)vkSdkShouldPresentViewController:(UIViewController *)controller{
    [self presentViewController:controller animated: YES completion: nil];
}

-(void)vkSdkReceivedNewToken:(VKAccessToken *)newToken{
    [self startWorking];
}

- (IBAction)signInSignOut:(id)sender {
    if([VKSdk wakeUpSession]){
        //NSLog(@"IM HERE!!!");
        [VKSdk forceLogout];
    }
    else{
        [self go:nil];
    }
    [self updateButtonText];
}

-(void) updateButtonText{
    if ([VKSdk wakeUpSession]) {
        [self.signInSignOutButton setTitle:@"Log out" forState:UIControlStateNormal];
        //[self startWorking];
    }
    else{
        NSLog(@"IM HERE!");
        [self.signInSignOutButton setTitle:@"Log in" forState:UIControlStateNormal];
        //[self go:nil];
    }
}

-(void)vkSdkWillDismissViewController:(UIViewController *)controller{
    NSLog(@"dismiss");
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if([segue.identifier isEqualToString:@"showAudio"]){
//        AudioTableViewController *audio = ;
//    }
//}

@end
