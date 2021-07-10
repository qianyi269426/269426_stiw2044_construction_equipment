<?php
$servername = "localhost";
$username = "javathre_constructoradmin";
$password = "62b}a9{*rZq0";
$dbname = "javathre_constructorequipmentdb";

$conn = new mysqli($servername, $username, $password, $dbname);
if($conn->connect_error){
    die("Connection failed: " . $conn->connect_error);
}
?>