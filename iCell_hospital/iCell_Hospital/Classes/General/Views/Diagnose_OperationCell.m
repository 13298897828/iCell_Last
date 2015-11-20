//
//  Diagnose_OperationCell.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/14.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "Diagnose_OperationCell.h"

@interface Diagnose_OperationCell ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;




@end

@implementation Diagnose_OperationCell

- (void)setOper:(Diagnose_Operation *)oper{
    //去除HTML标记符号
    NSString *mss = [self filterHTML:oper.message];
    
    _nameLabel.text = oper.name;
    _descLabel.text = oper.desc;
    _messageLabel.text = mss;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kSicknessImgUrl,oper.img]]];
    
    self.initData();
}


#pragma searchbar的代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    for (Diagnose_Operation *oper in [DiagnoseManager sharedDiagnoseManager].operateArr) {
        
        if ([oper.name isEqualToString:_searchBar.text]) {
            
            [self setOper:oper];
            
            //收回键盘
            [_searchBar endEditing:YES];
            return;
        }
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手术项目的名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{

    _table.hidden = NO;
    
    CATransition *transition = [CATransition animation];
    //设置动画类型
    transition.type = @"FlipFromLeft";
    //间隔
    transition.duration = 0.5;
    //设置动画路径
    transition.subtype = kCATransitionFromBottom;
    
    [self.table.layer addAnimation:transition forKey:@"transition"];
}



//消除解析出的数据的HTML标记
- (NSString *)filterHTML:(NSString *)html{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    return html;
}


#pragma mark - tableView 的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [DiagnoseManager sharedDiagnoseManager].operateArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    
    cell.textLabel.text = [[DiagnoseManager sharedDiagnoseManager].operateArr[indexPath.row] name];
    
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.searchBar.text = [[DiagnoseManager sharedDiagnoseManager].operateArr[indexPath.row] name];
    
    [self searchBarSearchButtonClicked:_searchBar];
    
    _table.hidden = YES;
}



#pragma mark -  xib会走此方法
- (void)awakeFromNib {
    //设定cell根据内容自适应高度
    self.table.rowHeight = UITableViewAutomaticDimension;
    self.table.estimatedRowHeight = 100;
    
    //给tableView设置代理
    _table.delegate = self;
    _table.dataSource = self;
    
    //刷新数据
    [_table reloadData];
    
    //关闭cell的可选择性，避免影响其他的操作
    //self.selected = NO;
    
    self.table.hidden = YES;
    self.searchBar.delegate = self;
    
    //注册cell
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    
    // 使得点击本身后不会变色
    self.selectedBackgroundView = ({
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:183/255. green:213/255. blue:233/255. alpha:0.8];
        view;
        
    });
    
    //轻拍返回
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self addGestureRecognizer:tap];

}
- (void)back{
    //收回键盘
    [_searchBar endEditing:YES];
    
    _table.hidden = YES;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
