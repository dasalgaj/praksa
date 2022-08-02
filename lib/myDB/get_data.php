<?php
include "connection.php";

global $conn;
$email = $_POST['email'];
$lozinka = $_POST['password'];

$sql = "SELECT * FROM Users WHERE Email = '".$email."' AND Lozinka = '".$lozinka."'";
$result = sqlsrv_query($conn, $sql, array(), array("Scrollable" => 'static'));
$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC );
$count = sqlsrv_num_rows($result);

if ($count == 1){
    echo json_encode($row);
}
else{
    echo json_encode("Error");
}

?>