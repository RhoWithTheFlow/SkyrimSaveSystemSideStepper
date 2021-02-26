Scriptname SSSSS_MainScript extends Quest  

Quest Property StatsManager Auto
Quest Property AppearanceManager Auto

String maindir = "../SkyrimSaveSystemSideStepper/"

Actor playerRef

function Invoke(String option, String filename)
	String sfile = maindir+filename
	
	if (option == "SAVE")
		InvokeSave(sfile)
	elseIf (option == "LOAD")
		InvokeLoad(sfile)
	endIf
endFunction

function InvokeSave(String sfile)
	Debug.Notification("Saving character data to file...")
	if JsonUtil.JsonExists(sfile)
		DoSave(sfile)
		Debug.Notification("Save success.")
		return
	endIf
	Debug.Notification("Data JSON file does not exist.")
endFunction

function DoSave(String sfile)
	JsonUtil.Load(sfile)
	
	playerRef = Game.GetPlayer()
	
	(StatsManager as SSSSS_StatsManager).InvokeExport("ATTRIBUTES",playerRef,sfile,"../SkyrimSaveSystemSideStepper/statsref")
	
	(StatsManager as SSSSS_StatsManager).InvokeExport("SKILLS",playerRef,sfile,"../SkyrimSaveSystemSideStepper/statsref")
	
	(StatsManager as SSSSS_StatsManager).InvokeExport("PERKS",playerRef,sfile,"../SkyrimSaveSystemSideStepper/statsref")
	
	(StatsManager as SSSSS_StatsManager).InvokeExport("MISC",playerRef,sfile,"../SkyrimSaveSystemSideStepper/statsref")

	(AppearanceManager as SSSSS_AppearanceManager).InvokeExport("HEADPARTS",playerRef,sfile,"../SkyrimSaveSystemSideStepper/statsref")

	(AppearanceManager as SSSSS_AppearanceManager).InvokeExport("TINTMASKS",playerRef,sfile,"../SkyrimSaveSystemSideStepper/statsref")

	(AppearanceManager as SSSSS_AppearanceManager).InvokeExport("MISC",playerRef,sfile,"../SkyrimSaveSystemSideStepper/statsref")
	
	JsonUtil.Save(sfile)
endFunction

function InvokeLoad(String sfile)
	Debug.Notification("Loading character data from file...")
	if JsonUtil.JsonExists(sfile)
		DoLoad(sfile)
		Debug.Notification("Load success.")
		return
	endIf
	Debug.Notification("Data JSON file does not exist.")
endFunction

function DoLoad(String sfile)
	JsonUtil.Load(sfile)
	
	playerRef = Game.GetPlayer()
	
	(StatsManager as SSSSS_StatsManager).InvokeImport("ATTRIBUTES",playerRef,sfile,"../SkyrimSaveSystemSideStepper/statsref")
	
	(StatsManager as SSSSS_StatsManager).InvokeImport("SKILLS",playerRef,sfile,"../SkyrimSaveSystemSideStepper/statsref")
	
	(StatsManager as SSSSS_StatsManager).InvokeImport("PERKS",playerRef,sfile,"../SkyrimSaveSystemSideStepper/statsref")
	
	(StatsManager as SSSSS_StatsManager).InvokeImport("MISC",playerRef,sfile,"../SkyrimSaveSystemSideStepper/statsref")
	
	(AppearanceManager as SSSSS_AppearanceManager).InvokeImport("HEADPARTS",playerRef,sfile,"../SkyrimSaveSystemSideStepper/statsref")

	(AppearanceManager as SSSSS_AppearanceManager).InvokeImport("TINTMASKS",playerRef,sfile,"../SkyrimSaveSystemSideStepper/statsref")

	(AppearanceManager as SSSSS_AppearanceManager).InvokeImport("MISC",playerRef,sfile,"../SkyrimSaveSystemSideStepper/statsref")

endFunction

