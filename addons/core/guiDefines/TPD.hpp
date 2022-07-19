class GVAR(TPD) {
	//GUI and script related macros
	#include "\a3\3DEN\UI\macros.inc"

	#define CTRL_DEFAULT_H (SIZE_M * GRID_H)
	#define DIALOG_W 80
	#define DIALOG_Y (safezoneY + 2 * CTRL_DEFAULT_H)

	class TPD_Teleport
	{
		idd = -1;
		onLoad = QUOTE(uiNamespace setVariable [QQGVAR(TPD_display), _this select 0]; ['onLoad', nil, _this select 0] spawn FUNC(teleport));
		class ControlsBackground
		{
			class Headline: ctrlStaticTitle
			{
				text = "$STR_DN_LOCATIONS";
				x = 0.5 - DIALOG_W / 2 * GRID_W;
				y = DIALOG_Y;
				w = DIALOG_W * GRID_W;
				h = CTRL_DEFAULT_H;
			};
			class Background: ctrlStaticBackground
			{
				x = 0.5 - DIALOG_W / 2 * GRID_W;
				y = DIALOG_Y + CTRL_DEFAULT_H;
				w = DIALOG_W * GRID_W;
				h = 67 * GRID_H;
			};
		};
		class Controls
		{
			class Locations: ctrlListBox
			{
				idc = 10;
				x = 0.5 - DIALOG_W / 2 * GRID_W + GRID_W;
				y = DIALOG_Y + CTRL_DEFAULT_H + GRID_H;
				w = DIALOG_W * GRID_W - 2 * GRID_W;
				h = 59 * GRID_H;
			};
			class Teleport: ctrlButton
			{
				text = "$STR_STATE_MOVE";
				x = 0.5 - DIALOG_W / 2 * GRID_W + GRID_W;
				y = DIALOG_Y + 66 * GRID_H;
				w = DIALOG_W / 3 * GRID_W - 2 * GRID_W;
				h = CTRL_DEFAULT_H;
				onButtonClick = QUOTE(['teleport', nil, _this select 0] spawn FUNC(teleport));
			};
			class Preview: Teleport
			{
				text = "$STR_EDITOR_MENU_FILE_PREVIEW";
				x = 0.5 + DIALOG_W / 3 * GRID_W - DIALOG_W / 2 * GRID_W + GRID_W;
				onButtonClick = QUOTE(['previewPosition', nil, _this select 0] call FUNC(teleport));
			};
			class Close: Teleport
			{
				idc= 1;
				text = "$STR_DISP_OPT_CLOSE";
				x = 0.5 + DIALOG_W / 2 * GRID_W - DIALOG_W / 3 * GRID_W + GRID_W;
				onButtonClick = "";
			};
		};
	};
};
