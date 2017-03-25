//
//  ExchangedTableViewCell.m
//  LKProject
//
//  Created by 李伟 on 2017/3/7.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "ExchangedTableViewCell.h"
#import "LKBaseDefine.h"

@implementation ExchangedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (DEF_iPhone5SE) {
        self.moneyLabel.font = [UIFont systemFontOfSize:25.f];
    } else {
        self.moneyLabel.font = [UIFont systemFontOfSize:30.0f];
    }
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
