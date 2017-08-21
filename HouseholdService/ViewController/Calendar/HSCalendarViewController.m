//
//  HSCalendarViewController.m
//  HouseholdService
//
//  Created by Mr.LuDashi on 2017/5/22.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

#import "HSCalendarViewController.h"
#import "HSCalendarCell.h"
#import "FSCalendarExtensions.h"
#import "FSCalendar.h"

@interface HSCalendarViewController () <FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) FSCalendar *calendar;

- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;

@end

@implementation HSCalendarViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"选择日期";
        _selectDateArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, height)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.swipeToChooseGesture.enabled = NO;
    calendar.allowsMultipleSelection = YES;
    [view addSubview:calendar];
    self.calendar = calendar;
    
    calendar.calendarHeaderView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    calendar.calendarWeekdayView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    calendar.appearance.eventSelectionColor = [UIColor whiteColor];
    calendar.appearance.eventOffset = CGPointMake(0, -7);
    calendar.today = nil; // Hide the today circle
    [calendar registerClass:[HSCalendarCell class] forCellReuseIdentifier:@"cell"];
    
   // UIPanGestureRecognizer *scopeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:calendar action:@selector(handleScopeGesture:)];
    //[calendar addGestureRecognizer:scopeGesture];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    //[self.calendar selectDate:[self.gregorian dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:[NSDate date] options:0] scrollToDate:NO];
    //[self.calendar selectDate:[NSDate date] scrollToDate:NO];
    //[self.calendar selectDate:[self.gregorian dateByAddingUnit:NSCalendarUnitDay value:1 toDate:[NSDate date] options:0] scrollToDate:NO];
    
    // Uncomment this to perform an 'initial-week-scope'
    // self.calendar.scope = FSCalendarScopeWeek;
    
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate new];
    //return [self.dateFormatter dateFromString:@"2016-07-08"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:5 toDate:[NSDate date] options:0];
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @"今";
    }
    return nil;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    HSCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    return 2;
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    if (_selectDateArray.count < 3) {
        NSString * dateStr = [self.dateFormatter stringFromDate:date];
        [_selectDateArray addObject:dateStr];
        NSLog(@"did select date %@", dateStr);
         [self configureVisibleCells];
    } else {
        [self.calendar deselectDate:date];
    }
    
    
   
   
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    NSString * dateStr = [self.dateFormatter stringFromDate:date];
    if ([_selectDateArray containsObject: dateStr]) {
        [_selectDateArray removeObject:dateStr];
        NSLog(@"did deselect date %@",dateStr);
    }
    [self configureVisibleCells];
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @[[UIColor orangeColor]];
    }
    return @[[UIColor redColor]];//@[appearance.eventDefaultColor];
}

#pragma mark - Private methods

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}

- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    HSCalendarCell *diyCell = (HSCalendarCell *)cell;
    
    // Custom today circle
    diyCell.circleImageView.hidden = ![self.gregorian isDateInToday:date];
   
    // Configure selection layer
    if (monthPosition == FSCalendarMonthPositionCurrent) {
        
        SelectionType selectionType = SelectionTypeNone;
        if ([self.calendar.selectedDates containsObject:date]) {
            selectionType = SelectionTypeSingle;
            
        } else {
            selectionType = SelectionTypeNone;
        }
        
        if (selectionType == SelectionTypeNone) {
            diyCell.selectionLayer.hidden = YES;
            return;
        }
        
        diyCell.selectionLayer.hidden = NO;
        diyCell.selectionType = selectionType;
        
    } else {
        
        diyCell.circleImageView.hidden = YES;
        diyCell.selectionLayer.hidden = YES;
        
    }
}

@end
