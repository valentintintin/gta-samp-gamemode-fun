#include <a_samp>
#include "../include/zcmd" 
#include "../include/sscanf2"
#include "../include/streamer"
#include "../include/filemanager"

new Float:lastPosX[2], Float:lastPosY[2], Float:lastPosZ[2];

main()
{
    print("\n----------------------------------");
    print(" Recorder ");
    print("----------------------------------\n");
    
    loadPlaces();    
}

public OnGameModeInit()
{
    SetGameModeText("Recorder");
    
    loadPlaces();
    
    AddPlayerClass(0, 2047.221801, 1349.185180, 10.671875, 0, 0, 0, 0, 0, 0, 0);
    return 1;
}

public OnGameModeExit()
{
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{   
    SetPlayerPos(playerid, 2047.221801, 1349.185180, 10.671875);
    SetPlayerCameraPos(playerid, 2047.221801, 1349.185180, 10.671875);
    SetPlayerCameraLookAt(playerid, 2047.221801, 1349.185180, 10.671875);
    
    return 1;
}

public OnPlayerConnect(playerid)
{
	
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    return 1;
}

public OnPlayerSpawn(playerid)
{
	if (lastPosX[playerid] && lastPosY[playerid] && lastPosZ[playerid]) {
		SetPlayerPos(playerid, lastPosX[playerid], lastPosY[playerid], lastPosZ[playerid]);
		SetPlayerCameraPos(playerid, lastPosX[playerid], lastPosY[playerid], lastPosZ[playerid]);
		SetPlayerCameraLookAt(playerid, lastPosX[playerid], lastPosY[playerid], lastPosZ[playerid]);
    }
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
   	GetPlayerPos(playerid, lastPosX[playerid], lastPosY[playerid], lastPosZ[playerid]);
    return 1;
}

public OnVehicleSpawn(vehicleid)
{
    return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    return 1;
}

public OnPlayerText(playerid, text[])
{
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
   return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
    return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
    return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
    return 1;
}

public OnRconCommand(cmd[])
{
    return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    return 1;
}

public OnObjectMoved(objectid)
{
    return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
    return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
    return 1;
}

public OnPlayerExitedMenu(playerid)
{
    return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
    return 1;
}

public OnPlayerUpdate(playerid)
{
    return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
    return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
    return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
    return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    new Float:X, Float:Y, Float:Z;
    GetPlayerPos(clickedplayerid, X, Y, Z);
    SetPlayerPos(playerid, X, Y, Z + 5);
    return 1;
}

public fcreate(filename[])
{
    if (fexist(filename)){return false;}
    new File:fhandle = fopen(filename,io_write);
    fclose(fhandle);
    return true;
}

CMD:place(playerid, params[])
{
    new type[32], filePath[64], string[256];
    if (!sscanf(params, "s", type))
    {
        format(filePath, 64, "valentin/%s.txt", type);
    	fcreate(filePath);
		new File:file=fopen(filePath, io_append);
    	if (file) {
	    	new Float:X, Float:Z, Float:Y;
	    	GetPlayerPos(playerid, X, Y, Z);
	        format(string, 256, "%f %f %f\n", X, Y, Z);
		    fwrite(file, string);
		    fclose(file);
	        SendClientMessage(playerid, 0x00FF00FF, "Saved !");
			CreateDynamicMapIcon(X, Y, Z, 19, 0xFFFFFFFF, -1, -1, -1, 200, MAPICON_GLOBAL);
        } else {
		  	SendClientMessage(playerid, 0xFFFFFFFF, "Issue when open file !");
	  	}
  	} else {
	  	SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /place <type>");
  	}
    return 1;
}

CMD:car(playerid, params[])
{
    if(IsPlayerConnected(playerid))
    {
        new vehicle = 0;

        if(!sscanf(params, "i", vehicle))
        {
	    	new Float:X, Float:Z, Float:Y, Float:Rotation;
	    	GetPlayerPos(playerid, X, Y, Z);
	        GetPlayerFacingAngle(playerid,Rotation);
            new iVehicleID = 0;
            iVehicleID = CreateVehicle(vehicle, X, Y, Z, Rotation, 0, 1, 60);
            PutPlayerInVehicle(playerid, iVehicleID, 0);
        }
        else SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /car <id>");
    }
        else SendClientMessage(playerid, 0xFFFFFFFF, "Error !");

    return 1;
}

CMD:kill(playerid, params[])
{
    if(IsPlayerConnected(playerid))
    {
      	SetPlayerHealth(playerid, 0);  
    } else SendClientMessage(playerid, 0xFFFFFFFF, "Error !");

    return 1;
}

CMD:tp(playerid, params[])
{
    if(IsPlayerConnected(playerid))
    {
      	SetPlayerHealth(playerid, 0);  
    } else SendClientMessage(playerid, 0xFFFFFFFF, "Error !");

    return 1;
}

public loadPlaces() {
	printf("\nReading files :");
    
    new dir:dHandle = dir_open("./scriptfiles/valentin/");
	new item[40], type, filePath[64], string[256];
	new Float:X, Float:Z, Float:Y;
	
	while(dir_list(dHandle, item, type))
	{
	    if (type == FM_FILE) {
			printf(item);	
	        format(filePath, 64, "valentin/%s", item);
			new total = 0, File:file=fopen(filePath, io_read);
			if (file) {
				while(fread(file, string)) 
				{
					if (!sscanf(string, "fff", X, Y, Z))
				    {
						CreateDynamicMapIcon(X, Y, Z, 19, 0xFFFFFFFF, -1, -1, -1, 200, MAPICON_GLOBAL);
						total++;
					}
				}
				printf("%d places added !", total);
			} else {
				printf("Error !");
			}
	    }
	}
		    
	dir_close(dHandle);
}
