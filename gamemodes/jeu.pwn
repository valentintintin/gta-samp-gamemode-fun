#include <a_samp>
#include <core>
#include <float>
#include "progress"
#include "sscanf2"

#include "../include/gl_common.inc"
#include "../include/gl_spawns.inc"

//touche
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define HOLD(%0) \
	((newkeys & (%0)) == (%0))
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

//define très utiles pour le jeu
#define nb_perso 10
#define nb_vehicle 5000
#define gazoil_plein 60
#define nb_station_max 50

#define help ShowPlayerDialog(playerid, 1, DIALOG_STYLE_LIST, "Aide à propos des commandes et du serveur", "Comment jouer (Pas fait)\r\nVéhicules et armes\r\nPerso", "Voir", "Annuler");

//define métiers
#define civil 299
#define routier 121
#define policier 280
#define pompier 279
#define ambulancier 274
#define car 187
#define taxis 147

//jeu
new timer_time, heure = 9, minute = 0;
new PlayerColors[200] = {
0xFF8C13FF,0xC715FFFF,0x20B2AAFF,0xDC143CFF,0x6495EDFF,0xf0e68cFF,0x778899FF,0xFF1493FF,0xF4A460FF,
0xEE82EEFF,0xFFD720FF,0x8b4513FF,0x4949A0FF,0x148b8bFF,0x14ff7fFF,0x556b2fFF,0x0FD9FAFF,0x10DC29FF,
0x534081FF,0x0495CDFF,0xEF6CE8FF,0xBD34DAFF,0x247C1BFF,0x0C8E5DFF,0x635B03FF,0xCB7ED3FF,0x65ADEBFF,
0x5C1ACCFF,0xF2F853FF,0x11F891FF,0x7B39AAFF,0x53EB10FF,0x54137DFF,0x275222FF,0xF09F5BFF,0x3D0A4FFF,
0x22F767FF,0xD63034FF,0x9A6980FF,0xDFB935FF,0x3793FAFF,0x90239DFF,0xE9AB2FFF,0xAF2FF3FF,0x057F94FF,
0xB98519FF,0x388EEAFF,0x028151FF,0xA55043FF,0x0DE018FF,0x93AB1CFF,0x95BAF0FF,0x369976FF,0x18F71FFF,
0x4B8987FF,0x491B9EFF,0x829DC7FF,0xBCE635FF,0xCEA6DFFF,0x20D4ADFF,0x2D74FDFF,0x3C1C0DFF,0x12D6D4FF,
0x48C000FF,0x2A51E2FF,0xE3AC12FF,0xFC42A8FF,0x2FC827FF,0x1A30BFFF,0xB740C2FF,0x42ACF5FF,0x2FD9DEFF,
0xFAFB71FF,0x05D1CDFF,0xC471BDFF,0x94436EFF,0xC1F7ECFF,0xCE79EEFF,0xBD1EF2FF,0x93B7E4FF,0x3214AAFF,
0x184D3BFF,0xAE4B99FF,0x7E49D7FF,0x4C436EFF,0xFA24CCFF,0xCE76BEFF,0xA04E0AFF,0x9F945CFF,0xDCDE3DFF,
0x10C9C5FF,0x70524DFF,0x0BE472FF,0x8A2CD7FF,0x6152C2FF,0xCF72A9FF,0xE59338FF,0xEEDC2DFF,0xD8C762FF,
0xD8C762FF,0xFF8C13FF,0xC715FFFF,0x20B2AAFF,0xDC143CFF,0x6495EDFF,0xf0e68cFF,0x778899FF,0xFF1493FF,
0xF4A460FF,0xEE82EEFF,0xFFD720FF,0x8b4513FF,0x4949A0FF,0x148b8bFF,0x14ff7fFF,0x556b2fFF,0x0FD9FAFF,
0x10DC29FF,0x534081FF,0x0495CDFF,0xEF6CE8FF,0xBD34DAFF,0x247C1BFF,0x0C8E5DFF,0x635B03FF,0xCB7ED3FF,
0x65ADEBFF,0x5C1ACCFF,0xF2F853FF,0x11F891FF,0x7B39AAFF,0x53EB10FF,0x54137DFF,0x275222FF,0xF09F5BFF,
0x3D0A4FFF,0x22F767FF,0xD63034FF,0x9A6980FF,0xDFB935FF,0x3793FAFF,0x90239DFF,0xE9AB2FFF,0xAF2FF3FF,
0x057F94FF,0xB98519FF,0x388EEAFF,0x028151FF,0xA55043FF,0x0DE018FF,0x93AB1CFF,0x95BAF0FF,0x369976FF,
0x18F71FFF,0x4B8987FF,0x491B9EFF,0x829DC7FF,0xBCE635FF,0xCEA6DFFF,0x20D4ADFF,0x2D74FDFF,0x3C1C0DFF,
0x12D6D4FF,0x48C000FF,0x2A51E2FF,0xE3AC12FF,0xFC42A8FF,0x2FC827FF,0x1A30BFFF,0xB740C2FF,0x42ACF5FF,
0x2FD9DEFF,0xFAFB71FF,0x05D1CDFF,0xC471BDFF,0x94436EFF,0xC1F7ECFF,0xCE79EEFF,0xBD1EF2FF,0x93B7E4FF,
0x3214AAFF,0x184D3BFF,0xAE4B99FF,0x7E49D7FF,0x4C436EFF,0xFA24CCFF,0xCE76BEFF,0xA04E0AFF,0x9F945CFF,
0xDCDE3DFF,0x10C9C5FF,0x70524DFF,0x0BE472FF,0x8A2CD7FF,0x6152C2FF,0xCF72A9FF,0xE59338FF,0xEEDC2DFF,
0xD8C762FF,0xD8C762FF
};

//perso
new float:x[nb_perso], float:y[nb_perso], float:z[nb_perso], Text:text_player[nb_perso], timer_player[nb_perso];
new float:vitesseX[nb_perso], float:vitesseY[nb_perso], float:vitesseZ[nb_perso], metier[nb_perso];

//voiture
new timer_gazoil[nb_vehicle], gazoil[nb_vehicle], Text3D:label_gazoil[nb_vehicle], Text:text_gazoil[nb_perso], float:vie_vehicule[nb_vehicle];
new Text:text_etat[nb_perso], Text:text_quel[nb_perso], Text3D:label_etat[nb_vehicle], float:vitesse[nb_perso];
new CarName[][] =
{
    "4x4", "bravura", "buffalo", "linerunner", "perrenial", "sentinel",
        "dumper", "pompier", "poubelle", "limousine", "manana", "infernus",
        "voodoo", "pony", "mule", "cheetah", "ambulance", "leviathan", "moonbeam",
    "esperanto", "taxi", "washington", "bobcat", "mrwhoopee", "bfinjection",
        "hunter", "premier", "enforcer", "securicar", "banshee", "predator", "bus",
        "tank", "barracks", "hotknife", "semie", "previon", "car", "taxi2",
        "stallion", "rumpo", "rcbandit", "romero", "packer", "monster truck", "admiral",
        "squalo", "seasparrow", "pizzaboy", "tram", "benne", "turismo", "speeder",
        "reefer", "tropic", "flatbed", "yankee", "caddy", "solair", "berkley",
        "skimmer", "pcj600", "faggio", "freeway", "rcbaron", "rcraider", "glendale",
        "oceanic","sanchez", "sparrow", "patriot", "quad", "coastguard", "dinghy",
        "hermes", "sabre", "rustler", "zr350", "walton", "regina", "comet", "bmx",
        "burrito", "vanne", "marquis", "baggage", "dozer", "maverick", "news",
        "rancher", "fbirancher", "virgo", "greenwood", "jetmax", "hotring", "sandking",
        "blista", "helipolice", "boxville", "benson", "mesa", "rcgoblin",
        "hotringa", "hotringb", "bloodring", "rancher", "supergt",
        "elegant", "campingcar", "bike", "mountainbike", "beagle", "cropduster", "stuntplane",
        "tanker", "roadtrain", "nebula", "majestic", "buccaneer", "shamal", "hydra",
        "fcr900", "nrg500", "hpv1000", "cement", "towtruck", "fortune",
        "cadrona", "fbitruck", "willard", "forklift", "tracteur", "moisseneuse", "feltzer",
        "remington", "slamvan", "blade", "fret", "tgv", "vortex", "vincent",
    "bullet", "clover", "sadler", "pompier2", "hustler", "intruder", "primo",
        "banane", "tampa", "sunrise", "merit", "utility", "nevada", "yosemite",
        "windsor", "monsterA", "monsterB", "uranus", "jester", "sultan", "stratum",
        "elegy", "raindance", "rctank", "flash", "tahoma", "savanna", "bandito",
    "wagonfret", "wagontgv", "kart", "mower", "dune", "sweeper",
        "broadway", "tornado", "at400", "dft30", "huntley", "stafford", "bf400",
        "newsvan", "tug", "citerne", "emperor", "wayfarer", "euros", "hotdog", "club",
        "boxfret", "frigo", "andromada", "dodo", "rccam", "launch", "lspd",
        "sfpd", "lvpd", "ranger", "picador", "swat", "alpha",
        "phoenix", "glendale", "sadler", "bagageA", "bagageB", "stairs", "boxville2",
        "farm", "utility2"
};
new pas_gazoil[] = {417, 425, 447, 460, 469, 476, 487, 488, 497, 511, 512, 513, 519, 520, 548, 553, 563, 577, 592, 593, 430, 446, 452, 453, 454, 472, 473, 484, 493, 595, 569, 570, 590, 449, 537, 538, 539};
new total_vehicles_from_files = 0, pompe = 0, nb_station, float:station_X1[nb_station_max], float:station_X2[nb_station_max];
new float:station_Y1[nb_station_max], float:station_Y2[nb_station_max];

public pas_gaz(vehicleid)
{
	new i, result = 0;

	for(i = 0; i < 36; i++) if (pas_gazoil[i] == GetVehicleModel(vehicleid)) result = 1;

	return result;
}

public station_la(playerid)
{
	new i, result = 0;

	GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);

	for(i = 0; i < nb_station - 1; i++) if (x[playerid] >= station_X1[i] && x[playerid] <= station_X2[i] && y[playerid] >= station_Y1[i] && y[playerid] <= station_Y2[i]) result = 1;

	return result;
}

public var(quoi[255], float:variable)
{
	new string[255];
	
	format(string, sizeof(string), "%s: %f", quoi, variable);
	SendClientMessageToAll(0xFF0000, string);
	printf("%s", string);
	
	return 1;
}

public time()
{
	new i;

    if (minute >= 60)
    {
        if (heure >= 23)
        {
            heure = 0;
            minute = 0;
		}
		else heure++;
		minute = 1;
	}
	else minute++;

    for(i = 0; i < nb_perso; i++) if(IsPlayerConnected(i)) SetPlayerTime(i, heure, minute);
}

public gaz(playerid, vehicleid)
{
    if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) if (vitesse[playerid] > 2) gazoil[vehicleid]--;
}

public player(playerid)
{
    new player[255], quel[255], etat[255], gaz[255], etat2[255], gaz2[255];
    
    if (IsPlayerInAnyVehicle(playerid))
	{
		GetVehicleVelocity(GetPlayerVehicleID(playerid), vitesseX[playerid] , vitesseY[playerid] , vitesseZ[playerid] );
		if (station_la(playerid))
		{
			format(quel, sizeof(quel), "~y~~k~~VEHICLE_HANDBRAKE~ ~w~pour faire le plein");
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), true, false, false, false, true, false, false); //engine, lights, alarm, doors, bonnet, boot, objective
		}
		else
		{
			format(quel, sizeof(quel), "~w~%s ~p~(%d)", CarName[GetVehicleModel(GetPlayerVehicleID(playerid)) - 400], GetVehicleModel(GetPlayerVehicleID(playerid)));
			if (gazoil[GetPlayerVehicleID(playerid)] > 0) SetVehicleParamsEx(GetPlayerVehicleID(playerid), true, false, false, false, false, false, false); //engine, lights, alarm, doors, bonnet, boot, objective
		}

	    GetVehicleHealth(GetPlayerVehicleID(playerid), vie_vehicule[GetPlayerVehicleID(playerid)]);
	    format(etat2, sizeof(etat2), "Etat: %d%", floatround(floatdiv(vie_vehicule[GetPlayerVehicleID(playerid)], 10), floatround_ceil));
		if (vie_vehicule[GetPlayerVehicleID(playerid)] > 600.0 && vie_vehicule[GetPlayerVehicleID(playerid)] <= 1000.0)
		{
			format(etat, sizeof(etat), "~w~Etat: ~g~%d%", floatround(floatdiv(vie_vehicule[GetPlayerVehicleID(playerid)], 10), floatround_ceil));
		    Update3DTextLabelText(label_etat[GetPlayerVehicleID(playerid)], 0x00FF00FF, etat2);
		}
		else if (vie_vehicule[GetPlayerVehicleID(playerid)] > 400.0 && vie_vehicule[GetPlayerVehicleID(playerid)] <= 600.0)
		{
		    format(etat, sizeof(etat), "~w~Etat: ~y~%d%", floatround(floatdiv(vie_vehicule[GetPlayerVehicleID(playerid)], 10), floatround_ceil));
		    Update3DTextLabelText(label_etat[GetPlayerVehicleID(playerid)], 0xFF8C28FF, etat2);
		}
		else if (vie_vehicule[GetPlayerVehicleID(playerid)] >= 0.0 && vie_vehicule[GetPlayerVehicleID(playerid)] <= 400.0)
		{
		    format(etat, sizeof(etat), "~w~Etat: ~r~%d%", floatround(floatdiv(vie_vehicule[GetPlayerVehicleID(playerid)], 10), floatround_ceil));
		    Update3DTextLabelText(label_etat[GetPlayerVehicleID(playerid)], 0xFF0000FF, etat2);
		}

		if (!pas_gaz(GetPlayerVehicleID(playerid)))
		{
			if (gazoil[GetPlayerVehicleID(playerid)] > 0)
			{
			    format(gaz2, sizeof(gaz2), "~w~Gazoil: %dL", gazoil[GetPlayerVehicleID(playerid)]);
       			if (gazoil[GetPlayerVehicleID(playerid)] > 30 && gazoil[GetPlayerVehicleID(playerid)] <= 60)
				{
				    format(gaz, sizeof(gaz), "~w~Gazoil: ~g~%dL", gazoil[GetPlayerVehicleID(playerid)]);
					Update3DTextLabelText(label_gazoil[GetPlayerVehicleID(playerid)], 0x00FF00FF, gaz2);
				}
			    else if (gazoil[GetPlayerVehicleID(playerid)] > 10 && gazoil[GetPlayerVehicleID(playerid)] <= 30)
				{
				    format(gaz, sizeof(gaz), "~w~Gazoil: ~y~%dL", gazoil[GetPlayerVehicleID(playerid)]);
					Update3DTextLabelText(label_gazoil[GetPlayerVehicleID(playerid)], 0xFF8C28FF, gaz2);
				}
				else if (gazoil[GetPlayerVehicleID(playerid)] >= 0 && gazoil[GetPlayerVehicleID(playerid)] <= 10)
				{
				    format(gaz, sizeof(gaz), "~w~Gazoil: ~r~%dL", gazoil[GetPlayerVehicleID(playerid)]);
					Update3DTextLabelText(label_gazoil[GetPlayerVehicleID(playerid)], 0xFF0000FF, gaz2);
				}
			}
			else
			{
				format(gaz, sizeof(gaz), "~g~En panne");
                Update3DTextLabelText(label_gazoil[GetPlayerVehicleID(playerid)], 0xFF0000FF, "En panne");
    			SetVehicleParamsEx(GetPlayerVehicleID(playerid), false, false, false, false, true, false, false); //engine, lights, alarm, doors, bonnet, boot, objective
			}
		}
		else format(gaz, sizeof(gaz), "~w~Gazoil: ~g~Illimite");
	}
    else GetPlayerVelocity(playerid, vitesseX[playerid], vitesseY[playerid], vitesseZ[playerid]);

    vitesseX[playerid]  = floatmul(vitesseX[playerid] , 10);
	vitesseY[playerid]  = floatmul(vitesseY[playerid] , 10);
	vitesseZ[playerid]  = floatmul(vitesseZ[playerid] , 10);
	vitesse[playerid] = floatround(floatadd(floatadd(floatmul(vitesseX[playerid], vitesseX[playerid]), floatmul(vitesseY[playerid], vitesseY[playerid])), floatmul(vitesseZ[playerid], vitesseZ[playerid])), floatround_ceil);

    GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);

	if (vitesse[playerid] > 100) format(player, sizeof(player), "~w~Vitesse: ~r~%dkm/h~n~~w~Altitude: ~p~%dm", vitesse[playerid], floatround(z[playerid], floatround_ceil));
	else if (vitesse[playerid] > 60 && vitesse[playerid] <= 100) format(player, sizeof(player), "~w~Vitesse: ~y~%dkm/h~n~~w~Altitude: ~p~%dm", vitesse[playerid], floatround(z[playerid], floatround_ceil));
	else if (vitesse[playerid] > 2 && vitesse[playerid] <= 60) format(player, sizeof(player), "~h~~w~Vitesse: ~g~%dkm/h~n~~w~Altitude: ~p~%dm", vitesse[playerid], floatround(z[playerid], floatround_ceil));
	else if (vitesse[playerid] >= 0 && vitesse[playerid] <= 2) format(player, sizeof(player), "~w~Vitesse: ~b~%dkm/h~n~~w~Altitude: ~p~%dm", vitesse[playerid], floatround(z[playerid], floatround_ceil));

    TextDrawDestroy(text_player[playerid]);
    TextDrawDestroy(text_quel[playerid]);
    TextDrawDestroy(text_etat[playerid]);
    TextDrawDestroy(text_gazoil[playerid]);
    
	text_player[playerid] = TextDrawCreate(30.0, 280.0, player);
	text_quel[playerid] = TextDrawCreate(30.0, 300.0, quel);
	text_etat[playerid] = TextDrawCreate(30.0, 310.0, etat);
	text_gazoil[playerid] = TextDrawCreate(30.0, 320.0, gaz);

	TextDrawSetShadow(text_player[playerid], 0);
	TextDrawSetShadow(text_quel[playerid], 0);
	TextDrawSetShadow(text_etat[playerid], 0);
	TextDrawSetShadow(text_gazoil[playerid], 0);

	TextDrawFont(text_player[playerid], 0);
	TextDrawFont(text_quel[playerid], 1);
	TextDrawFont(text_etat[playerid], 2);
	TextDrawFont(text_gazoil[playerid], 3);
	
	TextDrawShowForPlayer(playerid, text_player[playerid]);
	TextDrawShowForPlayer(playerid, text_quel[playerid]);
	TextDrawShowForPlayer(playerid, text_etat[playerid]);
	TextDrawShowForPlayer(playerid, text_gazoil[playerid]);
}

main()
{
	printf("\n\n\n\n\n\n");
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);

	if (HOLD(KEY_HANDBRAKE) && IsPlayerInAnyVehicle(playerid) && station_la(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if (gazoil[GetPlayerVehicleID(playerid)] < gazoil_plein)
		{
		    gazoil[GetPlayerVehicleID(playerid)]++;
			GivePlayerMoney(playerid, -1);
		}
	}

	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new string[1000];
	
    if(dialogid == 1)
    {
        if (response)
        {
            switch(listitem)
            {
                case 0:
				{
					strcat(string, "TOUT CE QUI EST ECRIT LA NE MARCHE PAS ENCORE !!\n");
					strcat(string, "C'est très simple !\nTape /travail pour choisir dans la liste les lieux de livraisons à effectuer\n");
					strcat(string, "Ensuite tu n'as qu'à t'y rendre pour gagner ton salaire ! \n\nBon jeu !");
					ShowPlayerDialog(playerid, 2, DIALOG_STYLE_MSGBOX, "Comment jouer", string, "Ok !", "Retour");
				}
                case 1:
				{
                    strcat(string, "Véhicules:\nLes véhicules TERRESTRES ont besoin de Gazoil.\n");
					strcat(string, "Pour celà il faudra aller à la pompe quelques fois.\nPour les trouver va dans les villes et cherche");
					strcat(string, "sur la carte l'icone en forme de clé.\nEnsuite appuie autant de fois sur ESPACE que tu veux mettre");
					strcat(string, "de Litre (MAX: 60L).\nLe plein te coutera 1$ par Litre. C'est pour ça qu'il faut travailler !\n");
					strcat(string, "Pour faire apparaître un véhicule utilisez la commande /cars [id] ou [nom_du_vehicule].\nL'id va de 400 à 611.\n");
					strcat(string, "Pour savoir à quoi ils correspondent faite /helpcar [id].\n\nArmes:\n");
					strcat(string, "LE SERVEUR N'A PAS POUR PRIORITE L'USAGE DES ARMES !\nPour");
					strcat(string, "s'en procurer utiliser /armes [id].\nL'id va de 1 à 46. Les vrais armes commencent à 22.");
					ShowPlayerDialog(playerid, 2, DIALOG_STYLE_MSGBOX, "Voitures et armes", string, "Ok !", "Retour");
				}
				case 2:
				{
					strcat(string, "Perso:\nLa seul commande qu'il éxiste actuellement est le suicide avec /kill.");
					ShowPlayerDialog(playerid, 2, DIALOG_STYLE_MSGBOX, "Perso", string, "Ok !", "Retour");
				}
			}
		}
    }
	else if(dialogid == 2)
    {
        if (!response)
        {
			help
		}
    }
	
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
    TogglePlayerControllable(playerid, 1);

	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if (label_etat[vehicleid] == 0 && label_gazoil[vehicleid] == 0)
	{
		label_etat[vehicleid] = Create3DTextLabel("", 0xFF0000FF, 0.0, 0.0, 0.0, 50.0, 0, 1);
 		label_gazoil[vehicleid] = Create3DTextLabel("", 0xFF0000FF, 0.0, 0.0, 0.0, 50.0, 0, 1);
	    Attach3DTextLabelToVehicle(label_etat[vehicleid], vehicleid, 0.0, 0.0, 1.0);
		Attach3DTextLabelToVehicle(label_gazoil[vehicleid], vehicleid, 0.0, 0.0, 1.2);
	}
	
	timer_gazoil[vehicleid] = SetTimerEx("gaz", 7000, true, "ii", playerid, vehicleid);
		
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	KillTimer(timer_gazoil[vehicleid]);

	return 1;
}

public OnVehicleDeath(vehicleid)
{
    KillTimer(timer_gazoil[vehicleid]);
   	Delete3DTextLabel(label_etat[vehicleid]);
   	label_etat[vehicleid] = 0;
    Delete3DTextLabel(label_gazoil[vehicleid]);
   	label_gazoil[vehicleid] = 0;
    gazoil[vehicleid] = gazoil_plein;
	SetVehicleParamsEx(vehicleid, true, false, false, false, false, false, false); //engine, lights, alarm, doors, bonnet, boot, objective

    return 1;
}

public OnPlayerConnect(playerid)
{
   	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    new string[255], name[MAX_PLAYER_NAME];

    GetPlayerName(playerid, name, sizeof(name));
    format(string, sizeof(string), "[SERVEUR] %s c'est déconnecté!", name);
	SendClientMessageToAll(0xFF0000, string);
	printf("%s", string);

	TextDrawDestroy(text_gazoil[playerid]);
	TextDrawDestroy(text_etat[playerid]);
	TextDrawDestroy(text_quel[playerid]);
	TextDrawDestroy(text_player[playerid]);

    KillTimer(timer_player[playerid]);

	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[128], idx;
	cmd = strtok(cmdtext, idx);

	if(strcmp(cmd, "/gazoil", true) == 0)
	{
		new tmp[128];
		tmp = strtok(cmdtext, idx);

		if(strlen(tmp) == 0) SendClientMessage(playerid, 0xFFFFFFFF, "/gazoil nb[<= 60]");
		else gazoil[GetPlayerVehicleID(playerid)] = strval(tmp);

		return 1;
	}

	/*if(strcmp(cmd, "/station1", true) == 0)
	{
		new string[255], txt[255], txt2[255], i;

	    GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);

        new File:gazoil = fopen("station1.txt", io_readwrite);
		while (fread(gazoil, txt) != 0)
		{
			format(string, sizeof(string), "%s\n%s", txt2, txt);
			strpack(txt2, txt);
		}
		format(txt, sizeof(txt), "%s\n%f %f", txt, x[playerid], y[playerid]);
		fwrite(gazoil, txt);
		fclose(gazoil);

		format(string, sizeof(string), "point 1");
		SendClientMessageToAll(0xFF0000, string);
		printf("%s", string);

    	return 1;
	}

	if(strcmp(cmd, "/station2", true) == 0)
	{
		new string[255], txt[255], txt2[255], i;

	    GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);

        new File:gazoil = fopen("station2.txt", io_readwrite);
		while (fread(gazoil, txt) != 0)
		{
			format(string, sizeof(string), "%s\n%s", txt2, txt);
			strpack(txt2, txt);
		}
		format(txt, sizeof(txt), "%s\n%f %f", txt, x[playerid], y[playerid]);
		fwrite(gazoil, txt);
		fclose(gazoil);

		format(string, sizeof(string), "point 2");
		SendClientMessageToAll(0xFF0000, string);
		printf("%s", string);

    	return 1;
	}
	
	if(strcmp(cmd, "/station3", true) == 0)
	{
		new string[255], txt[255], txt2[255], i;

	    GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);

        new File:gazoil = fopen("station.txt", io_readwrite);
        pompe = 0;
		while (fread(gazoil, txt) != 0)
		{
			format(string, sizeof(string), "%s\n%s", txt2, txt);
			strpack(txt2, txt);
			pompe++;
		}
		format(txt, sizeof(txt), "%s\n%f %f %f", txt, x[playerid], y[playerid], z[playerid]);
		fwrite(gazoil, txt);
		fclose(gazoil);

        for(i = 0; i < nb_perso; i++) if(IsPlayerConnected(i)) SetPlayerMapIcon(i, pompe, x[playerid], y[playerid], z[playerid], 27, 0, MAPICON_GLOBAL);

		format(string, sizeof(string), "Nouvelle station service!");
		SendClientMessageToAll(0xFF0000, string);
		printf("%s", string);

    	return 1;
	}*/
	
	if(strcmp(cmd, "/ou", true) == 0)
	{
		new string[255];

	    GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);

		format(string, sizeof(string), "%f, %f, %f", x[playerid], y[playerid], z[playerid]);
		SendClientMessage(playerid, 0xFF0000, string);
		printf("%s", string);

    	return 1;
	}
	
	if(strcmp(cmd, "/cars", true) == 0)
	{
		new tmp[128], string[255], name[MAX_PLAYER_NAME], i, id = 0;

    	GetPlayerName(playerid, name, sizeof(name));

		tmp = strtok(cmdtext, idx);
		
		if (strlen(tmp) != 0 && strval(tmp) >= 400 && strval(tmp) <= 612)
		{
			for (i = 0; i < 212; i++) if (strcmp(tmp, CarName[i], true) == 0) id = 400 + i;
			if (id == 0) id = strval(tmp);

			GetPlayerPos(playerid, x[playerid], y[playerid], z[playerid]);

			AddStaticVehicle(id, x[playerid], y[playerid], z[playerid], 269.15, random(126), random(126));

			format(string, sizeof(string), "%s a fait apparaître le véhicule %s (%d).", name, CarName[id - 400], id);
			//SendClientMessageToAll(GetPlayerColor(playerid), string);
			printf("%s", string);
		}
		else SendClientMessage(playerid, 0xFFFFFFFF, "/cars [id]  id >= 400 et <= 611");

		return 1;
	}
	
	if(strcmp(cmd, "/armes", true) == 0)
	{
		new tmp[128], string[255], name[MAX_PLAYER_NAME];
		tmp = strtok(cmdtext, idx);

		GetPlayerName(playerid, name, sizeof(name));

		GivePlayerWeapon(playerid, strval(tmp), 999);
		
		format(string, sizeof(string), "%s a pris l'arme %d", name, strval(tmp));
		//SendClientMessageToAll(GetPlayerColor(playerid), string);
		printf("%s", string);
		
		if(strlen(tmp) == 0 || strval(tmp) >= 1 || strval(tmp) <= 46) return SendClientMessage(playerid, 0xFFFFFFFF, "/armes [id]  id >= 1 et <= 46");

		return 1;
	}
	
	if(strcmp(cmd, "/kill", true) == 0)
	{
	    new string[255], name[MAX_PLAYER_NAME];

		SetPlayerHealth(playerid, 0);

    	GetPlayerName(playerid, name, sizeof(name));

		format(string, sizeof(string), "%s s'est suicidé!", name);
		//SendClientMessageToAll(GetPlayerColor(playerid), string);
		printf("%s", string);

    	return 1;
	}

	if(strcmp(cmd, "/helpcars", true) == 0)
	{
		new tmp[128], i, string[255];
		tmp = strtok(cmdtext, idx);

    	if (strlen(tmp) != 0 && strval(tmp) >= 400 && strval(tmp) <= 612)
		{
			for (i = 0; i < 212; i++)
			{
				if (i + 400 == strval(tmp))
				{
					format(string, sizeof(string), "L'id %d est associé au véhicule %s", strval(tmp), CarName[i]);
					SendClientMessage(playerid, 0xFF0000, string);
				}
			}
		}
		else SendClientMessage(playerid, 0xFFFFFFFF, "/helpcars [id]  id >= 400 et <= 611");

		return 1;
	}
	
	if(strcmp(cmd, "/help", true) == 0)
   	{
  		TogglePlayerControllable(playerid, 0);
		//help
		
	    return 1;
	}

	return 0;
}

public OnPlayerEnterCheckpoint(playerid)
{

    return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	x[playerid] = fX;
	y[playerid] = fY;
	z[playerid] = fZ;

    if (IsPlayerInAnyVehicle(playerid)) SetVehiclePos(GetPlayerVehicleID(playerid), fX, fY, fZ);
    else SetPlayerPosFindZ(playerid, fX, fY, fZ);

    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{

	return 1;
}
public OnPlayerSpawn(playerid)
{

	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    SetPlayerColor(playerid, PlayerColors[playerid]);
	TogglePlayerClock(playerid, 1);
	GivePlayerMoney(playerid, 3000);

    new prof[255], string[255], name[MAX_PLAYER_NAME], txt[255], float:tx, float:ty, float:tz;

    GetPlayerName(playerid, name, sizeof(name));

    if (metier[playerid] == civil) prof = "Civil";
    else if (metier[playerid] == routier) prof = "Routier";
    else if (metier[playerid] == car) prof = "Chaffeur de Car/Bus";
	else if (metier[playerid] == policier) prof = "Policier";

    format(string, sizeof(string), "[SERVEUR] %s c'est connecté en %s!", name, prof);
	SendClientMessageToAll(0xFF0000, string);
	printf("%s", string);

	pompe = 0;
/*
	new File:gazoil = fopen("station.txt", io_read);
	while (fread(gazoil, txt) != 0)
	{
		format(string, sizeof(string), "%s", txt);
	    sscanf(txt, "fff", tx, ty, tz);
	    SetPlayerMapIcon(playerid, pompe, tx, ty, tz, 27, 0, MAPICON_LOCAL);
	    pompe++;
	}
	fclose(gazoil);*/
	nb_station = pompe;

	timer_player[playerid] = SetTimerEx("player", 100, true, "i", playerid);

    return 1;
}

public OnGameModeInit()
{
	new i;

    ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	ShowNameTags(1);
	SetGameModeText("DEBUG");
	timer_time = SetTimer("time", 800, true); //true = repéter

	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/trains.txt");
	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/pilots.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/lv_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/lv_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/lv_gen.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/sf_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/sf_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/sf_gen.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_inner.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_outer.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/whetstone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/bone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/flint.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/tierra.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/red_county.txt");

    for (i = 0; i < nb_vehicle; i++) gazoil[i] = gazoil_plein;
/*
    new txt[255], float:tx, float:ty, float:tx2, float:ty2, string[255];
	new File:station = fopen("station.txt", io_read);
	while (fread(station, txt) != 0)
	{
		format(string, sizeof(string), "%s", txt);
	    sscanf(txt, "ffff", tx, ty, tx2, ty2);
	    station_X1[pompe] = tx;
	    station_Y1[pompe] = ty;
	    station_X2[pompe] = tx2;
	    station_Y2[pompe] = ty2;
	    pompe++;
	}
	fclose(station);
*/
	AddPlayerClass(civil, 2038.910766, 1553.894409, 10.671875, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(routier, 2866.388427, 918.909729, 10.439550, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(car, -1995.561645, 151.110931, 27.375928, 0, 0, 0, 0, 0, 0, 0);

	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
   metier[playerid] = GetPlayerSkin(playerid);

	if (metier[playerid] == civil) GameTextForPlayer(playerid, "Civil", 1500, 3);
	if (metier[playerid] == routier) GameTextForPlayer(playerid, "Routier", 1500, 3);
	if (metier[playerid] == policier) GameTextForPlayer(playerid, "Policier", 1500, 3);
	if (metier[playerid] == pompier) GameTextForPlayer(playerid, "Pompier", 1500, 3);
	if (metier[playerid] == ambulancier) GameTextForPlayer(playerid, "Ambulancier", 1500, 3);
	if (metier[playerid] == car) GameTextForPlayer(playerid, "Chaffeur de Car/Bus", 1500, 3);
	if (metier[playerid] == taxis) GameTextForPlayer(playerid, "Chaffeur de Taxis", 1500, 3);

	return 1;
}
