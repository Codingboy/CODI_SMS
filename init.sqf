call compile preprocessFileLineNumbers "sms.sqf";
if (hasInterface) then
{
	waitUntil{!isNull player};
	player addAction ["Open Smartphone", {createDialog "CODI_SMS_SmartphoneMenu";}];
}