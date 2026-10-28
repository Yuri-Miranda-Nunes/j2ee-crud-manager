<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.yuri.model.Tarefa" %>
<%
    Tarefa tEdit = (Tarefa) request.getAttribute("tarefaEditando");
    boolean editando = (tEdit != null);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Gerenciador de Tarefas</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f4f4f4; }
        form { margin-bottom: 20px; background: #f9f9f9; padding: 15px; border-radius: 5px; }
        input, select { margin: 5px 0; padding: 8px; width: 100%; box-sizing: border-box; }
        button { background-color: #28a745; color: white; padding: 10px 15px; border: none; cursor: pointer; }
        .btn-warning { background-color: #ffc107; color: black; padding: 5px 10px; text-decoration: none; border-radius: 3px; margin-right: 5px; }
        .btn-danger { background-color: #dc3545; color: white; padding: 5px 10px; text-decoration: none; border-radius: 3px; }
        .btn-cancel { background-color: #6c757d; color: white; padding: 10px 15px; text-decoration: none; border-radius: 3px; display: inline-block; margin-left: 10px; }
    </style>
</head>
<body>

    <h2><%= editando ? "Editar Tarefa #" + tEdit.getId() : "Cadastrar Nova Tarefa" %></h2>
    <form action="tarefas" method="post">
        <% if (editando) { %>
            <input type="hidden" name="id" value="<%= tEdit.getId() %>">
        <% } %>

        <label>Título:</label>
        <input type="text" name="titulo" value="<%= editando ? tEdit.getTitulo() : "" %>" required>

        <label>Descrição:</label>
        <input type="text" name="descricao" value="<%= editando && tEdit.getDescricao() != null ? tEdit.getDescricao() : "" %>">

        <label>Status:</label>
        <select name="status">
            <option value="PENDENTE" <%= editando && "PENDENTE".equals(tEdit.getStatus()) ? "selected" : "" %>>PENDENTE</option>
            <option value="EM ANDAMENTO" <%= editando && "EM ANDAMENTO".equals(tEdit.getStatus()) ? "selected" : "" %>>EM ANDAMENTO</option>
            <option value="CONCLUÍDO" <%= editando && "CONCLUÍDO".equals(tEdit.getStatus()) ? "selected" : "" %>>CONCLUÍDO</option>
        </select>

        <button type="submit"><%= editando ? "Atualizar Tarefa" : "Salvar Tarefa" %></button>
        <% if (editando) { %>
            <a href="tarefas" class="btn-cancel">Cancelar</a>
        <% } %>
    </form>

    <h2>Lista de Tarefas</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Título</th>
                <th>Descrição</th>
                <th>Status</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Tarefa> lista = (List<Tarefa>) request.getAttribute("listaTarefas");
                if (lista != null && !lista.isEmpty()) {
                    for (Tarefa t : lista) {
            %>
                <tr>
                    <td><%= t.getId() %></td>
                    <td><%= t.getTitulo() %></td>
                    <td><%= t.getDescricao() %></td>
                    <td><%= t.getStatus() %></td>
                    <td>
                        <a href="tarefas?action=editar&id=<%= t.getId() %>" class="btn-warning">Editar</a>
                        <a href="tarefas?action=deletar&id=<%= t.getId() %>" class="btn-danger" onclick="return confirm('Tem certeza?')">Deletar</a>
                    </td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="5">Nenhuma tarefa cadastrada.</td>
                </tr>
            <%
                }
            %>
        </tbody>
    </table>

</body>
</html>