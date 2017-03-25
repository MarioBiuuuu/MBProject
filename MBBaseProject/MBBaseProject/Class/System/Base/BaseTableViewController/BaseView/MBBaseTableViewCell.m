//
//  MBBaseTableViewCell.m
//  MBBaseController
//
//  Created by ZhangXiaofei on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "MBBaseTableViewCell.h"
#import "UIButton+SwipMenuItem.h"

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

@property (nonatomic, strong) NSMutableArray<MBSwipCellMenuItem *> *menuArrM;

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

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat itemX = 0;
    if (self.menuArrM.count > 0) {
        
        for (int i = 0; i < self.menuArrM.count; i++) {
            MBSwipCellMenuItem *item = self.menuArrM[i];
            UIButton *btn = self.menuButtons[i];
            
            btn.frame = CGRectMake(itemX, 0, item.itemWidth, self.contentView.frame.size.height);
            _menuWidth += item.itemWidth;
            itemX = itemX + item.itemWidth;
            
        }
    }
    
    self.containerView.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds), 0, _menuWidth, CGRectGetHeight(self.contentView.bounds));
}

#pragma mark - 事件操作

// 关闭左滑，恢复原状
- (void)closeLeftSwipe {
    if (!self.isOpenLeft) return; //还未打开左滑，不需要执行右滑
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
        // 放大
        self.contentView.center = CGPointMake(SCREENWIDTH * 0.5, self.contentView.bounds.size.height * 0.5);
        self.containerView.frame = CGRectMake(self.frame.size.width, 0, _menuWidth, CGRectGetHeight(self.contentView.bounds));

    } completion:nil];
    self.isOpenLeft = NO;
}

- (void)addMenuItems:(NSArray<MBSwipCellMenuItem *> *)items {
    self.menuArrM = [NSMutableArray arrayWithArray:items];
    [self initialMenuView];
}

- (void)initialMenuView {
    
    UIView *containerView = [[UIView alloc] init];
    self.containerView = containerView;
    self.containerView.backgroundColor = [UIColor clearColor];
    
    NSUInteger buttonIdx = 0;
    self.menuButtons = [NSMutableArray array];
    for (MBSwipCellMenuItem *item in self.menuArrM) {
        UIButton *btn = [UIButton buttonWithItem:item];
        btn.tag = kMENUBUTTON_TAG + buttonIdx;
        [self.containerView addSubview:btn];
        buttonIdx ++;
        [self.menuButtons addObject:btn];
        [btn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.contentView addGestureRecognizer:rightPan];
    self.rightPanGesture = rightPan;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone; //设置单元格选中样式
    
    [self insertSubview:containerView belowSubview:self.contentView];
    
}

- (void)menuBtnClick:(UIButton *)btn {
    if (self.autoClose) {
        [self closeLeftSwipe];
    }
    MBSwipCellMenuItem *item = self.menuArrM[btn.tag - kMENUBUTTON_TAG];
    if (item.handler) {
        item.handler(item);
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            for (UIView* next = [self superview]; next; next = next.superview) {
                UIResponder *nextResponder = [next nextResponder];
                if ([nextResponder isKindOfClass:[UITableView class]]) {
                    NSArray *cells = [(UITableView *)nextResponder visibleCells];
                    for (MBBaseTableViewCell *cell in cells) {
                        if ([cell isEqual:self]) {
                            continue;
                        }
                        [cell closeLeftSwipe];
                    }
                    break;
                }
            }
            
            _lastMovePoint = CGPointMake(0, 0);
            _beginPoint = [pan locationInView:self.contentView];
            _isMoveToLeft = NO;
            _lockMoveRight = NO;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (_lockMoveRight) {
                self.contentView.center = CGPointMake(self.center.x + 20, self.contentView.center.y);
                return;
            }
            CGPoint point = [pan locationInView:self.contentView];
            _isMoveToLeft = (point.x - _lastMovePoint.x) > 0;
            _lastMovePoint = point;
            
            CGFloat pointChangeX = _beginPoint.x - point.x;
            CGFloat contentViewX = self.contentView.center.x - pointChangeX;
            
            CGFloat containerViewX = self.containerView.frame.origin.x - pointChangeX;
            if (containerViewX <= (self.contentView.frame.size.width - _menuWidth)) {
                containerViewX = self.contentView.frame.size.width - _menuWidth;
            }
            self.containerView.frame = CGRectMake(containerViewX, 0, _menuWidth, CGRectGetHeight(self.contentView.bounds));
            if (!self.isOpenLeft && !_isMoveToLeft && contentViewX >= self.center.x + 20) {
                _lockMoveRight = YES;
                _lastMovePoint = CGPointMake(0, 0);
                _beginPoint = [pan locationInView:self.contentView];
                _isMoveToLeft = NO;
                self.isOpenLeft = NO;
                return;
            } else {
                self.contentView.center = CGPointMake(contentViewX, self.contentView.center.y);
            }
            NSLog(@"%@", @(_beginPoint.x - point.x));
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        {
            if (!_isMoveToLeft) {
                [self closeLeftSwipe];
            }
            if (self.contentView.center.x <= (self.center.x - _menuWidth * 0.5)) {
                self.isOpenLeft = YES;
                
                [UIView animateWithDuration:0.35 animations:^{
                    self.contentView.center = CGPointMake(self.center.x - _menuWidth, self.contentView.bounds.size.height * 0.5);
                    self.containerView.frame = CGRectMake(self.frame.size.width - _menuWidth, 0, _menuWidth, CGRectGetHeight(self.contentView.bounds));
                }];
            } else {
                
                self.isOpenLeft = NO;
                _isMoveToLeft = NO;
                [UIView animateWithDuration:0.35 animations:^{
                    self.contentView.center = CGPointMake(self.center.x, self.contentView.bounds.size.height * 0.5);
                    self.containerView.frame = CGRectMake(self.frame.size.width, 0, _menuWidth, CGRectGetHeight(self.contentView.bounds));
                }];
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        switch (gestureRecognizer.state)
        {
            case UIGestureRecognizerStateBegan:
            {
                UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
                CGPoint velocity = [pan velocityInView:self];
                CGFloat Vx = fabs(velocity.x);
                CGFloat Vy = fabs(velocity.y);
                
                return !(Vx > Vy - 50.0 || Vy < 400.0 || Vx > 500.0);
            }
                break;
                
            case UIGestureRecognizerStateChanged:
                return NO;
                break;
                
            default:
                break;
        }
    }
    
    return YES;
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
