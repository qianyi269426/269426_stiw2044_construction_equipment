<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
     $sql = "SELECT * FROM tbl_address WHERE user_email = '$email'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["address"] = array();
    while ($row = $result->fetch_assoc())
    {
        $addresslist = array();
        $addresslist["address_id"] = $row["address_id"];
        $addresslist["name"] = $row["name"];
        $addresslist["phoneno"] = $row["phoneno"];
        $addresslist["detailed_address"] = $row["detailed_address"];
        $addresslist["area"] = $row["area"];
        $addresslist["poscode"] = $row["poscode"];
        $addresslist["state"] = $row["state"];
        

        
        array_push($response["address"], $addresslist);
    }
    echo json_encode($response);
}
else
{
    echo "List Empty";
}

?>