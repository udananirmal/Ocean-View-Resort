package com.oceanview.model;

public class RoomType {
    private int id;
    private String typeName;
    private String description;
    private double ratePerNight;
    private int actualRoomCount; 

    public RoomType() {}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public double getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(double ratePerNight) { this.ratePerNight = ratePerNight; }
    public int getActualRoomCount() { return actualRoomCount; }
    public void setActualRoomCount(int actualRoomCount) { this.actualRoomCount = actualRoomCount; }

}
