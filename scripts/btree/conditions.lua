local Conditions = include("sim/btree/conditions")

function Conditions.IsArmed( sim, unit )
	return not unit:getTraits().pacifist
end
