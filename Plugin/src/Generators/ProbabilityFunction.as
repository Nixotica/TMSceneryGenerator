namespace Generate {
    /**
     * In both cases, the dictionary should be: 
     * KEY: CGameCtnBlock
     * VALUE: 0 <= int <= 1
     * such that for all unique keys, the sum of values = 1
     * 
     * In the future, when we consider all blocks that can be generated, this can probabily be static and not
     * taken as an input
     */

    /**
     * Function signature to be used as a handle for probability functions
     * 
     * NOTE: we may not even need this, I feel like in most instances we will just write it straight into the collapse function
     */
    funcdef CGameCtnBlock ProbabilityFunction(dictionary probability_map);

    /**
     * Function signature to be used as a handle for collapse functions
     */
    funcdef CGameCtnBlock CollapseFunction(
        CGameCtnBlock[] surroundingBlocks,
        dictionary probability_map,
        ProbabilityFunction probability_function);
}