Scriptname SSSSS_ExportScript extends Quest  
import SSSSS_UtilScript

String maindir = "../SkyrimSaveSystemSideStepper/"

Actor playerRef

Bool opBasicAttributes = True
Bool opSkillLevels = True
Bool opPerks = True

Bool opAppearance = True

Bool opInventory = True

Bool opKnownSpells = True

Bool opKnownShouts = True

Bool opPassiveEffects = True

function SetOption(String option, Bool setting)
	if (option == "BASICATTRIBUTES")
		opBasicAttributes = setting
	elseIf (option == "SKILLLEVELS")
		opSkillLevels = setting
	elseIf (option == "PERKS")
		opPerks = setting
	elseIf (option == "APPEARANCE")
		opAppearance = setting
	elseIf (option == "INVENTORY")
		opInventory = setting
	endIf
endFunction

function InvokeExport(String filename)
	String sfolder = maindir+filename+"/"
	playerRef = Game.GetPlayer()
	
	Debug.Notification("Saving character data to file...")
	
	DoExport(sfolder)
		
	Debug.Notification("Save success.")
endFunction

function DoExport(String sfolder)
	if (opBasicAttributes)
		DoExportBasicAttributes(sfolder)
	endIf
	if (opSkillLevels)
		DoExportSkillLevels(sfolder)
	endIf
	if (opPerks)
		DoExportPerks(sfolder)
	endIf
	if (opAppearance)
		DoExportAppearance(sfolder)
	endIf
	if (opInventory)
		DoExportInventory(sfolder)
	endIf

endFunction

;
; STATS
;

function DoExportBasicAttributes(String sfolder)
	String sfile = sfolder+"stats"
	JsonUtil.Load(sfile)
	JsonUtil.SetFloatValue(sfile, "Health", playerRef.GetBaseActorValue("Health"))
	JsonUtil.SetFloatValue(sfile, "Magicka", playerRef.GetBaseActorValue("Magicka"))
	JsonUtil.SetFloatValue(sfile, "Stamina", playerRef.GetBaseActorValue("Stamina"))
	JsonUtil.Save(sfile)
endFunction

function DoExportSkillLevels(String sfolder)
	String sfile = sfolder+"stats"
	JsonUtil.Load(sfile)
	String[] skillList = GetSkillList()
	int curr = 0
	while (curr < skillList.Length)
		JsonUtil.SetFloatValue(sfile, skillList[curr], playerRef.GetBaseActorValue(skillList[curr]))
		curr += 1
	endWhile
	JsonUtil.Save(sfile)
endFunction

function DoExportPerks(String sfolder)
	String sfile = sfolder+"stats"
	JsonUtil.Load(sfile)
	JsonUtil.SetIntValue(sfile, "PerkPoints", Game.GetPerkPoints())
	JsonUtil.SetIntValue(sfile, "Level", playerRef.GetLevel())
	JsonUtil.SetFloatValue(sfile, "Experience", Game.GetPlayerExperience())

	JsonUtil.FormListClear(sfile, "OwnedPerks")
	String[] skillList = GetSkillList()
	int curr_a = 0
	int curr_b = 0
	while (curr_a <  skillList.Length)
		while (curr_b < ActorValueInfo.GetAVIbyName(skillList[curr_a]).GetPerks().Length)
			if (playerRef.HasPerk(ActorValueInfo.GetAVIbyName(skillList[curr_a]).GetPerks()[curr_b]))
				JsonUtil.FormListAdd(sfile, "OwnedPerks", ActorValueInfo.GetAVIbyName(skillList[curr_a]).GetPerks()[curr_b])
			endIf
			curr_b += 1
		endWhile
		curr_b = 0
		curr_a += 1
	endWhile
	JsonUtil.Save(sfile)
endFunction

;
; APPEARANCE
;

function DoExportAppearance(String sfolder)
	String sfile = sfolder+"appearance"
	JsonUtil.Load(sfile)
	JsonUtil.FormListClear(sfile, "HeadParts")
	JsonUtil.IntListClear(sfile, "TintMasks")
	JsonUtil.StringListClear(sfile, "TintMaskTexturePaths")
	
	int curr_a = 0
	while (curr_a < playerRef.GetActorBase().GetNumHeadParts())
		JsonUtil.FormListAdd(sfile, "HeadParts", playerRef.GetActorBase().GetNthHeadPart(curr_a))
		curr_a += 1
	endWhile
	
	int curr_b = 0
	while (curr_b < Game.GetNumTintMasks())
		JsonUtil.IntListAdd(sfile, "TintMasks", Game.GetNthTintMaskColor(curr_b))
		JsonUtil.StringListAdd(sfile, "TintMaskTexturePaths", Game.GetNthTintMaskTexturePath(curr_b))
		curr_b += 1
	endWhile

	JsonUtil.SetFormValue(sfile, "HairColor", playerRef.GetActorBase().GetHairColor())
	JsonUtil.SetFormValue(sfile, "Race", playerRef.GetRace())
	JsonUtil.SetFormValue(sfile, "Skin", playerRef.GetActorBase().GetSkin())
	JsonUtil.SetFormValue(sfile, "SkinFar", playerRef.GetActorBase().GetSkinFar())
	JsonUtil.SetFormValue(sfile, "FaceTextureSet", playerRef.GetActorBase().GetFaceTextureSet())
	JsonUtil.SetFloatValue(sfile, "Height", playerRef.GetActorBase().GetHeight())
	JsonUtil.SetFloatValue(sfile, "Weight", playerRef.GetActorBase().GetWeight())

	
	; MORPHS
	;
	; REMINDER:
	; I'm going to need to add the ability to export/import face morphs later on.  I noticed that, though the actual face parts themselves would be exported/imported,
	; the actual morph data wouldn't be.  Obviously.  So I need to fix that.
	; Only problem is that I have ZERO clue what the indexes for all the face morphs are, and have ZERO clue where to find them.
	; So I'm gonna just go ahead and work on the other stuff for now.
	;
	JsonUtil.Load(sfile+"_morphs")


	JsonUtil.Save(sfile+"_morphs")
	

	JsonUtil.Save(sfile)
endFunction

;
; INVENTORY & EQUIPMENT
;

function DoExportInventory(String sfolder)
	Debug.MessageBox("POG")
	;JsonUtil.FormListClear(sfile, "Inventory")
	JsonUtil.FormListClear(sfolder+"inventory/weapons", "WeaponForm")
	JsonUtil.IntListClear(sfolder+"inventory/weapons", "BaseDamage")
	JsonUtil.IntListClear(sfolder+"inventory/weapons", "CritDamage")
	JsonUtil.FloatListClear(sfolder+"inventory/weapons", "Reach")
	JsonUtil.FloatListClear(sfolder+"inventory/weapons", "MinRange")
	JsonUtil.FloatListClear(sfolder+"inventory/weapons", "MaxRange")
	JsonUtil.FloatListClear(sfolder+"inventory/weapons", "Speed")
	JsonUtil.FloatListClear(sfolder+"inventory/weapons", "Stagger")
	JsonUtil.IntListClear(sfolder+"inventory/weapons", "WeaponType")
	JsonUtil.StringListClear(sfolder+"inventory/weapons", "ModelPath")
	JsonUtil.StringListClear(sfolder+"inventory/weapons", "IconPath")
	JsonUtil.StringListClear(sfolder+"inventory/weapons", "MessageIconPath")
	JsonUtil.FormListClear(sfolder+"inventory/weapons", "Enchantment")
	JsonUtil.IntListClear(sfolder+"inventory/weapons", "EnchantmentValue")
	JsonUtil.FormListClear(sfolder+"inventory/weapons","EquippedModel")
	JsonUtil.FormListClear(sfolder+"inventory/weapons","EquipType")
	JsonUtil.StringListClear(sfolder+"inventory/weapons","Skill")
	JsonUtil.StringListClear(sfolder+"inventory/weapons","Resist")
	JsonUtil.FormListClear(sfolder+"inventory/weapons","CritEffect")
	;JsonUtil.BoolListClear(sfolder+"inventory/weapons","
	
	JsonUtil.ClearPath(sfolder+"inventory/weapons",".")

	
	int curr = 0
	while (curr < playerRef.GetNumItems())
		Form kForm = playerRef.GetNthForm(curr)
		if kForm.GetType() == 41 ; weapon
			ExportWeapon(sfolder, kForm as Weapon, curr)
		endIf
		curr += 1
	endWhile
endFunction

function ExportWeapon(String sfolder, Weapon wpn, Int someNumber)
	String sfile = sfolder+"inventory/weapons"
	String path = "."+(someNumber as String)+"."
	JsonUtil.Load(sfile)
	
	JsonUtil.SetPathFormValue(sfile, path+"Form", wpn as Form)
	JsonUtil.SetPathIntValue(sfile, path+"baseDamage", wpn.GetBaseDamage())
	JsonUtil.SetPathIntValue(sfile,path+"critDamage", wpn.GetCritDamage())
	JsonUtil.SetPathFloatValue(sfile,path+"Reach", wpn.GetReach())
	JsonUtil.SetPathFloatValue(sfile,path+"minRange", wpn.GetMinRange())
	JsonUtil.SetPathFloatValue(sfile,path+"maxRange", wpn.GetMaxRange())
	JsonUtil.SetPathFloatValue(sfile,path+"Speed", wpn.GetSpeed())
	JsonUtil.SetPathFloatValue(sfile,path+"Stagger", wpn.GetStagger())
	JsonUtil.SetPathIntValue(sfile,path+"weaponType", wpn.GetWeaponType())
	JsonUtil.SetPathStringValue(sfile,path+"modelPath", wpn.GetModelPath())
	JsonUtil.SetPathStringValue(sfile,path+"iconPath", wpn.GetIconPath())
	JsonUtil.SetPathStringValue(sfile,path+"messageIconPath", wpn.GetMessageIconPath())
	JsonUtil.SetPathFormValue(sfile,path+"enchantment.Form", wpn.GetEnchantment())
	
	int curr = 0
	while (curr < wpn.GetEnchantment().GetNumEffects())
		String encPath = path+"enchantment.effects."+(curr as String)+"."
		JsonUtil.SetPathFloatValue(sfile, encPath+"Magnitude",wpn.GetEnchantment().GetNthEffectMagnitude(curr))
		JsonUtil.SetPathIntValue(sfile, encPath+"Area", wpn.GetEnchantment().GetNthEffectArea(curr))
		JsonUtil.SetPathIntValue(sfile, encPath+"Duration", wpn.GetEnchantment().GetNthEffectDuration(curr))
		;Unfortunately, it doesn't look like it's possible to set NthEffectMagicEffect, even though it's possible to get it.
		;So I'll just have to stick with only being able to export/import the magnitude, area, and durations for now.
		;Hopefully there won't be any issues.
		curr += 1
	endWhile
	
	JsonUtil.SetPathIntValue(sfile,path+"enchantment.Value", wpn.GetEnchantmentValue())
	JsonUtil.SetPathFormValue(sfile, path+"equippedModel", wpn.GetEquippedModel())
	JsonUtil.SetPathFormValue(sfile, path+"equipType", wpn.GetEquipType())
	JsonUtil.SetPathStringValue(sfile, path+"Skill", wpn.GetSkill())
	JsonUtil.SetPathStringValue(sfile, path+"Resist", wpn.GetResist())
	;might need to add onto this thing so that it also stores the magnitude/whatever of the crit effect spell
	JsonUtil.SetPathFormValue(sfile, path+"critEffect", wpn.GetCritEffect())
	
	JsonUtil.SetPathIntValue(sfile, path+"critEffectOnDeath", wpn.GetCritEffectOnDeath() as Int)
	JsonUtil.SetPathFloatValue(sfile, path+"critMultiplier", wpn.GetCritMultiplier())

	;Basic stuff
	JsonUtil.SetPathIntValue(sfile, path+"goldValue", wpn.GetGoldValue())
	JsonUtil.SetPathStringValue(sfile, path+"Name", wpn.GetName())
	JsonUtil.SetPathFloatValue(sfile, path+"Weight", wpn.GetWeight())
	;apparently it's possible for some items to not have a world model, so I might want to add a checker to see if the thingy HAS a world model before trying to save it.
	;oh, and there's also world model texture sets, will prolly wanna add that stuff too.
	JsonUtil.SetPathStringValue(sfile,path+"worldModelPath", wpn.GetWorldModelPath())
	

	;I'm not sure what "keywords" are, but they seem important.
	;I might want to make a thingy to store all the keywords, too.

	JsonUtil.Save(sfile)
endFunction

;
; SPELLS, SHOUTS, & PASSIVE EFFECTS
;

function DoExportKnownSpells(String sfolder)

endFunction

function DoExportKnownShouts(String sfolder)

endFunction

function DoExportPassiveEffects(String sfolder)

endFunction
