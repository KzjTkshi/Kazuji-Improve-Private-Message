#include <a_samp>
#include <sscanf2>
#include <zcmd>

// Variable, BUAT PM STATUS ON / OFF
new bool:PMStatus[MAX_PLAYERS];

// INI BUAT FIX ERROR SendClientMessageEx
SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
    static
        args,
            str[144];

    if((args = numargs()) == 3)
    {
            SendClientMessage(playerid, color, text);
    }
    else
    {
        while (--args >= 3)
        {
            #emit LCTRL 5
            #emit LOAD.alt args
            #emit SHL.C.alt 2
            #emit ADD.C 12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S text
        #emit PUSH.C 144
        #emit PUSH.C str
        #emit PUSH.S 8
        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        SendClientMessage(playerid, color, str);

        #emit RETN
    }
    return 1;
}

// Define Untuk Pesan Kegunaan & Lebih Minimalist
#define USAGE(%1,%2) SendClientMessageEx(%1, 0xFFFF00FF, "USAGE: {ffffff}"%2)
#define ERROR(%1,%2) SendClientMessageEx(%1, 0xFF0000FF, "ERROR: {ffffff}"%2)
#define INFO(%1,%2) SendClientMessageEx(%1, 0x0080C0FF, "<i>: {ffffff}"%2)

// NGERESET PE-NONAKTIFKAN PM
public OnPlayerConnect(playerid)
{
	PMStatus[playerid] = false;
	return 1;
}

// Main Commands, Saran Pakai ZCMD
CMD:pm(playerid, params[])
{
	new str[256], NamaPemain[MAX_PLAYER_NAME], TargetPesan[MAX_PLAYER_NAME], gacorss, pesan;
    if(sscanf(params, "us", gacorss, pesan))
    {
    	USAGE(playerid, "/pm <id> <pesan>");
    }
    else
    {
		if(IsPlayerConnected(playerid))
		{
		    if(IsPlayerConnected(gacorss))
			{
			    GetPlayerName(playerid, NamaPemain, sizeof(NamaPemain));
			    GetPlayerName(gacorss, TargetPesan, sizeof(TargetPesan));
				//
    			if(PMStatus[playerid]) return ERROR(playerid, "ERROR: Private Message mu masih di nonaktifkan");
				if(PMStatus[gacorss]) return ERROR(playerid, "ERROR: %s menonaktifkan Private Message", TargetPesan);
				//
				format(str, sizeof(str), "Private Message Ke : [%s](%d) | %s", TargetPesan, gacorss, pesan);
				SendClientMessage(playerid, 0x132EACFF, str);
				format(str, sizeof(str), "Private Message Dari : [%s](%d) | %s", NamaPemain, playerid, pesan);
				SendClientMessage(gacorss, 0x132EACFF, str);
			    PlayerPlaySound(gacorss, 1085, 0.0, 0.0, 0.0);
			    printf("[Private Message]: %s To %s: %s", NamaPemain, TargetPesan, pesan);
			}
			else
			{
		        ERROR(playerid, "ERROR: Pemain dengan nama %s sedang tidak online", gacorss);
		    }
		}
		else
		{
			ERROR(playerid, "Lu harus masuk ke game buat pake cmd ini GOBLOK!");
		}
	}
    return 1;
}

CMD:dispm(playerid)
{
    if(!PMStatus[playerid])
	{
        INFO(playerid, "[Private Message]: Private Message di nonaktifkan!");
        PMStatus[playerid] = true;
    }
    else
	{
        INFO(playerid, "[Private Message]: Private Message sudah di nonaktifkan!");
        return 1;
    }
	return 1;
}

CMD:enapm(playerid)
{
	if(IsPlayerConnected(playerid))
	{
    	if(PMStatus[playerid])
		{
        	INFO(playerid, "[Private Message]: Private Message telah di aktifkan!");
	       	PMStatus[playerid] = false;
    	}
    	else
		{
        	INFO(playerid, "[Private Message]: Private Message sudah di aktifkan!");
    	}
	}
	return 1;
}

