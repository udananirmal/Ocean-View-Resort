package com.oceanview.servlet;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import com.oceanview.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/reservations/*")
public class ReservationServlet extends HttpServlet {

    private User getUser(HttpServletRequest req) {
        return (User) req.getSession().getAttribute("user");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = getUser(req);
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/list";

        ReservationDAO dao = new ReservationDAO();
        RoomDAO roomDao   = new RoomDAO();

        switch (pathInfo) {
            case "/add":
                req.setAttribute("roomTypes", roomDao.getAllRoomTypes());
                req.getRequestDispatcher("/pages/reservation_add.jsp").forward(req, resp);
                break;

            case "/list":
                String search = req.getParameter("search");
                List<Reservation> list;
                if (search != null && !search.trim().isEmpty()) {
                    list = dao.searchReservations(search.trim());
                    req.setAttribute("search", search);
                } else {
                    list = dao.getAllReservations();
                }
                req.setAttribute("reservations", list);
                req.getRequestDispatcher("/pages/reservation_list.jsp").forward(req, resp);
                break;

            case "/view":
                String resNum   = req.getParameter("resNum");
                String resIdStr = req.getParameter("id");
                Reservation res = null;
                if (resNum != null && !resNum.isEmpty()) {
                    res = dao.getReservationByNumber(resNum.trim());
                } else if (resIdStr != null) {
                    try { res = dao.getReservationById(Integer.parseInt(resIdStr)); }
                    catch (NumberFormatException ignored) {}
                }
                req.setAttribute("reservation", res);
                req.setAttribute("today", LocalDate.now().toString());
                req.getRequestDispatcher("/pages/reservation_view.jsp").forward(req, resp);
                break;

            case "/bill":
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    req.setAttribute("bill", dao.getBillDetails(id));
                    req.setAttribute("resId", id);
                } catch (NumberFormatException e) {
                    req.setAttribute("bill", null);
                    req.setAttribute("resId", 0);
                }
                req.getRequestDispatcher("/pages/bill.jsp").forward(req, resp);
                break;

            case "/available-rooms":
                try {
                    String checkIn  = req.getParameter("checkIn");
                    String checkOut = req.getParameter("checkOut");
                    int rtId = Integer.parseInt(req.getParameter("roomTypeId"));
                    List<Room> rooms = roomDao.getAvailableRooms(checkIn, checkOut, rtId);
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    StringBuilder json = new StringBuilder("[");
                    for (int i = 0; i < rooms.size(); i++) {
                        if (i > 0) json.append(",");
                        json.append("{\"id\":").append(rooms.get(i).getId())
                            .append(",\"roomNumber\":\"").append(rooms.get(i).getRoomNumber())
                            .append("\",\"floor\":").append(rooms.get(i).getFloorNumber())
                            .append("}");
                    }
                    json.append("]");
                    resp.getWriter().write(json.toString());
                } catch (Exception e) {
                    resp.setContentType("application/json");
                    resp.getWriter().write("[]");
                }
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/reservations/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = getUser(req);
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        ReservationDAO dao = new ReservationDAO();

        switch (pathInfo) {
            case "/add":
                try {
                    Reservation res = new Reservation();
                    res.setGuestName(req.getParameter("guestName"));
                    res.setGuestAddress(req.getParameter("address"));
                    res.setGuestContact(req.getParameter("contactNumber"));
                    res.setGuestEmail(req.getParameter("email"));
                    res.setRoomId(Integer.parseInt(req.getParameter("roomId")));
                    res.setRoomTypeId(Integer.parseInt(req.getParameter("roomTypeId")));
                    res.setCheckInDate(Date.valueOf(req.getParameter("checkIn")));
                    res.setCheckOutDate(Date.valueOf(req.getParameter("checkOut")));
                    res.setNumGuests(Integer.parseInt(req.getParameter("numGuests")));
                    res.setSpecialRequests(req.getParameter("specialRequests"));
                    res.setRatePerNight(Double.parseDouble(req.getParameter("ratePerNight")));
                    res.setCreatedBy(user.getId());

                    long diffMs = res.getCheckOutDate().getTime() - res.getCheckInDate().getTime();
                    int nights  = Math.max(1, (int)(diffMs / (1000L * 60 * 60 * 24)));
                    res.setTotalAmount(res.getRatePerNight() * nights * 1.10);

                    boolean ok = dao.addReservation(res);
                    if (ok) {
                        req.getSession().setAttribute("successMsg",
                            "Reservation " + res.getReservationNumber() + " created successfully!");
                        resp.sendRedirect(req.getContextPath() + "/reservations/view?resNum=" + res.getReservationNumber());
                    } else {
                        req.setAttribute("error", "Failed to create reservation. Room may no longer be available.");
                        req.setAttribute("roomTypes", new RoomDAO().getAllRoomTypes());
                        req.getRequestDispatcher("/pages/reservation_add.jsp").forward(req, resp);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("error", "Error: " + e.getMessage());
                    req.setAttribute("roomTypes", new RoomDAO().getAllRoomTypes());
                    req.getRequestDispatcher("/pages/reservation_add.jsp").forward(req, resp);
                }
                break;

            case "/update-status":
                try {
                    int resId = Integer.parseInt(req.getParameter("id"));
                    String status = req.getParameter("status");
                    dao.updateStatus(resId, status);
                    req.getSession().setAttribute("successMsg", "Status updated to " + status.replace("_", " "));
                } catch (NumberFormatException e) {
                    req.getSession().setAttribute("errorMsg", "Status update failed.");
                }
                resp.sendRedirect(req.getContextPath() + "/reservations/view?id=" + req.getParameter("id"));
                break;

            case "/checkin-early":
                try {
                    int resId = Integer.parseInt(req.getParameter("id"));
                    Date today = Date.valueOf(LocalDate.now());
                    boolean ok = dao.checkInEarly(resId, today);
                    if (ok) {
                        req.getSession().setAttribute("successMsg",
                            "Guest checked in early. Check-in date updated to today and bill recalculated.");
                    } else {
                        req.getSession().setAttribute("errorMsg", "Failed to process early check-in.");
                    }
                } catch (NumberFormatException e) {
                    req.getSession().setAttribute("errorMsg", "Invalid reservation ID.");
                }
                resp.sendRedirect(req.getContextPath() + "/reservations/view?id=" + req.getParameter("id"));
                break;

            case "/pay":
                try {
                    int resId = Integer.parseInt(req.getParameter("id"));
                    String payMethod = req.getParameter("paymentMethod");
                    dao.updatePaymentStatus(resId, "PAID", payMethod);
                    dao.updateStatus(resId, "CHECKED_OUT");
                    req.getSession().setAttribute("successMsg", "Payment processed successfully!");
                    resp.sendRedirect(req.getContextPath() + "/reservations/bill?id=" + resId);
                } catch (NumberFormatException e) {
                    resp.sendRedirect(req.getContextPath() + "/reservations/list");
                }
                break;

            case "/delete":
                try {
                    int resId = Integer.parseInt(req.getParameter("id"));
                    boolean ok = dao.deleteReservation(resId);
                    if (ok) {
                        req.getSession().setAttribute("successMsg", "Reservation deleted successfully.");
                    } else {
                        req.getSession().setAttribute("errorMsg", "Failed to delete reservation.");
                    }
                } catch (NumberFormatException e) {
                    req.getSession().setAttribute("errorMsg", "Invalid reservation ID.");
                }
                resp.sendRedirect(req.getContextPath() + "/reservations/list");
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/reservations/list");
        }
    }
}
