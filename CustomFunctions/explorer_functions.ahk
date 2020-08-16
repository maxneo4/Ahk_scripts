openCurrentFolderInCMD(){
	currdir := getSmartCurrentFolder()
	Run, cmd, % currdir ? currdir : "C:\"
}

getSmartSelectedFile(){
	IfWinActive ahk_group FileListers
		path := Explorer_GetSelected()
	if path 
		filePath := path
	else	if InStr(FileExist(Clipboard), "A")
		filePath := Clipboard
	return filePath
}

getSmartSelectedItem(){
	IfWinActive ahk_group FileListers
		path := Explorer_GetSelected()
	if path 
		itemPath := path
	else	if FileExist(Clipboard)
		itemPath := Clipboard
	return itemPath
}

getSmartCurrentFolder(){
	IfWinActive ahk_group FileListers
		path := Explorer_GetPath()
	if path 
		folderPath := path
	else if InStr(FileExist(folderPath), "D")
		folderPath := Clipboard
	return folderPath
}

getFileVersion(){
	filePath := getSmartSelectedFile()		
	f := FileGetVersionInfo_AW(filePath, "ProductVersion", "FileVersion")
	pv := f.productVersion 
	fv := f.fileVersion
	Clipboard = product version: %pv% `nfile version:%fv%
	MsgBox,,, % Clipboard
	return
}