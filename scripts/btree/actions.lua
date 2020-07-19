local Actions = include("sim/btree/actions")
local simdefs = include("sim/simdefs")

-- Turn-in-place actions for BountyTargetBrain.
-- Depend on facing getters of that brain.
function Actions.mmTurnToCurrentFacing(sim, unit)
	local facing = unit:getBrain():getPatrolFacing()
	unit:updateFacing(facing)
	return simdefs.BSTATE_COMPLETE
end

function Actions.mmTurnToNextFacing(sim, unit)
	local facing = unit:getBrain():getNextPatrolFacing()
	unit:updateFacing(facing)
	return simdefs.BSTATE_COMPLETE
end
