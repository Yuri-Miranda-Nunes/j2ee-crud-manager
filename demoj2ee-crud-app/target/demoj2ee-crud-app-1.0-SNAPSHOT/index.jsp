<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.yuri.model.Tarefa" %>
<%!
    // Escapes HTML to prevent XSS when printing user-provided data
    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }

    private static String badgeClass(String status) {
        if ("CONCLUÍDO".equals(status)) return "badge-done";
        if ("EM ANDAMENTO".equals(status)) return "badge-progress";
        return "badge-pending";
    }
%>
<%
    Tarefa tEdit = (Tarefa) request.getAttribute("tarefaEditando");
    boolean editando = (tEdit != null);

    List<Tarefa> lista = (List<Tarefa>) request.getAttribute("listaTarefas");
    int total = 0, pendentes = 0, andamento = 0, concluidas = 0;
    if (lista != null) {
        total = lista.size();
        for (Tarefa t : lista) {
            if ("PENDENTE".equals(t.getStatus())) pendentes++;
            else if ("EM ANDAMENTO".equals(t.getStatus())) andamento++;
            else if ("CONCLUÍDO".equals(t.getStatus())) concluidas++;
        }
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gerenciador de Tarefas</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #f4f5fb;
            --surface: #ffffff;
            --surface-2: #f8f9fd;
            --text: #1b1f3b;
            --muted: #6b7194;
            --border: #e4e6f2;
            --primary: #6366f1;
            --primary-hover: #4f46e5;
            --primary-soft: #eef0ff;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --radius: 16px;
            --shadow: 0 1px 2px rgba(20,24,60,.04), 0 8px 24px rgba(20,24,60,.06);
        }
        @media (prefers-color-scheme: dark) {
            :root {
                --bg: #0d0f1c;
                --surface: #151829;
                --surface-2: #1b1f35;
                --text: #eceefb;
                --muted: #8a90b5;
                --border: #262a45;
                --primary: #818cf8;
                --primary-hover: #a5b4fc;
                --primary-soft: #1f2347;
                --shadow: 0 1px 2px rgba(0,0,0,.3), 0 8px 24px rgba(0,0,0,.35);
            }
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Inter', system-ui, -apple-system, 'Segoe UI', sans-serif;
            background: var(--bg);
            color: var(--text);
            line-height: 1.5;
            min-height: 100vh;
            background-image:
                radial-gradient(900px 400px at 10% -10%, rgba(99,102,241,.18), transparent 60%),
                radial-gradient(700px 400px at 100% 0%, rgba(16,185,129,.10), transparent 60%);
            background-repeat: no-repeat;
        }
        .container { max-width: 1080px; margin: 0 auto; padding: 48px 24px 64px; }

        /* Header */
        header { display: flex; align-items: center; justify-content: space-between; gap: 16px; margin-bottom: 32px; flex-wrap: wrap; }
        .brand { display: flex; align-items: center; gap: 14px; }
        .logo {
            width: 46px; height: 46px; border-radius: 14px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            display: grid; place-items: center; color: #fff;
            box-shadow: 0 8px 20px rgba(99,102,241,.35);
        }
        .brand h1 { font-size: 1.5rem; font-weight: 700; letter-spacing: -.02em; }
        .brand p { color: var(--muted); font-size: .9rem; }
        .tech { display: flex; gap: 8px; flex-wrap: wrap; }
        .chip {
            font-size: .75rem; font-weight: 500; color: var(--muted);
            padding: 5px 12px; border: 1px solid var(--border);
            border-radius: 999px; background: var(--surface);
        }

        /* Stats */
        .stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 24px; }
        .stat {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 18px 20px; box-shadow: var(--shadow);
            position: relative; overflow: hidden;
        }
        .stat::before { content: ""; position: absolute; left: 0; top: 0; bottom: 0; width: 4px; background: var(--accent, var(--primary)); }
        .stat span { display: block; font-size: .78rem; color: var(--muted); font-weight: 500; text-transform: uppercase; letter-spacing: .06em; }
        .stat strong { font-size: 1.9rem; font-weight: 700; letter-spacing: -.03em; }
        .stat.pending { --accent: var(--warning); }
        .stat.progress { --accent: var(--primary); }
        .stat.done { --accent: var(--success); }

        /* Cards */
        .card {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: var(--radius); box-shadow: var(--shadow); padding: 28px;
            margin-bottom: 24px;
        }
        .card-title { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
        .card-title h2 { font-size: 1.1rem; font-weight: 600; letter-spacing: -.01em; }
        .tag-edit { font-size: .75rem; font-weight: 600; color: var(--warning); background: rgba(245,158,11,.12); padding: 4px 10px; border-radius: 999px; }

        /* Form */
        .form-grid { display: grid; grid-template-columns: 1.2fr 2fr 1fr; gap: 16px; }
        .field label { display: block; font-size: .8rem; font-weight: 500; color: var(--muted); margin-bottom: 6px; }
        input, select {
            width: 100%; padding: 11px 14px; font: inherit; color: var(--text);
            background: var(--surface-2); border: 1px solid var(--border);
            border-radius: 10px; transition: border-color .15s, box-shadow .15s, background .15s;
        }
        input:focus, select:focus {
            outline: none; border-color: var(--primary); background: var(--surface);
            box-shadow: 0 0 0 4px var(--primary-soft);
        }
        .actions { display: flex; align-items: center; gap: 12px; margin-top: 20px; }
        .btn {
            display: inline-flex; align-items: center; gap: 8px; font: inherit; font-weight: 600; font-size: .9rem;
            padding: 11px 20px; border: none; border-radius: 10px; cursor: pointer;
            text-decoration: none; transition: transform .1s, background .15s, box-shadow .15s;
        }
        .btn:active { transform: translateY(1px); }
        .btn-primary { background: var(--primary); color: #fff; box-shadow: 0 6px 16px rgba(99,102,241,.3); }
        .btn-primary:hover { background: var(--primary-hover); }
        .btn-ghost { background: transparent; color: var(--muted); border: 1px solid var(--border); }
        .btn-ghost:hover { background: var(--surface-2); color: var(--text); }

        /* Table */
        .table-wrap { overflow-x: auto; margin: 0 -8px; }
        table { width: 100%; border-collapse: separate; border-spacing: 0; }
        thead th {
            font-size: .72rem; text-transform: uppercase; letter-spacing: .07em;
            color: var(--muted); font-weight: 600; text-align: left;
            padding: 10px 14px; border-bottom: 1px solid var(--border);
        }
        tbody td { padding: 16px 14px; border-bottom: 1px solid var(--border); vertical-align: middle; }
        tbody tr { transition: background .15s; }
        tbody tr:hover { background: var(--surface-2); }
        tbody tr:last-child td { border-bottom: none; }
        .id { color: var(--muted); font-variant-numeric: tabular-nums; font-weight: 500; }
        .t-title { font-weight: 600; }
        .t-desc { color: var(--muted); font-size: .9rem; max-width: 380px; }

        .badge {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: .72rem; font-weight: 600; padding: 4px 10px; border-radius: 999px; white-space: nowrap;
        }
        .badge::before { content: ""; width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
        .badge-pending  { color: #b45309; background: rgba(245,158,11,.14); }
        .badge-progress { color: var(--primary); background: var(--primary-soft); }
        .badge-done     { color: #047857; background: rgba(16,185,129,.14); }
        @media (prefers-color-scheme: dark) {
            .badge-pending { color: #fbbf24; }
            .badge-done { color: #34d399; }
        }

        .row-actions { display: flex; gap: 8px; justify-content: flex-end; }
        .icon-btn {
            display: inline-flex; align-items: center; gap: 6px; font-size: .8rem; font-weight: 500;
            padding: 7px 12px; border-radius: 8px; text-decoration: none;
            border: 1px solid var(--border); color: var(--text); background: var(--surface);
            transition: all .15s;
        }
        .icon-btn:hover { border-color: var(--primary); color: var(--primary); }
        .icon-btn.danger:hover { border-color: var(--danger); color: var(--danger); background: rgba(239,68,68,.08); }

        /* Empty state */
        .empty { text-align: center; padding: 48px 16px; color: var(--muted); }
        .empty svg { margin-bottom: 12px; opacity: .6; }
        .empty strong { display: block; color: var(--text); font-size: 1rem; margin-bottom: 4px; }

        footer { text-align: center; color: var(--muted); font-size: .8rem; margin-top: 32px; }

        @media (max-width: 860px) {
            .stats { grid-template-columns: repeat(2, 1fr); }
            .form-grid { grid-template-columns: 1fr; }
            .container { padding: 32px 16px 48px; }
        }
    </style>
</head>
<body>
<div class="container">

    <header>
        <div class="brand">
            <div class="logo">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
            </div>
            <div>
                <h1>Gerenciador de Tarefas</h1>
                <p>Organize seu fluxo de trabalho com clareza.</p>
            </div>
        </div>
        <div class="tech">
            <span class="chip">Java</span>
            <span class="chip">JSP / Servlets</span>
            <span class="chip">CRUD</span>
        </div>
    </header>

    <section class="stats">
        <div class="stat"><span>Total</span><strong><%= total %></strong></div>
        <div class="stat pending"><span>Pendentes</span><strong><%= pendentes %></strong></div>
        <div class="stat progress"><span>Em andamento</span><strong><%= andamento %></strong></div>
        <div class="stat done"><span>Concluídas</span><strong><%= concluidas %></strong></div>
    </section>

    <section class="card">
        <div class="card-title">
            <h2><%= editando ? "Editar tarefa" : "Nova tarefa" %></h2>
            <% if (editando) { %><span class="tag-edit">Editando #<%= tEdit.getId() %></span><% } %>
        </div>

        <form action="tarefas" method="post">
            <% if (editando) { %>
                <input type="hidden" name="id" value="<%= tEdit.getId() %>">
            <% } %>

            <div class="form-grid">
                <div class="field">
                    <label for="titulo">Título</label>
                    <input id="titulo" type="text" name="titulo" placeholder="Ex.: Finalizar relatório"
                           value="<%= editando ? esc(tEdit.getTitulo()) : "" %>" required>
                </div>
                <div class="field">
                    <label for="descricao">Descrição</label>
                    <input id="descricao" type="text" name="descricao" placeholder="Detalhes opcionais"
                           value="<%= editando && tEdit.getDescricao() != null ? esc(tEdit.getDescricao()) : "" %>">
                </div>
                <div class="field">
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="PENDENTE" <%= editando && "PENDENTE".equals(tEdit.getStatus()) ? "selected" : "" %>>Pendente</option>
                        <option value="EM ANDAMENTO" <%= editando && "EM ANDAMENTO".equals(tEdit.getStatus()) ? "selected" : "" %>>Em andamento</option>
                        <option value="CONCLUÍDO" <%= editando && "CONCLUÍDO".equals(tEdit.getStatus()) ? "selected" : "" %>>Concluído</option>
                    </select>
                </div>
            </div>

            <div class="actions">
                <button type="submit" class="btn btn-primary">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><% if (editando) { %><polyline points="20 6 9 17 4 12"/><% } else { %><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/><% } %></svg>
                    <%= editando ? "Atualizar tarefa" : "Salvar tarefa" %>
                </button>
                <% if (editando) { %>
                    <a href="tarefas" class="btn btn-ghost">Cancelar</a>
                <% } %>
            </div>
        </form>
    </section>

    <section class="card">
        <div class="card-title">
            <h2>Lista de tarefas</h2>
        </div>

        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Título</th>
                        <th>Descrição</th>
                        <th>Status</th>
                        <th style="text-align:right">Ações</th>
                    </tr>
                </thead>
                <tbody>
                <% if (lista != null && !lista.isEmpty()) {
                       for (Tarefa t : lista) { %>
                    <tr>
                        <td class="id">#<%= t.getId() %></td>
                        <td class="t-title"><%= esc(t.getTitulo()) %></td>
                        <td class="t-desc"><%= t.getDescricao() != null && !t.getDescricao().isEmpty() ? esc(t.getDescricao()) : "—" %></td>
                        <td><span class="badge <%= badgeClass(t.getStatus()) %>"><%= esc(t.getStatus()) %></span></td>
                        <td>
                            <div class="row-actions">
                                <a href="tarefas?action=editar&id=<%= t.getId() %>" class="icon-btn">Editar</a>
                                <a href="tarefas?action=deletar&id=<%= t.getId() %>" class="icon-btn danger"
                                   onclick="return confirm('Tem certeza que deseja deletar esta tarefa?')">Deletar</a>
                            </div>
                        </td>
                    </tr>
                <%     }
                   } else { %>
                    <tr>
                        <td colspan="5">
                            <div class="empty">
                                <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="3"/><path d="M8 12h8"/></svg>
                                <strong>Nenhuma tarefa cadastrada</strong>
                                Use o formulário acima para criar a primeira.
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>

    <footer>Desenvolvido por Yuri · Projeto de portfólio</footer>
</div>
</body>
</html>
