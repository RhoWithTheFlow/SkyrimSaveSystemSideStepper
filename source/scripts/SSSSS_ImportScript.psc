Scriptname SSSSS_ImportScript extends Quest  
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

function InvokeImport(String filename)
	String sfolder = maindir+filename+"/"
	playerRef = Game.GetPlayer()
	
	Debug.Notification("Loading character data from file...")
	
	DoImport(sfolder)
	
	Debug.Notification("Load success.")
endFunction

function DoImport(String sfolder)
	if (opBasicAttributes)
		DoImportBasicAttributes(sfolder)
	endIf
	if (opSkillLevels)
		DoImportSkillLevels(sfolder)
	endIf
	if (opPerks)
		DoImportPerks(sfolder)
	endIf
	if (opAppearance)
		DoImportAppearance(sfolder)
	endIf
	if (opInventory)
		DoImportInventory(sfolder)
	endIf
endFunction

;
; STATS
;

function DoImportBasicAttributes(String sfolder)
	String sfile = sfolder+"stats"
	playerRef.SetActorValue("Health", JsonUtil.GetFloatValue(sfile, "Health"))
	playerRef.SetActorValue("Magicka", JsonUtil.GetFloatValue(sfile, "Magicka"))
	playerRef.SetActorValue("Stamina", JsonUtil.GetFloatValue(sfile, "Stamina"))
endFunction

function DoImportSkillLevels(String sfolder)
	String sfile = sfolder+"stats"
	String[] skillList = GetSkillList()
	int curr = 0
	while (curr < skillList.Length)
		playerRef.SetActorValue(skillList[curr], JsonUtil.GetFloatValue(sfile, skillList[curr]))
		curr += 1
	endWhile
endFunction

function DoImportPerks(String sfolder)
	String sfile = sfolder+"stats"
	Game.SetPerkPoints(JsonUtil.GetIntValue(sfile, "PerkPoints"))
	Game.SetPlayerLevel(JsonUtil.GetIntValue(sfile, "Level"))
	Game.SetPlayerExperience(JsonUtil.GetFloatValue(sfile, "Experience"))

	int curr = 0
	while (curr < JsonUtil.FormListCount(sfile, "OwnedPerks"))
		playerRef.AddPerk(JsonUtil.FormListGet(sfile, "OwnedPerks", curr) as Perk)
		curr += 1
	endWhile
endFunction

;
; APPEARANCE
;

function DoImportAppearance(String sfolder)
	String sfile = sfolder+"appearance"
	int curr = 0
	while (curr < JsonUtil.FormListCount(sfile, "HeadParts"))
		playerRef.GetActorBase().SetNthHeadPart(JsonUtil.FormListGet(sfile, "HeadParts", curr) as HeadPart, curr)
		curr += 1
	endWhile
	
	curr = 0
	while (curr < JsonUtil.IntListCount(sfile, "TintMasks"))
		Game.SetNthTintMaskColor(curr, JsonUtil.IntListGet(sfile, "TintMasks", curr))
		Game.SetNthTintMaskTexturePath(JsonUtil.StringListGet(sfile, "TintMaskTexturePaths", curr), curr)
		curr += 1
	endWhile

	playerRef.GetActorBase().SetHairColor(JsonUtil.GetFormValue(sfile, "HairColor") as ColorForm)
	playerRef.SetRace(JsonUtil.GetFormValue(sfile, "Race") as Race)
	playerRef.GetActorBase().SetSkin(JsonUtil.GetFormValue(sfile, "SkinFar") as Armor)
	playerRef.GetActorBase().SetSkinFar(JsonUtil.GetFormValue(sfile, "Skin") as Armor)
	playerRef.GetActorBase().SetFaceTextureSet(JsonUtil.GetFormValue(sfile, "FaceTextureSet") as TextureSet)
	playerRef.GetActorBase().SetHeight(JsonUtil.GetFloatValue(sfile, "Height"))
	playerRef.GetActorBase().SetWeight(JsonUtil.GetFloatValue(sfile, "Weight"))

	playerRef.QueueNiNodeUpdate() ; make changes visible
endFunction

;
; INVENTORY & EQUIPMENT
;

function DoImportInventory(String sfolder)
	ImportWeapons(sfolder)
	;int curr = 0
	;while (curr < JsonUtil.FormListCount(sfile, "Inventory"))
	;	playerRef.AddItem(JsonUtil.FormListGet(sfile, "Inventory", curr), 1, False)
	;	curr += 1
	;endWhile
endFunction

function ImportWeapons(String sfolder)
	String sfile = sfolder+"inventory/weapons"
	
	Debug.MessageBox(JsonUtil.PathCount(sfile,"."))
	Debug.MessageBox(JsonUtil.PathMembers(sfile,"."))
	int curr = 0
	while (curr < JsonUtil.PathCount(sfile,"."))
		String path = (JsonUtil.PathMembers(sfile,".")[curr])+"."
		Weapon wpn = JsonUtil.GetPathFormValue(sfile, path+"Form") as Weapon
		wpn.SetBaseDamage(JsonUtil.GetPathIntValue(sfile, path+"baseDamage"))
		wpn.SetCritDamage(JsonUtil.GetPathIntValue(sfile, path+"critDamage"))
		wpn.SetReach(JsonUtil.GetPathFloatValue(sfile,path+"Reach"))
		wpn.SetMinRange(JsonUtil.GetPathFloatValue(sfile,path+"minRange"))
		wpn.SetMaxRange(JsonUtil.GetPathFloatValue(sfile,path+"maxRange"))
		wpn.SetSpeed(JsonUtil.GetPathFloatValue(sfile,path+"Speed"))
		wpn.SetStagger(JsonUtil.GetPathFloatValue(sfile,path+"Stagger"))
		wpn.SetWeaponType(JsonUtil.GetPathIntValue(sfile,path+"WeaponType"))
		wpn.SetModelPath(JsonUtil.GetPathStringValue(sfile,path+"ModelPath"))
		wpn.SetIconPath(JsonUtil.GetPathStringValue(sfile,path+"IconPath"))
		wpn.SetMessageIconPath(JsonUtil.GetPathStringValue(sfile,path+"MessageIconPath"))
		
		Enchantment enc = JsonUtil.GetPathFormValue(sfile,path+"enchantment.Form") as Enchantment
		int encCurr = 0
		while (encCurr < JsonUtil.PathCount(sfile,path+"enchantment.effects."))
			enc.SetNthEffectMagnitude(encCurr, JsonUtil.GetPathFloatValue(sfile,path+"enchantment.effects."+(encCurr as String)+".Magnitude"))
			Debug.MessageBox(JsonUtil.GetPathFloatValue(sfile,path+"enchantment.effects."+(encCurr as String)+".Magnitude"))
			enc.SetNthEffectArea(encCurr, JsonUtil.GetPathIntValue(sfile,path+"enchantment.effects."+(encCurr as String)+".Area"))
			enc.SetNthEffectDuration(encCurr, JsonUtil.GetPathIntValue(sfile,path+"enchantment.effects."+(encCurr as String)+".duration"))
			encCurr+=1
		endWhile
		wpn.SetEnchantment(enc)
		
		wpn.SetEnchantmentValue(JsonUtil.GetPathIntValue(sfile,path+"enchantment.Value"))
		wpn.SetEquippedModel(JsonUtil.GetPathFormValue(sfile,path+"EquippedModel") as Static)
		wpn.SetEquipType(JsonUtil.GetPathFormValue(sfile,path+"EquipType") as EquipSlot)
		wpn.SetSkill(JsonUtil.GetPathStringValue(sfile,path+"Skill"))
		wpn.SetResist(JsonUtil.GetPathStringValue(sfile,path+"Resist"))
		
		Spell ce = JsonUtil.GetPathFormValue(sfile,path+"CritEffect") as Spell
		wpn.SetCritEffect(ce)
		
		wpn.SetCritEffectOnDeath(JsonUtil.GetPathIntValue(sfile,path+"critEffectOnDeath") != 0)
		wpn.SetCritMultiplier(JsonUtil.GetPathFloatValue(sfile,path+"critMultiplier"))
		
		wpn.SetGoldValue(JsonUtil.GetPathIntValue(sfile, path+"goldValue"))
		wpn.SetWeight(JsonUtil.GetPathFloatValue(sfile,path+"Weight"))
		wpn.SetName(JsonUtil.GetPathStringValue(sfile,path+"name"))
		wpn.SetWorldModelPath(JsonUtil.GetPathStringValue(sfile,path+"worldModelPath"))
		;;;
		playerRef.AddItem(wpn, 1, False)
		curr += 1
	endWhile

	;int curr = 0
	;while (curr < JsonUtil.FormListCount(sfile,"WeaponForm"))
		;Weapon thisWeapon = JsonUtil.FormListGet(sfile, "WeaponForm", curr) as Weapon
		;thisWeapon.SetBaseDamage(JsonUtil.IntListGet(sfile, "BaseDamage", curr))
		;thisWeapon.SetCritDamage(JsonUtil.IntListGet(sfile, "CritDamage", curr))
		
		;playerRef.AddItem(thisWeapon, 1, False)
		;curr += 1
	;endWhile
	
endFunction

;
; SPELLS, SHOUTS, & PASSIVE EFFECTS
;

function DoImportKnownSpells(String sfolder)

endFunction

function DoImportKnownShouts(String sfolder)

endFunction

function DoImportPassiveEffects(String sfolder)

endFunction
