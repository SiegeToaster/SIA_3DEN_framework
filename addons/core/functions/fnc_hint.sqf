#include "script_component.hpp"

#define HEX_PINK "#FEAAAA"
#define HEX_RED "#B21A00"
#define HEX_GREEN "#AAFEAA"
#define HEX_BLUE "#AAAAFE"
#define HEX_YELLOW "#FEFEAA"
#define HEX_WHITE "#FFFFFF"
#define HEX_SECONDARY "#666666" // gray
#define HEX_HEADER "#FFB84C" // yellow/orange color, aka "Koromiko"
#define FONT_HEADER "PuristaMedium"
#define FONT_PRIMARY "PuristaLight"
#define FONT_SECONDARY "PuristaSemibold"

/*
 * Author: McKendrick
 * Formats and displays information about the current mission in the form of a hint.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call sia3f_core_fnc_hint
*/

if (!GET_CONFIG(showStatusHint,true) || !hasInterface) exitWith {
	LOG("fnc_hint.sqf was disabled by player or ran on server.");
}; // Exit if not a player or if player has disabled status hint.

LOG("fnc_hint.sqf started.");

private _systemTime = systemTimeUTC; // Cache System's current time.
TRACE_1("cached system's current time in UTC timezone", _systemTime);

private _separator = parseText "<br />------------------------------<br />";
TRACE_1("Visual separator", _separator);
private _image = QPATHTOEF(core,ui\logo_sia3f_tiny.paa);
TRACE_1("SIA logo", _image);

private _txtHeader = text (getMissionConfigValue ["onLoadName", missionName]);
_txtHeader setAttributes ["color", HEX_HEADER, "size", "1.4", "font", FONT_SECONDARY, "shadow", "1", "shadowColor", HEX_SECONDARY, "shadowOffset", "0.07"];
TRACE_1("Mission Name", _txtHeader);

private _txtSetup = text "Current Phase:";
_txtSetup setAttributes ["align", "left", "font", FONT_HEADER];
TRACE_1("Current Phase:", _txtSetup);

private _txtSetupPhase = text (missionNamespace getVariable [QGVAR(safeStart_phase), "Waiting"]);
_txtSetupPhase setAttributes ["align", "right", "font", FONT_HEADER];
TRACE_1("Waiting Phase", _txtSetupPhase);

private _txtLocation = text (GET_CONFIG(missionLocationName, worldName) + "     " + str (date select 1) + "-" + str (date select 2) + "-" + str (date select 0) + "     " + ([daytime, "HH:MM"] call BIS_fnc_timeToString));
_txtLocation setAttributes ["center", "left", "color", HEX_SECONDARY, "font", FONT_PRIMARY, "size", "0.8"];
TRACE_1("Location and Date", _txtLocation);

private _txtSystemTime = text "System Time:";
_txtSystemTime setAttributes ["align", "left", "font", FONT_HEADER];
TRACE_1("System Time", _txtSystemTime);

private _timezoneOffset = -5;
private _timezoneName = "EST";
if ( (_systemTime select 1) >= 3 && (_systemTime select 1) <= 11 ) then { _timezoneOffset = -4; _timezoneName = "EDT" }; // Quick and dirty DST adjustment.
TRACE_2("UTC offset in hours, current timezone", _timezoneOffset, _timezoneName);

private _hour = _systemTime select 3;
_hour = if (_hour + _timezoneOffset < 0) then [{ _hour + _timezoneOffset + 24}, { _hour + _timezoneOffset }]; // Adjust hour of day for UTC being a day ahead of ET.
TRACE_1("current hour adjusted from UTC timezone", _hour);

_txtTime = text (([(_hour + ((_systemTime select 4) / 60)), "HH:MM"] call BIS_fnc_timeToString) + " " + _timezoneName);
_txtTime setAttributes ["align", "right", "font", FONT_HEADER];
TRACE_1("time", _txtTime);

private _txtFaction = text "Faction:";
_txtFaction setAttributes ["align", "left", "font", FONT_PRIMARY];
private _txtFactionName = text (getMissionConfigValue [("sia3f_configuration_" + str side player + "FactionName"), (getText (configFile >> "CfgFactionClasses" >> (faction player) >> "displayName"))]);
_txtFactionName setAttributes ["align", "right", "font", FONT_PRIMARY];
TRACE_2("Faction:, displayed current faction name", _txtFaction, _txtFactionName);

private _role = player getVariable [QGVAR(role), (roleDescription player)];
_role = if (_role != "") then [{ (_role splitString "@") select 0 }, { getText (configFile >> "CfgVehicles" >> (typeOf player) >> "displayName") }];
TRACE_1("player role", _role);

private _txtRole = text "Role:";
_txtRole setAttributes ["align", "left", "font", FONT_PRIMARY];
private _txtRoleName = text _role;
_txtRoleName setAttributes ["align", "right", "font", FONT_PRIMARY];
TRACE_2("Role:, displayed current player role", _txtRole, _txtRoleName);

private _txtRadioName = text "Radio:";
_txtRadioName setAttributes ["align", "left", "font", FONT_PRIMARY];
private _txtGroupChannel = text ((GET_CONFIG(personalRadio, "AN/PRC-343")) + " - Ch " + (str ((group player) getVariable [QGVAR(radioChannel), 1])));
_txtGroupChannel setAttributes ["align", "right", "font", FONT_PRIMARY];
TRACE_2("Radio:, displayed current radio type and channel", _txtRadioName, _txtGroupChannel);

private _txtGroup = text "Group:";
_txtGroup setAttributes ["align", "left", "font", FONT_SECONDARY, "color", HEX_HEADER];
private _txtGroupName = text (groupId (group player));
_txtGroupName setAttributes ["align", "right", "font", FONT_SECONDARY, "color", HEX_HEADER];
private _groupMembers = (units group player) apply {name _x};
private _txtGroupMembers = "";
TRACE_3("Group:, displayed player's group name, displayed members in player's group", _txtGroup, _txtGroupName, _txtGroupMembers);

private _array = [
	image _image,
	lineBreak,
	_txtHeader,
	lineBreak,
	_txtLocation,
	_separator,
	_txtSetup, _txtSetupPhase,
	lineBreak,
	_txtSystemTime, _txtTime,
	lineBreak,
	lineBreak,
	_txtFaction, _txtFactionName,
	lineBreak,
	_txtRole, _txtRoleName,
	lineBreak,
	_txtRadioName,_txtGroupChannel,
	lineBreak,
	lineBreak,
	_txtGroup,_txtGroupName,
	lineBreak,
	_txtGroupMembers
];
TRACE_1("array of hint box variables", _array);

{
	private _role = roleDescription _x;
	private _roleColor = '';

	if (_role != "") then { // If roleDescription is set, then truncate. Else use config name.
		_role = (_role splitString "@") select 0;
	} else {
		_role = getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
	};

	if (_x == player) then { // Set color of player's name to tan.
		_roleColor = HEX_RED;
	} else {
		_roleColor = HEX_WHITE;
	};

	private _teamColor = switch (assignedTeam _x) do {
		case "RED": { HEX_PINK };
		case "GREEN": { HEX_GREEN };
		case "BLUE": { HEX_BLUE };
		case "YELLOW": { HEX_YELLOW };
		default { HEX_WHITE };
	};

	private _rankIcon = image ("\A3\Ui_F\Data\GUI\Cfg\Ranks\" + (rank _x) + "_gs.paa"); // Get icon of units' rank from config.
	_rankIcon setAttributes ["align", "left", "size", "0.8", "color", _teamColor];
	_array pushBack _rankIcon;

	private _txt = text (" " + name _x);
	_txt setAttributes ["align", "left", "color", _teamColor, "font", FONT_HEADER, "size", "0.8"];
	_array pushBack _txt;

	_txt = text _role;
	_txt setAttributes ["align", "right", "color", HEX_SECONDARY, "font", FONT_PRIMARY, "size", "0.8"];
	_array pushBack _txt;
	_array pushBack lineBreak;
} forEach ([leader player] + (units group player - [leader player])); // Do for all units in group, starting with the group lead.
LOG("fnc_hint.sqf finished formatting _array in the forEach loop.");

private _structuredText = composeText _array;
TRACE_1("Structured Text", _structuredText);

hintSilent _structuredText;

INFO("fnc_hint.sqf fully executed.");
