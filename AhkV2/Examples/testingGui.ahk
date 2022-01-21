;ctrl  alt  g to open the window...
SetWorkingDir A_InitialWorkingDir

w := Gui("AlwaysOnTop", "Guid Search")
w.Add("Text", , "Connection string")
w.Add("Text", , "Guids to search")
w.Add("Edit", "vConnString w500 ym")
w.Add("Edit", "vGuids r10 w500")
button := w.Add("Button", ,"Search")
button.OnEvent("Click", SearchGuid)
w.Show

SearchGuid(*)
{
	data := w.Submit()
	A_Clipboard := data.Guids
	Run "guidSearchConsole.exe" ' "' data.ConnString '"'
}