//
//  YuriCodeScanView.m
//  YuriCodeScanner
//
//  Created by 张晓飞 on 16/3/11.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#import "YuriCodeScanView.h"
#import "YuriAlertView.h"

@interface YuriCodeScanView() <AVCaptureMetadataOutputObjectsDelegate> {
    
}

@property (nonatomic, copy) ResultBlock block;

@property (nonatomic, weak) UIImageView *codeImageView;
@property (nonatomic, weak) UILabel *tipLabel;
@property (nonatomic, weak) UIImageView *lineImageView;

@property (nonatomic, strong) AVCaptureDevice *acDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *acInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *acOutput;
@property (nonatomic, strong) AVCaptureSession *acSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *acPreview;

@end

@implementation YuriCodeScanView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *codeImageView = [[UIImageView alloc]init];
        codeImageView.userInteractionEnabled = YES;
        codeImageView.image = [UIImage imageNamed:@"扫一扫"];
        [self addSubview:codeImageView];
        self.codeImageView = codeImageView;
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:15.f];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.tipLabel = label;
        
        UIImageView *line = [[UIImageView alloc] init];
        line.image = [UIImage imageNamed:@"线"];
        [self addSubview:line];
        self.lineImageView = line;
        
        
        CGFloat codeH = kScanViewWidth;
        CGFloat codeW = codeH;
        CGFloat codeX = (kScreenWidth - codeH) * 0.5;
        CGFloat codeY = kScanOriginY;
        self.codeImageView.frame = CGRectMake(codeX, codeY, codeW, codeH);
        
        
        CGFloat labelX = 20;
        CGFloat labelY = CGRectGetMaxY(self.codeImageView.frame) + 20;
        CGFloat labelW = (kScreenWidth - labelX * 2.0);
        NSDictionary *attrs = @{NSFontAttributeName : self.tipLabel.font};
        CGFloat labelH = [self.tipLabel.text boundingRectWithSize:CGSizeMake(labelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
        self.tipLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        CGFloat lineX = codeX;
        CGFloat lineY = codeY;
        CGFloat lineW = codeW;
        CGFloat lineH = 3;
        self.lineImageView.frame = CGRectMake(lineX, lineY, lineW, lineH);
    }
    return self;
}

+ (instancetype)scanView {
    
    YuriCodeScanView *scanView = [[YuriCodeScanView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    return scanView;
    
}

+ (instancetype)scanViewWithFrame:(CGRect)frame {
    YuriCodeScanView *scanView = [[YuriCodeScanView alloc] initWithFrame:frame];
    return scanView;
}

- (void)beginScanning {
    self.acDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.acInput = [AVCaptureDeviceInput deviceInputWithDevice:self.acDevice error:nil];
    if (self.acInput == nil) {
        YuriAlertView *alertView = [[YuriAlertView alloc] initChoiceTipAlertWithMessage:@"设备不可用" completion:^(NSInteger index) {
            
        }];
        /*
         * Are U kidding me?
         */
        alertView = alertView;
        return;
    }
    
    self.acOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.acOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.acOutput.rectOfInterest= CGRectMake(kScanOriginY/kScreenHeight,(kScreenWidth - kScanViewWidth)/(2*kScreenWidth),kScanViewWidth/kScreenHeight, kScanViewWidth/kScreenWidth);
    
    self.acSession = [[AVCaptureSession alloc] init ];
    [self.acSession setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.acSession canAddInput:self.acInput]) {
        [self.acSession addInput:self.acInput];
    }
    if ([self.acSession canAddOutput:self.acOutput ]) {
        [self.acSession addOutput:self.acOutput];
    }
    
    self.acOutput.metadataObjectTypes = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];
    self.acPreview = [AVCaptureVideoPreviewLayer layerWithSession:self.acSession];
    self.acPreview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.acPreview.videoGravity = AVLayerVideoGravityResizeAspectFill ;
    [self.layer insertSublayer:self.acPreview atIndex:0];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScanOriginY)];
    topView.alpha = 0.5;
    topView.backgroundColor = [UIColor blackColor];
    [self addSubview:topView];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), (kScreenWidth - kScanViewWidth) / 2, (kScreenHeight - kScanOriginY))];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame)+kScanViewWidth, CGRectGetMaxY(topView.frame), (kScreenWidth - kScanViewWidth)/2, kScreenHeight - kScanOriginY)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self addSubview:rightView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame), (kScanOriginY + kScanViewWidth), (kScreenWidth - CGRectGetWidth(leftView.frame) * 2), (kScreenHeight -kScanOriginY - kScanViewWidth))];
//    bottomView.alpha = 0.5;
    bottomView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5f];
    [self addSubview:bottomView];
    
    UILabel *bottomTextLabel = [[UILabel alloc] init];
    bottomTextLabel.text = @"放入框内，自动扫描";
    bottomTextLabel.textColor = [UIColor whiteColor];
    bottomTextLabel.textAlignment = NSTextAlignmentCenter;
    bottomTextLabel.frame = CGRectMake(0, 10, bottomView.frame.size.width, 30);
    [bottomView addSubview:bottomTextLabel];
    
    [self.acSession startRunning];
    [self beginViewAnimate];
}

- (void)beginViewAnimate {
    
    [UIView animateWithDuration:3.0 animations:^{
        CGRect f = self.lineImageView.frame;
        f.origin.y = CGRectGetMaxY(self.codeImageView.frame) - 3;
        self.lineImageView.frame = f;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:3.0 animations:^{
            CGRect f = self.lineImageView.frame;
            f.origin.y = self.codeImageView.frame.origin.y;
            self.lineImageView.frame = f;
        } completion:^(BOOL finished) {
            [self beginViewAnimate];
        }];
    }];
    
}

- (void)outputResultString:(ResultBlock)result {
    self.block = result;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if ([metadataObjects count] > 0) {
        //[self.acSession stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        NSString *stringValue = metadataObject.stringValue;
        if (self.block) {
            self.block(stringValue);
        }
        if (self.autoRemoveScanView) {
            [self removeFromSuperview];
        }
    }
}

- (void)setTipMessage:(NSString *)tipMessage {
    _tipMessage = tipMessage;
    self.tipLabel.text = tipMessage;
}

- (void)setAutoRemoveScanView:(BOOL)autoRemoveScanView {
    _autoRemoveScanView = autoRemoveScanView;
}

- (void)hidScanView {
    [self removeFromSuperview];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
