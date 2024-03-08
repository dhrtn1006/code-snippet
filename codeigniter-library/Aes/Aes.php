<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Aes {
	public static $default_asekey = "aseKey";
	public static $default_ivkey = "ivKey";

	public function __construct(){}

	public function encrypt ($key, $iv, $value) {
		$val = openssl_encrypt($value, "aes-256-cbc", $key, true, $iv);
		return base64_encode($val);
	}
	public function decrypt ($key, $iv, $value) {
		$decrypt = openssl_decrypt(base64_decode($value), "aes-256-cbc", $key, true, $iv);
		return $decrypt;
	}
	public function erasenull ($value) {
		return substr($value,0,-1);
	}
	public function encdefaultkey(){
		$asenewkey = self::setkeygen();
		$asekey = self::getkeygen(1);
		$ivkey = self::getkeygen(2);
		$aes = self::encrypt($asekey, $ivkey, $asenewkey);
		return $aes;
	}
	public function decdefaultkey($code){
		$asekey = self::getkeygen(1);
		$ivkey = self::getkeygen(2);
		$aes = self::decrypt($asekey, $ivkey, $code);
		return $aes;
	}
	public function getkeygen($type=1){
		$asekey = self::$default_asekey;
		$ivkey = self::$default_ivkey;

		$key = "";
		switch($type){
			case 1:
				$key = md5($asekey);
			break;
			case 2:
				$key = substr( md5($ivkey) , 0 ,16 );
			break;
		}
		return $key;
	}

	public function setkeygen(){
		$setasekey = "setKey-20220429";
		return md5($setasekey);
	}
	public function infoenaes($code){
		$key = self::getkeygen(1);
		$iv  = self::getkeygen(2);
		$aes = self::encrypt($key, $iv, $code);
		return $aes;
	}
	public function infodeaes($code){
		$key = self::getkeygen(1);
		$iv  = self::getkeygen(2);
		$aes = self::decrypt($key, $iv, $code);
		return $aes;
	}
	public function enaes($code){
		$key = self::setkeygen();
		$iv  = self::getkeygen(2);
		$aes = self::encrypt($key, $iv, $code);
		return $aes;
	}
	public function deaes($code){
		$key = self::setkeygen();
		$iv  = self::getkeygen(2);
		$des = self::decrypt ($key, $iv, $code);
		return $des;
	}
}