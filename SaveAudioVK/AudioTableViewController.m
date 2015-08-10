	//
//  AudioTableViewController.m
//  SaveAudioVK
//
//  Created by Admin on 28.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AudioTableViewController.h"
#import "JSONModel.h"
#import "VKFeeds.h"
#import "VKTableViewCell.h"
#import <VKSdk.h>
#import "FFCircularProgressView.h"
#import <AFNetworking.h>

static int STEP = 30;
static NSString *identifier = @"Cell";

@interface AudioTableViewController (){
    VKFeeds *_feeds;
    int countUploads;
    int audioOffset;
    NSArray *tableData;
}
@end

@implementation AudioTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    countUploads = 1;
    tableData = [NSArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:identifier];
}

-(void)viewDidAppear:(BOOL)animated{
    [self vkAudioRequestWithOffset:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VKAudioFields *vkAudioFields = tableData[indexPath.row];
    VKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.buttonWasPressed.tag = indexPath.row;
    //cell.circuleButton.tag = indexPath.row;
    [cell.buttonWasPressed addTarget:self action:@selector(downloadAudioFromVK:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.artistLabel.text = vkAudioFields.artist;
    cell.titleLabel.text = vkAudioFields.title;
    
    return cell;
}

/*end of standart method*/

-(void)vkAudioRequestWithOffset:(int)offset{
    VKRequest *audioRequest = [VKRequest requestWithMethod:@"audio.get"
                                             andParameters:@{VK_API_OWNER_ID:[[VKSdk getAccessToken]userId], VK_API_COUNT:@30, VK_API_OFFSET:[NSString stringWithFormat:@"%d", offset]}
                                             andHttpMethod:@"GET"];
    [audioRequest executeWithResultBlock:^(VKResponse *response) {
        NSError *error = nil;
        _feeds = [[VKFeeds alloc] initWithDictionary:response.json error:&error];
        tableData = [tableData arrayByAddingObjectsFromArray:_feeds.items];
        //NSLog(@"feeds: %@", response);
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float offs = (scrollView.contentOffset.y + scrollView.bounds.size.height);
    float val = (scrollView.contentSize.height);
    if(offs == val){
        audioOffset = countUploads * STEP;
        [self vkAudioRequestWithOffset:audioOffset];
        countUploads++;
    }
}

/*Index and count VK auidos*/

-(NSInteger)vkAudiosCount{
    return tableData.count;
}

-(NSArray *)vkAudioAtIndex:(NSInteger)index{
    return [tableData objectAtIndex:index];
}

/*directly download*/

-(IBAction)downloadAudioFromVK:(id)sender{
    NSLog(@"first sender: %ld", (long)[sender tag]);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    VKTableViewCell *cell = (VKTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    VKAudioFields *audioWillDowload = tableData[[sender tag]];

    [cell.circuleButton startSpinProgressBackgroundLayer];
    __block float progress;
    
    NSString *guid = [[NSProcessInfo processInfo]globallyUniqueString];
    NSString *uniqueName = [NSString stringWithFormat:@"%@_%@.mp3", audioWillDowload.artist, guid];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:audioWillDowload.url];
    AFURLConnectionOperation *operation = [[AFURLConnectionOperation alloc]initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", uniqueName]];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
    
    NSLog(@"%@", filePath);
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        progress = (float)totalBytesRead / totalBytesExpectedToRead;
        [cell.circuleButton setProgress:progress];
        NSLog(@"%f", progress);
        
    }];
    [cell.circuleButton stopSpinProgressBackgroundLayer];
    [operation setCompletionBlock:^{
        NSLog(@"Download complete");
    }];
    
    [operation start];
}

-(BOOL)createDirectoryWithName:(NSString *)directoryName{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:directoryName];
    NSError *error;
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error]){
            NSLog(@"Create directory error: %@", error);
            return NO;
        }
    }
    return YES;
}

@end
