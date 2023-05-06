DialogueTask = {}
DialogueTask.__index = DialogueTask

local isLocalLoggingEnabled = false;

function DialogueTask:new(superSurvivor, TalkToMe, Dialogue, isYesOrNoQuestion, Trigger, YesResultActions,
						  NoResultActions, ContinueResultActions, useWindowDialogue)
	CreateLogLine("DialogueTask", isLocalLoggingEnabled, "DialogueTask:new() Called");

	local o = {}
	setmetatable(o, self)
	self.__index = self

	if (not IsItemArray(Dialogue)) then
		Dialogue = { Dialogue }
	end

	superSurvivor:StopWalk()

	-- WIP - Cows: When and where was "selfInitiated" assigned a value? This is still unassigned...
	o.WasSelfInit = selfInitiated
	o.Aite = TalkToMe
	o.parent = superSurvivor
	o.Name = "Direct Dialogue"
	o.TriggerName = Trigger
	o.useWindowDialogue = useWindowDialogue
	o.isYesOrNoQuestion = isYesOrNoQuestion
	o.YesResultActions = YesResultActions
	o.ContinueResultActions = ContinueResultActions
	o.NoResultActions = NoResultActions

	o.Current = 1
	o.Dialogue = Dialogue

	if (isYesOrNoQuestion) and (YesResultActions == nil) then
		CreateLogLine("DialogueTask", isLocalLoggingEnabled, "Warning: YesResultActions=nil on question dialogue!");
	end

	if (not o.Dialogue) then return nil end

	return o
end

function DialogueTask:isComplete()
	if self.Current > #self.Dialogue then
		self.parent.ContinueResultActions = self.ContinueResultActions --
		self.parent.TriggerName = self.TriggerName               --

		if (self.isYesOrNoQuestion) then
			self.parent.HasQuestion = true
			self.parent.NoResultActions = self.NoResultActions --
			self.parent.YesResultActions = self.YesResultActions -- 			
		end
		return true
	else
		return false
	end
end

function DialogueTask:isValid()
	if not self.parent or not self.Aite then
		return false
	else
		return true
	end
end

function DialogueTask:update()
	CreateLogLine("DialogueTask", isLocalLoggingEnabled, "DialogueTask:update() Called");
	if (not self:isValid()) then return false end

	if (self.parent:isInAction() == false) then
		local distance = getDistanceBetween(self.parent.player, self.Aite)
		if (distance > 1.8) then
			self.parent:walkTo(self.Aite:getCurrentSquare())
		else
			self.parent:StopWalk()
			self.parent.player:faceThisObject(self.Aite)

			if (not self.useWindowDialogue) then
				self.parent:Speak(self.Dialogue[self.Current])
				self.parent.player:getModData().lastThingIsaid = self.Dialogue[self.Current]
				self.Current = self.Current + 1
				self.parent:Wait(4)
			else
				self.Current = 99999
				self.parent:Wait(1)

				-- WIP - Cows: When and where was "myDialogueWindow" initiated? if this is a quest related item, it should be removed.
				myDialogueWindow:start(self.parent, self.Dialogue, self.isYesOrNoQuestion)
			end

			self:isComplete()
		end
	end
end
