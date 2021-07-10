<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$prid = $_POST['prid'];
$quantity = $_POST['quantity'];
$prprice = $_POST['prprice'];

$sqlupdate = "UPDATE tbl_cart SET prqty = '$quantity' WHERE user_email = '$email' AND prid = '$prid' AND prprice = '$prprice'";

if ($conn->query($sqlupdate) === true)
{
    echo "success";
}
else
{
    echo "failed";
}
    
$conn->close();
?>