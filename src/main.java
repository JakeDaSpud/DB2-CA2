import java.sql.*;

public class main {
    public static void main(String[] args) {
        /*
            GD2A CA2:
                Jake O'Reilly (Java Part)
                Ema Eiliakas
                Michal Becmer
        */

        //Video used to connect DB to Java App: https://youtu.be/AHFBPxWebFQ?si=UMsBsKxpAOizz-9S

        Connection connection = null;

        try{
            //Xampp localhost URL for DB
            String local_DB_URL = "jdbc:mysql://localhost:3306/kpop_database_ca2";

            //User Login Details
            String username = "root";
            String password = "";

            connection = DriverManager.getConnection(local_DB_URL, username, password);

            //Running SQL through Java
            System.out.println("Database started...");
            Statement statement = connection.createStatement();
            System.out.println("Connected to Database...");


//            String sql = "INSERT INTO Company (CompanyName) VALUES ('JYP Entertainment');";
//            statement.executeUpdate(sql);

            //Using ResultSet to output query
            System.out.println("Running SQL: select * from BandDetails;");
            ResultSet resultSet = statement.executeQuery("select * from BandDetails;");

            //Constructing output
//            while (resultSet.next()) {
//                System.out.println(resultSet.getString(1));
//            }

            while (resultSet.next()) {
                System.out.println(resultSet.getString(1) + " " + resultSet.getString(2) + " " + resultSet.getString(3) + " " + resultSet.getString(4) + " " + resultSet.getString(5) + " " + resultSet.getString(6) + " " + resultSet.getString(7));
            }

            System.out.println("\nRunning SQL: select * from BandMemberDetails;");
            resultSet = statement.executeQuery("select * from BandMemberDetails;");

            while (resultSet.next()) {
                System.out.println(resultSet.getString(1) + " " + resultSet.getString(2) + " " + resultSet.getString(3) + " " + resultSet.getString(4) + " " + resultSet.getString(5) + " " + resultSet.getString(6));
            }

            System.out.println("\nRunning SQL: select * from Company;");
            resultSet = statement.executeQuery("select * from Company;");

            while (resultSet.next()) {
                System.out.println(resultSet.getString(1) + " " + resultSet.getString(2) + " " + resultSet.getString(3) + " " + resultSet.getString(4) + " " + resultSet.getString(5));
            }

            // original resultSet while() loop
            /*
            while (resultSet.next()) {
                System.out.println(resultSet.getInt(1) + " " + resultSet.getString(2) + resultSet.getDouble(3));
            }
            */

            System.out.println("\nClosing connection to Database...");
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