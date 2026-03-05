<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
String pageTitle  = "Reports";
String reportType = (String) request.getAttribute("reportType");
if (reportType == null) reportType = "daily";
boolean isMonthly = "monthly".equals(reportType);

String reportDate  = (String) request.getAttribute("reportDate");
String reportMonth = (String) request.getAttribute("reportMonth");
List<Object[]> reportData = (List<Object[]>) request.getAttribute("reportData");

double totalRev  = 0;
int    paidCount = 0;
if (reportData != null) for (Object[] row : reportData) {
    if (row[7] != null) totalRev += (double)row[7];
    if ("PAID".equals(row[8])) paidCount++;
}
String periodLabel = isMonthly ? reportMonth : reportDate;
%>
<%@ include file="layout.jsp" %>

<div class="page-header">
  <div><h2>📊 Reports</h2></div>
  <button class="btn btn-primary no-print" onclick="window.print()">
    <i class="fas fa-print"></i> Print Report
  </button>
</div>

<div class="card" style="margin-bottom:20px">
  <div class="card-body" style="padding:16px">
    <!-- Tabs -->
    <div style="display:flex;gap:0;margin-bottom:16px;border-bottom:2px solid #e8ecf0">
      <a href="<%=ctx%>/admin/reports?type=daily&date=<%=reportDate != null ? reportDate : ""%>"
         style="padding:8px 20px;font-weight:600;text-decoration:none;border-bottom:<%=!isMonthly ? "3px solid #0077b6;color:#0077b6" : "3px solid transparent;color:#666"%>;margin-bottom:-2px">
        Daily
      </a>
      <a href="<%=ctx%>/admin/reports?type=monthly&month=<%=reportMonth != null ? reportMonth : ""%>"
         style="padding:8px 20px;font-weight:600;text-decoration:none;border-bottom:<%=isMonthly ? "3px solid #0077b6;color:#0077b6" : "3px solid transparent;color:#666"%>;margin-bottom:-2px">
        Monthly
      </a>
    </div>

    <% if (!isMonthly) { %>
    <form method="get" action="<%=ctx%>/admin/reports" style="display:flex;gap:12px;align-items:center">
      <input type="hidden" name="type" value="daily">
      <label style="font-weight:600;white-space:nowrap">Report Date:</label>
      <input type="date" class="form-control" name="date"
             value="<%=reportDate != null ? reportDate : ""%>" style="width:200px">
      <button type="submit" class="btn btn-primary">Generate</button>
    </form>
    <% } else { %>
    <form method="get" action="<%=ctx%>/admin/reports" style="display:flex;gap:12px;align-items:center">
      <input type="hidden" name="type" value="monthly">
      <label style="font-weight:600;white-space:nowrap">Month:</label>
      <input type="month" class="form-control" name="month"
             value="<%=reportMonth != null ? reportMonth : ""%>" style="width:200px">
      <button type="submit" class="btn btn-primary">Generate</button>
    </form>
    <% } %>
  </div>
</div>

<div class="stats-grid" style="grid-template-columns:repeat(4,1fr);margin-bottom:24px">
  <div class="stat-card blue">
    <div class="stat-icon">📋</div>
    <div class="stat-info">
      <p>Total Reservations</p>
      <h2><%=reportData != null ? reportData.size() : 0%></h2>
    </div>
  </div>
  <div class="stat-card green">
    <div class="stat-icon">💰</div>
    <div class="stat-info">
      <p>Total Revenue</p>
      <h2 style="font-size:1.2rem">LKR <%=String.format("%,.0f", totalRev)%></h2>
    </div>
  </div>
  <div class="stat-card orange">
    <div class="stat-icon">✅</div>
    <div class="stat-info">
      <p>Paid</p>
      <h2><%=paidCount%></h2>
    </div>
  </div>
  <div class="stat-card" style="background:linear-gradient(135deg,#6c757d,#495057)">
    <div class="stat-icon">📅</div>
    <div class="stat-info" style="color:#fff">
      <p style="color:rgba(255,255,255,0.8)">Period</p>
      <h2 style="font-size:1rem;color:#fff"><%=periodLabel%></h2>
    </div>
  </div>
</div>

<div class="card">
  <div class="card-header">
    <h3>
      <i class="fas fa-table" style="color:#0077b6"></i>
      <% if (isMonthly) { %>
        Reservations for <%=reportMonth%>
      <% } else { %>
        Reservations on <%=reportDate%>
      <% } %>
    </h3>
  </div>
  <div class="card-body" style="padding:0">
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>Res. Number</th>
            <th>Guest</th>
            <th>Room Type</th>
            <th>Room</th>
            <th>Check In</th>
            <th>Check Out</th>
            <th>Status</th>
            <th>Payment</th>
            <th>Amount (LKR)</th>
          </tr>
        </thead>
        <tbody>
          <% if (reportData != null) for (Object[] row : reportData) {
               String ps = row[8] != null ? row[8].toString() : "PENDING";
          %>
          <tr>
            <td><strong><%=row[0]%></strong></td>
            <td><%=row[1]%></td>
            <td><%=row[2]%></td>
            <td><%=row[3]%></td>
            <td><%=row[4]%></td>
            <td><%=row[5]%></td>
            <td>
              <span class="badge badge-<%=row[6].toString().toLowerCase()%>">
                <%=row[6].toString().replace("_"," ")%>
              </span>
            </td>
            <td>
              <span class="badge <%="PAID".equals(ps) ? "badge-paid" : "badge-pending"%>">
                <%=ps%>
              </span>
            </td>
            <td><strong><%=row[7] != null ? String.format("%,.2f", (double)row[7]) : "0.00"%></strong></td>
          </tr>
          <% } %>
          <% if (reportData == null || reportData.isEmpty()) { %>
          <tr>
            <td colspan="9" style="text-align:center;color:#888;padding:30px">
              No reservations found for this <%=isMonthly ? "month" : "date"%>.
            </td>
          </tr>
          <% } %>
          <% if (reportData != null && !reportData.isEmpty()) { %>
          <tr style="background:#1d3557;color:#fff">
            <td colspan="8" style="padding:12px 16px;font-weight:700">TOTAL</td>
            <td style="padding:12px 16px;font-weight:800"><%=String.format("%,.2f", totalRev)%></td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
</div>

    </div><!-- page-content -->
  </div><!-- main-content -->
</div><!-- app-wrapper -->
<script src="<%=ctx%>/js/main.js"></script>
</body></html>
