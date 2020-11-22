diag_log "---------------------------------- Starting RG Exile Client Init -----------------------------------";
diag_log "------------------------------------------- Version 0.1 --------------------------------------------";

[] execVM "R3F_LOG\init.sqf"; 
[] execVM "Custom\EnigmaRevive\init.sqf";

//Init UPSMON script
//call compile preprocessFileLineNumbers "scripts\Init_UPSMON.sqf";

/*
    File: init.sqf
    Author: Salutesh aka Steve
    
    Description:
	Main initialize file.
    
*/
private ["_timeStamp"];

_timeStamp = diag_tickTime;

// Run on all player clients incl. player host and headless clients
if (!isDedicated) then {	
	// Run on all player clients incl. player host
	if (hasInterface) then {
		call exile_fnc_statusbar;			// Load statusbar
	};
};
diag_log format["End of Exile RG Client Init :: Total Execution Time %1 seconds ",(diag_tickTime) - _timeStamp];

/**
 * AdminToolkit - An arma3 administration helper tool
 * @author ole1986
 */

// wait until main display has been loaded
[] spawn {
    private['_control', '_controlIDC', '_code'];

    _code = compileFinal preprocessFileLineNumbers 'atk\system\AdminToolkit_showMessage.sqf';
    missionNamespace setVariable ['AdminToolkit_showMessage', _code];

    if(isNil "AdminToolkit_network_receiveResponse") then {
        _code = compileFinal preprocessFileLineNumbers 'atk\system\AdminToolkit_receiveResponse.sqf';
        missionNamespace setVariable ['AdminToolkit_network_receiveResponse', _code];
    };

    disableSerialization;
    waitUntil {!isNull (findDisplay 46)};

        // create a structured text control
    _controlIDC = 1901; 
    _control = (finddisplay 46) ctrlCreate ["RscStructuredText", _controlIDC];
    _control ctrlSetPosition [0,0, 1,1];
    _control ctrlCommit 0;
    missionNamespace setVariable ['RscAdminToolkitMessage_IDC', _controlIDC];
    ["AdminToolkit", "This server is using the AdminToolkit"] call AdminToolkit_showMessage;
};