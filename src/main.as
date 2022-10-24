/*
DontCare edit
*/


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
