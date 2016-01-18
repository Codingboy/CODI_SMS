//CODI_SMS_messages = [["Coding",-1,[["Coding",serverTime,"asdf"]]]];
CODI_SMS_messages = [];
CODI_SMS_menuOpen = false;
CODI_SMS_chatOpen = false;
CODI_SMS_send = {
	private["_receiver","_sender"];
	_receiver = _this select 0;
	_message = _this select 1;
	[[name player, _receiver, _message], "CODI_SMS_receive", true, false] call BIS_fnc_MP;
};
CODI_SMS_receive = {
	private["_receiver","_sender","_message","_partner","_state","_firstSMS","_entry","_messages","_color"];
	_sender = _this select 0;
	_receiver = _this select 1;
	_message = _this select 2;
	if (hasInterface) then
	{
		if (_receiver == name player || _sender == name player) then
		{
			_partner = _sender;
			_state = 2;
			if (name player == _sender) then
			{
				_partner = _receiver;
				_state = 0;
			};
			_firstSMS = true;
			{
				_entry = _x;
				if ((_entry select 0) == _partner) then
				{
					_firstSMS = false;
					_messages = _entry select 2;
					_messages pushBack [_sender, serverTime, _message];
					CODI_SMS_messages set [_forEachIndex, [_partner, _state, _messages]];
				};
			}
			forEach CODI_SMS_messages;
			if (_firstSMS) then
			{
				CODI_SMS_messages pushBack [_partner, _state, [[_sender, serverTime, _message]]];
			};
			if (_partner == _sender) then
			{
				call CODI_SMS_notify;
			};
			if (CODI_SMS_chatOpen) then
			{
				if (_sender == CODI_SMS_partner) then
				{
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
					}
					else
					{
						[CODI_SMS_partner] call CODI_SMS_ackGlobal;
					};
					[_sender+":", _color] call CODI_SMS_fnc_insertText;
					[_message, [1,1,1,1]] call CODI_SMS_fnc_insertText;
				};
			};
		};
	};
};
CODI_SMS_notify = {
	playSound ["CODI_SMS_AO", true];
};
CODI_SMS_ackLocal = {
	private["_messages","_partner","_receiver","_sender"];
	_sender = _this select 0;
	_receiver = _this select 1;
	if (hasInterface) then
	{
		if (name player == _sender) then
		{
			{
				_partner = _x select 0;
				_messages = _x select 2;
				if (_partner == _receiver) then
				{
					CODI_SMS_messages set [_forEachIndex, [_partner, 1, _messages]];
					if (CODI_SMS_menuOpen) then
					{
						for "_i" from 0 to (lbSize 4242) do
						{
							if (lbText [4242, _i] == _partner) then
							{
								lbSetPicture [4242, _i, "ack.paa"];
							};
						};
					};
				};
			}
			forEach CODI_SMS_messages;
		};
		if (name player == _receiver) then
		{
			{
				_partner = _x select 0;
				_messages = _x select 2;
				if (_partner == _sender) then
				{
					CODI_SMS_messages set [_forEachIndex, [_partner, -1, _messages]];
					if (CODI_SMS_menuOpen) then
					{
						for "_i" from 0 to (lbSize 4242) do
						{
							if (lbText [4242, _i] == _partner) then
							{
								lbSetPicture [4242, _i, ""];
							};
						};
					};
				};
			}
			forEach CODI_SMS_messages;
		};
	};
};
CODI_SMS_ackGlobal = {
	private["_sender","_partner","_state","_messages"];
	_sender = _this select 0;
	{
		_partner = _x select 0;
		_state = _x select 1;
		_messages = _x select 2;
		if (_partner == _sender) then
		{
			if (_state == 2) then
			{
				CODI_SMS_messages set [_forEachIndex, [_partner, -1, _messages]];
				[[_sender, name player], "CODI_SMS_ackLocal", true, false] call BIS_fnc_MP;
			};
		};
	}
	forEach CODI_SMS_messages;
};
CODI_SMS_fnc_openChat = {
	CODI_SMS_partner = (_this select 0) lbText (_this select 1);
	CODI_SMS_partnerColor = (_this select 0) lbColor (_this select 1);
	closeDialog 1;
	[CODI_SMS_partner] call CODI_SMS_ackGlobal;
	createDialog "CODI_SMS_SmartphoneSMS";
	true
};
CODI_SMS_fnc_onKeyUp = {
	private["_control","_key","_handled"];
	_control = _this select 0;
	_key = _this select 1;
	_handled = false;
	if (_key == 28) then
	{
		_handled = true;
		_message = ctrlText _control;
		_control ctrlSetText "";
		[CODI_SMS_partner, _message] call CODI_SMS_send;
	};
	_handled
};
CODI_SMS_fnc_insertText = {
	private["_text","_color","_textArray","_textCount","_index","_finished","_line","_ret"];
	_text = _this select 0;
	_color = param[1, [1,1,1,1]];
	_textArray = toArray _text;
	_textCount = count _textArray;
	_index = 0;
	_finished = false;
	while {!_finished} do
	{
		_line = [];
		for "_i" from 1 to 38 do
		{
			if (_index < _textCount) then
			{
				_line pushBack (_textArray select _index);
			}
			else
			{
				_finished = true;
			};
			_index = _index + 1;
		};
		_ret = lbAdd[4243, toString _line];
		lbSetColor [4243, _ret, _color];
	};
};