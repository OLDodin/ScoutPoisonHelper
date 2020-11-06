Global("Locales", {})

function getLocale()
	return Locales[common.GetLocalization()] or Locales["eng"]
end

--------------------------------------------------------------------------------
-- Russian
--------------------------------------------------------------------------------

Locales["rus"]={}
Locales["rus"]["poisonBuffTarget"]="Слабый яд"
Locales["rus"]["poisonAction1"]="Обстрел"
Locales["rus"]["poisonAction2"]="Залп"


--------------------------------------------------------------------------------
-- English
--------------------------------------------------------------------------------

Locales["eng"]={}
Locales["eng"]["poisonBuffTarget"]="Слабый яд"
Locales["eng"]["poisonAction1"]="Обстрел"
Locales["eng"]["poisonAction2"]="Залп"

