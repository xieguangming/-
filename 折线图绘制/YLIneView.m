//
//  YLIneView.m
//  折线图绘制
//
//  Created by AS150701001 on 16/6/27.
//  Copyright © 2016年 lele. All rights reserved.
//

#import "YLIneView.h"
#import "UIView+Extension.h"
#define kStartX  20.0
#define kBottomHeight  30.0  // x 轴距离底部高度
#define kTopMargin    80.0   // y 轴距离顶部的高度
#define kLabelHeight  44.0
@interface YLIneView()
@property(nonatomic,assign)CGPoint perviousPoint;
@end
@implementation YLIneView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        // 顶部 label
        UILabel* textLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44.0)];
        textLabel.text=@"充电中";
        textLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:textLabel];
        // 做端文字 label
        UILabel* titleLabel=[[UILabel alloc] init];
        titleLabel.text=@"(度数)";
        titleLabel.font=[UIFont systemFontOfSize:12];
        [titleLabel sizeToFit];
        titleLabel.yl_y=textLabel.yl_bottom;
        [self addSubview:titleLabel];
    }
    return self;
}

-(void)setXValues:(NSArray *)xValues
{
    _xValues=xValues;
    [self setNeedsDisplay];
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues=yValues;
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect
{
    // 间距
    CGFloat x_space=(rect.size.width - 10 - 5 - 20) / self.xKeDuValus.count;
    CGFloat y_space=(rect.size.height - kBottomHeight -  kTopMargin - 20) / self.yKeDuValus.count;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 画 x 轴
    UIBezierPath* path = [UIBezierPath bezierPath];
    CGPoint startA=CGPointMake(0, rect.size.height - kBottomHeight);
    CGPoint endA=CGPointMake(rect.size.width - 5, rect.size.height - kBottomHeight);
    [path moveToPoint:startA];
    [path addLineToPoint:endA];
    CGContextAddPath(ctx, path.CGPath);
    [[UIColor lightGrayColor] set];
    CGContextSetLineWidth(ctx, 1);
    // 渲染
    CGContextStrokePath(ctx);
    
    // 绘制右侧箭头图片
    UIImage *xImg=[UIImage imageNamed:@"right"];
    [xImg drawInRect:CGRectMake(rect.size.width-5 - 5, rect.size.height - 35, 8, 10)];

    /** 画 y 轴 */
    UIBezierPath* yPath=[UIBezierPath bezierPath];
    CGPoint yStart=CGPointMake(kStartX, rect.size.height - kBottomHeight);
    CGPoint yEnd=CGPointMake(kStartX,  kTopMargin);
    [yPath moveToPoint:yStart];
    [yPath addLineToPoint:yEnd];
    CGContextAddPath(ctx, yPath.CGPath);
    CGContextStrokePath(ctx);
    UIImage *yImg=[UIImage imageNamed:@"up"];
    [yImg drawInRect:CGRectMake(kStartX - 4, kTopMargin, 8, 10)];
    
    /** 画 y 轴坐标横线*/
    for (int i = 0; i < self.yKeDuValus.count; i++) {
        [[UIColor  lightGrayColor] setStroke];
        CGContextSetLineWidth(ctx, 1);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx,kStartX - 4 , rect.size.height - kBottomHeight - y_space * (i+1));
        CGContextAddLineToPoint(ctx,kStartX,rect.size.height - kBottomHeight - y_space * (i+1));
        CGContextDrawPath(ctx, kCGPathStroke);
        
        // 画数字
        NSString* yStr=[NSString stringWithFormat:@"%@",self.yKeDuValus[i]];
        CGSize size=[yStr sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
        [yStr drawInRect:CGRectMake(0, rect.size.height - 40 - y_space * (i + 1) , kBottomHeight, size.height) withAttributes:@{NSForegroundColorAttributeName : self.yValueColor}];
    }
    UIBezierPath* path1=[UIBezierPath bezierPath];
    endA=CGPointMake([self.xValues[0] intValue], [self.yValues[0] intValue]);
    startA=CGPointMake(kStartX, rect.size.height - kBottomHeight);
    [path1 moveToPoint:startA];
    
    /** 计算移到 y 轴的位置*/
    for (int i = 0; i < self.xValues.count; i++) {
        CGFloat X =kStartX + x_space * (i+1) ;//[xValue[i] intValue]; //, [yValue[1] intValue])
        CGFloat Y =rect.size.height - kBottomHeight -  y_space * [self.yValues[i] intValue] * 0.1;
        [path1 addLineToPoint:CGPointMake(X, Y)];
    }
    
    CGContextAddPath(ctx, path1.CGPath);
    CGContextSetLineWidth(ctx, 6);
    CGContextSetRGBStrokeColor(ctx, 131.0/255.0, 190.0/255.0, 34.0/255.0, 1.0);
    CGContextStrokePath(ctx);

    // 填充色
    UIBezierPath* path2=[UIBezierPath bezierPath];
    endA=CGPointMake(x_space * 0, [self.yValues[0] intValue]);
    [path2 moveToPoint:startA];
    for (int i = 0; i < self.xValues.count; i++) {
        CGFloat X =kStartX + x_space * (i+1) ;
        CGFloat Y = rect.size.height - kBottomHeight -  y_space * [self.yValues[i] intValue] * 0.1;
        [path2 addLineToPoint:CGPointMake(X, Y)];
        if (i == self.xValues.count - 1) {
            [path2 addLineToPoint:CGPointMake(kStartX + x_space *  (i + 1), rect.size.height  -  kBottomHeight)];
        }
    }

    CGContextAddPath(ctx, path2.CGPath);
    CGContextSetRGBFillColor(ctx,215.0/255.0, 236.0/255.0, 177.0/255.0, 1.0);
    CGContextFillPath(ctx);
    
    // 绘制矩形框
    NSString* text=[NSString stringWithFormat:@"%.1f",[self.yValues.lastObject floatValue]];    CGSize textSize=[text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]}];

    CGRect texRrect=CGRectMake(kStartX + x_space * self.xValues.count, rect.size.height - kBottomHeight -  y_space * [self.yValues.lastObject intValue] * 0.1 - 20, textSize.width, textSize.height);
    CGRect juRect=CGRectMake(kStartX + x_space * self.xValues.count- 5, rect.size.height - kBottomHeight -  y_space * [self.yValues.lastObject intValue] * 0.1 - 20, textSize.width+10, textSize.height);
    UIBezierPath* path3=[UIBezierPath bezierPathWithRoundedRect:juRect cornerRadius:5];

    CGContextAddPath(ctx, path3.CGPath);
    CGContextSetRGBFillColor(ctx, 131.0/255.0, 190.0/255.0, 34.0/255.0, 1.0);
    CGContextFillPath(ctx);
    
    
    [text drawInRect:texRrect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 绘制底部的分割度线
    for (int i = 0; i < self.xKeDuValus.count; i++) {
        [[UIColor  lightGrayColor] setStroke];
        CGContextSetLineWidth(ctx, 1);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx,kStartX + x_space * i , rect.size.height - kBottomHeight);
        CGContextAddLineToPoint(ctx,kStartX + x_space * i, rect.size.height - 25);
        CGContextDrawPath(ctx, kCGPathStroke);
        
        NSString *x_titleStr= [NSString stringWithFormat:@"%@",self.xKeDuValus[i] ];
        CGSize titleSize=[x_titleStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}];
        [x_titleStr drawInRect:CGRectMake(kStartX + x_space * i - titleSize.width*0.5, rect.size.height - 25, titleSize.width, titleSize.height) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        
        if (i == self.xKeDuValus.count - 1) {
            NSString *textStr=@"时间/小时";
            CGSize titleSize=[textStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]}];
            [textStr drawInRect:CGRectMake(10 + x_space * i - titleSize.width*0.5, rect.size.height - 12, titleSize.width, titleSize.height) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0],NSForegroundColorAttributeName:self.xValueColor}];
        }
    }
}


@end
