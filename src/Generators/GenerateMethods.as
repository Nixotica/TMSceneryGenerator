namespace Generate {
    CGameCtnBlockInfo@ getRandomBlock(CGameCtnEditorCommon@ editor) {
        return editor.PluginMapType.BlockModels[Math::Rand(0, editor.PluginMapType.BlockModels.Length)];
    }
}