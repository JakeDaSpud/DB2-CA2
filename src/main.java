import java.sql.*;

public class main {
    public static void main(String[] args) {
        //Video used to connect DB to Java App: https://youtu.be/AHFBPxWebFQ?si=UMsBsKxpAOizz-9S

        Connection connection = null;

        try{
            //Xampp localhost URL for DB
            String local_DB_URL = "jdbc:mysql://localhost:3306/KPop_Database_CA2";

            //User Login Details
            String username = "root";
            String password = "";

            connection = DriverManager.getConnection(local_DB_URL, username, password);

            //Testing
            System.out.println("WHERE DOES THIS PRINT");
            Statement statement = connection.createStatement();
            System.out.println("does it work or nah");
            String sql = "INSERT INTO Company (CompanyName) VALUES ('JYP Entertainment');";
            statement.executeUpdate(sql);

            //Using ResultSet to output query
            ResultSet resultSet = statement.executeQuery("select * from Company");

            //Constructing output
            while (resultSet.next()) {
                System.out.println(resultSet.getString(2 /* or 1 idk */));
            }

            // original resultSet while() loop
            /*
            while (resultSet.next()) {
                System.out.println(resultSet.getInt(1) + " " + resultSet.getString(2) + resultSet.getDouble(3));
            }
            */

            //Closing / Ending connection
            connection.close();
        }

        //Error Catching / Handling
        catch (SQLException e) {
            for(Throwable t: e)
            {
                t.printStackTrace();
            }
        }
    }
}