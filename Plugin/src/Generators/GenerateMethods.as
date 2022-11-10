namespace Generate {
    
    class Block {
        CGameCtnBlockInfo@ info = null;
        int3 pos;
        CGameEditorPluginMap::ECardinalDirections dir;

        Block(){}

        Block(CGameCtnBlockInfo@ i, int3 p, CGameEditorPluginMap::ECardinalDirections d = CGameEditorPluginMap::ECardinalDirections::North){
            @info = i;
            pos  = p;
            dir  = d;
        }

        CGameCtnBlockInfo@ getBlockInfo() {
            return @info;
        }

        int3 getPosotion() {
            return pos;
        }

        CGameEditorPluginMap::ECardinalDirections getDirection() {
            return dir;
        }
    };
    
    CGameCtnBlockInfo@ getRandomBlock(CGameCtnEditorCommon@ editor) {
        return editor.PluginMapType.BlockModels[Math::Rand(0, editor.PluginMapType.BlockModels.Length)];
    }
}