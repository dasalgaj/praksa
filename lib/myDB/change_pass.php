<!DOCTYPE HTML>  
<html>
<head>
<style>
.error {color: #FF0000;}
</style>
</head>
<body> 

<?php
include "connection.php";

global $conn;
$id = $_GET['id'];
$email = $_GET['email'];

$sql = "SELECT * FROM Users WHERE UserID = '".$id."' AND Email = '".$email."'";
$result = sqlsrv_query($conn, $sql, array(), array("Scrollable" => 'static'));
$count = sqlsrv_num_rows($result);

if ($count == 1){

    $newPassErr = '';
    $confirmNewPass = '';
    $uspjeh = '';

    if (isset($_POST['newPass']) && isset($_POST['confirmNewPass'])) {

        if (empty($_POST['newPass']) || empty($_POST['confirmNewPass'])) {

            $newPassErr = " * Ovo polje je obavezno";

            $confirmNewPass = " * Ovo polje je obavezno";

        }
        else {

            if (preg_match("/^(?=.*?[A-Z])(?=.*[a-z])(?=.*\d)(?=.*\W).{8,}/", $_POST['newPass'] )) {
                    
                if ($_POST['confirmNewPass'] == $_POST['newPass']) {

                    $uspjeh = 'Uspješno ste izmjenili lozinku!';

                    $updateLozinke = "UPDATE Users SET Lozinka = '".$_POST['newPass']."' WHERE UserID = '".$id."'";
                    $queryUpdate = sqlsrv_query($conn, $updateLozinke);
                    
                }

            }
            else {
                $newPassErr = " * Unesite pravilnu lozinku";
            }

        }

    }
    
}
else{
    echo json_encode("Error");
}
?>

<meta name='viewport' content='width=device-width, initial-scale=1'>
        <div>
        <h2>Forgot password link</h2>
        <form name='form' action='' method='post'>
            <label for='newPass'>Unesite novu lozinku:</label><br>
            <input type='password' id='newPass' name='newPass' placeholder='Nova lozinka'>
            <span class='error'><?php echo $newPassErr; ?></span>
            <br><br>

            <label for='confirmNewPass'>Potvrdite novu lozinku:</label><br>
            <input type='password' id='confirmNewPass' name='confirmNewPass' placeholder='Potvrdi lozinku'>
            <span class='error'><?php echo $confirmNewPass; ?></span>
            <br><br>

            <input id='btnIspis' type='submit' value='Promjeni lozinku'>
        </form>
        <h3><?php echo $uspjeh ?></h3>
        </div>
        </body>
</html>