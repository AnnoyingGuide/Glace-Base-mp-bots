
include("glace/glace_functions.lua")

-- Creates a bot


function Glace_CreatePlayer( name, model, pos, profilepicture )
    if !game.SinglePlayer() and player.GetCount() < game.MaxPlayers() then 
        if !navmesh.IsLoaded() then PrintMessage(HUD_PRINTTALK,"Glace Base Warning: Map has no Navigation Mesh! Preventing Spawn..") return end


        local ply = player.CreateNextBot( name )
        ply.IsGlacePlayer = true
        ply._GlaceThinkTime = 0

        

        if model then

            ply:SetModel( model ) -- Set the custom model

        end

        -- The profile picture file name.
        -- Profile Pictures are found in, garrysmod/materials/glacebase/profilepictures.
        -- Any custom profile pictures should be located in that folder as well. Make sure any other client has a way of receiving them!

        -- To set the player's Profile Picture, just paste the file name and extension of a image from garrysmod/materials/glacebase/profilepictures in the profile picture arg or you can input GLACERANDOM for a random profile picture in the profile picture arg
        -- See glace_testplayer.lua to see a example

        -- NOTE THAT VOICE CHAT FADE OUT WILL LOOK WEIRD!
        -- I haven't figured out a way to fix this
        timer.Simple( 0, function()

            ply:SetNW2Bool( "glacebase_isglaceplayer", true )

            if profilepicture then

                if profilepicture == "GLACERANDOM" then
                    local pfps,_ = file.Find("materials/glacebase/profilepictures/*","GAME")
                    profilepicture = pfps[ math.random( #pfps ) ]
                end
                
                ply:SetNW2String( "glacebase_profilepicture", profilepicture )

            end

        end)

        if pos and isvector( pos ) then ply:SetPos( pos ) end

            ply.threadthink = coroutine.create(function()  -- Kick off the coroutine thread
            while true do
                if isfunction( ply.Glace_ThreadedThink ) then
                    ply:Glace_ThreadedThink()
                end
                coroutine.yield()
            end
        end)

        local id = ply:GetCreationID()
        local thinktime = 0
        local stuckchecktime = 0
        local lastpos 
        hook.Add( "Think", "GlacePlayerThink" .. id, function() -- Initialize the Think hook
            if !IsValid( ply ) then hook.Remove( "Think", "GlacePlayerThink" .. id ) return end

            if CurTime() > thinktime then

                if isfunction( ply.Glace_Think ) then
                    ply:Glace_Think()
                end

                thinktime = CurTime() + ply._GlaceThinkTime
            end

            if ply._GlaceIsMoving and CurTime() > stuckchecktime then
                if !lastpos then

                    lastpos = ply:GetPos()

                elseif ply:GetPos():DistToSqr( lastpos ) <= ( 50 * 50 ) then

                    if isfunction( ply.Glace_OnStuck ) then
                        
                        ply:Glace_OnStuck()
                        
                    end

                end
                
                stuckchecktime = CurTime()+1
            elseif !ply._GlaceIsMoving then
                lastpos = nil
            end

            if !ply.threadthink then return end
            
            if coroutine.status( ply.threadthink ) == "dead" then
                Msg(ply," Warning: Glace Coroutine returned dead!")
                ply.threadthink = nil
            end

            local ok, errormessage = coroutine.resume( ply.threadthink ) -- Keep the Coroutine going if it is still alive


            if ok == false then
                ErrorNoHalt(ply, " Glace Coroutine Thread encountered a error. Error: ", errormessage, "\n")
                ply.threadthink = nil
            end


            

            
        end)

        hook.Add( "PlayerDeath", "GlaceBase_OnOtherKilled" .. id, function( victim, inflictor, attacker )
            if !IsValid( ply ) then hook.Remove( "PlayerDeath", "GlaceBase_OnOtherKilled" .. id ) return end

            if isfunction( ply.Glace_OnOtherKilled ) and victim != ply then

               ply:Glace_OnOtherKilled( victim, attacker, inflictor ) 

            end
        end)

        -- Yes OnNPCKilled should be used instead but some things don't call the OnNPCKilled hook so we need to make sure if the ent is actually killed through this
        hook.Add( "PostEntityTakeDamage", "GlaceBase_OnOtherKilledPstDamage" .. id, function( ent, dmginfo ) 
            if !IsValid( ply ) then hook.Remove( "PostEntityTakeDamage", "GlaceBase_OnOtherKilledPstDamage" .. id ) return end

            if !IsValid( ent ) then return end

            if !ent:IsNPC() and !ent:IsNextBot() or ent:IsPlayer() then return end -- We don't want non NPCs and players to be passed through this hook


            if isfunction( ply.Glace_OnOtherKilled ) and ent:Health() <= 0 then

               ply:Glace_OnOtherKilled( ent, dmginfo:GetAttacker(), dmginfo:GetInflictor() ) 

            end        
        end)




        _GlaceSetupPlayerFunctions( ply ) -- Add the default functions
        

        return ply
    else
        -- Oh fiddle sticks what now?
        local message = !game.SinglePlayer() and player.GetCount() < game.MaxPlayers() and "Server Player limit has been reached!" or game.SinglePlayer() and "These players can only be used in multiplayer!"
        print(message)
    end
end


