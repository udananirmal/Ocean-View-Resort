package com.oceanview.servlet;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.RoomDAO;
import com.oceanview.dao.UserDAO;
import com.oceanview.model.RoomType;
import com.oceanview.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {

    private User getAdminUser(HttpServletRequest req) {
        User u = (User) req.getSession().getAttribute("user");
        return (u != null && u.isAdmin()) ? u : null;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (getAdminUser(req) == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/rooms";

        switch (pathInfo) {
            case "/rooms":
                req.setAttribute("roomTypes", new RoomDAO().getAllRoomTypesAdmin());
                req.setAttribute("rooms", new RoomDAO().getAllRooms());
                req.getRequestDispatcher("/pages/admin_rooms.jsp").forward(req, resp);
                break;

            case "/users":
                req.setAttribute("users", new UserDAO().getAllUsers());
                req.getRequestDispatcher("/pages/admin_users.jsp").forward(req, resp);
                break;

            case "/reports":
                String reportType = req.getParameter("type");
                if (reportType == null) reportType = "daily";
                ReservationDAO reportDao = new ReservationDAO();
                if ("monthly".equals(reportType)) {
                    String month = req.getParameter("month");
                    if (month == null || month.isEmpty())
                        month = LocalDate.now().toString().substring(0, 7); // YYYY-MM
                    req.setAttribute("reportType", "monthly");
                    req.setAttribute("reportMonth", month);
                    req.setAttribute("reportData", reportDao.getMonthlyReport(month));
                } else {
                    String date = req.getParameter("date");
                    if (date == null || date.isEmpty()) date = LocalDate.now().toString();
                    req.setAttribute("reportType", "daily");
                    req.setAttribute("reportDate", date);
                    req.setAttribute("reportData", reportDao.getDailyReport(date));
                }
                req.getRequestDispatcher("/pages/admin_reports.jsp").forward(req, resp);
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/admin/rooms");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (getAdminUser(req) == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        switch (pathInfo) {
            case "/update-room-type": {
                RoomType rt = new RoomType();
                rt.setId(Integer.parseInt(req.getParameter("id")));
                rt.setTypeName(req.getParameter("typeName"));
                rt.setDescription(req.getParameter("description"));
                rt.setRatePerNight(Double.parseDouble(req.getParameter("rate")));
                new RoomDAO().updateRoomType(rt);
                req.getSession().setAttribute("successMsg", "Room type updated successfully!");
                resp.sendRedirect(req.getContextPath() + "/admin/rooms");
                break;
            }
            case "/add-user": {
                UserDAO userDAO = new UserDAO();
                String username = req.getParameter("username");
                if (userDAO.usernameExists(username)) {
                    req.getSession().setAttribute("errorMsg", "Username '" + username + "' already exists.");
                } else {
                    User nu = new User();
                    nu.setUsername(username);
                    nu.setPassword(req.getParameter("password"));
                    nu.setFullName(req.getParameter("fullName"));
                    nu.setEmail(req.getParameter("email"));
                    nu.setRole(req.getParameter("role"));
                    userDAO.addUser(nu);
                    req.getSession().setAttribute("successMsg", "User added successfully!");
                }
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                break;
            }
            case "/delete-user": {
                boolean ok = new UserDAO().deleteUser(Integer.parseInt(req.getParameter("id")));
                req.getSession().setAttribute(ok ? "successMsg" : "errorMsg",
                    ok ? "User deleted successfully." : "Failed to delete user.");
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/rooms");
        }
    }
}
