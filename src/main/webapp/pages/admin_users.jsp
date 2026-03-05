<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.*,java.util.*" %>
<%
String pageTitle = "Manage Users";
List<User> users = (List<User>) request.getAttribute("users");
%>
<%@ include file="layout.jsp" %>

<div class="page-header">
  <div><h2>👥 Manage Users</h2></div>
  <button class="btn btn-primary" onclick="openModal('addUserModal')">
    <i class="fas fa-user-plus"></i> Add User
  </button>
</div>

<div class="card">
  <div class="card-body" style="padding:0">
    <div class="table-wrapper">
      <table>
        <thead>
          <tr><th>#</th><th>Username</th><th>Full Name</th><th>Email</th><th>Role</th><th>Actions</th></tr>
        </thead>
        <tbody>
          <% if (users != null) {
               int rowNum = 1;
               for (User u : users) { %>
          <tr>
            <td><%=rowNum++%></td>
            <td><strong><%=u.getUsername()%></strong></td>
            <td><%=u.getFullName()%></td>
            <td><%=u.getEmail() != null ? u.getEmail() : "-"%></td>
            <td><span class="badge badge-<%=u.getRole().toLowerCase()%>"><%=u.getRole()%></span></td>
            <td>
              <% if (!"admin".equals(u.getUsername())) { %>
              <form method="post" action="<%=ctx%>/admin/delete-user" style="display:inline">
                <input type="hidden" name="id" value="<%=u.getId()%>">
                <button type="submit" class="btn btn-danger btn-sm"
                        onclick="return confirm('Permanently delete user \'<%=u.getUsername()%>\'?\n\nThis cannot be undone.')">
                  <i class="fas fa-trash"></i> Delete
                </button>
              </form>
              <% } else { %>
              <span style="color:#aaa;font-size:0.8rem">Protected</span>
              <% } %>
            </td>
          </tr>
          <% } } %>
          <% if (users == null || users.isEmpty()) { %>
          <tr><td colspan="6" style="text-align:center;color:#888;padding:30px">No users found.</td></tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
</div>

<div class="modal-overlay" id="addUserModal">
  <div class="modal">
    <div class="modal-header">
      <h3>Add New User</h3>
      <button class="modal-close" onclick="closeModal('addUserModal')">&#10005;</button>
    </div>
    <form method="post" action="<%=ctx%>/admin/add-user">
      <div class="form-row">
        <div class="form-group"><label>Username *</label><input type="text" class="form-control" name="username" required></div>
        <div class="form-group"><label>Password *</label><input type="password" class="form-control" name="password" required minlength="6"></div>
      </div>
      <div class="form-group"><label>Full Name *</label><input type="text" class="form-control" name="fullName" required></div>
      <div class="form-row">
        <div class="form-group"><label>Email</label><input type="email" class="form-control" name="email"></div>
        <div class="form-group"><label>Role *</label>
          <select class="form-control" name="role" required>
            <option value="STAFF">Staff</option>
            <option value="ADMIN">Admin</option>
          </select>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="closeModal('addUserModal')">Cancel</button>
        <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Add User</button>
      </div>
    </form>
  </div>
</div>

    </div><!-- page-content -->
  </div><!-- main-content -->
</div><!-- app-wrapper -->
<script src="<%=ctx%>/js/main.js"></script>
</body></html>
