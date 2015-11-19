//
//  ScanViewController.h
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/13.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "ZbarOverlayView.h"
@interface ScanViewController : UIViewController<ZBarReaderViewDelegate>

{
    ZBarReaderView *_read;
    ZbarOverlayView *_overLayView;
}
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end
