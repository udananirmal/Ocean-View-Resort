<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.*,java.util.*" %>
<%
String pageTitle = "Manage Rooms";
List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");
List<Room> rooms = (List<Room>) request.getAttribute("rooms");
%>
<%@ include file="layout.jsp" %>

<div class="page-header">
  <div><h2>🚪 Manage Rooms</h2></div>
</div>

<!-- Room Types -->
<div class="card" style="margin-bottom:24px">
  <div class="card-header">
    <h3><i class="fas fa-tag" style="color:#0077b6"></i> Room Types &amp; Rates</h3>
  </div>
  <div class="card-body" style="padding:0">
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>Type</th>
            <th>Description</th>
            <th>Rate/Night (LKR)</th>
            <th>Rooms</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <% if (roomTypes != null) for (RoomType rt : roomTypes) {
               int actual = rt.getActualRoomCount();
          %>
          <tr>
            <td><strong><%=rt.getTypeName()%></strong></td>
            <td style="color:#666;font-size:0.85rem"><%=rt.getDescription()%></td>
            <td><strong style="color:#0077b6">LKR <%=String.format("%,.2f", rt.getRatePerNight())%></strong></td>
            <td>
              <strong><%=actual%></strong>
              <span style="color:#888;font-size:0.78rem"> room<%=actual != 1 ? "s" : ""%></span>
            </td>
            <td>
              <button class="btn btn-warning btn-sm"
                      onclick="openEditModal(<%=rt.getId()%>,
                               '<%=rt.getTypeName().replace("'","&#39;")%>',
                               '<%=rt.getDescription() != null ? rt.getDescription().replace("'","&#39;") : ""%>',
                               <%=rt.getRatePerNight()%>)">
                <i class="fas fa-edit"></i> Edit
              </button>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- All Rooms -->
<div class="card">
  <div class="card-header">
    <h3><i class="fas fa-door-open" style="color:#0077b6"></i> All Rooms</h3>
  </div>
  <div class="card-body" style="padding:0">
    <div class="table-wrapper">
      <table>
        <thead>
          <tr><th>Room Number</th><th>Type</th><th>Floor</th><th>Rate/Night</th><th>Status</th></tr>
        </thead>
        <tbody>
          <% if (rooms != null) for (Room r : rooms) { %>
          <tr>
            <td><strong><%=r.getRoomNumber()%></strong></td>
            <td><%=r.getRoomTypeName()%></td>
            <td>Floor <%=r.getFloorNumber()%></td>
            <td>LKR <%=String.format("%,.2f", r.getRatePerNight())%></td>
            <td><span class="badge badge-<%=r.getStatus().toLowerCase()%>"><%=r.getStatus()%></span></td>
          </tr>
          <% } %>
          <% if (rooms == null || rooms.isEmpty()) { %>
          <tr><td colspan="5" style="text-align:center;color:#888;padding:30px">No rooms found.</td></tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
</div>


<div class="modal-overlay" id="editRoomTypeModal">
  <div class="modal">
    <div class="modal-header">
      <h3>Edit Room Type</h3>
      <button class="modal-close" onclick="closeModal('editRoomTypeModal')">&#10005;</button>
    </div>
    <form method="post" action="<%=ctx%>/admin/update-room-type">
      <input type="hidden" name="id" id="editRtId">
      <div class="form-group">
        <label>Type Name</label>
        <input type="text" class="form-control" id="editRtNameDisplay" disabled
               style="background:#f8f9fb;color:#666">
      </div>
      <div class="form-group">
        <label>Description</label>
        <textarea class="form-control" name="description" id="editRtDesc" rows="3"></textarea>
      </div>
      <div class="form-group">
        <label>Rate Per Night (LKR) *</label>
        <input type="number" class="form-control" name="rate" id="editRtRate" min="0" step="0.01" required>
      </div>
      <input type="hidden" name="typeName" id="editRtName">
      <p style="font-size:0.82rem;color:#888;margin-top:-8px;margin-bottom:16px">
        <i class="fas fa-info-circle"></i>
        Rate change applies to <strong>new reservations only</strong>.
        Existing reservations keep their original agreed rate.
      </p>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="closeModal('editRoomTypeModal')">Cancel</button>
        <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save Changes</button>
      </div>
    </form>
  </div>
</div>

    </div><!-- page-content -->
  </div><!-- main-content -->
</div><!-- app-wrapper -->
<script src="<%=ctx%>/js/main.js"></script>
<script>
function openEditModal(id, name, desc, rate) {
  document.getElementById('editRtId').value          = id;
  document.getElementById('editRtName').value        = name;
  document.getElementById('editRtNameDisplay').value = name;
  document.getElementById('editRtDesc').value        = desc;
  document.getElementById('editRtRate').value        = rate;
  openModal('editRoomTypeModal');
}
</script>
</body></html>
