<?php
error_reporting(0);
include_once("dbconnect.php");
$addressid = $_POST['addressid'];

$sqldelete = "DELETE FROM tbl_address WHERE address_id = '$addressid'";
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>