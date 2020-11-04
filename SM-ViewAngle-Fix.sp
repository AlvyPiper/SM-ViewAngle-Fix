/*
SM-ViewAngle-Fix

Copyright (C) 2016 Alvy Piper

Additional credits to:
https://github.com/shyguy-yt - bug fixes.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include <sourcemod>

public Plugin:myinfo = 
{ 
	name = "ViewAngle Fix", 
	author = "Alvy Piper", 
	description = "Normalizes out of bounds viewangles, and does a hacky teleport fix.", 
	version = "0.1", 
	url = "github.com/AlvyPiper/" 
};

new Float:currentpos[3];
new Float:oldpos[3];

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2])
{
	new bool:alive = IsPlayerAlive(client);
	
	if(!alive)
	{
		return Plugin_Continue;
	}
	
	if(alive)
	{
		GetClientAbsOrigin(client, currentpos);
		
		if(currentpos[0] == 0 && oldpos[0] != 0 && currentpos[1] == 0 && oldpos[1] != 0)
		{
			KickClient(client, "Teleporting");
			return Plugin_Handled;
		}
		
		oldpos[0] = currentpos[0];
		oldpos[1] = currentpos[1];
		oldpos[2] = currentpos[2];
		
		if (angles[0] > 89.0)
		{
			angles[0] = 89.0;
		}
			
		if (angles[0] < -89.0)
		{
			angles[0] = -89.0;
		}
				
		while (angles[1] > 180.0)
		{
			angles[1] -= 360.0;
		}
		
		while(angles[1] < -180.0)
		{
			angles[1] += 360.0;
		}
			
		if(angles[2] != 0.0)
		{
			angles[2] = 0.0;
		}
		return Plugin_Changed;
	}
	return Plugin_Continue;
}
