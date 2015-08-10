//
//  VKFeeds.h
//  SaveAudioVK
//
//  Created by Admin on 29.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "JSONModel.h"

@interface VKAudioFields : JSONModel

@property(strong, nonatomic) NSString *artist;
@property(strong, nonatomic) NSDate *date;
@property(assign, nonatomic) int duration;
//@property(assign, nonatomic) int genre_id;
@property(assign, nonatomic) int id;
@property(assign, nonatomic) int owner_id;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSURL *url;

@end

@protocol VKAudioFields

@end

@interface VKFeeds : JSONModel

@property(assign, nonatomic) int count;
@property(strong,nonatomic) NSMutableArray<VKAudioFields> * items;

@end
