#include "..\script_component.hpp";
/*
 * Author: CPL.Brostrom.A
 * This function setup a loadout categories
 *
 * Arguments:
 * 0: Vehicle/Object/Crate <OBJECT>
 *
 * Return Value:
 * Main category used for creation <STRING>
 *
 * Example:
 * [this] call cScripts_fnc_vehicle_setupPylonCategories;
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

// Icons
//private _icon  = "iconTank" call FUNC(getIcon);

// Loadout action setup
private _pylonList = [];

if (_vehicle iskindOf "rhsusf_m1a1tank_base") then {
    _pylonList = [
        // TypeOf,               DisplayName,   Name,           Icon
        ["rhsusf_m1a1tank_base", "Hard",        "hard",         ""],
        ["rhsusf_m1a1tank_base", "Soft",        "soft",         ""],
        ["rhsusf_m1a1tank_base", "Default",     "default",      ""]
    ];
};

if (_vehicle iskindOf "APC_Wheeled_03_base_F") then {
    _pylonList = [
        // TypeOf,                DisplayName,  Name,           Icon
        ["APC_Wheeled_03_base_F", "AntiArmor",  "AntiArmor",    ""],
        ["APC_Wheeled_03_base_F", "AntiAir",    "AnitAir",      ""],
        ["APC_Wheeled_03_base_F", "Assault",    "Assault",      ""],
        ["APC_Wheeled_03_base_F", "Default",    "default",      ""]
    ];
};


if (count _pylonList == 0) exitWith {false};
private _icon = "";
// Setup category
private _mainCategory = ["ACE_SelfActions", QEGVAR(Actions_Vehicle,Main_Cat)];
private _vehiclePylon = [QEGVAR(Actions_Vehicle,Pylon_Cat), "Vehicle Loadouts", "", {true}, { call FUNC(checkStagingZone) }] call ace_interact_menu_fnc_createAction;
[_vehicle, 1, _mainCategory, _vehiclePylon] call ace_interact_menu_fnc_addActionToObject;

// Setup loadouts selection
{
    _x params ["_vehicleKind", "_displayName", "_loadoutName", ["_icon", ""]];
    #ifdef DEBUG_MODE
        [format ["Creating loadout '%1' (%2) action for vehicle %3 (%4)", _displayName, _loadoutName, _vehicle, typeOf _vehicle], "Vehicle Pylon Setup"] call FUNC(info);
    #endif
    private _pylon = [_vehicleKind, _loadoutName] call EFUNC(vehicle,getPylon);
    [_vehicle, _displayName, _vehicleKind, _loadoutName, _pylon, _icon] call EFUNC(vehicle,addPylonSelection);
} forEach _pylonList;

true
