
private ["_objet", "_config", "_nom", "_fonctionnalites"];

_objet = _this select 0;

_config = configFile >> "CfgVehicles" >> (typeOf _objet);
_nom = getText (_config >> "displayName");

if (isNil {_objet getVariable "R3F_LOG_est_transporte_par"}) then
{
	_objet setVariable ["R3F_LOG_est_transporte_par", objNull, false];
};

if (isNil {_objet getVariable "R3F_LOG_est_deplace_par"}) then
{
	_objet setVariable ["R3F_LOG_est_deplace_par", objNull, false];
};

if (isNil {_objet getVariable "R3F_LOG_proprietaire_verrou"}) then
{
	if (R3F_LOG_CFG_lock_objects_mode == "side") then
	{
		switch (getNumber (_config >> "side")) do
		{
			case 0: {_objet setVariable ["R3F_LOG_proprietaire_verrou", east, false];};
			case 1: {_objet setVariable ["R3F_LOG_proprietaire_verrou", west, false];};
			case 2: {_objet setVariable ["R3F_LOG_proprietaire_verrou", independent, false];};
		};
	}
	else
	{
		// En mode de lock faction : uniquement si l'objet appartient initialement � une side militaire
		if (R3F_LOG_CFG_lock_objects_mode == "faction") then
		{
			switch (getNumber (_config >> "side")) do
			{
				case 0; case 1; case 2:
				{_objet setVariable ["R3F_LOG_proprietaire_verrou", getText (_config >> "faction"), false];};
			};
		};
	};
};

if (isNumber (_config >> "preciseGetInOut")) then
{
	// Ne pas monter dans un v�hicule qui est en cours de transport
	_objet addEventHandler ["GetIn", R3F_LOG_FNCT_EH_GetIn];
};

#define __can_be_depl_heli_remorq_transp 0
#define __can_be_moved_by_player 1
#define __can_lift 2
#define __can_be_lifted 3
#define __can_tow 4
#define __can_be_towed 5
#define __can_transport_cargo 6
#define __can_transport_cargo_cout 7
#define __can_be_transported_cargo 8
#define __can_be_transported_cargo_cout 9

_fonctionnalites = _objet getVariable "R3F_LOG_fonctionnalites";

if (R3F_LOG_CFG_unlock_objects_timer != -1) then
{
	_objet addAction [("<t color=""#ee0000"">" + format [STR_R3F_LOG_action_deverrouiller, _nom] + "</t>"), {_this call R3F_LOG_FNCT_deverrouiller_objet}, false, 11, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_deverrouiller_valide"];
}
else
{
	_objet addAction [("<t color=""#ee0000"">" + STR_R3F_LOG_action_deverrouiller_impossible + "</t>"), {hintC STR_R3F_LOG_action_deverrouiller_impossible;}, false, 11, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_deverrouiller_valide"];
};

if (_fonctionnalites select __can_be_moved_by_player) then
{
	_objet addAction [("<t color=""#00eeff"">" + format [STR_R3F_LOG_action_deplacer_objet, _nom] + "</t>"), {_this call R3F_LOG_FNCT_objet_deplacer}, false, 5, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_deplacer_objet_valide"];
};

if (_fonctionnalites select __can_be_towed) then
{
	if (_fonctionnalites select __can_be_moved_by_player) then
	{
		_objet addAction [("<t color=""#00dd00"">" + STR_R3F_LOG_action_remorquer_deplace + "</t>"), {_this call R3F_LOG_FNCT_remorqueur_remorquer_deplace}, nil, 6, true, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_joueur_deplace_objet == _target && R3F_LOG_action_remorquer_deplace_valide"];
	};
	
	_objet addAction [("<t color=""#00dd00"">" + format [STR_R3F_LOG_action_remorquer_direct, _nom] + "</t>"), {_this call R3F_LOG_FNCT_remorqueur_remorquer_direct}, nil, 5, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_remorquer_direct_valide"];
	
	_objet addAction [("<t color=""#00dd00"">" + STR_R3F_LOG_action_detacher + "</t>"), {_this call R3F_LOG_FNCT_remorqueur_detacher}, nil, 6, true, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_detacher_valide"];
};

if (_fonctionnalites select __can_be_transported_cargo) then
{
	if (_fonctionnalites select __can_be_moved_by_player) then
	{
		_objet addAction [("<t color=""#dddd00"">" + STR_R3F_LOG_action_charger_deplace + "</t>"), {_this call R3F_LOG_FNCT_transporteur_charger_deplace}, nil, 8, true, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_joueur_deplace_objet == _target && R3F_LOG_action_charger_deplace_valide"];
	};
	
	_objet addAction [("<t color=""#dddd00"">" + format [STR_R3F_LOG_action_selectionner_objet_charge, _nom] + "</t>"), {_this call R3F_LOG_FNCT_transporteur_selectionner_objet}, nil, 5, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_selectionner_objet_charge_valide"];
};

if (_fonctionnalites select __can_be_moved_by_player) then
{
	_objet addAction [("<t color=""#ff9600"">" + STR_R3F_LOG_action_revendre_usine_deplace + "</t>"), {_this call R3F_LOG_FNCT_usine_revendre_deplace}, nil, 7, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_revendre_usine_deplace_valide"];
};