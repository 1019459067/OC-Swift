//
//  NewsViewController.m
//  网易新闻
//
//  Created by 肖伟华 on 16/6/29.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "NewsViewController.h"
#import "TopLineViewController.h"
#import "HotViewController.h"
#import "VideoViewController.h"
#import "SocietyViewController.h"
#import "ReaderViewController.h"
#import "ScienceViewController.h"

#define KScreenW [UIScreen mainScreen].bounds.size.width

static CGFloat const radio = 1.3;
static CGFloat const labelW = 100;

@interface NewsViewController()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContent;
@property (weak, nonatomic) UILabel *labelSelected;
@property (strong, nonatomic) NSMutableArray *arrayLabelsTitle;
@end
@implementation NewsViewController
- (NSArray *)arrayLabelsTitle
{
    if (!_arrayLabelsTitle) {
        _arrayLabelsTitle = [NSMutableArray array];
    }
    return _arrayLabelsTitle;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupAllChildrenVC];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupTitleLabel];
    [self setupScrollView];
}
- (void)setUpTitleCenter:(UILabel *)labelCenter
{
    CGFloat offSetX = labelCenter.center.x - KScreenW * 0.5;
   
    if (offSetX < 0) offSetX = 0;
    CGFloat offSetXMax = self.scrollViewTitle.contentSize.width - KScreenW;
    if (offSetX > offSetXMax) offSetX = offSetXMax;
    
    [self.scrollViewTitle setContentOffset:CGPointMake(offSetX, 0) animated:YES];
}
#pragma mark - 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat iPageCur = self.scrollViewContent.contentOffset.x / KScreenW;;
    //左边角标
    NSInteger indexLeft = iPageCur;
    NSInteger indexRight = indexLeft + 1;
    
    UILabel *labelLeft = self.arrayLabelsTitle[indexLeft];
    UILabel *labelRight;
    if (indexRight < self.arrayLabelsTitle.count-1) {
        labelRight = self.arrayLabelsTitle[indexRight];
    }
    //计算缩放比例
    CGFloat scaleRight = iPageCur - indexLeft;
    CGFloat scaleLeft = 1 - scaleRight;
    //缩放
    labelLeft.transform = CGAffineTransformMakeScale(scaleLeft*0.3+1, scaleLeft*0.3+1);
    labelRight.transform = CGAffineTransformMakeScale(scaleRight*0.3+1, scaleRight*0.3+1);
    
    //文字渐变
    labelLeft.textColor = [UIColor colorWithRed:scaleLeft green:0 blue:0 alpha:1];
    labelRight.textColor = [UIColor colorWithRed:scaleRight green:0 blue:0 alpha:1];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger iPage = self.scrollViewContent.contentOffset.x / KScreenW;
    
    [self showVC:iPage];
    //
    UILabel *labelSel = self.arrayLabelsTitle[iPage];
    [self selectedLabel:labelSel];
    
    [self setUpTitleCenter:labelSel];
}
- (void)setupScrollView
{
    NSInteger iCount = self.childViewControllers.count;
    self.scrollViewTitle.contentSize = CGSizeMake(labelW * iCount, 0);
    self.scrollViewTitle.showsHorizontalScrollIndicator = NO;
    self.scrollViewTitle.bounces = YES;

    self.scrollViewContent.contentSize = CGSizeMake(KScreenW * iCount, 0);
    self.scrollViewContent.showsHorizontalScrollIndicator = NO;
    self.scrollViewContent.bounces = NO;
    self.scrollViewContent.pagingEnabled = YES;
}
- (void)setupTitleLabel
{
    NSInteger iCount = self.childViewControllers.count;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelH = 44;
    for (int i = 0; i < iCount; i++)
    {
        UIViewController *vc = self.childViewControllers[i];
        UILabel *label = [[UILabel alloc]init];
        label.highlightedTextColor = [UIColor redColor];
        labelX = labelW * i;
        label.tag = i;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        label.text = vc.title;
        label.textAlignment = NSTextAlignmentCenter;
        [self.scrollViewTitle addSubview:label];
        
        [self.arrayLabelsTitle addObject:label];
        //
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapClick:)];
        [label addGestureRecognizer:tap];
        
        if (i == 0) {
            [self onTapClick:tap];
        }
    }
}
- (void)onTapClick:(UITapGestureRecognizer *)tap
{
    UILabel *labelSel = (UILabel *)tap.view;
    [self selectedLabel:labelSel];
    
    NSInteger index = labelSel.tag;
    CGFloat fOffSetX = index * KScreenW;
    self.scrollViewContent.contentOffset = CGPointMake(fOffSetX, 0);
    
    [self showVC:index];
    
    [self setUpTitleCenter:labelSel];
}
- (void)showVC:(NSInteger)index
{
    CGFloat fOffSetX = index * KScreenW;
    UIViewController *vc = self.childViewControllers[index];
//    if (vc.isViewLoaded) {
//        return;
//    }
    vc.view.frame = CGRectMake(fOffSetX, 0, self.scrollViewContent.frame.size.width, self.scrollViewContent.frame.size.height);
   
    [self.scrollViewContent addSubview:vc.view];
}
- (void)selectedLabel:(UILabel *)label
{
    _labelSelected.textColor = [UIColor blackColor];
    _labelSelected.transform = CGAffineTransformIdentity;
    _labelSelected.highlighted = NO;
    label.highlighted = YES;
    label.transform = CGAffineTransformMakeScale(radio, radio);
    _labelSelected = label;
}
- (void)setupAllChildrenVC
{
    TopLineViewController *vc1 = [[TopLineViewController alloc]init];
    vc1.title = @"头条";
    [self addChildViewController:vc1];

    HotViewController *vc2 = [[HotViewController alloc]init];
    vc2.title = @"热点";
    [self addChildViewController:vc2];

    VideoViewController *vc3 = [[VideoViewController alloc]init];
    vc3.title = @"视频";
    [self addChildViewController:vc3];

    SocietyViewController *vc4 = [[SocietyViewController alloc]init];
    vc4.title = @"社会";
    [self addChildViewController:vc4];

    ReaderViewController *vc5 = [[ReaderViewController alloc]init];
    vc5.title = @"阅读";
    [self addChildViewController:vc5];

    ScienceViewController *vc6 = [[ScienceViewController alloc]init];
    vc6.title = @"科学";
    [self addChildViewController:vc6];
    
    vc1.view.backgroundColor = [UIColor redColor];
    vc2.view.backgroundColor = [UIColor yellowColor];
    vc3.view.backgroundColor = [UIColor blueColor];
    vc4.view.backgroundColor = [UIColor greenColor];
    vc5.view.backgroundColor = [UIColor orangeColor];
    vc6.view.backgroundColor = [UIColor purpleColor];


}
@end
