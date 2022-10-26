namespace InterfaceNew {
    [Setting category="General" name="Window Visible" hidden]
    bool settingWindowVisible = true;

    void RenderMenu() {
        /*if(UI::MenuItem("\\$2f9" + Icons::Bath + "\\$fff TM Scenery Generator", "", settingWindowVisible, GetApp().Editor !is null)) {
            settingWindowVisible = !settingWindowVisible;
        }*/
    }

    void RenderInterface() {
        //if (Compatibility::EditorIsNull() || Compatibility::IsMapTesting() || !settingWindowVisible) return;
        UI::SetNextWindowSize(300,600, UI::Cond::FirstUseEver);
        UI::Begin(Icons::Bath + "TMSceneryGenerator", settingWindowVisible);
        auto editor = Editor();
        if(UI::Button("Generate a block", vec2(200, 50))) {
            for(int i = 0; i < 10; i++){
                auto x = Math::Rand(0,45);
                auto y = Math::Rand(0,45);
                auto z = Math::Rand(0,45);
                editor.PluginMapType.PlaceBlock(Generate::getRandomBlock(editor) , int3(x ,y ,z), CGameEditorPluginMap::ECardinalDirections::North);
            }
        }
        UI::End();
    }
}