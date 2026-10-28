package com.yuri.dao;

import com.yuri.config.ConnectionFactory;
import com.yuri.model.Tarefa;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TarefaDAO {

    public void salvar(Tarefa tarefa) {
        String sql = "INSERT INTO tarefas (titulo, descricao, status) VALUES (?, ?, ?)";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, tarefa.getTitulo());
            stmt.setString(2, tarefa.getDescricao());
            stmt.setString(3, tarefa.getStatus());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao salvar tarefa: ", e);
        }
    }

    public List<Tarefa> listarTodas() {
        List<Tarefa> tarefas = new ArrayList<>();
        String sql = "SELECT * FROM tarefas";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Tarefa t = new Tarefa(
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("descricao"),
                        rs.getString("status")
                );
                tarefas.add(t);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar tarefas: ", e);
        }
        return tarefas;
    }

    public Tarefa buscarPorId(int id) {
        String sql = "SELECT * FROM tarefas WHERE id = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Tarefa(
                            rs.getInt("id"),
                            rs.getString("titulo"),
                            rs.getString("descricao"),
                            rs.getString("status")
                    );
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar tarefa por ID: ", e);
        }
        return null;
    }

    public void atualizar(Tarefa tarefa) {
        String sql = "UPDATE tarefas SET titulo = ?, descricao = ?, status = ? WHERE id = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, tarefa.getTitulo());
            stmt.setString(2, tarefa.getDescricao());
            stmt.setString(3, tarefa.getStatus());
            stmt.setInt(4, tarefa.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao atualizar tarefa: ", e);
        }
    }

    public void deletar(int id) {
        String sql = "DELETE FROM tarefas WHERE id = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao deletar tarefa: ", e);
        }
    }
}