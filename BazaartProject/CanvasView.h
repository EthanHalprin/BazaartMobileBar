//
//  CanvasView.h
//  BazaartProject
//
//  Created by Yedidya Reiss on 19/05/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CanvasState : NSObject

@end

@interface CanvasView : UIView


-(CanvasState*) addLayer;
-(CanvasState*) deleteLastLayer;
-(void) saveState:(CanvasState*)state;
-(UIImage*) renderCanvas;

@end 

NS_ASSUME_NONNULL_END
