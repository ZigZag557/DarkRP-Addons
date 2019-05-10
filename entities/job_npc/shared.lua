ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName = "Job NPC"

ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = true


function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end


JobNPCQuestions = {}

JobNPCQuestions["Citizen"] = 
{


	{
		question = "Should you drive while you are drunk?",
		answers = 
		{
			["Yeah!"] = false,
			["Maybe"] = false,
			["Never!"] = true
		}

	},

	{
		question = "Another question",
		answers = 
		{
			["I believe that"] = true,
			["Yes, that must be true!"] = true,
			["Nope"] = false
		}

	}

}


JobNPCQuestions["Hobo"] = 
{
	{
		question = "Should you ask money from people?",
		answers = 
		{
			["Yeah!"] = true,
			["Maybe"] = false,
			["Never!"] = false
		}

	},

	{
		question = [[You are driving a car with your dear friends. One of them starts disrespecting hobos. What do you do?
					You are driving a car with your dear friends. One of them starts disrespecting hobos. What do you do?
					You are driving a car with your dear friends. One of them starts disrespecting hobos. What do you do?
					You are driving a car with your dear friends. One of them starts disrespecting hobos. What do you do?]],
		answers = 
		{
			["I would never do that."] = true,
			["Yes, I might do that."] = true,
			["I would never do such thing."] = false
		}

	},
	{
		question = "You are driving a car with your dear friends. One of them starts disrespecting hobos. What do you do?",
		answers = 
		{
			["I would never do that."] = true,
			["Yes, I might do that."] = true,
			["I would never do such thing."] = false
		}

	},
	{
		question = "You are driving a car with your dear friends. One of them starts disrespecting hobos. What do you do?",
		answers = 
		{
			["I would never do that."] = true,
			["Yes, I might do that."] = true,
			["I would never do such thing."] = false
		}

	},
	{
		question = "You are driving a car with your dear friends. One of them starts disrespecting hobos. What do you do?",
		answers = 
		{
			["I would never do that."] = true,
			["Yes, I might do that."] = true,
			["I would never do such thing."] = false
		}

	},
	{
		question = "You are driving a car with your dear friends. One of them starts disrespecting hobos. What do you do?",
		answers = 
		{
			["I would never do that."] = true,
			["Yes, I might do that."] = true,
			["I would never do such thing."] = false
		}

	},
	{
		question = "You are driving a car with your dear friends. One of them starts disrespecting hobos. What do you do?",
		answers = 
		{
			["I would never do that."] = true,
			["Yes, I might do that."] = true,
			["I would never do such thing."] = false
		}

	}

}

JobNPCQuestions["Gangster"] = 
{
	{
		question = "Soda guy test.",

		answers = 
		{
			["True answer"] = true,
			["Wrong answer"] = false

		}

	}

}
