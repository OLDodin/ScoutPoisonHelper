local m_poisonActionStr1 = getLocale()["poisonAction1"]
local m_poisonActionStr2 = getLocale()["poisonAction2"]
local m_poisonBuffTargetStr = getLocale()["poisonBuffTarget"]

local m_objParams = nil
local m_castingNow = false


local function GetPoisonBuffInfo(aBuffID)
	local targetID = avatar.GetTarget()
	if not targetID or not object.IsExist(targetID) then
		return
	end
	if unit.IsPlayer(targetID) or unit.IsPet(targetID) then
		return
	end
	local buffInfo = aBuffID and object.GetBuffInfo(aBuffID)
	if buffInfo and buffInfo.isStackable and buffInfo.stackLimit == 12 and buffInfo.name then
		local buffName = userMods.FromWString(buffInfo.name)
		if buffName == m_poisonBuffTargetStr then
			return buffInfo
		end
	end
end

function ActionStartCast(aParams)
	local actionName = userMods.FromWString(aParams.name)
	if aParams.name and aParams.progress < aParams.duration 
	and (actionName == m_poisonActionStr1 or actionName == m_poisonActionStr2)
	then
		if not m_castingNow then
			m_castingNow = true
		end
	else
		m_castingNow = false
	end
end

function ActionEndCast()
	m_castingNow = false
end

function CheckCast(aBuffID)
	local buffInfo = GetPoisonBuffInfo(aBuffID)

	if buffInfo and buffInfo.stackCount > 9 and buffInfo.stackCount ~= 12 then
		avatar.StopCasting()
	end
end

function BuffsChanged(aParams)
	if not m_castingNow then
		return
	end
	for objId, buffs in pairs( aParams.objects ) do
		if avatar.GetTarget() == objId then
			for buffId, active in pairs( buffs ) do
				if active then
					CheckCast(buffId)
				end
			end
		end
	end 
end

function Init()
	common.RegisterEventHandler(ActionStartCast, "EVENT_ACTION_PROGRESS_START")
	common.RegisterEventHandler(ActionEndCast, "EVENT_ACTION_PROGRESS_FINISH")
	common.RegisterEventHandler(ActionEndCast, "EVENT_PROCESS_TERMINATED")
	
	common.RegisterEventHandler(BuffsChanged, "EVENT_OBJECT_BUFFS_ELEMENT_CHANGED")
end

if avatar.IsExist() then
	Init()
else
	common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")
end