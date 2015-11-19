//
//  Diagnose_CheckItemCell.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "Diagnose_CheckItemCell.h"
@interface Diagnose_CheckItemCell ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *symptomLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;



@end

@implementation Diagnose_CheckItemCell

- (void)setItem:(Diagnose_CheckItem *)item{
    //去除HTML标记符号
    NSString *mss = [self filterHTML:item.message];
    
    _nameLabel.text = item.name;
    _placeLabel.text = item.place;
    _symptomLabel.text = item.symptom;
    _messageLabel.text = mss;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kSicknessImgUrl,item.img]]];
    
    self.initData();
}


#pragma searchbar的代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    for (Diagnose_CheckItem *item in [DiagnoseManager sharedDiagnoseManager].itemArr) {
        
        if ([item.name isEqualToString:_searchbar.text]) {
 
            [self setItem:item];
            
            
            //收回键盘
            [_searchbar endEditing:YES];
            return;
        }
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的检查项目的名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    _table.hidden = NO;
    _imgView.hidden = YES;
    
    CATransition *transition = [CATransition animation];
    //设置动画类型
    transition.type = @"RippleEffect";
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
    return [DiagnoseManager sharedDiagnoseManager].itemArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [[DiagnoseManager sharedDiagnoseManager].itemArr[indexPath.row] name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.searchbar.text = [[DiagnoseManager sharedDiagnoseManager].itemArr[indexPath.row] name];
    
    [self searchBarSearchButtonClicked:_searchbar];
    
    _table.hidden = YES;
    _imgView.hidden = NO;
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
    
    self.table.hidden = YES;
    self.searchbar.delegate = self;
    
    //注册cell
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    
    // 使得点击本身后不会变色
    self.selectedBackgroundView = ({
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:183/255. green:213/255. blue:233/255. alpha:0.8];
        view;
        
    });
    
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
