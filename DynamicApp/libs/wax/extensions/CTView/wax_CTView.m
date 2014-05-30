#import "wax_CTView.h"
#import "CTView.h"

#import "wax_instance.h"
#import "wax_helpers.h"

#import "lua.h"
#import "lauxlib.h"

#define METATABLE_NAME "CTView"

static int initWithFrame_withOldView_withDirection(lua_State *L) {
    CGRect *theFrame = wax_copyToObjc(L, @encode(CGRect), 2, nil);
    
    printf("theFrame->size.width :%f\n",theFrame->size.width);
    NSLog(@"%f",theFrame->size.width);
    
    double Animatetype = luaL_checknumber(L, 4);
    printf("Animatetype :%f\n",Animatetype);
    
    //UIColor **color = wax_copyToObjc(L, @encode(UIColor *), 2, nil);
    
    UIView **myView = (wax_copyToObjc(L, @encode(UIView *), 3, nil));//这个可以有
    NSLog(@"%@",*myView);
    
    //UIView *view = (__bridge UIView*)(wax_copyToObjc(L, @encode(UIView *), 3, nil));//ARC
    //    UIView *myView = (wax_copyToObjc(L, @encode(UIView *), 3, nil));//非ARC
    //    NSLog(@"%@",myView);//但是这样不行
    
    CTView *theView = [[CTView alloc]initWithFrame:*theFrame withOldView:*myView withDirection:Animatetype];
    
    wax_fromObjc(L, "@", &theView);
    
    printf("CTView has been initialized\n");
    
    //    free(theFrame);
    //    free(myView);
    
    return 1;
}

static const struct luaL_Reg metaFunctions[] = {
    {NULL, NULL}
};

static const struct luaL_Reg functions[] = {
    {"initWithFrame_withOldView_withDirection",initWithFrame_withOldView_withDirection},
    {NULL, NULL}
};

int luaopen_wax_CTView(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    luaL_newmetatable(L, METATABLE_NAME);
    luaL_register(L, NULL, metaFunctions);
    luaL_register(L, METATABLE_NAME, functions);
    END_STACK_MODIFY(L, 0)
    return 1;
}