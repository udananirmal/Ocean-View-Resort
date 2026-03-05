<%@ page contentType="text/html;charset=UTF-8" %>
<%
String pageTitle = "Help & Guide";
%>
<%@ include file="layout.jsp" %>

<div class="page-header">
  <div><h2>❓ Help & User Guide</h2></div>
</div>

<div style="display:grid;grid-template-columns:1fr 1fr;gap:24px">
  <div>
    <div class="card" style="margin-bottom:20px">
      <div class="card-header"><h3><i class="fas fa-sign-in-alt" style="color:#0077b6"></i> How to Login</h3></div>
      <div class="card-body">
        <div class="help-step"><div class="help-step-num">1</div><div class="help-step-text"><h4>Enter Credentials</h4><p>Enter your assigned username and password on the login page.</p></div></div>
        <div class="help-step"><div class="help-step-num">2</div><div class="help-step-text"><h4>Access Dashboard</h4><p>You'll be redirected to the dashboard showing today's statistics.</p></div></div>
        <div class="help-step"><div class="help-step-num">3</div><div class="help-step-text"><h4>Navigate</h4><p>Use the left sidebar to navigate between different sections.</p></div></div>
      </div>
    </div>

    <div class="card" style="margin-bottom:20px">
      <div class="card-header"><h3><i class="fas fa-plus-circle" style="color:#0077b6"></i> Adding a Reservation</h3></div>
      <div class="card-body">
        <div class="help-step"><div class="help-step-num">1</div><div class="help-step-text"><h4>Guest Details</h4><p>Fill in guest name, address, contact number, and email.</p></div></div>
        <div class="help-step"><div class="help-step-num">2</div><div class="help-step-text"><h4>Select Room Type</h4><p>Choose the room type. The rate will auto-populate.</p></div></div>
        <div class="help-step"><div class="help-step-num">3</div><div class="help-step-text"><h4>Select Dates</h4><p>Choose check-in and check-out dates. Available rooms will load automatically.</p></div></div>
        <div class="help-step"><div class="help-step-num">4</div><div class="help-step-text"><h4>Select Room & Submit</h4><p>Pick an available room, review the cost summary, then click Create Reservation.</p></div></div>
      </div>
    </div>

    <div class="card">
      <div class="card-header"><h3><i class="fas fa-receipt" style="color:#0077b6"></i> Generating a Bill</h3></div>
      <div class="card-body">
        <div class="help-step"><div class="help-step-num">1</div><div class="help-step-text"><h4>Find Reservation</h4><p>Go to All Reservations and find the guest's booking.</p></div></div>
        <div class="help-step"><div class="help-step-num">2</div><div class="help-step-text"><h4>Click Bill Icon</h4><p>Click the receipt (🧾) icon or go to View then click View Bill.</p></div></div>
        <div class="help-step"><div class="help-step-num">3</div><div class="help-step-text"><h4>Process Payment</h4><p>Select payment method and click Mark as Paid when payment is received.</p></div></div>
        <div class="help-step"><div class="help-step-num">4</div><div class="help-step-text"><h4>Print</h4><p>Click the Print button to print a physical copy for the guest.</p></div></div>
      </div>
    </div>
  </div>

  <div>
    <div class="card" style="margin-bottom:20px">
      <div class="card-header"><h3><i class="fas fa-bed" style="color:#0077b6"></i> Room Types & Rates</h3></div>
      <div class="card-body">
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
          <div class="room-rate-card">
            <h4>Standard</h4>
            <p style="color:#666;font-size:0.78rem;margin:4px 0">Garden view, AC, TV, WiFi</p>
            <p class="price">LKR 8,500</p>
            <p style="font-size:0.72rem;color:#aaa">per night</p>
          </div>
          <div class="room-rate-card">
            <h4>Deluxe</h4>
            <p style="color:#666;font-size:0.78rem;margin:4px 0">Partial sea view, minibar</p>
            <p class="price">LKR 12,500</p>
            <p style="font-size:0.72rem;color:#aaa">per night</p>
          </div>
          <div class="room-rate-card">
            <h4>Suite</h4>
            <p style="color:#666;font-size:0.78rem;margin:4px 0">Full sea view, jacuzzi</p>
            <p class="price">LKR 22,000</p>
            <p style="font-size:0.72rem;color:#aaa">per night</p>
          </div>
          <div class="room-rate-card">
            <h4>Family Room</h4>
            <p style="color:#666;font-size:0.78rem;margin:4px 0">2 queen beds, spacious</p>
            <p class="price">LKR 16,000</p>
            <p style="font-size:0.72rem;color:#aaa">per night</p>
          </div>
          <div class="room-rate-card" style="grid-column:1/-1">
            <h4>🏖️ Beachfront Villa</h4>
            <p style="color:#666;font-size:0.78rem;margin:4px 0">Private beach access, all amenities</p>
            <p class="price">LKR 35,000</p>
            <p style="font-size:0.72rem;color:#aaa">per night</p>
          </div>
        </div>
        <p style="font-size:0.78rem;color:#888;margin-top:12px">* All rates are subject to 10% tax & service charge</p>
      </div>
    </div>

    <div class="card" style="margin-bottom:20px">
      <div class="card-header"><h3><i class="fas fa-info-circle" style="color:#0077b6"></i> Reservation Statuses</h3></div>
      <div class="card-body">
        <p style="margin-bottom:10px"><span class="badge badge-confirmed">CONFIRMED</span> — Reservation created, guest hasn't arrived yet</p>
        <p style="margin-bottom:10px"><span class="badge badge-checked_in">CHECKED IN</span> — Guest has arrived and is in the room</p>
        <p style="margin-bottom:10px"><span class="badge badge-checked_out">CHECKED OUT</span> — Guest has left, stay is complete</p>
        <p><span class="badge badge-cancelled">CANCELLED</span> — Reservation was cancelled</p>
      </div>
    </div>

    <div class="card">
      <div class="card-header"><h3><i class="fas fa-shield-alt" style="color:#0077b6"></i> Admin Features</h3></div>
      <div class="card-body">
        <div class="help-step"><div class="help-step-num">🏨</div><div class="help-step-text"><h4>Manage Rooms</h4><p>Add/edit room types and their rates (Admin only)</p></div></div>
        <div class="help-step"><div class="help-step-num">👥</div><div class="help-step-text"><h4>Manage Users</h4><p>Create staff accounts and manage access (Admin only)</p></div></div>
        <div class="help-step"><div class="help-step-num">📊</div><div class="help-step-text"><h4>Reports</h4><p>Generate daily reservation and revenue reports (Admin only)</p></div></div>
      </div>
    </div>
  </div>
</div>
    </div><!-- page-content -->
  </div><!-- main-content -->
</div><!-- app-wrapper -->
<script src="<%=ctx%>/js/main.js"></script>
</body></html>
