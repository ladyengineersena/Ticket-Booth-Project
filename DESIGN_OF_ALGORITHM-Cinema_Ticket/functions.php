<?php
require_once 'db.php';

function getTimeSlots() {
    global $pdo;
    $stmt = $pdo->prepare("SELECT * FROM TimeSlots WHERE is_available = 1");
    $stmt->execute();
    return $stmt->fetchAll();
}

// function getSalons($timeSlotId) {
function getSalons() {
    global $pdo;
    /*$stmt = $pdo->prepare("SELECT s.* FROM Salons s
                           INNER JOIN Bookings b ON s.salon_id = b.salon_id
                           WHERE b.time_slot_id = ? AND b.status = 'confirmed'");
    $stmt->execute([$timeSlotId]);*/
    $stmt = $pdo->prepare("SELECT * FROM Salons");
    $stmt->execute();
    return $stmt->fetchAll();
}

function getSeats($salonId, $timeSlotId) {
    global $pdo;
    // This query checks for seats that are not taken and not booked for the specified time slot
    $stmt = $pdo->prepare("
        SELECT s.seat_id, s.number FROM Seats s
        LEFT JOIN Bookings b ON s.seat_id = b.seat_id AND b.time_slot_id = ? AND b.status = 'confirmed'
        WHERE s.salon_id = ? AND b.booking_id IS NULL
    ");
    $stmt->execute([$timeSlotId, $salonId]);
    return $stmt->fetchAll();
}

function bookSeat($timeSlotId, $salonId, $seatId, $customerId) {
    global $pdo;
    try {
        $checkStmt = $pdo->prepare("SELECT status FROM Bookings WHERE time_slot_id = ? AND salon_id = ? AND seat_id = ?");
        $checkStmt->execute([$timeSlotId, $salonId, $seatId]);
        $existingStatus = $checkStmt->fetchColumn();
        
        if ($existingStatus) {
            if ($existingStatus === 'confirmed') {
                return ['success' => false, 'message' => 'This seat is already booked for the selected time and salon. Please choose another seat.'];
            } else if ($existingStatus === 'pending') {
                return ['success' => false, 'message' => 'This booking is currently being taken. Please choose another seat or check later.'];
            }
        }

        $pdo->beginTransaction();
        $stmt = $pdo->prepare("INSERT INTO Bookings (customer_id, salon_id, seat_id, time_slot_id, status) VALUES (?, ?, ?, ?, 'pending')");
        $stmt->execute([$customerId, $salonId, $seatId, $timeSlotId]);
        $bookingId = $pdo->lastInsertId();
        $pdo->commit();

        return ['success' => true, 'message' => 'Booking is now pending. Proceed to transaction.', 'bookingId' => $bookingId];
    } catch (PDOException $e) {
        $pdo->rollBack();
        return ['success' => false, 'message' => 'Error booking seat: ' . $e->getMessage()];
    }
}

function checkStudentStatus($customerId) {
    global $pdo;
    $stmt = $pdo->prepare("SELECT is_student FROM Customers WHERE customer_id = ?");
    $stmt->execute([$customerId]);
    return $stmt->fetchColumn();
}

function finalizeTransaction($bookingId, $amount, $isStudent) {
    global $pdo;
    try {
        $pdo->beginTransaction();

        $isStudent = filter_var($isStudent, FILTER_VALIDATE_BOOLEAN); // Ensure that isStudent is treated as a boolean
        $discount = $isStudent ? 0.85 : 1;  // 15% discount for students
        $finalPrice = $amount * $discount;
        $discountApplied = $isStudent == true ? 1 : 0;  // Set discount applied flag based on student status
        
        $stmt = $pdo->prepare("INSERT INTO Transactions (booking_id, amount, discount_applied, final_price) VALUES (?, ?, ?, ?)");
        $stmt->execute([$bookingId, $amount, $discountApplied, $finalPrice]);

        $updateStmt = $pdo->prepare("UPDATE Bookings SET status = 'confirmed' WHERE booking_id = ?");
        $updateStmt->execute([$bookingId]);
        
        $pdo->commit();
        return ['success' => true, 'message' => 'Transaction completed successfully!'];
    } catch (Exception $e) {
        $pdo->rollBack();
        return ['success' => false, 'message' => 'Error in transaction: ' . $e->getMessage()];
    }
}

?>