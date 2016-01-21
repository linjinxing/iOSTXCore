//
//  LJXLockView.m
//  LockSample
//
//  Created by Lugede on 14/11/11.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "LJXLockView.h"

#define kLLBaseCircleNumber 10000       // tag基数（请勿修改）
#define kCircleDiameter 60.0            // 圆点直径
#define kLLCircleAlpha 1.0              // 圆点透明度
#define kLLLineWidth 2.0               // 线条宽
#define kLLLineColor [UIColor colorWithRed:28.0/255.0 green:176.0/255.0 blue:142.0/255.0 alpha:1] // 线条色蓝
#define kLLLineColorWrong [UIColor colorWithRed:201.0/255.0 green:9.0/255.0 blue:22.0/255.0 alpha:0.8] // 线条色红

@interface LJXLockView ()
{
    NSMutableArray* buttonArray;
    NSMutableArray* selectedButtonArray;
    NSMutableArray* wrongButtonArray;
    CGPoint nowPoint;
    
    NSTimer* timer;
    
    BOOL isWrongColor;
    BOOL isDrawing; // 正在画中
}

@end

@implementation LJXLockView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        [self initCircles];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.clipsToBounds = YES;
        [self initCircles];
    }
    return self;
}

- (void)initCircles
{
    buttonArray = [NSMutableArray array];
    selectedButtonArray = [NSMutableArray array];
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    CGFloat marginX = (viewWidth - 3*kCircleDiameter)/2;//x方向边距
    CGFloat marginY = (viewHeight - 3*kCircleDiameter)/2;//y方向边距
    
    // 初始化圆点
    for (int i = 0; i < 9; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        int x = (i%3) * (kCircleDiameter + marginX);
        int y = (i/3) * (kCircleDiameter + marginY);
//        LLLog(@"每个圆点位置 %d,%d", x, y);
        [button setFrame:CGRectMake(x, y, kCircleDiameter, kCircleDiameter)];
        
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"gestures_w"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"gestures_g"] forState:UIControlStateSelected];

        button.userInteractionEnabled= NO;//禁止用户交互
        button.alpha = kLLCircleAlpha;
        button.tag = i + kLLBaseCircleNumber + 1; // tag从基数+1开始,
        [self addSubview:button];
        [buttonArray addObject:button];
    }
    
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - 事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isDrawing = NO;
    // 如果是错误色才重置(timer重置过了)
    if (isWrongColor) {
        [self clearColorAndSelectedButton];
    }
    CGPoint point = [[touches anyObject] locationInView:self];
    [self updateFingerPosition:point];
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    isDrawing = YES;
    
    CGPoint point = [[touches anyObject] locationInView:self];
    [self updateFingerPosition:point];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"输入密码结束");
    [self endPosition];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"输入密码取消");
    [self endPosition];
}


#pragma mark - 绘制连线
- (void)drawRect:(CGRect)rect
{
//    NSLog(@"drawRect - %@", [NSString stringWithFormat:@"%d", isWrongColor]);
    
    if (selectedButtonArray.count > 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        isWrongColor ? [kLLLineColorWrong set] : [kLLLineColor set]; // 正误线条色
        CGContextSetLineWidth(context, kLLLineWidth);

        // 画之前线s
        CGPoint addLines[9];
        int count = 0;
        for (UIButton* button in selectedButtonArray) {
            CGPoint point = CGPointMake(button.center.x, button.center.y);
            addLines[count++] = point;
            
            // 画中心圆
            CGRect circleRect = CGRectMake(button.center.x- kLLLineWidth/2,
                                           button.center.y - kLLLineWidth/2,
                                           kLLLineWidth,
                                           kLLLineWidth);
            CGContextSetFillColorWithColor(context, kLLLineColor.CGColor);
            CGContextFillEllipseInRect(context, circleRect);
        }
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextAddLines(context, addLines, count);
        CGContextStrokePath(context);
         //*/
        
        // 画当前线
        UIButton* lastButton = selectedButtonArray.lastObject;
        CGContextMoveToPoint(context, lastButton.center.x, lastButton.center.y);
        CGContextAddLineToPoint(context, nowPoint.x, nowPoint.y);
        CGContextStrokePath(context);
    }
    
}

#pragma mark - 处理
// 当前手指位置
- (void)updateFingerPosition:(CGPoint)point{
    
    nowPoint = point;
    
//    LLLog(@"point x=%f, y=%f", point.x, point.y);
    
    for (UIButton *thisbutton in buttonArray) {
        CGFloat xdiff =point.x-thisbutton.center.x;
        CGFloat ydiff=point.y - thisbutton.center.y;
        
        if (fabs(xdiff) <36 &&fabs (ydiff) <36){
            
//            LLLog(@"now point is %d th",thisbutton.tag-kLLBaseCircleNumber);
            //             LLLog(@"%@", [resulttext.text stringByAppendingString:resulttext.text]);
            
            // 未选中的才能加入
            if (!thisbutton.selected) {
                thisbutton.selected = YES;
                [selectedButtonArray  addObject:thisbutton];
                [self makeButtonTransform];
            }
        }
    }
    [self setNeedsDisplay];
    
//    [self addstring]; // 可以用来划完后自动解锁，不用松开手指
}

- (void)endPosition
{
    isDrawing = NO;
    
    UIButton *strbutton;
    NSString *string=@"";
    
    // 生成密码串
    for (int i=0; i < selectedButtonArray.count; i++) {
        strbutton = selectedButtonArray[i];
        string= [string stringByAppendingFormat:@"%ld",strbutton.tag-kLLBaseCircleNumber];
    }
    
    [self clearColorAndSelectedButton]; // 清除到初始样式
    
    if ([self.delegate respondsToSelector:@selector(lockString:)]) {
        if (string && string.length>0) {
            [self.delegate lockString:string];
        }
    }
    
//    NSLog(@"addstring end Position");
//    [self addstring]; // 委托上一界面去处理
    
//    NSLog(@"end Position");
    
}

// 清除至初始状态
- (void)clearColor
{
    if (isWrongColor) {
//        NSLog(@"clearColorAndSelectedButton");
        // 重置颜色
        isWrongColor = NO;
        for (UIButton* button in buttonArray) {
            [button setBackgroundImage:[UIImage imageNamed:@"gestures_g"] forState:UIControlStateSelected];
        }
        
    }
}

- (void)clearSelectedButton
{
    // 换到下次按时再弄
    for (UIButton *thisButton in buttonArray) {
        [thisButton setSelected:NO];
    }
    [selectedButtonArray removeAllObjects];
    
    [self clearButtonTransform];
    
    [self setNeedsDisplay];
}

- (void)clearColorAndSelectedButton
{
    if (!isDrawing) {
        [self clearColor];
        [self clearSelectedButton];
    }
    
}

#pragma mark - 生成密码
-(void)addstring{
    
}

#pragma mark - 显示错误
- (void)showErrorCircles:(NSString*)string
{
//    NSLog(@"ShowError");

    isWrongColor = YES;
    
    NSMutableArray* numbers = [[NSMutableArray alloc] initWithCapacity:string.length];
    for (int i = 0; i < string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSNumber* number = [NSNumber numberWithInt:[string substringWithRange:range].intValue-1]; // 数字是1开始的
        [numbers addObject:number];
        [buttonArray[number.intValue] setSelected:YES];
        
        [selectedButtonArray addObject:buttonArray[number.intValue]];
    }
    
    for (UIButton* button in buttonArray) {
        if (button.selected) {
            [button setBackgroundImage:[UIImage imageNamed:@"circle_wrong"] forState:UIControlStateSelected];
        }
        
    }
    
    [self setNeedsDisplay];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(clearColorAndSelectedButton)
                                           userInfo:nil
                                            repeats:NO];
    
}


#pragma mark - 旋转按钮调整箭头方向
-(void)clearButtonTransform {
    for (UIButton *btn in buttonArray) {
        [btn setTransform:CGAffineTransformMakeRotation(0)];
        [btn setImage:nil forState:UIControlStateSelected];
    }
}

-(void)makeButtonTransform {
    NSInteger btnCount = selectedButtonArray.count;
    if (btnCount < 2) {
        return;
    }
    UIButton *currentBtn = selectedButtonArray[btnCount - 2];
    UIImage *arrowImage = [UIImage imageNamed:@"gestures_arrow1"];
    [currentBtn setImage:arrowImage forState:UIControlStateSelected];
    
    UIButton *nextBtn =  selectedButtonArray[btnCount - 1];

    CGFloat currentBtnX = currentBtn.frame.origin.x;
    CGFloat currentBtnY = currentBtn.frame.origin.y;
    CGFloat newBtnX = nextBtn.frame.origin.x;
    CGFloat newBtnY = nextBtn.frame.origin.y;


    if (LJXFloatIsEqual(currentBtnY, newBtnY)) {
        //Y坐标相等
        if (currentBtnX > newBtnX) {
            //箭头向左
            LJXFoundationLog("箭头向左");
            [currentBtn setTransform:CGAffineTransformMakeRotation(M_PI)];
        }else if (currentBtnX < newBtnX){
            //箭头向右
            LJXFoundationLog("箭头向右");
            [currentBtn setTransform:CGAffineTransformMakeRotation(0)];
        }
        
    }else if (LJXFloatIsEqual(currentBtnX, newBtnX)) {
        //X坐标相等
        if (currentBtnY > newBtnY) {
            //箭头向上
            LJXFoundationLog("箭头向上");
            [currentBtn setTransform:CGAffineTransformMakeRotation(3*M_PI_2)];
        }else if (currentBtnY < newBtnY){
            //箭头向下
             LJXFoundationLog("箭头向下");
            [currentBtn setTransform:CGAffineTransformMakeRotation(M_PI_2)];
        }

    }else
    {
        //x,y坐标都不相等，对角线上
        if (currentBtnY < newBtnY && currentBtnX < newBtnX) {
            //箭头右下方
            LJXFoundationLog("箭头右下方");
            [currentBtn setTransform:CGAffineTransformMakeRotation(M_PI_4*1)];
 
        }else if (currentBtnY < newBtnY && currentBtnX > newBtnX) {
            //箭头左下方
            LJXFoundationLog("箭头左下方");
            [currentBtn setTransform:CGAffineTransformMakeRotation(M_PI_4*3)];

        }else if (currentBtnY > newBtnY && currentBtnX < newBtnX) {
            //箭头向右上方
            LJXFoundationLog("箭头向右上方");
            [currentBtn setTransform:CGAffineTransformMakeRotation(M_PI_4*7)];
            
        }else if (currentBtnY > newBtnY && currentBtnX > newBtnX) {
            //箭头向左上方
            LJXFoundationLog("箭头向左上方");
            [currentBtn setTransform:CGAffineTransformMakeRotation(M_PI_4*5)];
        }
    }
}



@end
