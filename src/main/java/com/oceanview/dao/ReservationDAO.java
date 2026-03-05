package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    public boolean addReservation(Reservation res) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
         
            String guestSql = "INSERT INTO guests(guest_name,address,contact_number,email,nic_passport) VALUES(?,?,?,?,?)";
            PreparedStatement gps = conn.prepareStatement(guestSql, Statement.RETURN_GENERATED_KEYS);
            gps.setString(1, res.getGuestName());
            gps.setString(2, res.getGuestAddress());
            gps.setString(3, res.getGuestContact());
            gps.setString(4, res.getGuestEmail() != null ? res.getGuestEmail() : "");
            gps.setString(5, "");
            gps.executeUpdate();
            ResultSet gkeys = gps.getGeneratedKeys();
            int guestId = 0;
            if (gkeys.next()) guestId = gkeys.getInt(1);

            ResultSet maxRs = conn.prepareStatement(
                "SELECT COALESCE(MAX(id),0)+1 AS next_id FROM reservations").executeQuery();
            int nextId = maxRs.next() ? maxRs.getInt("next_id") : 1;
            String resNum = "RES" + String.format("%04d", nextId);
            String resSql = "INSERT INTO reservations(reservation_number,guest_id,room_id,room_type_id," +
                            "check_in_date,check_out_date,num_guests,special_requests,status,total_amount,created_by)" +
                            " VALUES(?,?,?,?,?,?,?,?,?,?,?)";
            PreparedStatement rps = conn.prepareStatement(resSql, Statement.RETURN_GENERATED_KEYS);
            rps.setString(1, resNum);
            rps.setInt(2, guestId);
            rps.setInt(3, res.getRoomId());
            rps.setInt(4, res.getRoomTypeId());
            rps.setDate(5, res.getCheckInDate());
            rps.setDate(6, res.getCheckOutDate());
            rps.setInt(7, res.getNumGuests());
            rps.setString(8, res.getSpecialRequests());
            rps.setString(9, "CONFIRMED");
            rps.setDouble(10, res.getTotalAmount());
            rps.setInt(11, res.getCreatedBy() > 0 ? res.getCreatedBy() : 1);
            rps.executeUpdate();
            ResultSet rkeys = rps.getGeneratedKeys();
            int resId = 0;
            if (rkeys.next()) resId = rkeys.getInt(1);
            
            PreparedStatement ups = conn.prepareStatement("UPDATE rooms SET status='OCCUPIED' WHERE id=?");
            ups.setInt(1, res.getRoomId());
            ups.executeUpdate();

            long diffMs = res.getCheckOutDate().getTime() - res.getCheckInDate().getTime();
            int nights = Math.max(1, (int)(diffMs / (1000L * 60 * 60 * 24)));
            double subtotal = res.getRatePerNight() * nights;
            double tax      = subtotal * 0.10;
            double total    = subtotal + tax;

            PreparedStatement bps = conn.prepareStatement(
                "INSERT INTO bills(reservation_id,num_nights,room_rate,subtotal,tax_rate,tax_amount,total_amount)" +
                " VALUES(?,?,?,?,10.00,?,?)");
            bps.setInt(1, resId);
            bps.setInt(2, nights);
            bps.setDouble(3, res.getRatePerNight());
            bps.setDouble(4, subtotal);
            bps.setDouble(5, tax);
            bps.setDouble(6, total);
            bps.executeUpdate();

            conn.commit();
            res.setReservationNumber(resNum);
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public Reservation getReservationByNumber(String resNum) {
        return queryOne("WHERE r.reservation_number=?", ps -> ps.setString(1, resNum));
    }

    public Reservation getReservationById(int id) {
        return queryOne("WHERE r.id=?", ps -> ps.setInt(1, id));
    }

    public List<Reservation> getAllReservations() {
        return queryList("", null);
    }

    public List<Reservation> searchReservations(String query) {
        String where = "WHERE r.reservation_number LIKE ? OR g.guest_name LIKE ? OR g.contact_number LIKE ?";
        String q = "%" + query + "%";
        return queryList(where, ps -> { ps.setString(1,q); ps.setString(2,q); ps.setString(3,q); });
    }

    public boolean updateStatus(int id, String status) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement ps = conn.prepareStatement("UPDATE reservations SET status=? WHERE id=?");
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();

            if ("CHECKED_OUT".equals(status) || "CANCELLED".equals(status)) {
                PreparedStatement rps = conn.prepareStatement(
                    "UPDATE rooms SET status='AVAILABLE' WHERE id=(SELECT room_id FROM reservations WHERE id=?)");
                rps.setInt(1, id);
                rps.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }


    public boolean checkInEarly(int reservationId, java.sql.Date actualCheckIn) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            PreparedStatement get = conn.prepareStatement(
                "SELECT r.check_out_date, b.room_rate FROM reservations r " +
                "JOIN bills b ON b.reservation_id=r.id WHERE r.id=?");
            get.setInt(1, reservationId);
            ResultSet rs = get.executeQuery();
            if (!rs.next()) { conn.rollback(); return false; }
            java.sql.Date checkOut = rs.getDate("check_out_date");
            double rate = rs.getDouble("room_rate");
            long diffMs  = checkOut.getTime() - actualCheckIn.getTime();
            int nights   = Math.max(1, (int)(diffMs / (1000L * 60 * 60 * 24)));
            double sub   = rate * nights;
            double tax   = sub * 0.10;
            double total = sub + tax;
            PreparedStatement updRes = conn.prepareStatement(
                "UPDATE reservations SET check_in_date=?, status='CHECKED_IN', total_amount=? WHERE id=?");
            updRes.setDate(1, actualCheckIn);
            updRes.setDouble(2, total);
            updRes.setInt(3, reservationId);
            updRes.executeUpdate();
            PreparedStatement updBill = conn.prepareStatement(
                "UPDATE bills SET num_nights=?, subtotal=?, tax_amount=?, total_amount=? WHERE reservation_id=?");
            updBill.setInt(1, nights);
            updBill.setDouble(2, sub);
            updBill.setDouble(3, tax);
            updBill.setDouble(4, total);
            updBill.setInt(5, reservationId);
            updBill.executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public Object[] getBillDetails(int reservationId) {
        String sql = "SELECT b.*, r.reservation_number, g.guest_name, g.contact_number, " +
            "rt.type_name, rm.room_number, r.check_in_date, r.check_out_date, r.num_guests " +
            "FROM bills b " +
            "JOIN reservations r ON b.reservation_id=r.id " +
            "JOIN guests g ON r.guest_id=g.id " +
            "JOIN rooms rm ON r.room_id=rm.id " +
            "JOIN room_types rt ON r.room_type_id=rt.id " +
            "WHERE b.reservation_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Object[]{
                    rs.getString("reservation_number"),    // 0
                    rs.getString("guest_name"),            // 1
                    rs.getString("contact_number"),        // 2
                    rs.getString("type_name"),             // 3
                    rs.getString("room_number"),           // 4
                    rs.getDate("check_in_date").toString(),  // 5
                    rs.getDate("check_out_date").toString(), // 6
                    rs.getInt("num_nights"),               // 7
                    rs.getDouble("room_rate"),             // 8
                    rs.getDouble("subtotal"),              // 9
                    rs.getDouble("tax_amount"),            // 10
                    rs.getDouble("total_amount"),          // 11
                    rs.getString("payment_status"),        // 12
                    rs.getInt("num_guests")                // 13
                };
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean updatePaymentStatus(int reservationId, String status, String method) {
        String sql = "UPDATE bills SET payment_status=?, payment_method=? WHERE reservation_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, method);
            ps.setInt(3, reservationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteReservation(int id) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            PreparedStatement freeRoom = conn.prepareStatement(
                "UPDATE rooms SET status='AVAILABLE' " +
                "WHERE id=(SELECT room_id FROM reservations WHERE id=?) AND status='OCCUPIED'");
            freeRoom.setInt(1, id);
            freeRoom.executeUpdate();

            PreparedStatement getGuest = conn.prepareStatement(
                "SELECT guest_id FROM reservations WHERE id=?");
            getGuest.setInt(1, id);
            ResultSet rs = getGuest.executeQuery();
            int guestId = rs.next() ? rs.getInt("guest_id") : 0;

            conn.prepareStatement("DELETE FROM bills WHERE reservation_id=" + id).executeUpdate();

            conn.prepareStatement("DELETE FROM reservations WHERE id=" + id).executeUpdate();

            if (guestId > 0) {
                ResultSet cr = conn.prepareStatement(
                    "SELECT COUNT(*) FROM reservations WHERE guest_id=" + guestId).executeQuery();
                if (cr.next() && cr.getInt(1) == 0) {
                    conn.prepareStatement("DELETE FROM guests WHERE id=" + guestId).executeUpdate();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public double getMonthlyRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount),0) FROM bills " +
                     "WHERE payment_status='PAID' AND MONTH(created_at)=MONTH(CURDATE()) " +
                     "AND YEAR(created_at)=YEAR(CURDATE())";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public Object[] getDashboardStats() {
        String sql = "SELECT " +
            "(SELECT COUNT(*) FROM reservations WHERE status='CONFIRMED') AS confirmed, " +
            "(SELECT COUNT(*) FROM reservations WHERE status='CHECKED_IN') AS checkedIn, " +
            "(SELECT COUNT(*) FROM reservations WHERE DATE(check_out_date)=CURDATE()) AS checkouts, " +
            "(SELECT COUNT(*) FROM rooms WHERE status='AVAILABLE') AS availRooms, " +
            "(SELECT COALESCE(SUM(total_amount),0) FROM bills WHERE payment_status='PAID' " +
            "   AND DATE(created_at)=CURDATE()) AS todayRevenue, " +
            "(SELECT COUNT(*) FROM reservations WHERE DATE(check_in_date)=CURDATE()) AS todayCheckins";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return new Object[]{
                rs.getInt("confirmed"),
                rs.getInt("checkedIn"),
                rs.getInt("checkouts"),
                rs.getInt("availRooms"),
                rs.getDouble("todayRevenue"),
                rs.getInt("todayCheckins")
            };
        } catch (SQLException e) { e.printStackTrace(); }
        return new Object[]{0, 0, 0, 0, 0.0, 0};
    }

    public List<Object[]> getDailyReport(String date) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT r.reservation_number, g.guest_name, rt.type_name, rm.room_number, " +
            "r.check_in_date, r.check_out_date, r.status, " +
            "COALESCE(b.total_amount,0) AS total_amount, " +
            "COALESCE(b.payment_status,'PENDING') AS payment_status " +
            "FROM reservations r " +
            "JOIN guests g ON r.guest_id=g.id " +
            "JOIN rooms rm ON r.room_id=rm.id " +
            "JOIN room_types rt ON r.room_type_id=rt.id " +
            "LEFT JOIN bills b ON r.id=b.reservation_id " +
            "WHERE DATE(r.created_at)=? ORDER BY r.created_at";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(new Object[]{
                rs.getString("reservation_number"),
                rs.getString("guest_name"),
                rs.getString("type_name"),
                rs.getString("room_number"),
                rs.getString("check_in_date"),
                rs.getString("check_out_date"),
                rs.getString("status"),
                rs.getDouble("total_amount"),
                rs.getString("payment_status")   // index 8 — added for report
            });
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Object[]> getMonthlyReport(String yearMonth) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT r.reservation_number, g.guest_name, rt.type_name, rm.room_number, " +
            "r.check_in_date, r.check_out_date, r.status, " +
            "COALESCE(b.total_amount,0) AS total_amount, " +
            "COALESCE(b.payment_status,'PENDING') AS payment_status " +
            "FROM reservations r " +
            "JOIN guests g ON r.guest_id=g.id " +
            "JOIN rooms rm ON r.room_id=rm.id " +
            "JOIN room_types rt ON r.room_type_id=rt.id " +
            "LEFT JOIN bills b ON r.id=b.reservation_id " +
            "WHERE DATE_FORMAT(r.created_at,'%Y-%m')=? ORDER BY r.created_at";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, yearMonth);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(new Object[]{
                rs.getString("reservation_number"),
                rs.getString("guest_name"),
                rs.getString("type_name"),
                rs.getString("room_number"),
                rs.getString("check_in_date"),
                rs.getString("check_out_date"),
                rs.getString("status"),
                rs.getDouble("total_amount"),
                rs.getString("payment_status")
            });
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }


    @FunctionalInterface
    interface PSetter { void set(PreparedStatement ps) throws SQLException; }

    private Reservation queryOne(String where, PSetter setter) {
        String sql = buildSelectSQL() + " " + where;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (setter != null) setter.set(ps);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapReservation(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private List<Reservation> queryList(String where, PSetter setter) {
        List<Reservation> list = new ArrayList<>();
        String sql = buildSelectSQL() + (where.isEmpty() ? "" : " " + where) + " ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (setter != null) setter.set(ps);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapReservation(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private String buildSelectSQL() {
        return "SELECT r.*, g.guest_name, g.address, g.contact_number, g.email, " +
               "rm.room_number, rt.type_name, rt.rate_per_night, " +
               "DATEDIFF(r.check_out_date, r.check_in_date) AS num_nights, " +
               "COALESCE(b.payment_status, 'PENDING') AS payment_status " +
               "FROM reservations r " +
               "JOIN guests g ON r.guest_id=g.id " +
               "JOIN rooms rm ON r.room_id=rm.id " +
               "JOIN room_types rt ON r.room_type_id=rt.id " +
               "LEFT JOIN bills b ON b.reservation_id=r.id";
    }

    private Reservation mapReservation(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setId(rs.getInt("id"));
        r.setReservationNumber(rs.getString("reservation_number"));
        r.setGuestId(rs.getInt("guest_id"));
        r.setGuestName(rs.getString("guest_name"));
        r.setGuestAddress(rs.getString("address"));
        r.setGuestContact(rs.getString("contact_number"));
        r.setGuestEmail(rs.getString("email"));
        r.setRoomId(rs.getInt("room_id"));
        r.setRoomNumber(rs.getString("room_number"));
        r.setRoomTypeId(rs.getInt("room_type_id"));
        r.setRoomTypeName(rs.getString("type_name"));
        r.setRatePerNight(rs.getDouble("rate_per_night"));
        r.setCheckInDate(rs.getDate("check_in_date"));
        r.setCheckOutDate(rs.getDate("check_out_date"));
        r.setNumGuests(rs.getInt("num_guests"));
        r.setSpecialRequests(rs.getString("special_requests"));
        r.setStatus(rs.getString("status"));
        r.setPaymentStatus(rs.getString("payment_status"));   // FIX 1: map it
        r.setTotalAmount(rs.getDouble("total_amount"));
        r.setNumNights(rs.getInt("num_nights"));
        r.setCreatedAt(rs.getString("created_at"));
        return r;
    }
}
