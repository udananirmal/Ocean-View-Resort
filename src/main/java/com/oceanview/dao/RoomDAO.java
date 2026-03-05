package com.oceanview.dao;

import com.oceanview.model.Room;
import com.oceanview.model.RoomType;
import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    public List<RoomType> getAllRoomTypes() {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT rt.*, " +
                     "(SELECT COUNT(*) FROM rooms r WHERE r.room_type_id=rt.id) AS actual_count " +
                     "FROM room_types rt WHERE rt.is_active=1 ORDER BY rt.rate_per_night";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRoomType(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<RoomType> getAllRoomTypesAdmin() {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT rt.*, " +
                     "(SELECT COUNT(*) FROM rooms r WHERE r.room_type_id=rt.id) AS actual_count " +
                     "FROM room_types rt ORDER BY rt.rate_per_night";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRoomType(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public RoomType getRoomTypeById(int id) {
        String sql = "SELECT rt.*, " +
                     "(SELECT COUNT(*) FROM rooms r WHERE r.room_type_id=rt.id) AS actual_count " +
                     "FROM room_types rt WHERE rt.id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRoomType(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    
    public boolean updateRoomType(RoomType rt) {
        String sql = "UPDATE room_types SET type_name=?,description=?,rate_per_night=?,total_rooms=?,is_active=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rt.getTypeName());
            ps.setString(2, rt.getDescription());
            ps.setDouble(3, rt.getRatePerNight());
            ps.setInt(6, rt.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name, rt.rate_per_night FROM rooms r " +
                     "JOIN room_types rt ON r.room_type_id=rt.id ORDER BY r.room_number";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRoom(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Room getRoomById(int id) {
        String sql = "SELECT r.*, rt.type_name, rt.rate_per_night FROM rooms r " +
                     "JOIN room_types rt ON r.room_type_id=rt.id WHERE r.id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRoom(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Room> getAvailableRooms(String checkIn, String checkOut, int roomTypeId) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name, rt.rate_per_night FROM rooms r " +
            "JOIN room_types rt ON r.room_type_id = rt.id " +
            "WHERE r.room_type_id=? AND r.status='AVAILABLE' " +
            "AND r.id NOT IN (" +
            "  SELECT room_id FROM reservations " +
            "  WHERE status IN ('CONFIRMED','CHECKED_IN') " +
            "  AND NOT (check_out_date <= ? OR check_in_date >= ?)" +
            ")";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.setString(2, checkIn);
            ps.setString(3, checkOut);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRoom(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

 
    public int countAvailableRooms() {
        String sql = "SELECT COUNT(*) FROM rooms WHERE status='AVAILABLE'";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int countOccupiedRooms() {
        String sql = "SELECT COUNT(*) FROM rooms WHERE status='OCCUPIED'";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private RoomType mapRoomType(ResultSet rs) throws SQLException {
        RoomType rt = new RoomType();
        rt.setId(rs.getInt("id"));
        rt.setTypeName(rs.getString("type_name"));
        rt.setDescription(rs.getString("description"));
        rt.setRatePerNight(rs.getDouble("rate_per_night"));
        // Live count from rooms table — will be 0 if column not in query (safe fallback)
        try { rt.setActualRoomCount(rs.getInt("actual_count")); } catch (SQLException ignored) {}
        return rt;
    }

    private Room mapRoom(ResultSet rs) throws SQLException {
        Room r = new Room();
        r.setId(rs.getInt("id"));
        r.setRoomNumber(rs.getString("room_number"));
        r.setRoomTypeId(rs.getInt("room_type_id"));
        r.setRoomTypeName(rs.getString("type_name"));
        r.setRatePerNight(rs.getDouble("rate_per_night"));
        r.setFloorNumber(rs.getInt("floor_number"));
        r.setStatus(rs.getString("status"));
        return r;
    }
}
