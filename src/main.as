/*
DontCare edit
*/

namespace Compatibility 
{
   bool EditorIsNull() 
   {
      return cast<CGameCtnEditorFree> (Editor()) is null;
   }

   bool IsMapTesting() 
   {
#if TMNEXT
      return GetApp().CurrentPlayground !is null;
#else
      CGameCtnEditorFree@ editor = cast<CGameCtnEditorFree>(Editor());
      return editor !is null && editor.PluginMapType.IsSwitchedToPlayground;
#endif
   }
}

//Entry Point
void Main()
{
   print("Hello DontCare");
}

//is called each frame
void Render() {

   //render dialog if there is one i believe
   TMDialog::Render();

   //renders the interface
   Interface::RenderInterface();
}

// we can define the editor here to simplify each time we grab it
CGameCtnEditorCommon@ Editor() {
    auto app = GetApp();
    return cast<CGameCtnEditorCommon@>(app.Editor);
}