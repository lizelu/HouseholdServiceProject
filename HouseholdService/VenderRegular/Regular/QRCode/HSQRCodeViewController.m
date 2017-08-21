//
//  HSQRCodeViewController.m
//  HouseholdService
//
//  Created by Mr.LuDashi on 2017/5/11.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

#import "HSQRCodeViewController.h"

@import AVFoundation;

static NSInteger const kInterestWidth = 250;//扫描区域的宽度
static NSInteger const kInterestHeight = 250;//扫描区域的高度

@interface HSQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice *device;

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureDeviceInput *input;

@property (nonatomic, strong) AVCaptureMetadataOutput *output;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewlayer;

@property (nonatomic, assign) BOOL isCaptured;

@property (nonatomic, assign) CGRect scanRect;

@property (nonatomic, strong) UIView *scanmaskView;

@property (nonatomic, strong) CAShapeLayer *outnerShaperLayer;

@property (nonatomic, strong) CAShapeLayer *innerShaperLayer;

@property (nonatomic, strong) NSTimer *scanTimer;

@property (nonatomic, strong) UIImageView *lineImageView;

@property (nonatomic, strong) UILabel *noteLabel;

@end

@implementation HSQRCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self requestAuthorization];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if (_captureSession.isRunning == NO)
    {
        [_captureSession startRunning];
    }
    [self startTimer];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_captureSession.isRunning == YES)
    {
        [_captureSession stopRunning];
    }
    [self stopTimer];
}


- (void)initUI
{
    self.isCaptured = NO;
    self.title = @"扫描二维码";

    [self.view addSubview:self.scanmaskView];
    [self.view addSubview:self.lineImageView];
    [self.view addSubview:self.noteLabel];
}


- (void)requestAuthorization
{
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authorizationStatus)
    {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler: ^(BOOL granted) {
                if (granted) {
                    [self startScan];
                } else {
                    NSLog(@"提示访问受限");
                }
            }];
            break;
        }
            
        case AVAuthorizationStatusAuthorized:
        {
            [self startScan];
            break;
        }
            
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
        {
            NSLog(@"提示访问受限");
            break;
        }
            
        default:
            break;
        
    }
}


- (void)moveLineImageView
{
    CGFloat y1 = self.scanRect.origin.y + 5.0;
    CGFloat y2 = CGRectGetMaxY(self.scanRect) - 5.0;
    __block CGRect rect = self.lineImageView.frame;
    rect = CGRectMake(rect.origin.x, y1, rect.size.width, rect.size.height);
    self.lineImageView.frame = rect;
    [UIView animateWithDuration:2.5 animations:^{
        rect = CGRectMake(rect.origin.x, y2, rect.size.width, rect.size.height);
        self.lineImageView.frame = rect;
    }];
}


- (void)startTimer
{
    [self moveLineImageView];
    self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(moveLineImageView) userInfo:nil repeats:YES];
}


- (void)stopTimer
{
    if (self.scanTimer.valid == NO)
    {
        [self.scanTimer invalidate];
        self.scanTimer = nil;
    }
}


- (void)startScan
{
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    if (!_input) {
        return;
    }
    
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _captureSession = [[AVCaptureSession alloc]init];
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    [_captureSession addInput:_input];
    [_captureSession addOutput:_output];
    
    _output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
    
    _previewlayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    _previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewlayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view.layer insertSublayer:_previewlayer atIndex:0];
    
    //在iOS7中下面方法有问题(该方法在观察某个通知的回调中)，iOS9正常，所以直接设置rectOfInterest
    //self.output.rectOfInterest = [self.previewlayer metadataOutputRectOfInterestForRect:self.scanRect];
    [_output setRectOfInterest:CGRectMake(self.scanRect.origin.y / [UIScreen mainScreen].bounds.size.height, self.scanRect.origin.x / [UIScreen mainScreen].bounds.size.width, self.scanRect.size.height / [UIScreen mainScreen].bounds.size.height, self.scanRect.size.width / [UIScreen mainScreen].bounds.size.width)];

    //开始捕获
    [_captureSession startRunning];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0 && !_isCaptured)
    {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex : 0 ];
        if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode])
        {
            self.isCaptured = YES;
            [_captureSession stopRunning];
            [self stopTimer];
            //输出扫描字符串
            NSLog(@"扫描结果:%@",metadataObject.stringValue);
            if ([self.delegate respondsToSelector:@selector(QRCodeViewController:readResult:)])
            {
                [self.delegate QRCodeViewController:self readResult:metadataObject.stringValue];
            }
        }
    }
}



#pragma mark - setter and getter
- (CGRect)scanRect
{
    CGRect rect = CGRectZero;
    
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - kInterestWidth) / 2.0;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height - 64.0 - kInterestWidth) / 2.0;
    rect = CGRectMake(x, y, kInterestWidth, kInterestHeight);
    
    return rect;
}


- (UIView *)scanmaskView
{
    if (!_scanmaskView)
    {
        _scanmaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _scanmaskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        [rectPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:self.scanRect cornerRadius:0] bezierPathByReversingPath]];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = rectPath.CGPath;
        
        _scanmaskView.layer.mask = shapeLayer;
        
        [_scanmaskView.layer addSublayer:self.outnerShaperLayer];
        [_scanmaskView.layer addSublayer:self.innerShaperLayer];
        
    }
    return _scanmaskView;
}


- (CAShapeLayer *)outnerShaperLayer
{
    if (!_outnerShaperLayer)
    {
        UIBezierPath *outPath = [UIBezierPath bezierPathWithRect:self.scanRect];
        
        _outnerShaperLayer = [CAShapeLayer layer];
        _outnerShaperLayer.strokeColor = [UIColor whiteColor].CGColor;
        _outnerShaperLayer.fillColor = [UIColor clearColor].CGColor;
        _outnerShaperLayer.lineWidth = 1;
        _outnerShaperLayer.lineJoin = kCALineJoinRound;
        _outnerShaperLayer.lineCap = kCALineCapRound;
        _outnerShaperLayer.path = outPath.CGPath;
        
    }
    return _outnerShaperLayer;
}


- (CAShapeLayer *)innerShaperLayer
{
    if (!_innerShaperLayer)
    {
        CGFloat conerLineLength = 20.0;
        CGFloat conerLineWidth = 6.0;
        UIBezierPath *innerPath = [[UIBezierPath alloc]init];
        //左上角
        [innerPath moveToPoint:CGPointMake(self.scanRect.origin.x, self.scanRect.origin.y + conerLineLength)];
        [innerPath addLineToPoint:CGPointMake(self.scanRect.origin.x, self.scanRect.origin.y)];
        [innerPath addLineToPoint:CGPointMake(self.scanRect.origin.x + conerLineLength, self.scanRect.origin.y)];
        //右上角
        [innerPath moveToPoint:CGPointMake(CGRectGetMaxX(self.scanRect) - conerLineLength, CGRectGetMinY(self.scanRect))];
        [innerPath addLineToPoint:CGPointMake(CGRectGetMaxX(self.scanRect), CGRectGetMinY(self.scanRect))];
        [innerPath addLineToPoint:CGPointMake(CGRectGetMaxX(self.scanRect), CGRectGetMinY(self.scanRect) + conerLineLength)];
        //右下角
        [innerPath moveToPoint:CGPointMake(CGRectGetMaxX(self.scanRect), CGRectGetMaxY(self.scanRect) - conerLineLength)];
        [innerPath addLineToPoint:CGPointMake(CGRectGetMaxX(self.scanRect), CGRectGetMaxY(self.scanRect))];
        [innerPath addLineToPoint:CGPointMake(CGRectGetMaxX(self.scanRect) - conerLineLength, CGRectGetMaxY(self.scanRect))];
        //左下角
        [innerPath moveToPoint:CGPointMake(CGRectGetMinX(self.scanRect) + conerLineLength, CGRectGetMaxY(self.scanRect))];
        [innerPath addLineToPoint:CGPointMake(CGRectGetMinX(self.scanRect), CGRectGetMaxY(self.scanRect))];
        [innerPath addLineToPoint:CGPointMake(CGRectGetMinX(self.scanRect), CGRectGetMaxY(self.scanRect) - conerLineLength)];
        
        _innerShaperLayer = [CAShapeLayer layer];
        _innerShaperLayer.strokeColor = HEXCOLOR(0xE1C078).CGColor;
        _innerShaperLayer.fillColor = [UIColor clearColor].CGColor;
        _innerShaperLayer.lineWidth = conerLineWidth;
        _innerShaperLayer.lineJoin = kCALineJoinMiter;
        _innerShaperLayer.lineCap = kCALineCapSquare;
        _innerShaperLayer.path = innerPath.CGPath;
    }
    return _innerShaperLayer;
}


- (UIImageView *)lineImageView
{
    if (!_lineImageView)
    {
        CGFloat width = 200.0;
        CGFloat x = self.scanRect.origin.x + (kInterestWidth - width) / 2.0;
        CGFloat y = self.scanRect.origin.y + 5.0;
        _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, 2.0)];
        _lineImageView.backgroundColor = HEXCOLOR(0xE1C078);
    }
    return _lineImageView;
}


- (UILabel *)noteLabel
{
    if (!_noteLabel)
    {
        _noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.scanRect) + 20.0, [UIScreen mainScreen].bounds.size.width, 25)];
        _noteLabel.text = @"将二维码放入扫描框即可自动扫描";
        _noteLabel.textAlignment = NSTextAlignmentCenter;
        _noteLabel.textColor = [UIColor whiteColor];
    }
    return _noteLabel;
}

@end
