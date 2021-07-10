<?php
error_reporting(0);
include_once("dbconnect.php");

$prid = $_POST['prid'];
$prprice = $_POST['prprice'];
$prqty = $_POST['prqty'];
$email = $_POST['email'];


$sqlsearch = "SELECT * FROM tbl_cart WHERE user_email = '$email' AND prid = '$prid' AND prprice = '$prprice' ";

$result = $conn->query($sqlsearch);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        $prquantity = $row["prqty"];
    }
    $prquantity = $prquantity + $prqty;
    $sqlinsert = "UPDATE tbl_cart SET prqty = '$prquantity' WHERE user_email = '$email' AND prid = '$prid' AND prprice = '$prprice'";
    
}else{
    $sqlinsert = "INSERT INTO tbl_cart(user_email,prid,prqty,prprice) VALUES ('$email','$prid','$prqty','$prprice')";
}

if ($conn->query($sqlinsert) === true)
{
    $sqlquantity = "SELECT * FROM tbl_cart WHERE user_email = '$email'";

    $resultq = $conn->query($sqlquantity);
    if ($resultq->num_rows > 0) {
        $quantity = 0;
        while ($row = $resultq ->fetch_assoc()){
            $quantity = $row["product_qty"] + $quantity;
        }
    }

    $quantity = $quantity;
    echo "success,".$quantity;
}
else
{
    echo "failed";
}


?>