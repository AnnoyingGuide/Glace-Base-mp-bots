
-- Here's a fairly simple Player that will simply walk around and shoot at people sometimes.
-- This will give a good example on the useage of the Glaces. I will be refering them as Players throughout the code.

-- Just localizing some stuff 
local random = math.random
local has_talked = false
local hasSwitchedm = false
local hasSwitchedl = false
local hasSwitcheds = false

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

-- This table is used for when we need to know which entity class name we need to look for to get ammo
local ammotranslation = {
    ["Pistol"] = "item_ammo_pistol",
    ["AR2"] = "item_ammo_ar2",
    ["SMG1"] = "item_ammo_smg1",
    ["357"] = "item_ammo_357",
    ["XBowBolt"] = "item_ammo_crossbow",
    ["Buckshot"] = "item_box_buckshot",
    ["RPG_Round"] = "item_rpg_round",

}

local Taunts = {
	"bot/hes_dead.wav",
	"bot/hes_down.wav",
	"bot/got_him.wav", 
	"bot/dropped_him.wav", 
	"bot/killed_him.wav", 
	"bot/ruined_his_day.wav", 
	"bot/wasted_him.wav", 
	"bot/took_him_out.wav", 
	"bot/took_him_out2.wav", 
	"bot/took_him_down.wav", 
	"bot/made_him_cry.wav", 
	"bot/hes_broken.wav", 
	"bot/hes_done.wav" 
}

local Helps = {
	"bot/taking_fire_need_assistance2.wav",
	"bot/i_could_use_some_help.wav", 
	"bot/i_could_use_some_help_over_here.wav", 
	"bot/help.wav", 
	"bot/need_help.wav", 
	"bot/need_help2.wav", 
	"bot/im_in_trouble.wav"
}

local Death = {
	"bot/pain2.wav",
	"bot/pain4.wav",
	"bot/pain5.wav",
	"bot/pain8.wav",
	"bot/pain9.wav",
	"bot/pain10.wav",
}

local Engage = {
	"bot/attacking.wav", 
	"bot/attacking_enemies.wav", 
	"bot/engaging_enemies.wav", 
	"bot/in_combat.wav", 
	"bot/in_combat2.wav", 
	"bot/returning_fire.wav" 
}

local FriendKill = {
	"bot/what_happened.wav",
	"bot/noo.wav",
	"bot/oh_my_god.wav",
	"bot/oh_man.wav",
	"bot/oh_no_sad.wav",
	"bot/what_have_you_done.wav",
}

local Pain = {
	"bot/ow.wav",
	"bot/ouch.wav",
}

local Long_guns = {
	"weapon_357",
	"weapon_pistol",
	"weapon_crossbow",
	"weapon_ar2",
	"weapon_rpg",
	"weapon_smg1",
	"weapon_357_hl1",
	"weapon_crossbow_hl1",
	"weapon_glock_hl1",
	"weapon_egon",
	"weapon_hornetgun",
	"weapon_mp5_hl1",
	"weapon_rpg_hl1",
	"weapon_gauss",
}

local Short_guns = {
	"weapon_shotgun",
	"weapon_frag",
	"weapon_handgrenade",
	"weapon_snark",
	"weapon_shotgun_hl1",
}

local melee = {
	"weapon_crowbar",
	"weapon_stunstick",
	"weapon_crowbar_hl1",
	"weapon_fists",
}

local AllEnemies = {
	["npc_cscanner"]=true,
	["CombineElite"]=true,
	["npc_combine_s"]=true,
	["npc_hunter"]=true,
	["npc_manhack"]=true,
	["npc_metropolice"]=true,
	["CombinePrison"]=true,
	["PrisonShotgunner"]=true,
	["npc_clawscanner"]=true,
	["ShotgunSoldier"]=true,
	["npc_stalker"]=true,
	["monster_alien_grunt"]=true,
	["monster_alien_slave"]=true,
	["monster_human_assassin"]=true,
	["monster_babycrab"]=true,
	["monster_bullchicken"]=true,
	["monster_alien_controller"]=true,
	["monster_bigmomma"]=true,
	["monster_human_grunt"]=true,
	["monster_headcrab"]=true,
	["monster_turret"]=true,
	["monster_houndeye"]=true,
	["monster_miniturret"]=true,
	["monster_sentry"]=true,
	["monster_zombie"]=true,
	["npc_antlion"]=true,
	["npc_antlionguard"]=true,
	["npc_antlionguardian"]=true,
	["npc_antlion_worker"]=true,
	["npc_barnacle"]=true,
	["npc_headcrab_fast"]=true,
	["npc_fastzombie"]=true,
	["npc_fastzombie_torso"]=true,
	["npc_headcrab"]=true,
	["npc_headcrab_black"]=true,
	["npc_poisonzombie"]=true,
	["npc_zombie"]=true,
	["npc_zombie_torso"]=true,
	["npc_zombine"]=true,
}

local names = {
    "Beta",
	"Generic Name 1",
	"Ze Uberman",
	"Q U A N T U M P H Y S I C S",
	"portable fridge",
	"Methman456",
	"i rdm kids for breakfast",
	"Cheese Adiction Therapist",
	"private hoovy",
	"Socks with Sandals",
	"Solar",
	"AdamYeBoi",
	"troll",
	"de_struction and de_fuse",
	"de_rumble",
	"decoymail",
	"Damian",
	"BrandontheREDSpy",
	"Braun",
	"brent13",
	"BrokentoothMarch",
	"BruH",
	"BudLightVirus",
	"Call of Putis",
	"CanadianBeaver",
	"Cake brainer",
	"cant scream in space",
	"CaptGravyBoness",
	"CaraKing09",
	"CarbonTugboat",
	"CastHalo",
	"cate",
	"ccdrago56",
	"cduncan05",
	"Chancellor_Ant",
	"Changthunderwang",
	"Charstorms",
	"Ch33kCLaper69",
	"Get Good Get Lmao Box",
	"Atomic",
	"Audrey",
	"Auxometer",
	"A Wise Author",
	"Awtrey516",
	"Aytx",
	"BabaBooey",
	"BackAlleyDealerMan",
	"BalieyeatsPizza",
	"ballzackmonster",
	"Banovinski",
	"bardochib",
	"BBaluka",
	"Bean man",
	"Bear",
	"Bearman_18",
	"beeflover100",
	"Albeon Stormhammer",
	"Andromedus",
	"Anilog",
	"Animus",
	"Sorry_an_Error_has_Occurred",
	"I am the Spy",
	"engineer gaming",
	"Ze Uberman",
	"Regret",
	"Sora",
	"Sky",
	"Scarf",
	"Graves",
	"bruh moment",
	"Garrys Mod employee",
	"i havent eaten in 69 days",
	"DOORSTUCK89",
	"PickUp That Can Cop",
	"Never gonna give you up",
	"if you are reading this, ur mom gay ",
	"The Lemon Arsonist",
	"Cave Johnson",
	"Chad",
	"Speedy",
	"Alan"
}
-- probably a better way to do random models, but I think this will work anyways
local models = {
    "models/player/alyx.mdl",
	"models/player/barney.mdl",
	"models/player/breen.mdl",
	"models/player/charple.mdl",
	"models/player/p2_chell.mdl",
	"models/player/combine_soldier.mdl",
	"models/player/combine_super_soldier.mdl",
	"models/player/combine_soldier_prisonguard.mdl",
	"models/player/corpse1.mdl",
	"models/player/arctic.mdl",
	"models/player/gasmask.mdl",
	"models/player/guerilla.mdl",
	"models/player/leet.mdl",
	"models/player/phoenix.mdl",
	"models/player/riot.mdl",
	"models/player/swat.mdl",
	"models/player/urban.mdl",
	"models/player/dod_american.mdl",
	"models/player/dod_german.mdl",
	"models/player/eli.mdl",
	"models/player/Group01/female_01.mdl",
	"models/player/Group01/female_02.mdl",
	"models/player/Group01/female_03.mdl",
	"models/player/Group01/female_03.mdl",
	"models/player/Group01/female_04.mdl",
	"models/player/Group01/female_05.mdl",
	"models/player/Group01/female_06.mdl",
	"models/player/Group03/female_01.mdl",
	"models/player/Group03/female_02.mdl",
	"models/player/Group03/female_03.mdl",
	"models/player/Group03/female_04.mdl",
	"models/player/Group03/female_05.mdl",
	"models/player/Group03/female_06.mdl",
	"models/player/gman_high.mdl",
	"models/player/hostage/hostage_01.mdl",
	"models/player/hostage/hostage_02.mdl",
	"models/player/hostage/hostage_03.mdl",
	"models/player/hostage/hostage_04.mdl",
	"models/player/kleiner.mdl",
	"models/player/magnusson.mdl",
	"models/player/Group01/male_01.mdl",
	"models/player/Group01/male_02.mdl",
	"models/player/Group01/male_03.mdl",
	"models/player/Group01/male_04.mdl",
	"models/player/Group01/male_05.mdl",
	"models/player/Group01/male_06.mdl",
	"models/player/Group01/male_07.mdl",
	"models/player/Group01/male_08.mdl",
	"models/player/Group01/male_09.mdl",
	"models/player/Group03/male_01.mdl",
	"models/player/Group03/male_02.mdl",
	"models/player/Group03/male_03.mdl",
	"models/player/Group03/male_04.mdl",
	"models/player/Group03/male_05.mdl",
	"models/player/Group03/male_06.mdl",
	"models/player/Group03/male_07.mdl",
	"models/player/Group03/male_08.mdl",
	"models/player/Group03/male_09.mdl",
	"models/player/Group03m/male_01.mdl",
	"models/player/Group03m/male_02.mdl",
	"models/player/Group03m/male_03.mdl",
	"models/player/Group03m/male_04.mdl",
	"models/player/Group03m/male_05.mdl",
	"models/player/Group03m/male_06.mdl",
	"models/player/Group03m/male_07.mdl",
	"models/player/Group03m/male_08.mdl",
	"models/player/Group03m/male_09.mdl",
	"models/player/Group03m/female_01.mdl",
	"models/player/Group03m/female_02.mdl",
	"models/player/Group03m/female_03.mdl",
	"models/player/Group03m/female_04.mdl",
	"models/player/Group03m/female_05.mdl",
	"models/player/Group03m/female_06.mdl",
	"models/player/monk.mdl",
	"models/player/mossman.mdl",
	"models/player/mossman_arctic.mdl",
	"models/player/odessa.mdl",
	"models/player/police.mdl",
	"models/player/police_fem.mdl",
	"models/player/Group02/male_02.mdl",
	"models/player/Group02/male_04.mdl",
	"models/player/Group02/male_06.mdl",
	"models/player/Group02/male_08.mdl",
	"models/player/skeleton.mdl",
	"models/player/soldier_stripped.mdl",
	"models/player/zombie_classic.mdl",
	"models/player/zombie_fast.mdl",
	"models/player/zombie_soldier.mdl",
}

-- To start off, we encase the entire player in their own function to spawn them.
function SpawnTeamGlacePlayer()
    local ply = Glace_CreatePlayer( names[ random( #names ) ], models[ random( #models ) ], "GLACERANDOM" )

    if !IsValid( ply ) then print( "Unable to spawn player! Player limit may have been reached!" ) return end -- We need to make sure that we say this and end this function or else we get useless bug reports

    -- We now start making the AI

    ply:Glace_SetAutoReload( true )
    ply:Glace_SwitchWeapon("weapon_ar2")
    ply:Glace_SetThinkTime( 0.1 )


    -- For this player, we'll create a form of State System to work with.
    -- We'll create a custom var and a few new functions for this specific Player.
    ply.Glace_State = "idle"

    function ply:Glace_GetState() -- Returns the Glace_State
        return self.Glace_State
    end

    function ply:Glace_SetState( state ) -- Sets the state. We'll be using this to switch from a idle mode to a combat
        self.Glace_LastState = self.Glace_State
        self.Glace_State = state
    end

    function ply:Glace_GetLastState() -- Gets the last state the player was in
        return self.Glace_LastState
    end

    function ply:Glace_SetEnemy( ent ) -- Set the enemy
        self.Glace_Enemy = ent
    end

    function ply:Glace_GetEnemy() -- Get the enemy
        return self.Glace_Enemy
    end



    function ply:Glace_OnKilled( attacker, inflictor )
		self:EmitSound( Death[ random( #Death ) ] )
		self:Glace_Timer( 3, function() self:Spawn() end)
    end

    function ply:Glace_OnHurt( attacker, hp, damage ) -- Play a generic pain sound
        if attacker == self then return end
		self:Glace_Face( attacker )
		self:EmitSound( Pain[ random( #Pain ) ] )
        --self:Glace_CancelMove() 
        --self:Glace_SetEnemy( attacker )
        --self:Glace_SetState( "incombat" )
    end

    -- Now we create our normal Think hook
    function ply:Glace_Think()

        --if random(50) == 1 then
            --self:Glace_SaySoundFile( "vo/breencast/br_instinct01.wav" )
        --end

        if self:Health() < self:GetMaxHealth()*0.4 and self:Glace_GetState() != "findmedkits" then -- I NEED A MEDIC BAG
            self:Glace_SetState("findmedkits")
            self:Glace_CancelMove()
        end

        if IsValid(self:GetActiveWeapon()) and !self:GetActiveWeapon():HasAmmo() and self:Glace_GetState() != "findammo" then -- If we run out of ammo, then find some
            self:Glace_SetState("findammo")
            self:Glace_CancelMove()
        end

        if self:Glace_GetState() == "incombat" and !IsValid(self.Glace_Enemy) then -- If our enemy isn't valid then just go back to normal
            self:Glace_Sprint( false )
            self:Glace_StopFace()
            self:Glace_SetState( "idle" )
            self:Glace_SetEnemy(nil)
        end

        if IsValid( self.Glace_Enemy ) and self:Glace_CanSee( self.Glace_Enemy ) then -- Shoot at our target if we can see em

            self:Glace_AddKeyPress( IN_ATTACK )
            return 
        end -- If the enemy is valid then don't run the code below

        local surrounding = self:Glace_FindInSphere( 1500, function(ent) if IsValid(ent) and AllEnemies[ent:GetClass()] then return true end end ) -- Get Nearby NPCs and Players we can see

        for k, v in RandomPairs(surrounding) do -- Select a random target
			
            self:Glace_CancelMove() 
            self:Glace_SetEnemy( v )
            self:Glace_SetState( "incombat" )
            break
        end

    end

    -- This hook is the same as Nextbot's ENT:OnOtherKilled(). This will be called whenever a NPC, Nextbot, or Player that isn't us dies
    function ply:Glace_OnOtherKilled( victim, attacker, inflictor )

        if victim == self:Glace_GetEnemy() then
            self:Glace_Sprint( false )
            self:Glace_StopFace()
            self:Glace_SetState( "idle" )
            self:Glace_SetEnemy(nil)
			self:EmitSound( Taunts[ random( #Taunts ) ] )
        end
    end

    function ply:Glace_ThreadedThink() -- Same as Nextbot's ENT:RunBehaviour() except this is internally in a while true loop so it'll constantly run the function after it finishes the entire function
        
        if self:Glace_GetState() == "idle" then -- Idle state will just be wandering

            self:Glace_Sprint( false )
			has_talked = false

            local pos = self:Glace_GetRandomPosition( 2000 ) -- Get a random spot that we want to go to
            self:Glace_MoveToPos( pos ) -- Go to that spot with the default args

        elseif self:Glace_GetState() == "incombat" and IsValid( self:Glace_GetEnemy() ) then -- Combat State
			if not has_talked then
				self:EmitSound( Engage[ random( #Engage ) ] )
				has_talked = true
			end
			
			-- weapon switching code can probabley be done better, but I think it's ok
			local range = 160000
			local TargetDist = self:Glace_GetRangeSquaredTo( self:Glace_GetEnemy() )
			local weps = self:GetWeapons()
			if (TargetDist < range/4 and TargetDist < range*2) and not hasSwitchedm then
					self:Glace_SwitchWeapon( melee[ random( #melee ) ] )
					if not table.contains(weps, melee) then
						self:Glace_SwitchWeapon( melee[ random( #melee ) ] )
					end
					hasSwitchedm = true
					hasSwitchedl = false
					hasSwitcheds = false
			elseif (TargetDist > range) and not hasSwitchedl then
					self:Glace_SwitchWeapon( Long_guns[ random( #Long_guns ) ] )
					if not table.contains(weps, Long_guns) then
						self:Glace_SwitchWeapon( Long_guns[ random( #Long_guns ) ] )
					end
					hasSwitchedm = false
					hasSwitchedl = true
					hasSwitcheds = false
			elseif (TargetDist < range) and not hasSwitcheds then
					self:Glace_SwitchWeapon( Short_guns[ random( #Short_guns ) ] )
					if not table.contains(weps, Short_guns) then
						self:Glace_SwitchWeapon( Short_guns[ random( #Short_guns ) ] )
					end
					hasSwitchedm = false
					hasSwitchedl = false
					hasSwitcheds = true
			end
			
            -- This timer makes the player bhop
            self:Glace_Timer( 0.4, function()
                if !IsValid( self:Glace_GetEnemy() ) then return "remove" end
                if self:Glace_GetRangeSquaredTo( self:Glace_GetEnemy() ) <= ( 200 * 200 ) then return "remove" end
                if self:Glace_GetState() != "incombat" then return "remove" end  -- We return "remove" so that the timer will remove itself so we don't have to do it. This will be pretty useful
                if self:GetVelocity():Length() < 200 then return end 
                

                self:Glace_AddKeyPress( IN_JUMP )
            end, "bhop", 30 ) 

            -- If we can't see our enemy, then go to their position
            local pos = self:Glace_CanSee( self:Glace_GetEnemy() ) and ( self:Glace_GetEnemy():GetPos() + self:Glace_GetNormalTo( self:Glace_GetEnemy() ) * -400 ) or self:Glace_GetEnemy():GetPos()

            self:Glace_Sprint( true )
            self:Glace_Face( self:Glace_GetEnemy() )
            self:Glace_MoveToPos( pos, nil, nil )

        elseif self:Glace_GetState() == "findmedkits" then -- Find a medkit or perish

            -- Only return medkits
            local surrounding = self:Glace_FindInSphere( 1500, function(ent) if ent:GetClass() == "item_healthkit" or ent:GetClass() == "item_healthvial" then return true end end ) 
            local medkit 

            for k, v in RandomPairs( surrounding ) do
                medkit = v
                break
            end
            
            if IsValid(medkit) then
                self:Glace_Sprint( true )
                self:Glace_StopFace()

                self:Glace_Timer( 0.4, function() -- Bhop to the medkit and pray the enemies never played CSGO for years
                    if !IsValid( medkit ) then return "remove" end
                    if self:Glace_GetRangeSquaredTo( medkit ) <= ( 200 * 200 ) then return "remove" end
                    if self:Glace_GetState() != "findmedkits" then return "remove" end
                    if self:GetVelocity():Length() < 200 then return end 
                     
    
                    self:Glace_AddKeyPress( IN_JUMP )
                end, "bhop", 30 ) 

                self:Glace_MoveToPos( medkit, nil, nil, 3, true ) -- Go to the medkit and have the pathfinder wait for the player
            end
            self:Glace_SetState( self:Glace_GetLastState() )

        elseif self:Glace_GetState() == "findammo" then

            -- Only return the correct ammo type
            local surrounding = self:Glace_FindInSphere( 1500, function(ent) if ent:GetClass() == ammotranslation[self:Glace_ActiveAmmoName()] then return true end end ) 
            local ammo 

            for k, v in RandomPairs( surrounding ) do
                ammo = v
                break
            end
            

            if IsValid(ammo) then -- Go grab that ammo
                self:Glace_Sprint( true )
                self:Glace_StopFace()

                self:Glace_Timer( 0.4, function()
                    if !IsValid( ammo ) then return "remove" end
                    if self:Glace_GetRangeSquaredTo( ammo ) <= ( 200 * 200 ) then return "remove" end
                    if self:Glace_GetState() != "findammo" then return "remove" end
                    if self:GetVelocity():Length() < 200 then return end 
                     
    
                    self:Glace_AddKeyPress( IN_JUMP )
                end, "bhop", 30 ) 

                self:Glace_MoveToPos( ammo, nil, 10, 3, true )
            end
            self:Glace_SetState( self:Glace_GetLastState() )
        end

    end

    

end


-- We now "register" the player as a console command so we can spawn them
concommand.Add("glacebase_spawnteamplayer",SpawnTeamGlacePlayer)