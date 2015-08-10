//
//  AudioTableViewController.h
//  SaveAudioVK
//
//  Created by Admin on 28.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>
#import "VKTableViewCell.h"

@class VKFeeds;

@interface AudioTableViewController : UITableViewController <VKSdkDelegate, UITableViewDataSource, UITableViewDelegate>

-(VKFeeds *) vkAudioAtIndex: (NSInteger)index;
-(NSInteger) vkAudiosCount;

-(void)vkAudioRequestWithOffset:(int)offset;
//-(void)vkCircularDownloadAudioWithIndexPath;

@end
