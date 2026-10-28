<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.yuri.model.Tarefa" %>
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
        .btn-danger { background-color: #dc3545; color: white; padding: 5px 10px; text-decoration: none; border-radius: 3px; }
    </style>
</head>
<body>

    <h2>Cadastrar Nova Tarefa</h2>
    <form action="tarefas" method="post">
        <label>Título:</label>
        <input type="text" name="titulo" required>

        <label>Descrição:</label>
        <input type="text" name="descricao">

        <label>Status:</label>
        <select name="status">
            <option value="PENDENTE">PENDENTE</option>
            <option value="EM ANDAMENTO">EM ANDAMENTO</option>
            <option value="CONCLUÍDO">CONCLUÍDO</option>
        </select>

        <button type="submit">Salvar Tarefa</button>
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