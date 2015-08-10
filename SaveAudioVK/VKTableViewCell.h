//
//  VKTableViewCell.h
//  SaveAudioVK
//
//  Created by Admin on 30.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FFCircularProgressView.h>

@interface VKTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *buttonWasPressed;
@property (strong, nonatomic) IBOutlet FFCircularProgressView *circuleButton;
@end
