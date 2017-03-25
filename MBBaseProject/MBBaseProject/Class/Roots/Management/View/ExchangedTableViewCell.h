//
//  ExchangedTableViewCell.h
//  LKProject
//
//  Created by 李伟 on 2017/3/7.
//  Copyright © 2017年 Yuri. All rights reserved.
//
/**
 优惠卷／实物 总数cell
 */

#import "LKBaseTableViewCell.h"

@interface ExchangedTableViewCell : LKBaseTableViewCell

/**
 金额／实物名称
 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

/**
 数量
 */
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

/**
 有效期开始时间
 */
@property (weak, nonatomic) IBOutlet UILabel *validateStrTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *validateStrDateLabel;


/**
 有效期结束时间
 */
@property (weak, nonatomic) IBOutlet UILabel *validateEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *validateEndDateLabel;

/**
 使用门槛
 */
@property (weak, nonatomic) IBOutlet UILabel *minValiMoneyLabel;

@end
