<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*, java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="java.io.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>图书系统</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="./css/layui.css">
    <link rel="stylesheet" href="./css/ind.css">
    <script src="layui.js"></script>
    <script src="card.js"></script>
    <style type="text/css">
        body {
            background-color: #F2F2F2;
            min-width: 1200px;
        }

        .layui-form {
            position: absolute;
            width: 380px;
            left: 280px;
            top: 30px;
        }

        #input-box {
            font-size: 14px;
        }

        #nav {
            position: fixed;
            background-color: #393D49;
        }

        .content {
            display: block;
            width: 72%;
            min-width: 820px;
            max-width: 1360px;
            position: absolute;
            left: 280px;
            top: 100px;
        }

        #breadcrumb {
            margin-bottom: 10px;
        }

    </style>
</head>

<body>
<% 
    //初始化
	String c = request.getParameter("field");
    int choose = Integer.parseInt(c);	
	String value = request.getParameter("value");	
	
	Context initContext = new InitialContext();
	Context envContext  = (Context)initContext.lookup("java:/comp/env");
	DataSource ds = (DataSource)envContext.lookup("jdbc/book"); 
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String[] field = {"book_name", "author", "press"};
    String[] field_c = {"书名", "作者", "出版社"};

    ArrayList book_list = new ArrayList();
    int book_number = 0;

	try {
		conn = ds.getConnection();			
		stmt = conn.createStatement();
        rs = stmt.executeQuery("select * from books where "+ field[choose] +" like '%" + value +"%'");		
        while (rs.next()) {
            Map<String, String> item = new HashMap<String, String>();
            item.put("id", rs.getString("id"));
            item.put("b_cate", rs.getString("b_cate"));
            item.put("s_cate", rs.getString("s_cate"));
            item.put("name", rs.getString("book_name"));
            item.put("author", rs.getString("author"));
            item.put("discription", rs.getString("discription"));
            item.put("press", rs.getString("press"));
            item.put("image", rs.getString("image"));
            item.put("url", rs.getString("detail_url"));
            book_list.add(item);
        }
        rs.close();
	} catch (Exception e) {
		throw e;
	} finally {
        book_number = book_list.size();
		try {
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		} catch (Exception e) {
			throw e;
		}
	}
%>
    <%-- 导航栏 --%>
    <ul class="layui-nav layui-nav-tree layui-nav-side" lay-filter="nav" id="nav">
        <li class="layui-nav-item"><a href="">小说</a></li>
        <li class="layui-nav-item"><a href="">文学</a></li>
        <li class="layui-nav-item"><a href="">青春文学</a></li>
        <li class="layui-nav-item"><a href="">传记</a></li>
        <li class="layui-nav-item"><a href="">励志与成功</a></li>
        <li class="layui-nav-item"><a href="">管理</a></li>
        <li class="layui-nav-item"><a href="">经济</a></li>
        <li class="layui-nav-item"><a href="">金融与投资</a></li>
        <li class="layui-nav-item"><a href="">历史</a></li>
        <li class="layui-nav-item"><a href="">心理学</a></li>
        <li class="layui-nav-item"><a href="">政治/军事</a></li>
        <li class="layui-nav-item"><a href="">社会科学</a></li>
        <li class="layui-nav-item"><a href="">科普读物</a></li>
        <li class="layui-nav-item"><a href="">计算机与互联网</a></li>
        <li class="layui-nav-item"><a href="">电子与通信</a></li>
    </ul>

    <%-- 搜索框 --%>
    <form class="layui-form" action="search.jsp">
        <div class="layui-form-item" id="search-box">
            <div class="layui-input-inline" id="field">
                <select name="field" lay-filter="field">
                    <option value="0">书名</option>
                    <option value="1">作者</option>
                    <option value="2">出版社</option>
                </select>
            </div>
            <div class="layui-input-inline" id="input-div">
                <input type="text" name="value" title="输入你的检索词" required class="layui-input" id="input-box">
            </div>
            <button class="layui-btn layui-btn-primary" type="submit">
                <i class="layui-icon">&#xe615;</i>
            </button>
        </div>
    </form>

    <div class="content">
        <%-- 面包屑 --%>
        <div class="layui-breadcrumb" lay-separator=">" id="breadcrumb">
            <a href="index.html">首页</a>
            <a><cite><%=field_c[choose]%>：<%=value%></cite></a>
        </div>
        <div class="search-result">
            <span>搜索到 <%=book_number%> 条记录</span>
        </div>
        <div style="margin-bottom: 30px;"><hr style="background-color: #cccccc;"></div>

        <%-- 搜索结果列表 --%>
        <div class="book-list" id="b-list">
<%
        for(int i=0; i<book_number; i++)
        {
            Map<String, String> book = new HashMap<String, String>();
            book = (Map<String, String>) book_list.get(i);
            String id = book.get("id");
            String b_cate = book.get("b_cate");
            String s_cate = book.get("s_cate");
            String name = book.get("name"); 
            String author = book.get("author"); 
            String discription = book.get("discription"); 
            String press = book.get("press"); 
            String image = book.get("image"); 
            String url = book.get("url"); 
%>
            <div class="book card">
                <div class="card__flipper">
                    <div class="card__front">
                        <div class="book-img">
                            <img src="<%=image%>">
                        </div>
                        <div class="book-name"><%=name%></div>
                        <div class="book-author"><%=author%> 著</div>
                        <div class="book-press"><%=press%></div>
                    </div>
                    <div class="card__back">
                        <div class="close-btn">
                            <button class="layui-btn layui-btn-primary">
                                <i class="layui-icon">&#x1006;</i>
                            </button>
                        </div>
                        <div class="book-img" id="detail-img">
                            <img
                                src="<%=image%>">
                        </div>
                        <div class="book-name" id="book-name-back"><b><%=name%></b></div>
                        <div class="book-author"><%=author%> 著</div>
                        <div class="book-id">
                            <span>图书编码：</span>
                            <span><%=id%></span>
                        </div>
                        <div class="layui-breadcrumb category-lable" lay-separator=" — ">
                            <span>分类：</span>
                            <a href=""><%=b_cate%></a>
                            <a href=""><%=s_cate%></a>
                        </div>
                    <% if(discription != null && discription.length()>0) { %>
                        <div class="book-discription">&emsp;&emsp;<%=discription%></div>
                    <% } %>
                        <div class="buttons">
                            <a target="_blank" href="<%=url%>">
                                <button class="layui-btn layui-btn-primary">前往购买</button>
                            </a>
                            <button class="layui-btn layui-btn-primary">修改内容</button>
                            <button class="layui-btn layui-btn-primary">删除书本</button>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>
            <div class='page-box'>
        </div>

        </div>
    </div>

    <script>
        layui.use(['form', 'element', 'laypage'], function () {
            var form = layui.form;
            var element = layui.element;
            element.on('tab(demo)', function (data) {
                console.log(data);
            });

            var laypage = layui.laypage;
            laypage.render({
                elem: 'page-box',
                count: <%=book_number%>,
                limit: 30
            });
        });

    </script>


</body>
</html>