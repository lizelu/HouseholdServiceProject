//
//  HSCalendarCell.m
//  HouseholdService
//
//  Created by Mr.LuDashi on 2017/5/22.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

#import "HSCalendarCell.h"
#import "FSCalendarExtensions.h"

@implementation HSCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *circleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle"]];
        [self.contentView insertSubview:circleImageView atIndex:0];
        self.circleImageView = circleImageView;
        
        CAShapeLayer *selectionLayer = [[CAShapeLayer alloc] init];
        selectionLayer.fillColor = [[UIColor orangeColor] colorWithAlphaComponent:1].CGColor;
        selectionLayer.actions = @{@"hidden":[NSNull null]};
        [self.contentView.layer insertSublayer:selectionLayer below:self.titleLabel.layer];
        self.selectionLayer = selectionLayer;
        
        self.shapeLayer.hidden = YES;
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = CGRectInset(self.bounds, 1, 1);
    self.circleImageView.frame = self.backgroundView.frame;
    self.selectionLayer.frame = self.bounds;
    
    CGFloat diameter = MIN(self.selectionLayer.fs_height, self.selectionLayer.fs_width);
    self.selectionLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.contentView.fs_width/2-diameter/2, self.contentView.fs_height/2-diameter/2, diameter, diameter)].CGPath;
    
  }

- (void)configureAppearance
{
    [super configureAppearance];
    // Override the build-in appearance configuration
    if (self.isPlaceholder) {
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.eventIndicator.hidden = YES;
    }
}

- (void)setSelectionType:(SelectionType)selectionType
{
    if (_selectionType != selectionType) {
        _selectionType = selectionType;
        [self setNeedsLayout];
    }
}

@end
