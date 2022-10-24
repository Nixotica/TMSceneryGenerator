void RenderUI() {
    // Get editor; if null then we aren't in editor, so return
    auto editor = Editor();
    if (editor is null) return;

    
}

void RenderInterfaceBackdrop() {
    nvg::BeginPath();
    nvg::RoundedRect(vec2(50, 950), vec2(250, 150), 10);
    nvg::FillColor(vec4(50./255, 50./255, 50./255, 200./255));
    nvg::Fill();
    nvg::ClosePath();
    nvg::Text(vec2(300, 900), "Le Epic Scenery Generator");
}