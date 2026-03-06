<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.User" %>
<%
User currentUser = (User) session.getAttribute("user");
if (currentUser == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}
String ctx = request.getContextPath();
String uri = request.getRequestURI();
String successMsg = (String) session.getAttribute("successMsg");
String errorMsg   = (String) session.getAttribute("errorMsg");
if (successMsg != null) session.removeAttribute("successMsg");
if (errorMsg   != null) session.removeAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%=pageTitle%> - Ocean View Resort</title>
  <link rel="stylesheet" href="<%=ctx%>/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <input type="hidden" id="contextPath" value="<%=ctx%>">
</head>
<body>
<div class="app-wrapper">

  <aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
      <h2>Ocean View Resort</h2>
      <p>Management System</p>
    </div>
    <nav class="sidebar-nav">
      <span class="nav-section">Main</span>
      <a href="<%=ctx%>/dashboard" class="nav-item <%=uri.contains("/dashboard") ? "active" : ""%>">
        <i class="fas fa-tachometer-alt"></i> Dashboard
      </a>
      <span class="nav-section">Reservations</span>
      <a href="<%=ctx%>/reservations/add" class="nav-item <%=uri.contains("/reservations/add") ? "active" : ""%>">
        <i class="fas fa-plus-circle"></i> New Reservation
      </a>
      <a href="<%=ctx%>/reservations/list" class="nav-item <%=uri.contains("/reservations/list") ? "active" : ""%>">
        <i class="fas fa-list"></i> All Reservations
      </a>
      <% if (currentUser.isAdmin()) { %>
      <span class="nav-section">Administration</span>
      <a href="<%=ctx%>/admin/rooms" class="nav-item <%=uri.contains("/admin/rooms") ? "active" : ""%>">
        <i class="fas fa-door-open"></i> Manage Rooms
      </a>
      <a href="<%=ctx%>/admin/users" class="nav-item <%=uri.contains("/admin/users") ? "active" : ""%>">
        <i class="fas fa-users"></i> Manage Users
      </a>
      <a href="<%=ctx%>/admin/reports" class="nav-item <%=uri.contains("/admin/reports") ? "active" : ""%>">
        <i class="fas fa-chart-bar"></i> Reports
      </a>
      <% } %>
      <span class="nav-section">Help</span>
      <a href="<%=ctx%>/help" class="nav-item <%=uri.contains("/help") ? "active" : ""%>">
        <i class="fas fa-question-circle"></i> Help &amp; Guide
      </a>
    </nav>
    <div class="sidebar-footer">
      <div class="sidebar-user">
        <div class="user-avatar"><%=currentUser.getFullName().substring(0, 1).toUpperCase()%></div>
        <div class="user-info">
          <p><%=currentUser.getFullName()%></p>
          <span><%=currentUser.getRole()%></span>
        </div>
      </div>
    </div>
  </aside>

  <!-- Main Content -->
  <div class="main-content">
    <div class="topbar">
      <div class="topbar-left">
        <h1><%=pageTitle%></h1>
        <p><%=java.time.LocalDate.now().toString()%></p>
      </div>
      <div class="topbar-right">
        <a href="<%=ctx%>/logout" class="btn btn-outline btn-sm">
          <i class="fas fa-sign-out-alt"></i> Logout
        </a>
      </div>
    </div>
    <div class="page-content">
      <% if (successMsg != null) { %>
      <div class="alert alert-success alert-auto"><i class="fas fa-check-circle"></i> <%=successMsg%></div>
      <% } %>
      <% if (errorMsg != null) { %>
      <div class="alert alert-danger alert-auto"><i class="fas fa-exclamation-circle"></i> <%=errorMsg%></div>
      <% } %>
