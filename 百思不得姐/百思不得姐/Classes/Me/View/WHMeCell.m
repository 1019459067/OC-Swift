//
//  WHMeCell.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/23.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHMeCell.h"

@implementation WHMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.image == nil) nil;
    self.imageView.wh_y = WHSmallMargin;
    self.imageView.wh_height = self.wh_height - WHSmallMargin * 2;
    
    self.textLabel.wh_x = self.imageView.wh_right + WHMargin;
}
@end
