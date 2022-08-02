<?php
include "connection.php";

global $conn;
$email = $_POST['email'];

$sql = "SELECT * FROM Users WHERE Email = '".$email."'";
$result = sqlsrv_query($conn, $sql, array(), array("Scrollable" => 'static'));
$count = sqlsrv_num_rows($result);
$data = sqlsrv_fetch_array($result);

if ($count){
    $idData = $data['UserID'];
    $userData = $data['Email'];

    $url = 'http://'.$_SERVER['SERVER_NAME'].'/change_pass.php?id='.$idData.'&email='.$userData;

    echo json_encode($url);
}
else{
    echo json_encode("INVALIDUSER");
}

?>