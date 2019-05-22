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

    ArrayList book_list = new ArrayList();
    Map<String, String> item = new HashMap<String, String>();
    int book_number = 0;

	try {
		conn = ds.getConnection();			
		stmt = conn.createStatement();
        rs = stmt.executeQuery("select * from books where "+ field[choose] +" like '%" + value +"%'");		
        while (rs.next()) {
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
    <form class="layui-form" action="search_page.jsp">
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
            <a href="">国际新闻</a>
            <a href="">亚太地区</a>
            <a><cite>正文</cite></a>
        </div>

        <%-- 搜索结果列表 --%>
        <div class="book-list">

<%
        for(int i=0; i<book_number; i++)
        {
            Map<String, String> book = new HashMap<String, String>();
            book = book_list.get(i);
%>
            <div class="book card">
                <div class="card__flipper">
                    <div class="card__front">
                        <div class="book-img">
                            <img src="<%=book.get("image")%>">
                        </div>
                        <div class="book-name">浮生六记（2018新版！无删减彩色插图珍藏本)</div>
                        <div class="book-author">杨绛 著</div>
                        <div class="book-press">三联书店</div>
                    </div>
                    <div class="card__back">
                        <div class="close-btn">
                            <button class="layui-btn layui-btn-primary">
                                <i class="layui-icon">&#x1006;</i>
                            </button>
                        </div>
                        <div class="book-img" id="detail-img">
                            <img
                                src="https://img14.360buyimg.com/n7/jfs/t22720/73/1034241904/151911/8d39c1a7/5b4da4fdN7639b927.jpg">
                        </div>
                        <div class="book-name" id="book-name-back"><b>浮生六记（2018新版！无删减彩色插图珍藏本)</b></div>
                        <div class="book-author">杨绛 著</div>
                        <div class="book-id">
                            <span>图书编码：</span>
                            <span>12405244</span>
                        </div>
                        <div class="layui-breadcrumb category-lable" lay-separator=">">
                            <span>分类：</span>
                            <a href="">小说</a>
                            <a href="">中国现代小说</a>
                        </div>
                        <div class="book-discription">&emsp;&emsp;至真至美至情至性的中国古典爱情范本！让年轻人正确认识爱情和对待生活！唯美国画配图，名家详释精注，无障碍阅读！
                            林语堂、俞平伯、曹聚仁等推崇备至，汪涵、贾平凹力荐！</div>
                        <div class="buttons">
                            <a target="_blank" href="https://item.jd.com/12405244.html">
                                <button class="layui-btn layui-btn-primary">前往购买</button>
                            </a>
                            <button class="layui-btn layui-btn-primary">修改内容</button>
                            <button class="layui-btn layui-btn-primary">删除书本</button>
                        </div>
                    </div>
                </div>
            </div>
        }
%>
        </div>
    </div>



</body>
</html>