Scriptname SSSSS_UtilScript   

String[] function GetSkillList() global
	; Returns an array containing the names of all the skills in vanilla Skyrim
	String[] skillList = new String[18]
	skillList[0] = "OneHanded"
	skillList[1] = "TwoHanded"
	skillList[2] = "Marksman"
	skillList[3] = "Block"
	skillList[4] = "Smithing"
	skillList[5] = "HeavyArmor"
	skillList[6] = "LightArmor"
	skillList[7] = "Pickpocket"
	skillList[8] = "Lockpicking"
	skillList[9] = "Sneak"
	skillList[10] = "Alchemy"
	skillList[11] = "Speechcraft"
	skillList[12] = "Alteration"
	skillList[13] = "Conjuration"
	skillList[14] = "Destruction"
	skillList[15] = "Illusion"
	skillList[16] = "Restoration"
	skillList[17] = "Enchanting"
	return skillList
endFunction