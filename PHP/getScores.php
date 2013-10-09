<?php
$sql = "SELECT userScore,userName,scoreDate FROM highScores order by userScore desc LIMIT 0 , 10";
$conn = mysql_connect("pachinko.db.7951030.hostedresource.com", "pachinko", "Mimo38Bear");
$dbName = "pachinko";
mysql_select_db($dbName,$conn);
$myresults = mysql_query($sql,$conn);
if ($myresults){
	$numResults = mysql_num_rows($myresults);
	if (mysql_num_rows($myresults)>0){
		$rankCount = 0;
		echo "score,name\n";
		while($logarray = mysql_fetch_array($myresults)){
			$rankCount++;
			echo $logarray[0].",";
			echo $logarray[1]."\n";
		}
	}else{
		echo "totalscores=0";
	}
}
?>