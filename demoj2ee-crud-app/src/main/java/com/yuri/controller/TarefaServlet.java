package com.yuri.controller;

import com.yuri.dao.TarefaDAO;
import com.yuri.model.Tarefa;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/tarefas")
public class TarefaServlet extends HttpServlet {

    private TarefaDAO dao;

    @Override
    public void init() {
        dao = new TarefaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("deletar".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deletar(id);
            response.sendRedirect("tarefas");
            return;
        }

        List<Tarefa> lista = dao.listarTodas();
        request.setAttribute("listaTarefas", lista);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String titulo = request.getParameter("titulo");
        String descricao = request.getParameter("descricao");
        String status = request.getParameter("status");

        Tarefa tarefa = new Tarefa(titulo, descricao, status);
        dao.salvar(tarefa);

        response.sendRedirect("tarefas");
    }
}