#import "wax_CTViewController.h"
#import "CTViewController.h"

#import "wax_instance.h"
#import "wax_helpers.h"

#import "lua.h"
#import "lauxlib.h"

#define METATABLE_NAME "CTViewController"

static int initVC(lua_State *L) {
    CTViewController* viewController = [[CTViewController alloc]init];
    NSLog(@"hahaha");
    wax_fromObjc(L, "@", &viewController);
    printf("CTViewController has been initialized\n");
    return 1;
}

static const struct luaL_Reg metaFunctions[] = {
    {NULL, NULL}
};

static const struct luaL_Reg functions[] = {
    {"initVC",initVC},
    {NULL, NULL}
};

int luaopen_wax_CTViewController(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    luaL_newmetatable(L, METATABLE_NAME);
    luaL_register(L, NULL, metaFunctions);
    luaL_register(L, METATABLE_NAME, functions);
    END_STACK_MODIFY(L, 0)
    return 1;
}