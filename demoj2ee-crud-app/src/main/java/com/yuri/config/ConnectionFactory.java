package com.yuri.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {

    // URL de conexão com a base de dados MySQL (porta padrão 3306)
    private static final String URL = "jdbc:mysql://localhost:3306/j2ee_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root"; // Teu utilizador do MySQL
    private static final String PASSWORD = ""; // Coloca aqui a tua palavra-passe do MySQL

    public static Connection getConnection() {
        try {
            // Carrega o driver JDBC do MySQL na memória
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException("Erro ao conectar à base de dados: ", e);
        }
    }

    // Método main para testar se a conexão funciona antes de rodar no servidor Tomcat
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("✅ Conexão com o MySQL realizada com sucesso!");
            }
        } catch (Exception e) {
            System.err.println("❌ Falha na conexão com o MySQL:");
            e.printStackTrace();
        }
    }
}