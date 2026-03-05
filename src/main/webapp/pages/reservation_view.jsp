<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.*" %>
<%
String pageTitle = "View Reservation";
Reservation res = (Reservation) request.getAttribute("reservation");
String today    = (String) request.getAttribute("today");
%>
<%@ include file="layout.jsp" %>

<div class="page-header">
  <div>
    <h2>🔍 Reservation Details</h2>
    <p class="breadcrumb">Complete booking information</p>
  </div>
  <a href="<%=ctx%>/reservations/list" class="btn btn-secondary btn-sm">
    <i class="fas fa-arrow-left"></i> Back to List
  </a>
</div>

<% if (res == null) { %>
<div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> Reservation not found.</div>
<div style="margin:20px 0">
  <form method="get" action="<%=ctx%>/reservations/view" style="display:flex;gap:12px;max-width:400px">
    <input type="text" class="form-control" name="resNum" placeholder="Enter reservation number">
    <button class="btn btn-primary">Search</button>
  </form>
</div>
<% } else {
     String ps = res.getPaymentStatus() != null ? res.getPaymentStatus() : "PENDING";
     boolean isEarlyCheckIn = "CONFIRMED".equals(res.getStatus())
                              && today != null
                              && today.compareTo(res.getCheckInDate().toString()) < 0;
%>

<div style="display:grid;grid-template-columns:2fr 1fr;gap:24px">
  <div>

    <div class="card" style="margin-bottom:20px">
      <div style="background:linear-gradient(135deg,#0077b6,#00b4d8);padding:24px;
                  border-radius:12px 12px 0 0;display:flex;justify-content:space-between;align-items:center">
        <div>
          <h3 style="color:#fff;font-size:1.3rem;margin-bottom:4px"><%=res.getReservationNumber()%></h3>
          <p style="color:rgba(255,255,255,0.8);font-size:0.85rem">Created: <%=res.getCreatedAt()%></p>
        </div>
        <div style="display:flex;flex-direction:column;align-items:flex-end;gap:6px">
          <span class="badge badge-<%=res.getStatus().toLowerCase()%>"
                style="font-size:0.9rem;padding:8px 16px">
            <%=res.getStatus().replace("_"," ")%>
          </span>
          <% if (!"CANCELLED".equals(res.getStatus())) { %>
          <span class="badge <%="PAID".equals(ps) ? "badge-paid" : "badge-pending"%>"
                style="font-size:0.82rem;padding:5px 12px">
            <%="PAID".equals(ps) ? "&#10003; PAID" : "&#36; PENDING"%>
          </span>
          <% } %>
        </div>
      </div>

      <div class="card-body">
        <div class="detail-grid">
          <div class="detail-item">
            <span class="detail-label">Guest Name</span>
            <span class="detail-value"><%=res.getGuestName()%></span>
          </div>
          <div class="detail-item">
            <span class="detail-label">Contact Number</span>
            <span class="detail-value"><%=res.getGuestContact()%></span>
          </div>
          <div class="detail-item">
            <span class="detail-label">Email</span>
            <span class="detail-value"><%=res.getGuestEmail() != null && !res.getGuestEmail().isEmpty()
                ? res.getGuestEmail() : "N/A"%></span>
          </div>
          <div class="detail-item">
            <span class="detail-label">Number of Guests</span>
            <span class="detail-value"><%=res.getNumGuests()%></span>
          </div>
          <div class="detail-item" style="grid-column:1/-1">
            <span class="detail-label">Address</span>
            <span class="detail-value"><%=res.getGuestAddress()%></span>
          </div>
        </div>
      </div>
    </div>

    <div class="card">
      <div class="card-header">
        <h3><i class="fas fa-bed" style="color:#0077b6"></i> Room &amp; Booking Details</h3>
      </div>
      <div class="card-body">
        <div class="detail-grid">
          <div class="detail-item">
            <span class="detail-label">Room Number</span>
            <span class="detail-value">Room <%=res.getRoomNumber()%></span>
          </div>
          <div class="detail-item">
            <span class="detail-label">Room Type</span>
            <span class="detail-value"><%=res.getRoomTypeName()%></span>
          </div>
          <div class="detail-item">
            <span class="detail-label">Check-In Date</span>
            <span class="detail-value"><%=res.getCheckInDate()%></span>
          </div>
          <div class="detail-item">
            <span class="detail-label">Check-Out Date</span>
            <span class="detail-value"><%=res.getCheckOutDate()%></span>
          </div>
          <div class="detail-item">
            <span class="detail-label">Number of Nights</span>
            <span class="detail-value"><%=res.getNumNights()%> night(s)</span>
          </div>
          <div class="detail-item">
            <span class="detail-label">Rate Per Night</span>
            <span class="detail-value">LKR <%=String.format("%,.2f", res.getRatePerNight())%></span>
          </div>
          <div class="detail-item">
            <span class="detail-label">Total Amount (incl. 10% tax)</span>
            <span class="detail-value" style="color:#0077b6;font-size:1.1rem">
              LKR <%=String.format("%,.2f", res.getTotalAmount())%>
            </span>
          </div>
          <div class="detail-item">
            <span class="detail-label">Payment Status</span>
            <span class="detail-value">
              <% if ("CANCELLED".equals(res.getStatus())) { %>
                <span style="color:#aaa">N/A</span>
              <% } else if ("PAID".equals(ps)) { %>
                <span style="color:#2dc653;font-weight:700">&#10003; Paid</span>
              <% } else { %>
                <span style="color:#d97706;font-weight:700">&#36; Payment Pending</span>
              <% } %>
            </span>
          </div>
          <% if (res.getSpecialRequests() != null && !res.getSpecialRequests().isEmpty()) { %>
          <div class="detail-item" style="grid-column:1/-1">
            <span class="detail-label">Special Requests</span>
            <span class="detail-value"><%=res.getSpecialRequests()%></span>
          </div>
          <% } %>
        </div>
      </div>
    </div>
  </div>

  <div>
    <div class="card" style="margin-bottom:20px">
      <div class="card-header">
        <h3><i class="fas fa-cogs" style="color:#0077b6"></i> Actions</h3>
      </div>
      <div class="card-body">
        <a href="<%=ctx%>/reservations/bill?id=<%=res.getId()%>"
           class="btn btn-warning btn-block" style="margin-bottom:10px">
          <i class="fas fa-receipt"></i> View / Print Bill
        </a>

        <% if ("CONFIRMED".equals(res.getStatus())) { %>

          <% if (isEarlyCheckIn) { %>
          <form method="post" action="<%=ctx%>/reservations/checkin-early"
                onsubmit="return confirm('Guest is arriving early (booked: <%=res.getCheckInDate()%>, today: <%=today%>).\n\nCheck-in date will be updated to today and the bill will be recalculated.\n\nProceed?')">
            <input type="hidden" name="id" value="<%=res.getId()%>">
            <button type="submit" class="btn btn-success btn-block" style="margin-bottom:10px">
              <i class="fas fa-sign-in-alt"></i> Early Check In &amp; Recalculate Bill
            </button>
          </form>
          <% } else { %>
          <form method="post" action="<%=ctx%>/reservations/update-status">
            <input type="hidden" name="id" value="<%=res.getId()%>">
            <input type="hidden" name="status" value="CHECKED_IN">
            <button type="submit" class="btn btn-success btn-block" style="margin-bottom:10px">
              <i class="fas fa-sign-in-alt"></i> Check In
            </button>
          </form>
          <% } %>

          <form method="post" action="<%=ctx%>/reservations/update-status" style="margin-bottom:10px">
            <input type="hidden" name="id" value="<%=res.getId()%>">
            <input type="hidden" name="status" value="CANCELLED">
            <button type="submit" class="btn btn-danger btn-block"
                    onclick="return confirm('Are you sure you want to cancel this reservation?')">
              <i class="fas fa-times"></i> Cancel Reservation
            </button>
          </form>

        <% } else if ("CHECKED_IN".equals(res.getStatus())) { %>
        <form method="post" action="<%=ctx%>/reservations/update-status" style="margin-bottom:10px">
          <input type="hidden" name="id" value="<%=res.getId()%>">
          <input type="hidden" name="status" value="CHECKED_OUT">
          <button type="submit" class="btn btn-primary btn-block">
            <i class="fas fa-sign-out-alt"></i> Check Out
          </button>
        </form>
        <% } %>

        <hr style="border:none;border-top:1px solid #f0f0f0;margin:12px 0">
        <% if (currentUser.isAdmin()) { %>
        <form method="post" action="<%=ctx%>/reservations/delete"
              onsubmit="return confirm('Permanently delete reservation <%=res.getReservationNumber()%>?\n\nThis cannot be undone.')">
          <input type="hidden" name="id" value="<%=res.getId()%>">
          <button type="submit" class="btn btn-danger btn-block" style="background:#e63946;border-color:#e63946">
            <i class="fas fa-trash"></i> Delete Reservation
          </button>
        </form>
        <% } %>
      </div>
    </div>

    <div class="card">
      <div class="card-header">
        <h3><i class="fas fa-info-circle" style="color:#0077b6"></i> Status Guide</h3>
      </div>
      <div class="card-body">
        <p style="font-size:0.82rem;color:#666;margin-bottom:8px">
          <span class="badge badge-confirmed">CONFIRMED</span> Reservation made
        </p>
        <p style="font-size:0.82rem;color:#666;margin-bottom:8px">
          <span class="badge badge-checked_in">CHECKED IN</span> Guest arrived
        </p>
        <p style="font-size:0.82rem;color:#666;margin-bottom:8px">
          <span class="badge badge-checked_out">CHECKED OUT</span> Stay completed
        </p>
        <p style="font-size:0.82rem;color:#666;margin-bottom:12px">
          <span class="badge badge-cancelled">CANCELLED</span> Booking cancelled
        </p>
        <hr style="border:none;border-top:1px solid #f0f0f0;margin-bottom:12px">
        <p style="font-size:0.82rem;color:#666;margin-bottom:8px">
          <span class="badge badge-paid">&#10003; PAID</span> Payment received
        </p>
        <p style="font-size:0.82rem;color:#666">
          <span class="badge badge-pending">PENDING</span> Awaiting payment
        </p>
      </div>
    </div>
  </div>
</div>
<% } %>

    </div><!-- page-content -->
  </div><!-- main-content -->
</div><!-- app-wrapper -->
<script src="<%=ctx%>/js/main.js"></script>
</body></html>
