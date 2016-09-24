//
//  SlideShowViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/6/18.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "SlideShowViewController.h"

@interface SlideShowViewController ()

@property (strong, nonatomic) NSArray *photoArray;
@property (strong, nonatomic) NSMutableArray *photoMutableArray;
@property (strong, nonatomic) NSTimer *slideShowTimer;
@property (nonatomic) NSInteger photoIndex;

@end

@implementation SlideShowViewController

@synthesize weddingInfoObjectId, photo, photoArray, photoIndex, slideShowTimer, photoMutableArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    photoIndex = 0;
    photoMutableArray = [[NSMutableArray alloc]init];
    [self loadingPhoto];
    [self.navigationController setHidesBarsOnTap:YES];
    /*
    PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"%@%@", weddingInfoObjectId, @"OriginalPhoto"]];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([objects count] == 0) {
            }
            else{
                photoArray  = objects;
                [self loadingPhoto];
                //[self changePhoto];
                //slideShowTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(changePhoto:) userInfo:nil repeats:YES];
                //[slideShowTimer fire];
                NSLog(@"photoArray count = %lu", (unsigned long)[photoArray count]);
            }
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
     */
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadingPhoto{
    PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"%@%@", weddingInfoObjectId, @"OriginalPhoto"]];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([objects count] == 0) {
            }
            else{
                [photoMutableArray removeAllObjects];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    for (int i = 0 ; i<[objects count]; i++) {
                        PFObject *object = [objects objectAtIndex:i];
                        PFFile *photoFile= (PFFile *)object[@"Photo"];
                        NSData *data = [photoFile getData];
                        [photoMutableArray addObject:data];
                        NSLog(@"forloop");
                    }
                    
                    [self photoSlideShow];
                });
                
                NSLog(@"photoArray count = %lu", (unsigned long)[photoArray count]);
            }
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) photoSlideShow{
    NSLog(@"photo slide show photoMutableArray count = %d", [photoMutableArray count]);
    dispatch_async(dispatch_get_main_queue(), ^{
        slideShowTimer = [NSTimer scheduledTimerWithTimeInterval:5  target:self selector:@selector(changePhoto:) userInfo:nil repeats:YES];
        [slideShowTimer fire];
    });
}

- (void)changePhoto:(NSTimer *)sender{
    NSLog(@"startchangephoto  index = %d", photoIndex);
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0
                         animations:^{
                             photo.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:1.0
                                              animations:^{
                                                  photo.image = [UIImage imageWithData:photoMutableArray[photoIndex]];
                                                  photo.alpha = 1.0f;
                                              }
                                              completion:^(BOOL finished){
                                                  if (photoIndex>=[photoMutableArray count]-1) {
                                                      photoIndex = 0;
                                                      [slideShowTimer invalidate];
                                                      slideShowTimer = nil;
                                                      [self loadingPhoto];
                                                  }
                                                  else{
                                                      photoIndex++;
                                                  }
                                              }];
                         }];
    });
}
/*
- (void)changePhoto{//:(NSTimer *)sender{
    NSLog(@"startchangephoto");
    while (1) {
        if (photoIndex >= [photoArray count]-1) {
            photoIndex = 0;
        }
        PFObject *object = [photoArray objectAtIndex:photoIndex];
        PFFile *photoFile= (PFFile *)object[@"Photo"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [photoFile getData];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:2.0
                                     animations:^{
                                         photo.alpha = 0.0f;
                                     }
                                     completion:^(BOOL finished){
                                         [UIView animateWithDuration:2.0
                                                          animations:^{
                                                              photo.image = [UIImage imageWithData:data];
                                                              photo.alpha = 1.0f;
                                                          }
                                                          completion:^(BOOL finished){
                                                              photoIndex++;
                                                          }];
                                     }];
                });
            }
            
        });
    }
    
    
    
    //photo.file = photoFile;
    //[photo loadInBackground];
    
    
}
*/
/*
- (void)slidShow:(NSArray *)photoArray{
    for(PFObject *object in photoArray){
        PFFile *photoFile= object[@"Photo"];
        //dispatch_async(dispatch_get_main_queue(),^{
            photo.file = (PFFile *)photoFile;
            [photo loadInBackground];
        //});
        [NSThread sleepForTimeInterval:5];
        NSLog(@"testtttt");
    }
}
*/

- (IBAction)endOfSlideShow:(id)sender {
    [slideShowTimer invalidate];
    slideShowTimer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
