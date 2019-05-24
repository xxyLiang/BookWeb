<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*, java.sql.*, javax.sql.*, javax.naming.*" %>
<!DOCTYPE html>
<html>

<head>
    <title>图书系统</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="./css/layui.css">
    <link rel="stylesheet" href="./css/ind.css">
    <script src="layui.js"></script>
    <script src="card.js"></script>
    <script>
        layui.use(['form', 'element'], function () {
            var form = layui.form;
            var element = layui.element;
            element.on('tab(demo)', function (data) {
                console.log(data);
            }); 
        });
    </script>
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

        #breadcrumb {
            margin-bottom: 10px;
        }

    </style>
</head>


<% 
    //初始化
	String c = request.getParameter("field");
    int choose = Integer.parseInt(c);
	String value = request.getParameter("value");
    int page_num = 1;
    try{
        String p = request.getParameter("page_num");
        page_num = Integer.parseInt(p);
    } catch (Exception e) {}

    int start = 30 * (page_num - 1);
	
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
    int total_book_number = 0;

	try {
		conn = ds.getConnection();			
		stmt = conn.createStatement();
		rs = stmt.executeQuery("select * from books where "+ field[choose] +" like '%" + value + "%' limit "+start+",30");

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

        rs = stmt.executeQuery("select count(*) from books where "+ field[choose] +" like '%" + value + "%'");
        if(rs.next()) {
            total_book_number = rs.getInt(1);
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


<body>
    <%-- 导航栏 --%>
    <ul class="layui-nav layui-nav-tree layui-nav-side" lay-filter="nav" id="nav">
        <li class="layui-nav-item"><a href="list.jsp?b_cate=小说&s_cate=">小说</a></li>
        <li class="layui-nav-item"><a href="list.jsp?b_cate=文学&s_cate=">文学</a></li>
        <li class="layui-nav-item"><a href="list.jsp?b_cate=青春文学&s_cate=">青春文学</a></li>
        <li class="layui-nav-item"><a href="list.jsp?b_cate=传记&s_cate=">传记</a></li>
        <li class="layui-nav-item"><a href="list.jsp?b_cate=励志与成功&s_cate=">励志与成功</a></li>
        <li class="layui-nav-item"><a href="list.jsp?b_cate=管理&s_cate=">管理</a></li>
        <li class="layui-nav-item"><a href="list.jsp?b_cate=经济&s_cate=">经济</a></li>
        <li class="layui-nav-item"><a href="list.jsp?b_cate=金融与投资&s_cate=">金融与投资</a></li>
        <li class="layui-nav-item"><a href="list.jsp?b_cate=历史&s_cate=">历史</a></li>
        <li class="layui-nav-item"><a href="list.jsp?b_cate=心理学&s_cate=">心理学</a></li>
        <li class="layui-nav-item"><a href="list.jsp?b_cate=政治/军事&s_cate=">政治/军事</a></li>
        <li class="layui-nav-item"><a href="list.jsp?b_cate=社会科学&s_cate=">社会科学</a></li>
        <li class="layui-nav-item"><a href="list.jsp?b_cate=科普读物&s_cate=">科普读物</a></li>
        <li class="layui-nav-item"><a href="list.jsp?b_cate=计算机与互联网&s_cate=">计算机与互联网</a></li>
        <li class="layui-nav-item"><a href="list.jsp?b_cate=电子与通信&s_cate=">电子与通信</a></li>
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
            <span>搜索到 <%=total_book_number%> 条记录</span>
        </div>
        <div style="margin-bottom: 30px;"><hr style="background-color: #cccccc;"></div>

        <%-- 搜索结果列表 --%>
        <div class="book-list">
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
                            <img src="<%=image%>">
                        </div>
                        <div class="book-name" id="book-name-back"><b><%=name%></b></div>
                        <div class="book-author"><%=author%> 著</div>
                        <div class="book-id">
                            <span>图书编码：</span>
                            <span><%=id%></span>
                        </div>
                        <div class="layui-breadcrumb category-lable" lay-separator=" — ">
                            <span>分类：</span>
                            <a href="list.jsp?b_cate=<%=b_cate%>&s_cate="><%=b_cate%></a>
                            <a href="list.jsp?b_cate=<%=b_cate%>&s_cate=<%=s_cate%>"><%=s_cate%></a>
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
        </div>
        <div id='page-box'></div>
    </div>



    <script>

        layui.use(['laypage', 'jquery'], function () {
            var $ = layui.$;

            var laypage = layui.laypage;
            laypage.render({
                elem: 'page-box',
                count: <%=total_book_number%>,
                limit: 30,
                curr: <%=page_num%>,
                layout: ['prev', 'page', 'next', 'skip'],
                jump: function (obj, first) {
                    if(!first){
                        var url = "search.jsp?field=<%=c%>&value=<%=value%>&page_num=" + obj.curr;
                        window.location.href = url;
                }}
            });
            if(<%=total_book_number%> <= 30){
                document.getElementById('page-box').style.display="none";
            }

        });

    </script>

</body>
</html>