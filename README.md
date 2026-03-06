Ocean View Resort — Hotel Reservation Management System

A web-based hotel management system built with Java Servlets, JSP, and MySQL.



Built With

- Java (Jakarta EE)
- Apache Tomcat 10
- MySQL 8.0
- JSP + HTML + CSS
- Maven



Setup Instructions

1. Clone the repository

git clone https://github.com/yourusername/ocean-view-resort.git


 2. Create the database
- Open MySQL and run the schema file:

source database/schema.sql


3. Configure the database connection
- Open `src/main/java/com/oceanview/util/DBConnection.java`
- Update your MySQL username and password:
java
private static final String USERNAME = "root";
private static final String PASSWORD = "your_password";


 4. Build the project

mvn clean package


 5. Deploy to Tomcat
- Copy `target/OceanViewResort.war` to your Tomcat `webapps/` folder
- Start Tomcat

6. Open in browser

http://localhost:8080/OceanViewResort/login





| Role  | Username | Password |
|-------|----------|----------|
| Admin | admin    | admin123 |
| Staff | staff   | staff123 |



- Staff login with session management
- Create, view, and search reservations
- Room availability checking
- Early check-in with bill recalculation
- Payment processing and check-out
- Daily and monthly reports (Admin only)
- User management (Admin only)
- Room type management (Admin only)




src/
├── main/java/com/oceanview/
│   ├── dao/        
│   ├── model/      
│   ├── servlet/    
│   └── util/       
└── main/webapp/
    └── pages/      
   

- Java 17+
- Apache Tomcat 10+
- MySQL 8.0+
- Maven 3.6+
