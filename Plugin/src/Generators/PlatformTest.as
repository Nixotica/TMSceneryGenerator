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
int MAP_SIZE_XZ = 48;
int MAP_SIZE_Y = 40;

// TODO store this somewhere in a global sense
int AIR_BLOCK_ID = -1;

namespace PlatformTest {
    // This stores all the blocks in the editor, all functions accessing this variable are responsible for
    // ensuring that it is accurate when blocks are added/removed from the editor
    CGameCtnBlock[] allBlocksInEditor;

    // This stores an internal memory of which locations in the map have been generated so far, so that
    // we don't attempt to overwrite already generated blocks or air
    int3[] generatedLocations;
    
    array<array<array<int>>> probability_map = {
        {895, {
            {-1, 0.75}, 
            {895, 0.25}}}
    };

    dictionary block_id_to_name = {
        {
            895, "PlatformTechBase"
        }
    };

    /**
     * Provided a location, get the triples of the 6 surrounding locations back as a list of int3s
     */
    int3[] getSurroundingLocations(int3 location) {
        int3[] surrounding_locations;
        int x = location.x;
        int y = location.y;
        int z = location.z;
        surrounding_locations.InsertLast(int3(x-1, y, z));
        surrounding_locations.InsertLast(int3(x+1, y, z));
        surrounding_locations.InsertLast(int3(x, y-1, z));
        surrounding_locations.InsertLast(int3(x, y+1, z));
        surrounding_locations.InsertLast(int3(x, y, z-1));
        surrounding_locations.InsertLast(int3(x, y, z+1));
        return surrounding_locations;
    }

    /**
     * Provided a list of locations, return only those locations which are not generated
     */
    int3[] getUngeneratedLocations(int3[] locations) {
        int3[] ungenerated_locations;
        for (int i = 0; i < locations.Length; i++) {
            if (generatedLocations.Find(locations[i]) < 0) {
                ungenerated_locations.InsertLast(locations[i]);
            }
        }
        return ungenerated_locations;
    }

    /**
     * Provided a list of locations, return only those locations which are generated
     */
    int3[] getUngeneratedLocations(int3[] locations) {
        int3[] generated_locations;
        for (int i = 0; i < locations.Length; i++) {
            if (generatedLocations.Find(locations[i]) >= 0) {
                generated_locations.InsertLast(locations[i]);
            }
        }
        return generated_locations;
    }

    /**
     * Provided a location, return a list of the adjacent blocks (not corners or edges yet, might in future)
     */
    CGameCtnBlock[] getSurroundingBlocks(int3 location) {
        auto editor = Editor();
        CGameCtnBlock[] surroundingBlocks;
        auto x = location.x;
        auto y = location.y;
        auto z = location.z;
        auto surrounding_locations = getSurroundingLocations(location);
        for (int i = 0; i < surrounding_locations.Length; i++) {
            auto block = editor.PluginMapType.GetBlock(surrounding_locations[i]);
            if (block_id_to_name.)
        }
        surroundingBlocks.InsertLast(editor.PluginMapType.GetBlock(int3(x-1, y, z)));
        surroundingBlocks.InsertLast(editor.PluginMapType.GetBlock(int3(x+1, y, z)));
        surroundingBlocks.InsertLast(editor.PluginMapType.GetBlock(int3(x, y-1, z)));
        surroundingBlocks.InsertLast(editor.PluginMapType.GetBlock(int3(x, y+1, z)));
        surroundingBlocks.InsertLast(editor.PluginMapType.GetBlock(int3(x, y, z-1)));
        surroundingBlocks.InsertLast(editor.PluginMapType.GetBlock(int3(x, y, z+1)));
        return surroundingBlocks;
    }

    /**
     * Provided an input location, get a random surrounding location in one of the 6 directions for which
     * the generated block has yet to be decided
     */
    vec3 getRandomSurroundingUngeneratedLocation(int3 location) {
        int3 surrounding_locations = getSurroundingLocations(location);

    }

    /**
     * Provided a location, return the most appropriate block to generate at this location
     * 
     * NOTE: This is VERY simple right now, but this provides a basis for our more complex algos later when
     * we have more data to work with and train on
     */
    CGameCtnBlock collapse(int3 location) {
        CGameCtnBlock[] surrounding_blocks = getSurroundingBlocks(location);
        CGameCtnBlock base_block = getRandomBlockFromList(surrounding_blocks);
    }

    /** 
     * Returns a list of all non-air blocks in the editor
     * 
     * NOTE: This should be called very infrequently, and then store the array in memory, as this is super expensive
     * It also should be moved to a more common location, since it's likely going to be needed for a lot of algos
     */

    CGameCtnBlock[] getAllBlocksInEditor() {
        auto editor = Editor();
        for(int x = 0; x < MAP_SIZE_XZ; x++) {
            for(int y = 0; y < MAP_SIZE_Y; y++) {
                for(int z = 0; z < MAP_SIZE_XZ; z++) {
                    // TODO for multi-location spanning blocks, will this add them again?
                    // if so then we need to add a check for that
                    auto block = editor.PluginMapType.GetBlock(int3(x,y,z));
                    if(block != null && block.BlockInfo.IdName != "Grass") {
                        allBlocksInEditor.InsertLast(block);
                    }
                }
            }
        }
        return allBlocksInEditor;
    }

    void printAllBlocks() {
        auto editor = Editor();
        int length = editor.PluginMapType.BlockModels.Length;
        for(int i = 0; i < length; i++) {
            auto block = editor.PluginMapType.BlockModels[i];
            print(block.IdName +" " +i);
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
    CGameCtnBlock@ getRandomBlockFromList(CGameCtnBlock[] blocks) {
        auto editor = Editor();
        int randomIdx = Math::Rand(0, blocks.Length);
        return editor.PluginMapType.Blocks[randomIdx];
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

        // TODO remember to add the generated block to allBlocksInEditor
    }
}