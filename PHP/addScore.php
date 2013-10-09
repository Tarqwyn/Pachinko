<?php
session_start();
function redirect($url) { 
	die('<meta http-equiv="refresh" content="0;URL='.$url.'">'); 
}
if(isset($_POST["userName"])){
	$userName = $_POST["userName"];
	$myScore = $_POST["myScore"];
	$time = time();
	$scoreDate =  date("Y-m-d H:i:s",$time);
	if (!$_SERVER['REQUEST_METHOD'] == "POST" || !$userName){
		$myScoreDB = -1;
		$addFlag = " : tried to add: ".$myScore;
	}else{
		$myScoreDB = $myScore;
	}
	if ($_SERVER['REQUEST_METHOD'] != "POST"){
		$myScoreDB = -1;
		$addFlag = " : tried to add: ".$myScore;
	}
	$sql = "insert into highScores (userName,userScore,scoreDate,scoreFrom) values ('$userName',$myScoreDB,'$scoreDate','".$_SERVER['HTTP_REFERER']." : ".$_SERVER['REQUEST_METHOD']." : ".$scoreValid.$addFlag."')";
	$conn = mysql_connect("pachinko.db.7951030.hostedresource.com", "pachinko", "Mimo38Bear");
	$dbName = "pachinko";
	mysql_select_db($dbName,$conn);
	if (mysql_query($sql,$conn)){
		echo "&scoreIn=1";
		exit;
	}else{
		echo "&scoreIn=0";
		echo "&scoreError=".mysql_error();
		exit;
	}
}
?>