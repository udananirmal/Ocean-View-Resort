package com.oceanview.servlet;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import com.oceanview.model.Reservation;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        ReservationDAO dao = new ReservationDAO();
        Object[] stats = dao.getDashboardStats();
        List<Reservation> all = dao.getAllReservations();
        List<Reservation> recent = all.size() > 5 ? all.subList(0, 5) : all;

        req.setAttribute("stats", stats);
        req.setAttribute("recentReservations", recent);
        req.getRequestDispatcher("/pages/dashboard.jsp").forward(req, resp);
    }
}
