/* 
Note: attributes are not set until edited by the user.  Not just opening the
	GUI, but actually changing the value of the attribute and saving.  The
	functions using mission config values will have to account for the possible
	absence of config values by defaulting to the defaultValue.
*/

class Cfg3DEN {
	class Mission { // https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Scenario
		#include "FrameworkSettings\FrameworkSettings.hpp"
		#include "Briefing\Briefing.hpp"
		#include "hiddenConfigValues.hpp"
	};

	class Object {
		class AttributeCategories {
			class GVAR(objectSettings) {
				displayName = "SIA Framework";
				collapsed = 0;
				class Attributes {
					class GVAR(isArsenal) {
						displayName = "Is Arsenal";
						tooltip = "Check if this object is meant to be an arsenal";
						property = QGVAR(isArsenal);
						control = "Checkbox";
						expression = QUOTE( \
							if (_value) then { \
								if (isNil QQGVAR(arsenals)) then { GVAR(arsenals) = []; }; \
								GVAR(arsenals) pushBackUnique _this; \
							} else { \
								GVAR(arsenals) = GVAR(arsenals) - [_this]; \
							}; \
						);
						defaultValue = false;

						// condition should be objectSimulated && !objectControllable && !logicModule
						condition = "objectSimulated * (1 - objectControllable) * (1 - logicModule)"; // https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Condition
					};

					class GVAR(isButton) {
						displayName = "Is Button";
						tooltip = "Check if this object is meant to be a button";
						property = QGVAR(isButton);
						control = "Checkbox";
						expression = QUOTE( \
							if (_value) then { \
								if (isNil QQGVAR(buttons)) then { GVAR(buttons) = []; }; \
								GVAR(buttons) pushBackUnique _this; \
							} else { \
								GVAR(buttons) = GVAR(buttons) - [_this]; \
							}; \
						);
						defaultValue = false;
						// condition should be objectSimulated && !objectControllable && !logicModule
						condition = "objectSimulated * (1 - objectControllable) * (1 - logicModule)"; // https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Condition
					};

					class GVAR(role) {
						displayName = "Role";
						tooltip = "The unit's role (e.g, ""Rifleman""); Only needs to be defined on playable units";
						property = QGVAR(role);
						control = "Edit"; // ToDo: custom control that hides when unit is not playable
						expression = QUOTE([ARR_2(_this, _value)] call FUNC(rolesExpression););
						typeName = "STRING";
						defaultValue = "''";

						// only units should have this attribute
						condition = "objectControllable";
					};
				};
			};
		};
	};

	class Group {
		class AttributeCategories {
			class GVAR(groupSettings) {
				displayName = "SIA Framework";
				collapsed = 0;

				class Attributes {
					class GVAR(radioChannel) {
						displayName = "Radio Channel";
						tooltip = "The channel number this group's personal radio will automatically be set to.";
						property = QGVAR(radioChannel);
						control = "Edit";
						expression = QUOTE(_this setVariable [ARR_3(""%s"",_value,true)];);

						defaultValue = "1";

						unique = 0;
						validate = "number";
						typeName = "NUMBER";
						// only units should have this attribute
						//condition = "objectControllable";
					};
				};
			};
		};
	};
};
