function toggleSidebar() {
    document.querySelector('.sidebar').classList.toggle('open');
}


document.addEventListener('DOMContentLoaded', function() {
    setTimeout(() => {
        document.querySelectorAll('.alert-auto').forEach(a => {
            a.style.transition = 'opacity 0.5s';
            a.style.opacity = '0';
            setTimeout(() => a.remove(), 500);
        });
    }, 4000);
});


function openModal(id) { document.getElementById(id).classList.add('active'); }
function closeModal(id) { document.getElementById(id).classList.remove('active'); }


async function fetchAvailableRooms() {
    const checkIn = document.getElementById('checkIn').value;
    const checkOut = document.getElementById('checkOut').value;
    const roomTypeId = document.getElementById('roomTypeId').value;
    const roomSelect = document.getElementById('roomId');
    const rateField = document.getElementById('ratePerNight');

    if (!checkIn || !checkOut || !roomTypeId) return;

    if (new Date(checkOut) <= new Date(checkIn)) {
        alert('Check-out date must be after check-in date.');
        return;
    }

    roomSelect.innerHTML = '<option value="">Loading...</option>';
    roomSelect.disabled = true;

    try {
        const ctx = document.getElementById('contextPath').value;
        const resp = await fetch(`${ctx}/reservations/available-rooms?checkIn=${checkIn}&checkOut=${checkOut}&roomTypeId=${roomTypeId}`);
        const rooms = await resp.json();
        roomSelect.innerHTML = rooms.length === 0
            ? '<option value="">No rooms available for selected dates</option>'
            : '<option value="">-- Select Room --</option>' + rooms.map(r => `<option value="${r.id}">Room ${r.roomNumber} (Floor ${r.floor})</option>`).join('');
        roomSelect.disabled = false;


        const nights = Math.ceil((new Date(checkOut) - new Date(checkIn)) / (1000*60*60*24));
        const rate = parseFloat(rateField ? rateField.value : 0);
        updateTotalCost(nights, rate);
    } catch(e) { roomSelect.innerHTML = '<option value="">Error loading rooms</option>'; }
}


function updateRoomTypeRate() {
    const sel = document.getElementById('roomTypeId');
    const opt = sel.options[sel.selectedIndex];
    const rate = opt ? opt.dataset.rate : 0;
    const rateField = document.getElementById('ratePerNight');
    if (rateField) rateField.value = rate || 0;
    fetchAvailableRooms();
    updateCostSummary();
}

function updateCostSummary() {
    const checkIn = document.getElementById('checkIn') ? document.getElementById('checkIn').value : '';
    const checkOut = document.getElementById('checkOut') ? document.getElementById('checkOut').value : '';
    const rate = parseFloat(document.getElementById('ratePerNight') ? document.getElementById('ratePerNight').value : 0);
    if (!checkIn || !checkOut || !rate) return;
    const nights = Math.max(1, Math.ceil((new Date(checkOut) - new Date(checkIn)) / (1000*60*60*24)));
    updateTotalCost(nights, rate);
}

function updateTotalCost(nights, rate) {
    const el = document.getElementById('costSummary');
    if (!el) return;
    const sub = nights * rate;
    const tax = sub * 0.10;
    const total = sub + tax;
    el.innerHTML = `
        <div style="background:#f8f9fb;border-radius:8px;padding:16px;margin-top:16px">
          <h4 style="color:#1d3557;margin-bottom:12px">💰 Cost Summary</h4>
          <div style="display:flex;justify-content:space-between;margin-bottom:6px"><span>Room rate/night</span><span>LKR ${rate.toLocaleString('en',{minimumFractionDigits:2})}</span></div>
          <div style="display:flex;justify-content:space-between;margin-bottom:6px"><span>Nights</span><span>${nights}</span></div>
          <div style="display:flex;justify-content:space-between;margin-bottom:6px"><span>Subtotal</span><span>LKR ${sub.toLocaleString('en',{minimumFractionDigits:2})}</span></div>
          <div style="display:flex;justify-content:space-between;margin-bottom:6px"><span>Tax (10%)</span><span>LKR ${tax.toLocaleString('en',{minimumFractionDigits:2})}</span></div>
          <hr style="border:1px solid #ddd;margin:8px 0">
          <div style="display:flex;justify-content:space-between;font-weight:800;font-size:1.1rem;color:#0077b6"><span>Total</span><span>LKR ${total.toLocaleString('en',{minimumFractionDigits:2})}</span></div>
        </div>`;
}


function printBill() {
    window.print();
}


function confirmAction(msg, formId) {
    if (confirm(msg)) document.getElementById(formId).submit();
}
