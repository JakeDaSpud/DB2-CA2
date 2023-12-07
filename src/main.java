import javax.swing.plaf.nimbus.State;
import java.sql.*;

public class main {
    public static void main(String[] args) {
        //Video used to connect DB to Java App: https://youtu.be/AHFBPxWebFQ?si=UMsBsKxpAOizz-9S
    }

    String url="jdbc:mysql://localhost:3306/jdbcdemo";
    String username="root";
    String password="";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection connection = DriverManager.getConnection(url, username, password);

        Statement statement = connection.createStatement();

        ResultSet resultSet = statement.executeQuery("select * from table");

        while (resultSet.next()) {
            System.out.println(resultSet.getInt(1) + " " + resultSet.getString(2) + resultSet.getDouble(3));
        }

        connection.close();
    }

    catch (Exception e) {
        System.out.println(e);
    }
}
