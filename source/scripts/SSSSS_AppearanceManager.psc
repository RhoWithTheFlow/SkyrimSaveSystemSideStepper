Scriptname SSSSS_AppearanceManager extends Quest  

function InvokeExport(String option, Actor playerRef, String sfile, String rfile)
	JsonUtil.Load(rfile)
	if (option == "HEADPARTS")
		DoExportHeadParts(playerRef, sfile, rfile)
	elseIf (option == "TINTMASKS")
		DoExportTintMasks(playerRef, sfile, rfile)
	elseIf (option == "MISC")
		DoExportMisc(playerRef,sfile,rfile)
	endIf
endFunction

function InvokeImport(String option, Actor playerRef, String sfile, String rfile)
	JsonUtil.Load(rfile)
	if (option == "HEADPARTS")
		DoImportHeadParts(playerRef, sfile, rfile)
	elseIf (option == "TINTMASKS")
		DoImportTintMasks(playerRef, sfile, rfile)
	elseIf (option == "MISC")
		DoImportMisc(playerRef,sfile,rfile)
	endIf

	playerRef.QueueNiNodeUpdate()
endFunction

;
; Export functions
;

function DoExportHeadParts(Actor playerRef, String sfile, String rfile)
	JsonUtil.FormListClear(sfile, "HeadParts")
	
	int curr = 0
	while (curr < playerRef.GetActorBase().GetNumHeadParts())
		JsonUtil.FormListAdd(sfile, "HeadParts", playerRef.GetActorBase().GetNthHeadPart(curr))
		curr += 1
	endWhile
endFunction

function DoExportTintMasks(Actor playerRef, String sfile, String rfile)
	JsonUtil.IntListClear(sfile, "TintMasks")
	JsonUtil.StringListClear(sfile, "TintMaskTexturePaths")
	
	int curr = 0
	while (curr < Game.GetNumTintMasks())
		JsonUtil.IntListAdd(sfile, "TintMasks", Game.GetNthTintMaskColor(curr))
		JsonUtil.StringListAdd(sfile, "TintMaskTexturePaths", Game.GetNthTintMaskTexturePath(curr))
		curr += 1
	endWhile
endFunction

function DoExportMisc(Actor playerRef, String sfile, String rfile)
	JsonUtil.SetFormValue(sfile, "HairColor", playerRef.GetActorBase().GetHairColor())
	JsonUtil.SetFormValue(sfile, "Race", playerRef.GetRace())
	JsonUtil.SetFormValue(sfile, "Skin", playerRef.GetActorBase().GetSkin())
	JsonUtil.SetFormValue(sfile, "SkinFar", playerRef.GetActorBase().GetSkinFar())
	JsonUtil.SetFormValue(sfile, "FaceTextureSet", playerRef.GetActorBase().GetFaceTextureSet())
	JsonUtil.SetFloatValue(sfile, "Height", playerRef.GetActorBase().GetHeight())
	JsonUtil.SetFloatValue(sfile, "Weight", playerRef.GetActorBase().GetWeight())
endFunction

;
;Import functions
;

function DoImportHeadParts(Actor playerRef, String sfile, String rfile)
	int curr = 0
	while (curr < JsonUtil.FormListCount(sfile, "HeadParts"))
		playerRef.GetActorBase().SetNthHeadPart(JsonUtil.FormListGet(sfile, "HeadParts", curr) as HeadPart, curr)
		curr += 1
	endWhile
endFunction 

function DoImportTintMasks(Actor playerRef, String sfile, String rfile)
	int curr = 0
	while (curr < JsonUtil.IntListCount(sfile, "TintMasks"))
		Game.SetNthTintMaskColor(curr, JsonUtil.IntListGet(sfile, "TintMasks", curr))
		Game.SetNthTintMaskTexturePath(JsonUtil.StringListGet(sfile, "TintMaskTexturePaths", curr), curr)
		curr += 1
	endWhile
endFunction

function DoImportMisc(Actor playerRef, String sfile, String rfile)
	playerRef.GetActorBase().SetHairColor(JsonUtil.GetFormValue(sfile, "HairColor") as ColorForm)
	playerRef.SetRace(JsonUtil.GetFormValue(sfile, "Race") as Race)
	playerRef.GetActorBase().SetSkin(JsonUtil.GetFormValue(sfile, "SkinFar") as Armor)
	playerRef.GetActorBase().SetSkinFar(JsonUtil.GetFormValue(sfile, "Skin") as Armor)
	playerRef.GetActorBase().SetFaceTextureSet(JsonUtil.GetFormValue(sfile, "FaceTextureSet") as TextureSet)
	playerRef.GetActorBase().SetHeight(JsonUtil.GetFloatValue(sfile, "Height"))
	playerRef.GetActorBase().SetWeight(JsonUtil.GetFloatValue(sfile, "Weight"))
endFunction