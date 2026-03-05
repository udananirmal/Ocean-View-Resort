<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.*,java.util.*" %>
<%
String pageTitle = "All Reservations";
List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
String search = (String) request.getAttribute("search");
%>
<%@ include file="layout.jsp" %>

<div class="page-header">
  <div>
    <h2>📋 All Reservations</h2>
    <p class="breadcrumb"><%=reservations != null ? reservations.size() : 0%> reservation(s) found</p>
  </div>
  <a href="<%=ctx%>/reservations/add" class="btn btn-primary">
    <i class="fas fa-plus"></i> New Reservation
  </a>
</div>

<div class="card" style="margin-bottom:20px">
  <div class="card-body" style="padding:16px">
    <form method="get" action="<%=ctx%>/reservations/list" class="search-form">
      <input type="text" class="form-control search-input" name="search"
             placeholder="Search by reservation number, guest name, or contact..."
             value="<%=search != null ? search : ""%>">
      <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i> Search</button>
      <% if (search != null) { %>
      <a href="<%=ctx%>/reservations/list" class="btn btn-secondary">Clear</a>
      <% } %>
    </form>
  </div>
</div>

<div class="card">
  <div class="card-body" style="padding:0">
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>Res. Number</th>
            <th>Guest Name</th>
            <th>Contact</th>
            <th>Room</th>
            <th>Check In</th>
            <th>Check Out</th>
            <th>Nights</th>
            <th>Booking Status</th>
            <th>Payment</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <% if (reservations != null) for (Reservation r : reservations) {
               String ps = r.getPaymentStatus() != null ? r.getPaymentStatus() : "PENDING";
          %>
          <tr>
            <td><strong style="color:#0077b6"><%=r.getReservationNumber()%></strong></td>
            <td><%=r.getGuestName()%></td>
            <td><%=r.getGuestContact()%></td>
            <td><%=r.getRoomNumber()%>
              <span style="color:#888;font-size:0.78rem">(<%=r.getRoomTypeName()%>)</span>
            </td>
            <td><%=r.getCheckInDate()%></td>
            <td><%=r.getCheckOutDate()%></td>
            <td style="text-align:center"><strong><%=r.getNumNights()%></strong></td>
            <td>
              <span class="badge badge-<%=r.getStatus().toLowerCase()%>">
                <%=r.getStatus().replace("_"," ")%>
              </span>
            </td>
            <td>
              <%-- FIX 1: Show payment badge only when relevant --%>
              <% if ("CANCELLED".equals(r.getStatus())) { %>
                <span style="color:#aaa;font-size:0.8rem">—</span>
              <% } else if ("PAID".equals(ps)) { %>
                <span class="badge badge-paid">&#10003; PAID</span>
              <% } else { %>
                <span class="badge badge-pending">PENDING</span>
              <% } %>
            </td>
            <td>
              <div style="display:flex;gap:6px">
                <a href="<%=ctx%>/reservations/view?id=<%=r.getId()%>"
                   class="btn btn-info btn-sm" title="View Details">
                  <i class="fas fa-eye"></i>
                </a>
                <a href="<%=ctx%>/reservations/bill?id=<%=r.getId()%>"
                   class="btn btn-warning btn-sm" title="View Bill">
                  <i class="fas fa-receipt"></i>
                </a>
                <% if (currentUser.isAdmin()) { %>
                <form method="post" action="<%=ctx%>/reservations/delete" style="display:inline"
                      onsubmit="return confirm('Permanently delete reservation <%=r.getReservationNumber()%>?\n\nThis cannot be undone.')">
                  <input type="hidden" name="id" value="<%=r.getId()%>">
                  <button type="submit" class="btn btn-danger btn-sm" title="Delete">
                    <i class="fas fa-trash"></i>
                  </button>
                </form>
                <% } %>
              </div>
            </td>
          </tr>
          <% } %>
          <% if (reservations == null || reservations.isEmpty()) { %>
          <tr>
            <td colspan="10" style="text-align:center;color:#888;padding:40px">
              <i class="fas fa-inbox" style="font-size:2rem;display:block;margin-bottom:10px"></i>
              No reservations found. <a href="<%=ctx%>/reservations/add">Create a new one</a>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
</div>

    </div><!-- page-content -->
  </div>
</div>
<script src="<%=ctx%>/js/main.js"></script>
</body></html>
