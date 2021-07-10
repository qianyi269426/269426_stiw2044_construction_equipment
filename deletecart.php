<?php
error_reporting(0);
include_once("dbconnect.php");

$prid = $_POST['prid'];
$email = $_POST['email'];
$prprice = $_POST['prprice'];

$sqldelete = "DELETE FROM tbl_cart WHERE user_email = '$email' AND prid = '$prid' AND prprice = '$prprice'";


if ($conn->query($sqldelete) === TRUE){
   echo "success";
}else {
    echo "failed";
}
?>