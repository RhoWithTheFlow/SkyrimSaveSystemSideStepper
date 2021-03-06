Scriptname SSSSS_MCMScript extends SKI_ConfigBase

Perk[] Property PerkList Auto

Quest Property ImportManager Auto
Quest Property ExportManager Auto

event OnPageReset(string page)
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddHeaderOption("Skyrim Save System Side-Stepper")
	AddHeaderOption("Mod is still very unfinished.")
	AddHeaderOption("There may be bugs.")
	AddTextOptionST("SAVENOW", "Save Character Data", "")
	AddTextOptionST("LOADNOW", "Load Character Data", "")
endEvent

state SAVENOW
	event OnHighlightST()
		SetInfoText("<Save Character Data>")
	endEvent

	event OnSelectST()
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		(ExportManager as SSSSS_ExportScript).InvokeExport("data")
	endEvent
endState

state LOADNOW
	event OnHighlightST()
		SetInfoText("<Load Character Data>")
	endEvent

	event OnSelectST()
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		(ImportManager as SSSSS_ImportScript).InvokeImport("data")
	endEvent
endState
