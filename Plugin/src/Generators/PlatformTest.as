/**
 * The purpose of this test is to provide proof-of-concept for the basics of WFC algorithm.
 * 
 * This test will achieve a few things:
 * - Define the difference between an empty space (ungenerated) and air block (generated)
 * - The ability to randomly select a block in the map (must be platform or verified air block)
 * - Build off from that selected block using a probabilistic generation function
 * - Provide insight as to the average density and for how long this algorithm would run without halting
 */

// TODO make this programmatic and store it somewhere, since this can fluctuate 
int MAP_SIZE = 48;

namespace PlatformTest {
    // This stores all the blocks in the editor, all functions accessing this variable are responsible for
    // ensuring that it is accurate when blocks are added/removed from the editor
    CGameCtnBlock[] allBlocksInEditor;
    
    Generate::Block getGeneratedBlock() {

    }

    /** 
     * Returns a list of all non-air blocks in the editor
     * 
     * NOTE: This should be called very infrequently, and then store the array in memory, as this is super expensive
     * It also should be moved to a more common location, since it's likely going to be needed for a lot of algos
     */
    CGameCtnBlock[] getAllBlocksInEditor() {
        auto editor = Editor();
        CGameCtnBlock[] allBlocks;
        for(int x = 0; x < MAP_SIZE; x++) {
            for(int y = 0; y < MAP_SIZE; y++) {
                for(int z = 0; z < MAP_SIZE; z++) {
                    // TODO for multi-location spanning blocks, will this add them again?
                    // if so then we need to add a check for that
                    auto block = editor.PluginMapType.GetBlock(int3(x,y,z));
                    if(block != null && block.BlockInfo.IdName != "Grass") {
                        allBlocks.InsertLast(block);
                    }
                }
            }
        }
    }

    /**
     * Add a block to the list of all blocks in the editor
     */
    void addBlockToAllBlocksList(CGameCtnBlock block) {
        allBlocksInEditor.InsertLast(block);
    }

    /**
     * Grabs a random block from the input list of blocks
     */
    CGameCtnBlock getRandomBlock(CGameCtnBlock[] blocks) {
        int randomIdx = Math::Rand(0, blocks.Length);
        return 
    }

    /**
     * Publicly called to generate a block from our algorithm (platform or air)
     */
    void generateBlock() {
        // This is to ensure we only run this once or if it makes sense to
        // All other functions should properly handle this array if they modify the blocks in the editor
        if (allBlocksInEditor.Length == 0) {
            allBlocksInEditor = getAllBlocksInEditor();
        }
    }
}