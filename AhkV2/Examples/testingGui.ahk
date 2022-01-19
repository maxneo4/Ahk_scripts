;ctrl  alt  g to open the window...
w := Gui("AlwaysOnTop", "Guid Search")
w.Add("Text", , "Connection string")
w.Add("Text", , "Guids to search")
w.Add("Edit", "w500 ym")
w.Add("Edit", "r10 w500")
button := w.Add("Button", ,"Search")
button.OnEvent("Click", SearchGuid)
w.Show

SearchGuid(*)
{
	Run("Notepad")
}