#include "script_component.hpp"

/*
    Name: TFAR_fnc_onLRTangentPressed

    Author(s):
        NKey

    Description:
        Fired when the keybinding for LR is pressed.

    Parameters:

    Returns:
        BOOLEAN

    Example:
        call TFAR_fnc_onLRTangentPressed;
*/
if (time - TF_last_lr_tangent_press > 0.1) then {
    if (!(TF_tangent_lr_pressed) and {alive TFAR_currentUnit} and {call TFAR_fnc_haveLRRadio}) then {
        if (call TFAR_fnc_isAbleToUseRadio) then {
            private _radio = call TFAR_fnc_activeLrRadio;
            if (!([_radio] call TFAR_fnc_RadioOn)) exitWith {};
            if ([TFAR_currentUnit, TFAR_currentUnit call TFAR_fnc_vehicleIsIsolatedAndInside, TFAR_currentUnit call TFAR_fnc_eyeDepth] call TFAR_fnc_canUseLRRadio) then {
                [format[localize "STR_transmit",format ["%1<img size='1.5' image='%2'/>",[_radio select 0, "displayName"] call TFAR_fnc_getLrRadioProperty,
                    getText(configFile >> "CfgVehicles"  >> typeof (_radio select 0) >> "picture")],(_radio call TFAR_fnc_getLrChannel) + 1, call TFAR_fnc_currentLRFrequency],
                format["TANGENT_LR	PRESSED	%1%2	%3	%4	%5", call TFAR_fnc_currentLRFrequency, _radio call TFAR_fnc_getLrRadioCode, ([_radio select 0, "tf_range"] call TFAR_fnc_getLrRadioProperty)  * (call TFAR_fnc_getTransmittingDistanceMultiplicator), [_radio select 0, "tf_subtype"] call TFAR_fnc_getLrRadioProperty, typeOf _x],
                -1
                ] call TFAR_fnc_ProcessTangent;
                TF_tangent_lr_pressed = true;
                //				unit, radio, radioType, additional, buttonDown
                ["OnTangent", [TFAR_currentUnit, _radio, 1, false, true]] call TFAR_fnc_fireEventHandlers;
            } else {
                call TFAR_fnc_inWaterHint;
            }
        } else {
            call TFAR_fnc_unableToUseHint;
        };
    };
};
TF_last_lr_tangent_press = time;
true