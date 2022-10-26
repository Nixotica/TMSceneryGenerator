namespace InterfaceNew {
    [Setting category="General" name="Window Visible" hidden]
    bool settingWindowVisible = true;

    void RenderMenu() {
        /*if(UI::MenuItem("\\$2f9" + Icons::Bath + "\\$fff TM Scenery Generator", "", settingWindowVisible, GetApp().Editor !is null)) {
            settingWindowVisible = !settingWindowVisible;
        }*/
    }

    void RenderInterface() {
        if (Compatibility::EditorIsNull() || Compatibility::IsMapTesting() || !settingWindowVisible) return;
        UI::SetNextWindowSize(300,600, UI::Cond::FirstUseEver);
        UI::Begin(Icons::Bath + "TMSceneryGenerator", settingWindowVisible);
        auto editor = Editor();
        if(UI::Button("Generate a block", vec2(200, 50)))
        {
            auto block = editor.CurrentBlockInfo;
            print(block.IdName);
        }
        UI::End();

        
    }
}