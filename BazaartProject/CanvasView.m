//
//  CanvasView.m
//  BazaartProject
//
//  Created by Yedidya Reiss on 19/05/2021.
//

#import "CanvasView.h"
#import "BazaartProject-Swift.h"

#define STATE_TYPE_ADD 1
#define STATE_TYPE_DELETE 2

static NSInteger nextStateIndex = 0;
@interface CanvasState ()

@property (assign,nonatomic) NSInteger i;
@property (assign,nonatomic) NSInteger type;

@end

@implementation CanvasState

-(instancetype) initWithType:(NSInteger) type {
    self = [super init];
    self.i = nextStateIndex;
    self.type = type;
    nextStateIndex++;
    return self;
}


@end


@interface CanvasView ()

@property (strong,nonatomic) UIView* contentView;
@property (assign,nonatomic) BOOL isSavingState;

@end

@implementation CanvasView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setupContentView];
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    return self;
}

-(void) setupContentView {
    [self.contentView removeFromSuperview];
    
    UIImageView* v = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:v];
    self.contentView = v;
    
    v.translatesAutoresizingMaskIntoConstraints = NO;
    [v.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [v.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [v.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [v.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    
    v.image = [UIImage imageNamed:@"bg"];
    v.contentMode = UIViewContentModeScaleAspectFill;
    v.userInteractionEnabled = YES;
}

-(CanvasState*)addLayer {
    CanvasLayer* canvasLayer = [CanvasLayer layer];
    [self.contentView addSubview:canvasLayer];
    [canvasLayer setLocationWithPoint:self.contentView.center];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self saveState:nil testing:YES];
    });
    
    return [[CanvasState alloc] initWithType:STATE_TYPE_ADD];
}

- (CanvasState*)deleteLastLayer {
    [self removeLastLayer];
    return [[CanvasState alloc] initWithType:STATE_TYPE_DELETE];
}

- (UIImage *)renderCanvas {
    
    NSAssert(!self.isSavingState, @"You can't render the canvas while the state is in saving process");
    
    //fake save
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 1);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (NSInteger)layersCount {
    return self.contentView.subviews.count;
}

- (void) removeLastLayer {
    if (!NSThread.isMainThread) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self removeLastLayer];
        }];
        return;
    }
    
    UIView* v = self.contentView.subviews.lastObject;
    [v removeFromSuperview];
}

-(void) saveState:(CanvasState*) state {
    [self saveState:state testing:NO];
}

//DON'T CHANGE THIS FUNCTION (AND THIS FILE)
//IT IS FAKING SOME HEAVY SAVE PROCESS
//THE 'testing' PARAM IS USED FOR INTERNAL TEST - CHECKING IF THE STATE WAS SAVED AFTER IT WAS CHANGED
-(void) saveState:(CanvasState*) state testing:(BOOL) testing {
    static NSInteger lastSaved = -1;
    
    if (testing) {
        if (lastSaved == -1) {
            //YOU DIDN'T SAVED THE STATE AFTER IT WAS CHANGED, SEE THE .h FILE FOR MORE OPTIONS
            NSLog(@"\n\n\n------ YOU DIDN'T SAVE THE STATE -------\n\n");
        }
        return;
    }
    
    NSAssert(lastSaved + 1 == state.i, @"You missed a state that wasn't saved");
    
    lastSaved = state.i;
    
    NSAssert(!self.isSavingState, @"You can't call save state while the state is in saving process");

    self.isSavingState = YES;
    
    //fake some heavy code
    if (state.type == STATE_TYPE_DELETE) {
        [NSThread sleepForTimeInterval:3];
    } else {
        [NSThread sleepForTimeInterval:0.5];
    }
    
    self.isSavingState = NO;
}



@end
