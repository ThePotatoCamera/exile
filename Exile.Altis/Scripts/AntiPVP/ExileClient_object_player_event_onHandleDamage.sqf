/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 * Tweaked by PixelDetonator
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */

params ["_unit", "_hit", "_damage", "_source", "_ammo"];

if (isPlayer _source && !(_source isEqualTo player)) then {
	systemChat format ["Getting attack from %1!", name _source];
	_damage = damage _unit;
};

_damage
