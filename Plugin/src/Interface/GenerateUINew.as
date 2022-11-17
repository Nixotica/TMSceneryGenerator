namespace Interface {
    [Setting category="General" name="Window Visible" hidden]
    bool settingWindowVisible = true;
    bool airMode = true;
    int MAP_SIZE_XZ = 48;
    int MAP_SIZE_Y = 40;
    auto route = Route();
    
    void RenderInterface() {
        UI::SetNextWindowSize(300,600, UI::Cond::FirstUseEver);
        UI::Begin(Icons::Bath + "TMSceneryGenerator", settingWindowVisible);
        auto editor = Editor();
        
        if(UI::Button("Generate a block", vec2(200, 50))) {
            for(int i = 0; i < 10; i++){
                int x = Math::Rand(0,45);
                int y = Math::Rand(0,45);
                int z = Math::Rand(0,45);
                Generate::Block block = Generate::Block(Generate::getRandomBlock(editor), int3(x,y,z), CGameEditorPluginMap::ECardinalDirections::North);
                route.addRouteBlock(block);
            }
            auto mapBlocks = route.getRouteBlocks();
            print("block array length: " + mapBlocks.Length);
            for( int i = 0; i < mapBlocks.Length; i++){
                editor.PluginMapType.PlaceBlock(mapBlocks[i].info, mapBlocks[i].pos, mapBlocks[i].dir);
            }
        }

        if(UI::Button("print all blocks", vec2(200,50))) {
            PlatformTest::printAllBlocks();
        }

        if(UI::Button("Platform test (one block)", vec2(200, 50))) {
            PlatformTest::generateBlock();
        }

        // TODO update the UI to have checked/unchecked box
        if(UI::Checkbox("Air Mode", airMode)) {
            if(airMode) { airMode = false; }
            else
            {
                editor.ButtonAirBlockModeOnClick();
                airMode = true;
            }
        }

        if(UI::Button("Save Route", vec2(200, 50))) {
            for(int x = 0; x < MAP_SIZE_XZ; x++) {
                for(int y = 0; y < MAP_SIZE_Y; y++) {
                    for(int z = 0; z < MAP_SIZE_XZ; z++) {
                        auto block = editor.PluginMapType.GetBlock(int3(x, y, z));
                        if(block == null || block.BlockInfo.IdName == "Grass"){ continue; }
                        else {
                            route.addRouteBlock(Generate::Block(block.BlockInfo, int3(x, y, z), block.Dir));
                        }
                    }
                }
            }
            print(route.getRouteBlocks().Length);
            auto routeBlocks = route.getRouteBlocks();
            for(int i = 0; i < routeBlocks.Length; i++) {
                print(routeBlocks[i].getBlockInfo().IdName +"xyz ("+routeBlocks[i].getPosotion().x+"," +routeBlocks[i].getPosotion().y+","+routeBlocks[i].getPosotion().z +")");
            }
        }

        if(UI::Button("Clear Route", vec2(200, 50))) {
            route.clearRouteblocks();
            if(route.getRouteBlocks().Length == 0) {
                print("Route empty!");
            }
        }

        UI::Text("Route block total size: " +route.getRouteBlocks().Length);
        UI::End();
    }
}