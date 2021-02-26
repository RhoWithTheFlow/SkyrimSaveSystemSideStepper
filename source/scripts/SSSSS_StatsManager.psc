Scriptname SSSSS_StatsManager extends Quest  
Import Perk

function InvokeExport(String option, Actor playerRef, String sfile, String rfile)
	JsonUtil.Load(rfile)
	if (option == "ATTRIBUTES")
		DoExportAttributes(playerRef,sfile,rfile)
	elseIf (option == "SKILLS")
		DoExportSkills(playerRef,sfile,rfile)
	elseIf (option == "PERKS")
		DoExportPerks(playerRef,sfile,rfile)
	elseIf (option == "MISC")
		DoExportMisc(playerRef,sfile,rfile)
	endIf
endFunction

function InvokeImport(String option, Actor playerRef, String sfile, String rfile)
	JsonUtil.Load(rfile)
	if (option == "ATTRIBUTES")
		DoImportAttributes(playerRef,sfile,rfile)
	elseIf (option == "SKILLS")
		DoImportSkills(playerRef,sfile,rfile)
	elseIf (option == "PERKS")
		DoImportPerks(playerRef,sfile,rfile)
	elseIf (option == "MISC")
		DoImportMisc(playerRef,sfile,rfile)
	endIf
endFunction

;
; Export functions
;

function DoExportAttributes(Actor playerRef, String sfile, String rfile)
	int curr = 0
	while (curr < JsonUtil.StringListCount(rfile, "attributes_vanilla"))
		JsonUtil.SetFloatValue(sfile, JsonUtil.StringListGet(rfile, "attributes_vanilla", curr), playerRef.GetBaseActorValue(JsonUtil.StringListGet(rfile, "attributes_vanilla", curr)))
		curr += 1
	endWhile
endFunction

function DoExportSkills(Actor playerRef, String sfile, String rfile)
	int curr = 0
	while (curr < JsonUtil.StringListCount(rfile, "skills_vanilla"))
		JsonUtil.SetFloatValue(sfile, JsonUtil.StringListGet(rfile, "skills_vanilla", curr), playerRef.GetBaseActorValue(JsonUtil.StringListGet(rfile, "skills_vanilla", curr)))
		curr += 1
	endWhile
endFunction

function DoExportPerks(Actor playerRef, String sfile, String rfile)
	JsonUtil.SetIntValue(sfile, "PerkPoints", Game.GetPerkPoints())
	
	JsonUtil.FormListClear(sfile, "OwnedPerks")
	
	int curr_a = 0
	int curr_b = 0
	while (curr_a <  JsonUtil.StringListCount(rfile, "skills_vanilla"))
		while (curr_b < ActorValueInfo.GetAVIbyName(JsonUtil.StringListGet(rfile, "skills_vanilla", curr_a)).GetPerks().Length)
			if (playerRef.HasPerk(ActorValueInfo.GetAVIbyName(JsonUtil.StringListGet(rfile, "skills_vanilla", curr_a)).GetPerks()[curr_b]))
				JsonUtil.FormListAdd(sfile, "OwnedPerks", ActorValueInfo.GetAVIbyName(JsonUtil.StringListGet(rfile, "skills_vanilla", curr_a)).GetPerks()[curr_b])
			endIf
			curr_b += 1
		endWhile
		curr_b = 0
		curr_a += 1
	endWhile
endFunction

function DoExportMisc(Actor playerRef, String sfile, String rfile)
	JsonUtil.SetIntValue(sfile, "Level", playerRef.GetLevel())
	JsonUtil.SetFloatValue(sfile, "Experience", Game.GetPlayerExperience())
endFunction

;
; Import functions
;

function DoImportAttributes(Actor playerRef, String sfile, String rfile)
	int curr = 0
	while (curr < JsonUtil.StringListCount(rfile, "attributes_vanilla"))
		playerRef.SetActorValue(JsonUtil.StringListGet(rfile, "attributes_vanilla", curr), JsonUtil.GetFloatValue(sfile, JsonUtil.StringListGet(rfile, "attributes_vanilla", curr)))
		curr += 1
	endWhile
endFunction

function DoImportSkills(Actor playerRef, String sfile, String rfile)
	int curr = 0
	while (curr < JsonUtil.StringListCount("../SkyrimSaveSystemSideStepper/statsref", "skills_vanilla"))
		playerRef.SetActorValue(JsonUtil.StringListGet(rfile, "skills_vanilla", curr), JsonUtil.GetFloatValue(sfile, JsonUtil.StringListGet(rfile, "skills_vanilla", curr)))
		curr += 1
	endWhile
endFunction

function DoImportPerks(Actor playerRef, String sfile, String rfile)
	Game.SetPerkPoints(JsonUtil.GetIntValue(sfile, "PerkPoints"))

	int curr = 0
	while (curr < JsonUtil.FormListCount(sfile, "OwnedPerks"))
		playerRef.AddPerk(JsonUtil.FormListGet(sfile, "OwnedPerks", curr) as Perk)
		curr += 1
	endWhile
endFunction

function DoImportMisc(Actor playerRef, String sfile, String rfile)
	Game.SetPlayerLevel(JsonUtil.GetIntValue(sfile, "Level"))
	Game.SetPlayerExperience(JsonUtil.GetFloatValue(sfile, "Experience"))
endFunction