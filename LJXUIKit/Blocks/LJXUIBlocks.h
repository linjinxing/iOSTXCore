//
//  LJXBlocksKitMacros.h
//  LJXUI
//
//  Created by steven on 3/7/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

/* sender: 触发事件的控件,  param: 传递到controller时需要传递的参数，updateView为controller回调回来给controller更新界面的block，param为带的参数 */
//@protocol LJXUpdateView <NSObject>
//@property(nonatomic, copy)void(^updateView)(id param);
//@end

typedef void(^LJXControlAction)(id sender, id value, UIControlEvents events);
//typedef void (^LJXControlActionHandler) (id sender, id param, id<LJXUpdateView> updateView);
//typedef void (^LJXControlActionHandler) (id sender, id param);
typedef void (^LJXAction) (id sender);
