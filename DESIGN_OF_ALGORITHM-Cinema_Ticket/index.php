<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salon Booking System</title>
    <link rel="stylesheet" href="styles.css">
    <script src="scripts.js" defer></script>
</head>
<body>
    <header>
        <h1>Welcome to the Salon Booking System</h1>
    </header>
    <main>
        <form id="bookingForm" onsubmit="event.preventDefault(); goToSellingPanel();">
            <section>
                <h2>Select a Time Slot</h2>
                <select id="timeSlots" name="timeSlots" required>
                    <!-- Options will be loaded by JavaScript -->
                </select>
            </section>
            <section>
                <h2>Select a Salon</h2>
                <select id="salons" name="salons" required>
                    <!-- Options will be loaded by JavaScript -->
                </select>
                <img id="salonImage" src="" alt="Salon Image" style="max-width: 200px; height: auto; margin-top: 10px;">
                <span id="salonFullMessage" style="display: none; color: red; margin-left: 10px;">Salon is full at this time.</span>
            </section>
            <section>
                <h2>Select a Seat</h2>
                <select id="seats" name="seats" required>
                    <!-- Options will be loaded by JavaScript -->
                </select>
            </section>
            <button type="submit">Go to Payment</button>
        </form>

        <!-- Transaction Panel, initially hidden -->
        <div id="transactionPanel" style="display:none;">
            <h2>Transaction Details</h2>
            <p id="discountNotice"></p>
            <input type="hidden" id="bookingId" name="bookingId"> <!-- Assuming you manage booking ID from your backend -->
            <label for="amount">Amount:</label>
            <input type="text" id="amount" name="amount" required disabled>
            <label for="isStudent">Are you a student?</label>
            <input type="checkbox" id="isStudent" name="isStudent">
            <button type="button" onclick="finalizeTransaction()">Complete Booking</button>
        </div>
    </main>
    <footer>
        <p>© 2024 Cinema Salon Booking System</p>
    </footer>
</body>
</html>