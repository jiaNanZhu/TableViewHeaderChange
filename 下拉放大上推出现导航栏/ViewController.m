//
//  ViewController.m
//  下拉放大上推出现导航栏
//
//  Created by 朱佳男 on 2016/12/14.
//  Copyright © 2016年 ShangYuKeJi. All rights reserved.
//
/*这里说的导航是假的导航，是自己设置出来的*/
#import "ViewController.h"
NSString *const cellId = @"cellID";
#define KHeaderHeight 200.0
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_header;
    UIImageView *_headerImageView;
    UIView *_lineView;
    UIStatusBarStyle _statStyle;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareTableView];
    
    [self preparaTopHeadr];
    
    _statStyle = UIStatusBarStyleLightContent;
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES];
}
//要改变StatusBar的显示样式需要在UIViewController中重载以下方法
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)preparaTopHeadr
{
    _header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, KHeaderHeight)];
    _header.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_header];
    
    _headerImageView = [[UIImageView alloc]initWithFrame:_header.bounds];
    _headerImageView.backgroundColor = [UIColor colorWithRed:0/255.0 green:15/255.0 blue:8/255.0 alpha:1];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.clipsToBounds = YES;//图片过大的裁切
    [_header addSubview:_headerImageView];
    //设置图像
    _headerImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://c.hiphotos.baidu.com/zhidao/pic/item/5ab5c9ea15ce36d3c704f35538f33a87e950b156.jpg"]]];
    //添加分割线一个像素
    CGFloat height = 1/[UIScreen mainScreen].scale;
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, KHeaderHeight, self.view.bounds.size.width, height)];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    [_header addSubview:_lineView];
}
- (void)prepareTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    [self.view addSubview:tableView];
    //设置表格的间距
    tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(200, 0, 0, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1000;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = @(indexPath.row).stringValue;
    
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsety = scrollView.contentOffset.y+scrollView.contentInset.top;
    if (offsety <= 0)
    {
        //放大
        CGRect frame= _header.frame;
        frame.origin.y = 0;
        
        frame.size.height = KHeaderHeight-offsety;
        _header.frame = frame;
        
        frame = _headerImageView.frame;
        frame.size.height = _header.bounds.size.height;;
        _headerImageView.frame = frame;;
        
        //设置透明度
        _headerImageView.alpha = 1.0;
        //根据透明度修改状态栏颜色
        _statStyle = UIStatusBarStyleLightContent;
        //主动更新状态栏
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
        
    }
    else
    {
        //整体移动
        
        CGRect frame= _header.frame;
        //header的最小y值
        CGFloat min = KHeaderHeight-64;
        frame.origin.y = -MIN(min, offsety);
        
        frame.size.height = KHeaderHeight;
        _header.frame = frame;
        
        frame = _headerImageView.frame;
        frame.size.height = _header.bounds.size.height;
        _headerImageView.frame = frame;;
        //设置透明度
        CGFloat progress = 1-(offsety/min);
        _headerImageView.alpha = progress;
        NSLog(@"%f",offsety/min);
        //根据透明度修改状态栏颜色
        _statStyle = (progress<0.5)?UIStatusBarStyleDefault:UIStatusBarStyleLightContent;
        //主动更新状态栏
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
        
    }
    
    CGRect frame = _lineView.frame;
    frame.origin.y = _header.bounds.size.height-_lineView.bounds.size.height;
    _lineView.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
