<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.*,java.util.*" %>
<%
String pageTitle = "New Reservation";
List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");
%>
<%@ include file="layout.jsp" %>

<div class="page-header">
  <div>
    <h2>📋 New Reservation</h2>
    <p class="breadcrumb">Fill in the details below to create a new reservation</p>
  </div>
  <a href="<%=ctx%>/reservations/list" class="btn btn-secondary btn-sm">
    <i class="fas fa-arrow-left"></i> Back to List
  </a>
</div>

<% if (request.getAttribute("error") != null) { %>
<div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div>
<% } %>

<form method="post" action="<%=ctx%>/reservations/add" id="reservationForm">
<div style="display:grid;grid-template-columns:1fr 1fr;gap:24px">

  <div class="card">
    <div class="card-header">
      <h3><i class="fas fa-user" style="color:#0077b6"></i> Guest Information</h3>
    </div>
    <div class="card-body">
      <div class="form-group">
        <label>Full Name *</label>
        <input type="text" class="form-control" name="guestName" required placeholder="Guest full name">
      </div>
      <div class="form-group">
        <label>Address *</label>
        <textarea class="form-control" name="address" rows="3" required placeholder="Guest address"></textarea>
      </div>
      <div class="form-row">
        <div class="form-group">
          <label>Contact Number *</label>
          <input type="tel" class="form-control" name="contactNumber" required placeholder="0771234567">
        </div>
        <div class="form-group">
          <label>Email</label>
          <input type="email" class="form-control" name="email" placeholder="guest@email.com">
        </div>
      </div>
      <div class="form-row">
        <div class="form-group">
          <label>Number of Guests *</label>
          <input type="number" class="form-control" name="numGuests" value="1" min="1" max="10" required>
        </div>
      </div>
      <div class="form-group">
        <label>Special Requests</label>
        <textarea class="form-control" name="specialRequests" rows="2" placeholder="Any special requirements..."></textarea>
      </div>
    </div>
  </div>

  <div class="card">
    <div class="card-header">
      <h3><i class="fas fa-bed" style="color:#0077b6"></i> Room & Booking Details</h3>
    </div>
    <div class="card-body">
      <div class="form-group">
        <label>Room Type *</label>
        <select class="form-control" name="roomTypeId" id="roomTypeId" required onchange="updateRoomTypeRate()">
          <option value="">-- Select Room Type --</option>
          <% if (roomTypes != null) for (RoomType rt : roomTypes) { %>
          <option value="<%=rt.getId()%>" data-rate="<%=rt.getRatePerNight()%>">
            <%=rt.getTypeName()%> - LKR <%=String.format("%,.0f", rt.getRatePerNight())%>/night
          </option>
          <% } %>
        </select>
      </div>
      <div class="form-row">
        <div class="form-group">
          <label>Check-In Date *</label>
          <input type="date" class="form-control" name="checkIn" id="checkIn" required onchange="fetchAvailableRooms()">
        </div>
        <div class="form-group">
          <label>Check-Out Date *</label>
          <input type="date" class="form-control" name="checkOut" id="checkOut" required onchange="fetchAvailableRooms()">
        </div>
      </div>
      <div class="form-group">
        <label>Available Room *</label>
        <select class="form-control" name="roomId" id="roomId" required>
          <option value="">-- Select dates & room type first --</option>
        </select>
      </div>
      <input type="hidden" name="ratePerNight" id="ratePerNight" value="0">
      <div id="costSummary"></div>
    </div>
  </div>

</div>
<div style="display:flex;gap:12px;margin-top:20px;justify-content:flex-end">
  <a href="<%=ctx%>/reservations/list" class="btn btn-secondary">Cancel</a>
  <button type="submit" class="btn btn-primary btn-lg">
    <i class="fas fa-save"></i> Create Reservation
  </button>
</div>
</form>
    </div><!-- page-content -->
  </div><!-- main-content -->
</div>
<script src="<%=ctx%>/js/main.js"></script>
<script>

document.getElementById('checkIn').min = new Date().toISOString().split('T')[0];
document.getElementById('checkOut').min = new Date().toISOString().split('T')[0];
document.getElementById('checkIn').addEventListener('change', function() {
  document.getElementById('checkOut').min = this.value;
});
</script>
</body></html>
