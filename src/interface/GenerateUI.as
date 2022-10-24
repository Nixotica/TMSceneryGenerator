namespace Interface {

    bool windowOpen = IsDevMode();
    void RenderInterface() {
        
        //default built in styling for components, like the ugly green they use everywhere
        TMUI::PushWindowStyle();

        //sets ui window size, its resizable
        UI::SetNextWindowSize(480,720);

        //actually starts the menu dings if dev mode on
        if(UI::Begin("TMSceneryGenerator", windowOpen))
        {
            RenderMenu();
        }
        
        //cleanup code
        UI::End();
        TMUI::PopWindowStyle();
    }
    
    //actual components of the ui go here i think
    void RenderMenu() {
        UI::Text("TMSceneryGenerator");
    }
}