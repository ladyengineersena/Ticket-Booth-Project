<?php
require_once 'functions.php';

header('Content-Type: application/json');

$action = $_GET['action'] ?? '';

switch ($action) {
    case 'getTimeSlots':
        echo json_encode(getTimeSlots());
        break;
    case 'getSalons':
        // $timeSlotId = $_GET['timeSlotId'] ?? '';
        // echo json_encode(getSalons($timeSlotId));
        echo json_encode(getSalons());
        break;
    case 'getSeats':
        $salonId = $_GET['salonId'] ?? '';
        $timeSlotId = $_GET['timeSlotId'] ?? '';
        echo json_encode(getSeats($salonId, $timeSlotId));
        break;
    case 'bookSeat':
        $timeSlotId = $_POST['timeSlotId'] ?? '';
        $salonId = $_POST['salonId'] ?? '';
        $seatId = $_POST['seatId'] ?? '';
        $customerId = $_POST['customerId'] ?? 1; // This would typically be retrieved from session or input
        echo json_encode(bookSeat($timeSlotId, $salonId, $seatId, $customerId));
        break;
    case 'checkStudentStatus':
        $customerId = $_POST['customerId'] ?? 1; // This should come from session or user input in a real application
        echo json_encode(['isStudent' => checkStudentStatus($customerId)]);
        break;
    case 'finalizeTransaction':
        $bookingId = $_POST['bookingId'] ?? '';
        $amount = $_POST['amount'] ?? 100; // Example default amount
        $isStudent = $_POST['isStudent'] ?? false;
        echo json_encode(finalizeTransaction($bookingId, $amount, $isStudent));
        break;
    default:
        echo json_encode(['success' => false, 'message' => 'Invalid action']);
}
?>