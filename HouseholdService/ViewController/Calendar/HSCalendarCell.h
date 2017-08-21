//
//  HSCalendarCell.h
//  HouseholdService
//
//  Created by Mr.LuDashi on 2017/5/22.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

#import "FSCalendar.h"
typedef NS_ENUM(NSUInteger, SelectionType) {
    SelectionTypeNone,
    SelectionTypeSingle,
};


@interface HSCalendarCell : FSCalendarCell

@property (weak, nonatomic) UIImageView *circleImageView;

@property (weak, nonatomic) CAShapeLayer *selectionLayer;

@property (assign, nonatomic) SelectionType selectionType;

@end
