//
//  FeedbackViewController.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/17.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "FeedbackViewController.h"
#import <MessageUI/MessageUI.h>
@interface FeedbackViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backImg;

- (IBAction)feedButton:(UIButton *)sender;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
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

- (IBAction)feedButton:(UIButton *)sender {
    
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:@"意见反馈"];
    [mc setCcRecipients:[NSArray arrayWithObject:@"709149549@qq.com"]];
    [mc setBccRecipients:[NSArray arrayWithObject:@"709149549@qq.com"]];
    [mc setMessageBody:@"请在此写出您的建议" isHTML:NO];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"blood_orange"
                                                     ofType:@"png"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [mc addAttachmentData:data mimeType:@"image/png" fileName:@"blood_orange"];
    
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        [(UINavigationController *)self.presentingViewController popToRootViewControllerAnimated:YES];
//
//    }];
      [self presentViewController:mc animated:YES completion:nil];
//    while(theViewController = [theObjectEnumerator nextObject ])
//    {
//        if([theViewController modalTransitionStyle] == UIModalTransitionStyleCoverVertical)
//        {
//            [self.mNavigationController popToRootViewControllerAnimated:
//             YES];
//        }
//    }
//}else
//while(theViewController = [theObjectEnumerator nextObject ])
//{
//    if([theViewController modalTransitionStyle] == UIModalTransitionStyleCoverVertical)
//    {
//        [self.mNavigationController dismissModalViewControllerAnimated:YES];
//    }
//}



}
@end
