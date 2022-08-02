<?php
include "connection.php";

global $conn;
$email = $_POST['email'];
$novaLozinka = $_POST['newPassword'];

$sql = "SELECT * FROM Users WHERE Email = '".$email."'";
$result = sqlsrv_query($conn, $sql, array(), array("Scrollable" => 'static'));
$count = sqlsrv_num_rows($result);

if ($count == 1){
    echo json_encode("Success");

    $updateLozinke = "UPDATE Users SET Lozinka = '".$novaLozinka."' WHERE Email = '".$email."'";
    $queryUpdate = sqlsrv_query($conn, $updateLozinke);
}
else{
    echo json_encode("Error");
}

?>