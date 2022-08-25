#include "script_component.hpp"

/*
 * Author: Siege
 * Formats a string with html attributes e.g, a new line is replaced with '<br/>'.
 *
 * Arguments:
 * 0: The string to format <STRING>
 *
 * Return Value:
 * The formatted string <STRING>
 *
 * Example:
 * call sia3f_core_fnc_briefing
*/

/* Efficiency stats:
	1,000,000 characters: 1.2 seconds
	100,000 characters: 118 ms
	10,000 characters: 11 ms
	1,000 characters: 1 ms
*/

params [
	["_str", "", [""]]
];

LOG("fnc_formatBriefing.sqf started.");

if (_str == "") exitWith { 
	LOG("fnc_formatBriefing.sqf found and returned an empty string.");

	return _str;
};

// replace newline with '<br/>'
private _newlineChar = "
";

if ((_str find _newlineChar) == -1) exitWith {
	LOG("fnc_formatBriefing.sqf found no newline char and returned string.");

	return _str;
};

private _strArr = _str splitString "";
{
	if (_x == _newlineChar) then {
		_strArr set [_forEachIndex, "<br></br>"];
		// diag_log _strArr;
		LOG("fnc_formatBriefing.sqf formatted a new line");
	};
} forEach _strArr; // there should be a more efficient way to do this than iterating through the entire array, which could possibly have thousands of indexes elements.

// ToDo: colors, bold, images?, etc.
_strArr joinString "";

INFO("fnc_formatBriefing.sqf fully executed.");
