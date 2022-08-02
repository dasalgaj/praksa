<?php
include "connection.php";

global $conn;
$email = $_POST['email'];
$mobitel = $_POST['mobitel'];
$lozinka = $_POST['password'];

$sql = "SELECT * FROM Users WHERE Email = '".$email."'";
$result = sqlsrv_query($conn, $sql, array(), array("Scrollable" => 'static'));
$count = sqlsrv_num_rows($result);

if ($count == 1){
    echo json_encode("Error");
}
else{
    $insert = "INSERT INTO Users(Email, Lozinka, Mobitel) VALUES ('".$email."', '".$lozinka."', '".$mobitel."')";
    $query = sqlsrv_query($conn, $insert);
    if ($query){
        echo json_encode("Success");
    }
}

?>