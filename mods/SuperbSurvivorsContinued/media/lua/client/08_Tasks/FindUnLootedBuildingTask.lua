FindUnlootedBuildingTask = {}
FindUnlootedBuildingTask.__index = FindUnlootedBuildingTask

local isLocalLoggingEnabled = false;

function FindUnlootedBuildingTask:new(superSurvivor)
	CreateLogLine("FindUnLootedBuildingTask", isLocalLoggingEnabled, "function: FindUnlootedBuildingTask:new() called");
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.parent = superSurvivor
	o.Name = "Find New Building"
	o.OnGoing = false
	o.TargetBuilding = nil
	o.TryWindow = false
	o.TargetSquare = nil
	o.PreviousSquare = nil
	o.WanderDirection = nil
	o.TicksSinceReversedDir = 0
	o.parent.TargetBuilding = nil

	if (o.parent:getSeenCount() == 0) then o.parent:setSneaking(true) end
	return o
end

function FindUnlootedBuildingTask:OnComplete()
	CreateLogLine("FindUnLootedBuildingTask", isLocalLoggingEnabled, "function: FindUnlootedBuildingTask:OnComplete() called");
	self.parent:setSneaking(false)
end

function FindUnlootedBuildingTask:isComplete()
	if (self.parent:inUnLootedBuilding()) or self.parent.TargetBuilding ~= nil then
		if (self.parent.TargetBuilding == nil) then self.parent.TargetBuilding = self.parent:getBuilding() end
		return true
	else
		return false
	end
end

function FindUnlootedBuildingTask:isValid()
	if not self.parent then
		return false
	else
		return true
	end
end

function FindUnlootedBuildingTask:update()
	CreateLogLine("FindUnLootedBuildingTask", isLocalLoggingEnabled, "function: FindUnlootedBuildingTask:update() called");
	if (not self:isValid()) then return false end

	if (self.parent:getSeenCount() == 0) then self.parent:setSneaking(true) end
	if (self.parent:isInAction() == false) then
		if (self.TargetSquare == nil) then

			local range = 25
			local Square;
			local closestsoFar = range

			local spiral = SpiralSearch:new(self.parent.player:getX(), self.parent.player:getY(), range)
			local x, y;

			for i = spiral:forMax(), 0, -1 do
				x = spiral:getX()
				y = spiral:getY()

				local Square = getCell():getGridSquare(x, y, 0)
				if (Square) then
					local tempRoom = Square:getRoom()
					local SquaresBuilding
					if (tempRoom ~= nil) then SquaresBuilding = tempRoom:getBuilding() end

					if (Square:isOutside() == false) and (SquaresBuilding ~= nil)
						and not self.parent:getBuildingExplored(SquaresBuilding)
						and not self.parent:AttemptedLootBuilding(SquaresBuilding)
						and (self.parent:getWalkToAttempt(Square) < 6)
					then
						local distance = getDistanceBetween(Square, self.parent.player)
						if (distance < closestsoFar)
							and (not self.parent.player:getCurrentSquare():isBlockedTo(Square))
							and (Square:isFree(false))
						then
							closestsoFar = distance

							self.TargetSquare = Square;
							self.TryWindow = false;
						end
					end
				end

				if self.TargetSquare ~= nil then
					break
				end

				spiral:next()
			end
		end

		if not self.TargetSquare then -- wander
			if (self.TicksSinceReversedDir <= 15) then
				self.TicksSinceReversedDir = self.TicksSinceReversedDir + 1
			end

			if not self.WanderDirection then self.WanderDirection = ZombRand(1, 4) end

			if (self.TicksSinceReversedDir > 15) then -- Meaning just stop movement entirely, so it doesn't lag
				self.parent:StopWalk()
				self.parent:getTaskManager():clear()
				return false
			end

			if (self.parent.player:getCurrentSquare()) and (self.parent.player:getCurrentSquare():getZoneType() ~= "TownZone") and (self.TicksSinceReversedDir > 10) then -- reverse direction
				--self.TicksSinceReversedDir = 0
				if (self.WanderDirection == 1) then
					self.WanderDirection = 2
				elseif (self.WanderDirection == 2) then
					self.WanderDirection = 1
				elseif (self.WanderDirection == 3) then
					self.WanderDirection = 4
				elseif (self.WanderDirection == 4) then
					self.WanderDirection = 3
				end
			end

			local xoff = 0
			local yoff = 0

			if (self.WanderDirection == 1) then
				xoff = 20
			elseif (self.WanderDirection == 2) then
				xoff = -20
			elseif (self.WanderDirection == 3) then
				yoff = -20
			else
				yoff = 20
			end

			local sq = getCell():getGridSquare(self.parent.player:getX() + xoff + ZombRand(-5, 5),
				self.parent.player:getY() + yoff + ZombRand(-5, 5), 0)

			if (sq ~= nil) then
				self.parent:walkTo(sq);
			end
		else
			local attempts = self.parent:getWalkToAttempt(self.TargetSquare)
			if (attempts < 6) then
				-- WIP - Cows: What is "Square" HERE?
				self.parent:walkTo(self.parent:FindClosestOutsideSquare(Square));

				if (self.TargetSquare:getRoom() ~= nil) then
					self.parent.TargetBuilding = self.TargetSquare:getRoom()
						:getBuilding()
				end
			else
				self.parent:MarkAttemptedBuildingExplored(self.parent.TargetBuilding)
				self.parent.TargetBuilding = nil
				self.TargetSquare = nil
				self.TryWindow = false
			end
		end
	end
end
