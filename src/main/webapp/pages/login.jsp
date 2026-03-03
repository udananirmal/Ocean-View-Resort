<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login - Ocean View Resort</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="login-wrapper">
  <div class="login-card">
    <div class="login-logo">
      <span class="logo-icon">🌊</span>
      <h1>Ocean View Resort</h1>
      <p>Galle, Sri Lanka</p>
    </div>
    <h2>Staff Login</h2>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div>
    <% } %>
    <form method="post" action="${pageContext.request.contextPath}/login">
      <div class="form-group">
        <label>Username</label>
        <div class="input-icon">
          <i class="fas fa-user"></i>
          <input type="text" class="form-control" name="username" required placeholder="Enter username" autofocus>
        </div>
      </div>
      <div class="form-group">
        <label>Password</label>
        <div class="input-icon">
          <i class="fas fa-lock"></i>
          <input type="password" class="form-control" name="password" required placeholder="Enter password">
        </div>
      </div>
      <button type="submit" class="btn btn-primary btn-lg btn-block" style="margin-top:8px">
        <i class="fas fa-sign-in-alt"></i> Login
      </button>
    </form>
    <p style="text-align:center;margin-top:24px;font-size:0.78rem;color:#aaa">
      Default: admin / admin123 &nbsp;|&nbsp; staff1 / staff123
    </p>
  </div>
</div>
</body>
</html>
