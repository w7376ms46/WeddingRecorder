//
//  GalleryViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/3/6.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "GalleryViewController.h"

@interface GalleryViewController ()

@property (nonatomic, strong)NSArray *pageTitles;
@property (nonatomic, strong)NSArray *pageImages;

@end

@implementation GalleryViewController

@synthesize stringList, currentIndex;

@synthesize pageTitles, pageImages, titleShooter;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Create the data model
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    FullScreenPhotoViewController *startingViewController = [self viewControllerAtIndex:currentIndex];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    //NSLog(@"self.view.frame.size = %f, %f", self.view.frame.size.width, self.view.frame.size.height);
    self.pageViewController.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [self.navigationItem setTitle:titleShooter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (FullScreenPhotoViewController *)viewControllerAtIndex:(NSUInteger)index{
    if (([stringList count] == 0) || (index >= [stringList count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    FullScreenPhotoViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FullScreenPhotoViewController"];
    
    PFObject *object = [stringList objectAtIndex:index];
    
    PFFile *thumbnail = object[@"Photo"];
    NSLog(@"shooter = %@", object[@"Shooter"]);
    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            [pageContentViewController.photo setImage:image];
        }
    }];
    
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = ((FullScreenPhotoViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = ((FullScreenPhotoViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [stringList count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}



- (IBAction)finish:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
