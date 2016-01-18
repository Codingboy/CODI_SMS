CODI_SMS_menuOpen = true;
_units = playableUnits;
_units = _units - [player];
{
	_unitName = name _x;
	_index = lbAdd[4242, _unitName];
	_color = [1,1,1,1];
	switch (side _x) do
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
	lbSetColor [4242, _index, _color];
	{
		_partner = _x select 0;
		if (_partner == _unitName) then
		{
			switch (_x select 1) do
			{
				case 0:
				{
					lbSetPicture [4242, _index, "sended.paa"];
				};
				case 1:
				{
					lbSetPicture [4242, _index, "ack.paa"];
				};
				case 2:
				{
					lbSetPicture [4242, _index, "notification.paa"];
				};
			};
			lbSetPictureColor [4242, _index, [1,1,1,1]];
		};
	}
	forEach CODI_SMS_messages;
}
forEach _units;