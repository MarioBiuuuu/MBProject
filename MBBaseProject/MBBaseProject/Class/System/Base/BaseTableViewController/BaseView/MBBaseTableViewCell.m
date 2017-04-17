//
//  MBBaseTableViewCell.m
//  MBBaseController
//
//  Created by ZhangXiaofei on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "MBBaseTableViewCell.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define kMENUBUTTON_TAG 1000

@interface MBBaseTableViewCell () {
    CGFloat _menuWidth;
    CGPoint _beginPoint;
    CGPoint _lastMovePoint;
    BOOL _isMoveToLeft;
    BOOL _lockMoveRight;
}

@property (nonatomic, weak) UIView *containerView; //容器view

@property (nonatomic, assign) BOOL isOpenLeft; //是否已经打开左滑动

@property (nonatomic, weak) UIPanGestureRecognizer *rightPanGesture; //向右清扫手势

@property (nonatomic, strong) NSMutableArray<UIButton *> *menuButtons;

@end

@implementation MBBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (UITableView *)tableView {
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0) {
        return  (UITableView *)self.superview.superview;
    } else {
        return (UITableView *)self.superview;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    if (tableView == nil) {
        return [[self alloc] init];
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"CellID"];
    [tableView registerClass:[self class] forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
}

+ (instancetype)nibCellWithTableView:(UITableView *)tableView {
    if (tableView == nil) {
        return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"nibCellID"];
    UINib *nib = [UINib nibWithNibName:classname bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
}

+ (NSString *)getCellReuserIdentifer {
    
    NSString *className = NSStringFromClass([self class]);
    NSString *reuseID = [className stringByAppendingString:@"CellID"];
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    if (nib) {
        reuseID = [className stringByAppendingString:@"nibCellID"];
    }
    return reuseID;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
@end
