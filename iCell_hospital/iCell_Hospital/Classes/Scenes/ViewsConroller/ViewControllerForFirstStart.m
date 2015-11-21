//
//  ViewControllerForFirstStart.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/21.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "ViewControllerForFirstStart.h"


@interface ViewControllerForFirstStart ()
{
    UIView *rootView;
    EAIntroView *_intro;
    
}
@end

@implementation ViewControllerForFirstStart


-(void)loadView{
    
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    
}




 
#pragma mark - Custom actions

- (IBAction)switchFlip:(id)sender {
    UISwitch *switchControl = (UISwitch *) sender;
    NSLog(@"%@", switchControl.on ? @"On" : @"Off");
    
    // limit scrolling on one, currently visible page (can't go previous or next page)
    //[_intro setScrollingEnabled:switchControl.on];
    
    if(!switchControl.on) {
        // scroll no further selected page (can go previous pages, but not next)
        [_intro limitScrollingToPage:_intro.visiblePageIndex];
    } else {
        [_intro setScrollingEnabled:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
