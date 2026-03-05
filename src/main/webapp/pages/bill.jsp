<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.*" %>
<%
String pageTitle = "Guest Bill";
Object[] bill = (Object[]) request.getAttribute("bill");
int resId = (int) request.getAttribute("resId");
%>
<%@ include file="layout.jsp" %>

<div class="page-header no-print">
  <div>
    <h2>🧾 Guest Bill</h2>
  </div>
  <div style="display:flex;gap:10px">
    <button class="btn btn-primary" onclick="printBill()"><i class="fas fa-print"></i> Print Bill</button>
    <a href="<%=ctx%>/reservations/list" class="btn btn-secondary btn-sm">Back</a>
  </div>
</div>

<% if (bill == null) { %>
<div class="alert alert-danger">Bill not found for this reservation.</div>
<% } else {
  String resNum = (String) bill[0];
  String guestName = (String) bill[1];
  String contact = (String) bill[2];
  String roomType = (String) bill[3];
  String roomNum = (String) bill[4];
  String checkIn = (String) bill[5];
  String checkOut = (String) bill[6];
  int nights = (int) bill[7];
  double rate = (double) bill[8];
  double sub = (double) bill[9];
  double tax = (double) bill[10];
  double total = (double) bill[11];
  String payStatus = (String) bill[12];
  int numGuests = (int) bill[13];
%>

<div class="bill-container">
  <div class="card">
    <!-- Bill Header -->
    <div class="bill-header">
      <div style="font-size:2.5rem;margin-bottom:8px">🌊</div>
      <h1>Ocean View Resort</h1>
      <p style="opacity:0.85">Galle, Sri Lanka &nbsp;|&nbsp; Tel: +94 91 234 5678 &nbsp;|&nbsp; info@oceanview.lk</p>
      <div style="margin-top:14px;background:rgba(255,255,255,0.15);display:inline-block;padding:6px 20px;border-radius:20px">
        <strong>INVOICE / BILL</strong>
      </div>
    </div>

    <div class="card-body">
      <!-- Guest & Reservation Info -->
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:24px;padding:16px;background:#f8f9fb;border-radius:8px">
        <div>
          <p style="font-size:0.75rem;color:#888;font-weight:700;text-transform:uppercase;margin-bottom:6px">Bill To</p>
          <p style="font-weight:700;font-size:1.05rem"><%=guestName%></p>
          <p style="color:#666;font-size:0.88rem">📞 <%=contact%></p>
          <p style="color:#666;font-size:0.88rem">👥 <%=numGuests%> Guest(s)</p>
        </div>
        <div>
          <p style="font-size:0.75rem;color:#888;font-weight:700;text-transform:uppercase;margin-bottom:6px">Booking Details</p>
          <p style="font-weight:700;color:#0077b6"><%=resNum%></p>
          <p style="color:#666;font-size:0.88rem">🏨 Room <%=roomNum%> — <%=roomType%></p>
          <p style="color:#666;font-size:0.88rem">📅 <%=checkIn%> → <%=checkOut%></p>
          <p style="color:#666;font-size:0.88rem">🌙 <%=nights%> Night(s)</p>
        </div>
      </div>

      <!-- Billing Table -->
      <table class="bill-table" style="border:1px solid #eee;border-radius:8px;overflow:hidden">
        <thead>
          <tr style="background:#1d3557;color:#fff">
            <th style="padding:12px 16px;text-align:left">Description</th>
            <th style="padding:12px 16px;text-align:right">Amount (LKR)</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><%=roomType%> - Room <%=roomNum%></td>
            <td style="text-align:right"><%=String.format("%,.2f", rate)%></td>
          </tr>
          <tr>
            <td>× <%=nights%> Night(s) @ LKR <%=String.format("%,.2f", rate)%></td>
            <td style="text-align:right"></td>
          </tr>
          <tr class="total-row">
            <td><strong>Subtotal</strong></td>
            <td style="text-align:right"><strong><%=String.format("%,.2f", sub)%></strong></td>
          </tr>
          <tr class="total-row">
            <td>Tax & Service Charges (10%)</td>
            <td style="text-align:right"><%=String.format("%,.2f", tax)%></td>
          </tr>
        </tbody>
        <tfoot>
          <tr class="grand-total">
            <td style="padding:16px;font-size:1.2rem"><strong>TOTAL AMOUNT</strong></td>
            <td style="padding:16px;text-align:right;font-size:1.2rem"><strong>LKR <%=String.format("%,.2f", total)%></strong></td>
          </tr>
        </tfoot>
      </table>

      <div style="display:flex;justify-content:space-between;align-items:center;margin-top:20px;padding:16px;background:#f8f9fb;border-radius:8px">
        <div>
          <p style="font-weight:700;color:#1d3557">Payment Status:
            <span class="badge badge-<%=payStatus.toLowerCase()%>"><%=payStatus%></span>
          </p>
        </div>
        <% if (!"PAID".equals(payStatus)) { %>
        <form method="post" action="<%=ctx%>/reservations/pay" class="no-print" style="display:flex;gap:8px;align-items:center">
          <input type="hidden" name="id" value="<%=resId%>">
          <select name="paymentMethod" class="form-control" style="width:150px">
            <option value="CASH">Cash</option>
            <option value="CARD">Card</option>
            <option value="BANK_TRANSFER">Bank Transfer</option>
          </select>
          <button type="submit" class="btn btn-success">
            <i class="fas fa-check"></i> Mark as Paid
          </button>
        </form>
        <% } %>
      </div>

      <p style="text-align:center;color:#aaa;font-size:0.78rem;margin-top:24px">
        Thank you for choosing Ocean View Resort! We hope you enjoyed your stay.<br>
        Printed: <%=new java.util.Date()%>
      </p>
    </div>
  </div>
</div>
<% } %>
    </div><!-- page-content -->
  </div><!-- main-content -->
</div><!-- app-wrapper -->
<script src="<%=ctx%>/js/main.js"></script>
</body></html>
