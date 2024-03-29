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

    // An instance of the editor
    auto editor = Editor();

    dictionary probability_map = {
        {
            "895", dictionary = 
            {
                {"-1", 0.75},
                {"895", 0.25}
            }
        }
    };

    dictionary block_name_to_id = {
        {
            "PlatformTechBase", 895
        }
    };

    /**
     * Provided a base block, get all of its surrounding block probabilities 
     */
    dictionary getBlockSurroundingProbabilities(CGameCtnBlock@ block) {
        auto block_id = string(block_name_to_id[block.IdName]);
        return dictionary(probability_map[block_id]);
    }

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
    int3[] getGeneratedLocations(int3[] locations) {
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
        CGameCtnBlock[] surroundingBlocks;
        auto surrounding_locations = getSurroundingLocations(location);
        for (int i = 0; i < surrounding_locations.Length; i++) {
            auto block = editor.PluginMapType.GetBlock(surrounding_locations[i]);
            if (block_name_to_id.Exists(block.IdName)) {
                surroundingBlocks.InsertLast(block);
            }
        }
        return surroundingBlocks;
    }

    /**
     * Provided an input location, get a random surrounding location in one of the 6 directions for which
     * the generated block has yet to be decided
     */
    int3 getRandomSurroundingUngeneratedLocation(int3 location) {
        array<int3> ungenerated_locations;
        auto surrounding_locations = getSurroundingLocations(location);
        for (int i = 0; i < surrounding_locations.Length; i++) {
            if (generatedLocations.Find(surrounding_locations[i]) < 0) {
                ungenerated_locations.InsertLast(surrounding_locations[i]);
            }
        }

        if (ungenerated_locations.Length == 0) {
            print("No ungenerated surrounding locations!");
            return int3(-1, -1, -1);
        }

        return ungenerated_locations[Math::Rand(0, ungenerated_locations.Length)];
    }

    /**
     * Provided a location, return the most appropriate block to generate at this location
     * 
     * NOTE: This is VERY simple right now, but this provides a basis for our more complex algos later when
     * we have more data to work with and train on
     */
    CGameCtnBlock@ collapse(int3 location) {
        CGameCtnBlock[] surrounding_blocks = getSurroundingBlocks(location);

        // Iterate over all surrounding blocks' valid surrounding blocks (in this direction, but simplifying for now)
        dictionary block_probabilities;
        for (int i = 0; i < surrounding_blocks.Length; i++) {
            auto possible_blocks_and_probs = getBlockSurroundingProbabilities(surrounding_blocks[i]);
            auto possible_keys = possible_blocks_and_probs.GetKeys();
            // For the first block, we simply add every block since X ∩ X = X
            if (i == 0) {
                for (int key = 0; key < possible_keys.get_Length(); key++) {
                    block_probabilities.Set(possible_keys[key], possible_blocks_and_probs[possible_keys[key]]);
                }
            }
            // Then for every other block, remove blocks which aren't present in both dictionaries, and 
            // update the probabilities of blocks in both with running probability (P_block = P_block / i+1)
            else {
                for (int key = 0; key < possible_keys.get_Length(); key++) {
                    if (!block_probabilities.Exists(possible_keys[key])) {
                        block_probabilities.Delete(string(possible_blocks_and_probs[possible_keys[key]]));
                    }
                    else {
                        block_probabilities.Set(string(possible_keys[key]), 
                            (double(possible_blocks_and_probs[possible_keys[key]]) + double(block_probabilities[possible_keys[key]])) / i);
                    }
                }
            }
        }

        // Change this to an iterable type (let's try to simplify logic in the future)
        auto keys = block_probabilities.GetKeys();
        double[] key_weights;
        for (int i = 0; i < keys.Length; i++) {
            key_weights.InsertLast(double(block_probabilities[keys[i]]));
        }

        // Now that we have all the probabilities, randomly choose a block ID with weights as the probabilities
        double random_prob = Math::Rand(0, 1);
        for (int i = 0; i < keys.Length; i++) {
            if (random_prob < key_weights[i]) {
                // This is our block, return it (or null if air block)
                auto block_id = Text::ParseInt(keys[i]);
                if (block_id == -1) {
                    return editor.PluginMapType.Blocks[block_id];
                }
                return editor.PluginMapType.Blocks[block_id];
            }
            random_prob -= key_weights[i];
        }
        print("Something went wrong in collapse function!");
        return editor.PluginMapType.Blocks[-1];
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


        auto base_block = getRandomBlockFromList(allBlocksInEditor);
        auto base_block_coords = int3(base_block.CoordX, base_block.CoordY, base_block.CoordZ);
        auto loc_to_generate = getRandomSurroundingUngeneratedLocation(base_block_coords);
        auto block_generated = collapse(loc_to_generate);
        auto block_generated_coords = int3(block_generated.CoordX, block_generated.CoordY, block_generated.CoordZ);

        // It's quite possible this is an air block, if so then handle differently


        editor.PluginMapType.PlaceBlock(block_generated.BlockInfo, block_generated_coords, block_generated.Dir);

        allBlocksInEditor.InsertLast(block_generated);
        generatedLocations.InsertLast(loc_to_generate);
    }
}