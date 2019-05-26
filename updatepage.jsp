<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*, java.sql.*, javax.sql.*, javax.naming.*" %>

<html>

<head>
    <title>添加书本</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="./css/layui.css">
    <script src="layui.js"></script>
    <script src="formsetting.js"></script>
    <style type="text/css">
        body {
            font-family: "Microsoft YaHei";
        }

        .layui-form {
            width: 600px;
            margin: 50px auto 0 100px;
        }

        .layui-form-select dl dd.layui-this {
            background-color: #0E86E2;
        }
        
        .layui-input:hover,
        .layui-textarea:hover {
            border-color: #66afe9 !important;
        }

        .layui-input:focus,
        .layui-textarea:focus {
            border-color: #66afe9 !important;
            outline: 0;
            -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 8px rgba(102, 175, 233, .6);
            box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 8px rgba(102, 175, 233, .6)
        }
    </style>
</head>

<% 
	String id = request.getParameter("id");
    String b_cate = request.getParameter("b_cate");
	String s_cate = request.getParameter("s_cate");
	String name = null;
	String author = null;
	String press = null;
    String discription = null;

    Context initContext = new InitialContext();
	Context envContext  = (Context)initContext.lookup("java:/comp/env");
	DataSource ds = (DataSource)envContext.lookup("jdbc/book"); 
	Connection conn = null;
    PreparedStatement psmt = null;
    ResultSet rs = null;

	try {
		conn = ds.getConnection();			
		psmt = conn.prepareStatement("select * from books where id=? and b_cate=? and s_cate=?");
        psmt.setString(1, id);
        psmt.setString(2, b_cate);
        psmt.setString(3, s_cate);
        rs = psmt.executeQuery();
		if(rs.next()) {
            name = rs.getString("book_name");
            author = rs.getString("author");
            press = rs.getString("press");
            discription = rs.getString("discription");
        }

	} catch (Exception e) {
		throw e;
	} finally {
		try {
			if (psmt != null) psmt.close();
			if (conn != null) conn.close();
		} catch (Exception e) {
			throw e;
		}
	}
%>


<body>
    <form class="layui-form" lay-filter="upd-form" action="insert.jsp">
        <div class="layui-form-item">
            <label class="layui-form-label"><b>ID</b></label>
            <div class="layui-input-block">
                <input type="text" name="id" required autocomplete="off" class="layui-input" style="width: 200px" maxlength="20" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"><b>书名</b></label>
            <div class="layui-input-block">
                <input type="text" name="name" required autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"><b>作者</b></label>
            <div class="layui-input-block">
                <input type="text" name="author" required autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"><b>出版社</b></label>
            <div class="layui-input-block">
                <input type="text" name="press" required autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"><b>分类</b></label>
            <div class="layui-input-inline" style="margin-right: 20px;">
                <select name="b_cate" lay-verify="required" id="b_cate" lay-filter="b_cate">
                    <option value=""></option>
                </select>
            </div>
            <div class="layui-input-inline">
                <select name="s_cate" lay-verify="required" id="s_cate">
                    <option value=""></option>
                </select>
            </div>
        </div>
        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label"><b>描述</b></label>
            <div class="layui-input-block">
                <textarea name="disc" placeholder="请输入内容" class="layui-textarea" style="height: 180px" maxlength="255"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="formDemo">立即提交</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </form>

    <script> 
    layui.use(['form', 'jquery'], function () {
        var form = layui.form;
        var $ = layui.$;

        $(document).ready(function() {
            b = document.getElementById("b_cate");
            for (var i = 0; i < cate_list.length; i++) {
                b.options.add(new Option(cate_list[i], cate_list[i]));
            }
            form.render('select');

            form.val("upd-form", {
                "id": "<%=id%>",
                "name": "<%=name%>",
                "author": "<%=author%>",
                "press": "<%=press%>",
                "b_cate": "<%=b_cate%>",
                "disc": "<%=discription%>",
            });

            var s_list = cate_arr["<%=b_cate%>"];
            var s_obj = document.getElementById("s_cate");
            s_obj.options.length = 1;
            for (var i = 0; i < s_list.length; i++) {
                s_obj.options.add(new Option(s_list[i], s_list[i]));
            }
            form.render('select');

            form.val("upd-form", {
                "s_cate": "<%=s_cate%>",
            });
        });
    });
    </script>

</body>

</html>