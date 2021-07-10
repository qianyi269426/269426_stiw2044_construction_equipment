<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_GET['email']; //email
$phoneno = $_GET['phoneno']; 
$name = $_GET['name']; 
$totalprice = $_GET['totalprice']; 
$address = $_GET['address']; 
$addmessage = $_GET['addmessage']; 
// $delivery_time = $_GET['delivery_time'];

$api_key = '4a2687ca-9e48-497a-a653-7122f30b2df0';
$collection_id = 'kuiidudl';
$host = 'https://billplz-staging.herokuapp.com/api/v3/bills';


$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'phoneno' => $phoneno,
          'name' => $name,
          'amount' => $totalprice * 100, // RM20
		  'description' => 'Payment for order' ,
          'callback_url' => "https://javathree99.com/s269426/constructorequipment/php/return_url",
          'redirect_url' => "https://javathree99.com/s269426/constructorequipment/php/payment_update.php?email=$email&phoneno=$phoneno&name=$name&totalprice=$totalprice&address=$address&addmessage=$addmessage" 
);


$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

echo "<pre>".print_r($bill, true)."</pre>";
header("Location: {$bill['url']}");
?>