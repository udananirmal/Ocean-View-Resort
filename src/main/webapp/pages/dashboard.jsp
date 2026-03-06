<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.*,java.util.*" %>
<%
String pageTitle = "Dashboard";
Object[] stats = (Object[]) request.getAttribute("stats");
List<com.oceanview.model.Reservation> recent = (List<com.oceanview.model.Reservation>) request.getAttribute("recentReservations");
%>
<%@ include file="layout.jsp" %>
<div class="stats-grid">
  <div class="stat-card blue">
    <div class="stat-icon">📅</div>
    <div class="stat-info">
      <p>Confirmed</p>
      <h2><%=stats[0]%></h2>
    </div>
  </div>
  <div class="stat-card green">
    <div class="stat-icon">🏨</div>
    <div class="stat-info">
      <p>Checked In</p>
      <h2><%=stats[1]%></h2>
    </div>
  </div>
  <div class="stat-card orange">
    <div class="stat-icon">🚪</div>
    <div class="stat-info">
      <p>Today Checkouts</p>
      <h2><%=stats[2]%></h2>
    </div>
  </div>
  <div class="stat-card teal">
    <div class="stat-icon">🛏️</div>
    <div class="stat-info">
      <p>Available Rooms</p>
      <h2><%=stats[3]%></h2>
    </div>
  </div>
  <div class="stat-card purple">
    <div class="stat-icon">💰</div>
    <div class="stat-info">
      <p>Today Revenue</p>
      <h2>LKR <%=String.format("%,.0f", (double)stats[4])%></h2>
    </div>
  </div>
  <div class="stat-card red">
    <div class="stat-icon">📥</div>
    <div class="stat-info">
      <p>Today Check-ins</p>
      <h2><%=stats[5]%></h2>
    </div>
  </div>
</div>

<div class="card">
  <div class="card-header">
    <h3><i class="fas fa-clock" style="color:#0077b6"></i> Recent Reservations</h3>
    <a href="<%=ctx%>/reservations/add" class="btn btn-primary btn-sm">
      <i class="fas fa-plus"></i> New Reservation
    </a>
  </div>
  <div class="card-body" style="padding:0">
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>Res. Number</th><th>Guest Name</th><th>Room</th>
            <th>Check In</th><th>Check Out</th><th>Status</th><th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <% if (recent != null) for (com.oceanview.model.Reservation r : recent) { %>
          <tr>
            <td><strong><%=r.getReservationNumber()%></strong></td>
            <td><%=r.getGuestName()%></td>
            <td>Room <%=r.getRoomNumber()%> (<%=r.getRoomTypeName()%>)</td>
            <td><%=r.getCheckInDate()%></td>
            <td><%=r.getCheckOutDate()%></td>
            <td><span class="badge badge-<%=r.getStatus().toLowerCase()%>"><%=r.getStatus()%></span></td>
            <td>
              <a href="<%=ctx%>/reservations/view?id=<%=r.getId()%>" class="btn btn-info btn-sm">
                <i class="fas fa-eye"></i>
              </a>
            </td>
          </tr>
          <% } %>
          <% if (recent == null || recent.isEmpty()) { %>
          <tr><td colspan="7" style="text-align:center;color:#888;padding:30px">No reservations yet. <a href="<%=ctx%>/reservations/add">Create one now</a></td></tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
</div>
<script src="<%=ctx%>/js/main.js"></script>
</body></html>
