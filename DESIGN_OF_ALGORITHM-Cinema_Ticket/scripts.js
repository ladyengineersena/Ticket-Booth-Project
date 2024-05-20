document.addEventListener('DOMContentLoaded', function() {
    loadTimeSlots();
    document.getElementById('timeSlots').addEventListener('change', function() {
        // loadSaUlons();
        loadSeats();  // Added to ensure seats are reloaded when time slots change
    });
    document.getElementById('salons').addEventListener('change', loadSeats);
    // document.getElementById('bookingForm').addEventListener('submit', submitBooking);

    document.getElementById('isStudent').addEventListener('change', applyDiscount);

});

function loadTimeSlots() {
    fetch('api.php?action=getTimeSlots')
        .then(response => response.json())
        .then(data => {
            const select = document.getElementById('timeSlots');
            select.innerHTML = data.map(slot => `<option value="${slot.time_slot_id}">${slot.start_time} - ${slot.end_time}</option>`).join('');
            loadSalons(); // Automatically load salons for the first time slot
        });
}

function loadSalons() {
    const timeSlotId = document.getElementById('timeSlots').value;
    fetch(`api.php?action=getSalons&timeSlotId=${timeSlotId}`)
        .then(response => response.json())
        .then(data => {
            const select = document.getElementById('salons');
            const amountInput = document.getElementById('amount');
            select.innerHTML = data.map(salon => `<option value="${salon.salon_id}" data-img="${salon.image_url}" data-price="${salon.price}">${salon.name}</option>`).join('');
            loadSeats(); // Automatically load seats for the first salon
            if (data.length > 0) {
                amountInput.value = data[0].price; // Set the price for the first salon as default
                amountInput.setAttribute('data-original-price', data[0].price); // Store original price
            }
        });
}

function updateSalonImage() {
    const salonSelect = document.getElementById('salons');
    const imageUrl = salonSelect.options[salonSelect.selectedIndex].getAttribute('data-img');
    const price = salonSelect.options[salonSelect.selectedIndex].getAttribute('data-price');
    document.getElementById('salonImage').src = imageUrl;
    document.getElementById('amount').value = price;
    document.getElementById('amount').setAttribute('data-original-price', price);
}

function loadSeats() {
    updateSalonImage();
    const salonId = document.getElementById('salons').value;
    const timeSlotId = document.getElementById('timeSlots').value;
    const salonFullMessage = document.getElementById('salonFullMessage');
    const seatSelect = document.getElementById('seats');
    fetch(`api.php?action=getSeats&salonId=${salonId}&timeSlotId=${timeSlotId}`)
        .then(response => response.json())
        .then(data => {
            if (data.length === 0) {
                // No seats available, show error message and disable seat dropdown
                salonFullMessage.style.display = 'block';
                seatSelect.innerHTML = ''; // Clear previous options
                seatSelect.disabled = true; // Disable the dropdown
            } else {
                // Seats available, hide error message and populate dropdown
                salonFullMessage.style.display = 'none';
                seatSelect.innerHTML = data.map(seat => `<option value="${seat.seat_id}">${seat.number}</option>`).join('');
                seatSelect.disabled = false; // Ensure the dropdown is enabled
            }
        });
}

// function submitBooking(event) {
//     event.preventDefault();
//     const formData = new FormData(document.getElementById('bookingForm'));
//     fetch('api.php?action=bookSeat', {
//         method: 'POST',
//         body: formData
//     })
//     .then(response => response.json())
//     .then(data => {
//         alert(data.message);
//         if (data.success) {
//             // Reset the form or redirect the user
//             document.getElementById('bookingForm').reset();
//         }
//     })
//     .catch(error => {
//         console.error('Error:', error);
//         alert('Error submitting booking.');
//     });
// }

function goToSellingPanel() {
    const timeSlotId = document.getElementById('timeSlots').value;
    const salonId = document.getElementById('salons').value;
    const seatId = document.getElementById('seats').value;
    const customerId = 1; // With Login System

    console.log(timeSlotId + ", "  + salonId + ", " + seatId)
    fetch('api.php?action=bookSeat', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `timeSlotId=${timeSlotId}&salonId=${salonId}&seatId=${seatId}&customerId=${customerId}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            document.getElementById('bookingId').value = data.bookingId; // Set the booking ID for transaction use
            showTransactionPanel();
        } else {
            alert(data.message); // Alert the user to the duplicate booking issue
        }
    });
}

function showTransactionPanel() {
    const isStudentCheckbox = document.getElementById('isStudent');
    const panel = document.getElementById('transactionPanel');
    panel.style.display = 'block';
    isStudentCheckbox.checked = false; // Reset the checkbox for a new transaction
}

function applyDiscount() {
    const isStudentCheckbox = document.getElementById('isStudent');
    const amountInput = document.getElementById('amount');
    const originalPrice = parseFloat(amountInput.getAttribute('data-original-price'));

    if (isStudentCheckbox.checked) {
        const discountedPrice = originalPrice * 0.85;
        amountInput.value = discountedPrice.toFixed(2);
    } else {
        amountInput.value = originalPrice.toFixed(2);
    }
}

function finalizeTransaction() {
    const bookingId = document.getElementById('bookingId').value; // Assuming bookingId is stored in an input field
    const amount = parseFloat(document.getElementById('amount').getAttribute('data-original-price')); // Assuming amount is entered or calculated
    const isStudent = document.getElementById('isStudent').checked; // Checkbox for student status
    console.log(isStudent)

    fetch('api.php?action=finalizeTransaction', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `bookingId=${bookingId}&amount=${amount}&isStudent=${isStudent}`
    })
    .then(response => response.json())
    .then(data => {
        alert(data.message);
        if (data.success) {
            document.getElementById('bookingForm').reset();
            document.getElementById('transactionPanel').style.display = 'none';
            loadSeats()
            updateSalonImage()
        }
    });
}
