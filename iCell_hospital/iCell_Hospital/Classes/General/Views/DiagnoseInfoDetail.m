//
//  DiagnoseInfoDetail.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "DiagnoseInfoDetail.h"

@interface DiagnoseInfoDetail ()



@end

@implementation DiagnoseInfoDetail

- (void)setInfo:(Diagnose_Info *)info{
    self.messageLabel.text = info.message;
    [self.urlBtn setTitle:info.url forState:UIControlStateNormal];
    self.infoImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.infoImg sd_setImageWithURL:[NSURL URLWithString:info.img]];
    
    NSLog(@"%f",_messageLabel.frame.size.height);
    _height =  _messageLabel.frame.size.height;
}

#pragma mark  根据模型(内容)计算高度
-(CGFloat)calcHeightWitInfo:(Diagnose_Info *)info{
    
    //1.设置计算所在的最大范围
    CGSize maxSize = CGSizeMake(_messageLabel.frame.size.width, 1000);
    
    //2.创建字典，包含字体大小
    NSDictionary *dict = @{NSFontAttributeName:_messageLabel.font};
    
    
    //3.使用方法，计算文字的frame（计算一段文本在限定宽高内所占矩形大小）
    CGRect frame = [info.message boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    
    //4.返回frame的高度值
    return frame.size.height;
    
}



- (IBAction)urlBtnAction:(UIButton *)sender {
    
    self.toInterest();
}










- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
