CODI_SMS_chatOpen = true;
{
	_partner = _x select 0;
	_messages = _x select 2;
	if (_partner == CODI_SMS_partner) then
	{
		{
			_sender = _x select 0;
			_message = _x select 2;
			_color = CODI_SMS_partnerColor;
			if (_sender == name player) then
			{
				switch (side player) do
				{
					case blufor:
					{
						_color = [(profilenamespace getvariable ['Map_BLUFOR_R',0]), (profilenamespace getvariable ['Map_BLUFOR_G',1]), (profilenamespace getvariable ['Map_BLUFOR_B',1]), (profilenamespace getvariable ['Map_BLUFOR_A',0.8])];
					};
					case opfor:
					{
						_color = [(profilenamespace getvariable ['Map_OPFOR_R',0]), (profilenamespace getvariable ['Map_OPFOR_G',1]), (profilenamespace getvariable ['Map_OPFOR_B',1]), (profilenamespace getvariable ['Map_OPFOR_A',0.8])];
					};
					case independent:
					{
						_color = [(profilenamespace getvariable ['Map_Independent_R',0]), (profilenamespace getvariable ['Map_Independent_G',1]), (profilenamespace getvariable ['Map_Independent_B',1]), (profilenamespace getvariable ['Map_Independent_A',0.8])];
					};
					case civilian:
					{
						_color = [(profilenamespace getvariable ['Map_Civilian_R',0]), (profilenamespace getvariable ['Map_Civilian_G',1]), (profilenamespace getvariable ['Map_Civilian_B',1]), (profilenamespace getvariable ['Map_Civilian_A',0.8])];
					};
				};
			};
			[_sender+":", _color] call CODI_SMS_fnc_insertText;
			[_message, [1,1,1,1]] call CODI_SMS_fnc_insertText;
		}
		forEach _messages;
	};
}
forEach CODI_SMS_messages;