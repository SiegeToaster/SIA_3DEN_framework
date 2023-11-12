#include "script_component.hpp"

/*
 * Author: Siege
 * Initializes the select role GUI.
 * 
 * Arguments:
 * 1: Arsenal display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [displayNull] call sia3f_dynamicgroups_fnc_roleSelectOnLoad
*/

params ["_display"];
 
if (isNil QGVAR(center)) then {
    GVAR(center) = player; // ToDo maybe?
};

GVAR(mouseButtonState) = [[], []];

// modified from ace_arsenal_fnc_onArsenalOpen by Alganthe:

// Camera prep
cutText ["", "plain"];
showCommandingMenu "";

GVAR(cameraView) = cameraView;
player switchCamera "internal";
if ("@ace" call EFUNC(core,checkModPresence)) then {
	[QUOTE(ADDON), [false, true, true, true, true, true, true, false, true, true]] call ace_common_fnc_showHud;
}; // ToDo: replicate showHud function for missions w/o ace

private _mouseAreaCtrl = _display displayCtrl 1200;
ctrlSetFocus _mouseAreaCtrl;

// init camera
private _centerBox = boundingBoxReal player;
GVAR(cameraOffsetInitial) = sqrt ([_centerBox select 0 select 0, _centerBox select 0 select 1] distance [_centerBox select 1 select 0, _centerBox select 1 select 1]);
GVAR(cameraOffset) = GVAR(cameraOffsetInitial) - (GVAR(cameraOffsetInitial) / 5); // make offset the middle of the right side of screen instead of rightmost position

if (isNil QGVAR(cameraPosition)) then { // ToDo: restrict camera view to right side
	GVAR(cameraPosition) = [5, 0, 0, [GVAR(cameraOffset), 0, 0.85]]; // distance, dirH, dirV, helperPos
};

// Save curator camera state so camera position and direction are not modified while using arsenal
if (!isNull curatorCamera) then {
	GVAR(curatorCameraData) = [getPosASL curatorCamera, [vectorDir curatorCamera, vectorUp curatorCamera]];
};

GVAR(cameraHelper) = createAgent ["Logic", position player, [], 0, "none"];
GVAR(cameraHelper) attachTo [player, GVAR(cameraPosition) select 3, ""];

GVAR(camera) = "camera" camCreate position player;
GVAR(camera) cameraEffect ["internal", "back"];
GVAR(camera) camPrepareFocus [-1, -1];
GVAR(camera) camPrepareFov 0.35;
GVAR(camera) camCommitPrepared 0;

showCinemaBorder false;
["#(argb,8,8,3)color(0,0,0,1)", false, nil, 0, [0, 0.5]] call BIS_fnc_textTiles;

//--------------- Reset camera pos
[controlNull, 0, 0] call FUNC(handleMouse);
GVAR(camPosUpdateHandle) = addMissionEventHandler ["draw3D", { [] call FUNC(updateCamPos) }];
