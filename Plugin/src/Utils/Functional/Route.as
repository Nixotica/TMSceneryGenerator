class Route {
    /**
     * The route class holds all information pertaining to the route before any generation.
     * Any decoration generated by this plugin will never be added to the route. This is a ground truth for
     * safekeeping to avoid any completely overwrites of a player's map. 
     */
    Generate::Block@[] blocks;

    /**
     * @brief Get the set of all blocks along the route
     * 
     * @returns Array of block objects
     */
    Generate::Block@[] getRouteBlocks() {
        return blocks;
    }

    /**
     * @brief Add a block to the route
     */
    void addRouteBlock(Generate::Block@ block) {
        blocks.InsertLast(block);
    }

    void clearRouteblocks() {
        blocks.Resize(0);
    }
}