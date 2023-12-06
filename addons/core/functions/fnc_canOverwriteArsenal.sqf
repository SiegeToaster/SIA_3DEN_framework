#include "script_component.hpp"

/*
 * Author: Siege
 * Checks if the overwrite arsenal Zeus Enhanced action is applicable.
 *
 * Arguments:
 * 0: Selected objects <ARRAY of OBJECT>
 *
 * Return Value:
 * True if disable arsenal on respawn is enabled and selected object is a player <BOOLEAN>
 *
 * Example:
 * [_objects] call sia3f_core_fnc_canOverwriteArsenal
*/

params [
	["_objects", [], [[]]]
];

GET_CONFIG(disableArsenalOnRespawn,false) && !isNil QGVAR(arsenalContents) && (_objects findIf {alive _x && {_x isKindOf 'CAManBase'}} != -1)
