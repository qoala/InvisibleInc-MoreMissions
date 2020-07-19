-- Brain for the assassination mission target.
-- Based on WimpBrain, but with more complex behavior once alerted.
local Brain = include("sim/btree/brain")
local btree = include("sim/btree/btree")
local actions = include("sim/btree/actions")
local conditions = include("sim/btree/conditions")
local CommonBrain = include( "sim/btree/commonbrain" )
local simdefs = include("sim/simdefs")
local simfactory = include( "sim/simfactory" )

require("class")

-- Actions for turning in place.

-- Flee to the safe room, then panic in place
local function SafeRoomPanic()
	return btree.Sequence("SafeRoomPanic",
		{
			btree.Condition(conditions.IsAlerted),
			btree.Action(actions.Panic),
			btree.Selector(
			{
				btree.Sequence(
				{
					btree.Condition(conditions.IsArmed),
					CommonBrain.RangedCombat(),
				}),
				btree.Sequence(
				{
					actions.MoveToNextPatrolPoint(),
					btree.Action(actions.mmTurnToCurrentFacing),
					btree.Action(actions.DoLookAround),
					btree.Action(actions.mmTurnToNextFacing),
				}),
			}),
		})
end

local BountyTargetBrain = class(Brain, function(self)
	Brain.init(self, "mmBountyTargetBrain",
		btree.Selector(
		{
			SafeRoomPanic(),
			btree.Sequence(
			{
				btree.Not(btree.Condition(conditions.IsAlerted)),
				btree.Selector(
				{
					CommonBrain.Investigate(),
					CommonBrain.Patrol(),
				}),
			}),
		})
	)
end)

function BountyTargetBrain:getPatrolFacing()
	local facings = self.unit:getTraits().patrolFacing
	local nextFacing = self.unit:getTraits().nextFacing

	if facings and nextFacing then
		return facings[nextFacing]
	else
		return self:getNextPatrolFacing()
	end
end

function BountyTargetBrain:getNextPatrolFacing()
	local facings = self.unit:getTraits().patrolFacing
	if not facings then
		return self.unit:getFacing()
	end

	local nextFacing = self.unit:getTraits().nextFacing
	if not nextFacing then
		nextFacing = 1
	else
		local maxFacing = #facings
		nextFacing = (nextFacing % maxFacing) + 1
	end
	self.unit:getTraits().nextFacing = nextFacing
	return facings[nextFacing]
end
    
local function createBrain()
	return BountyTargetBrain()
end

simfactory.register(createBrain)

return BountyTargetBrain
