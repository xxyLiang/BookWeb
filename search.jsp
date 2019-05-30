<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.util.*, java.sql.*, javax.sql.*, javax.naming.*, org.apache.commons.lang3.*" %>
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
            top: 0;
            left: 0;
            width: 380px;
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
    request.setCharacterEncoding("UTF-8");

    String c = null;
    int choose = 0;
	String value = null;
    String p = null;
    int page_num = 1;

    try{
        c = request.getParameter("field");
        value = request.getParameter("value");
        value = StringEscapeUtils.unescapeHtml4(value);
        if(value.equals("") || c.equals("")){
            response.sendRedirect("index.html");
        }
        choose = Integer.parseInt(c);
    } catch (Exception e) {}
    
    try{
        p = request.getParameter("page_num");
        page_num = Integer.parseInt(p);
    } catch (Exception e) {}

    int start = 30 * (page_num - 1);
  
	Context initContext = new InitialContext();
	Context envContext  = (Context)initContext.lookup("java:/comp/env");
	DataSource ds = (DataSource)envContext.lookup("jdbc/book"); 
	Connection conn = null;
    PreparedStatement psmt = null;
    PreparedStatement psmt2 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
    String[] field = {"书名", "作者", "出版社"};

    ArrayList book_list = new ArrayList();
    int book_number = 0;
    int total_book_number = 0;

	try {
		conn = ds.getConnection();			
        if(c != null)
        {
            if(choose==0){
                psmt = conn.prepareStatement("select * from books where book_name like ? limit ?,30");
                psmt2 = conn.prepareStatement("select count(*) from books where book_name like ?");
            }
            else if(choose==1){
                psmt = conn.prepareStatement("select * from books where author like ? limit ?,30");
                psmt2 = conn.prepareStatement("select count(*) from books where author like ?");
            }
            else {
                psmt = conn.prepareStatement("select * from books where press like ? limit ?,30");
                psmt2 = conn.prepareStatement("select count(*) from books where press like ?");
            }
            psmt.setString(1, "%"+value+"%");
            psmt.setInt(2, start);
            psmt2.setString(1, "%"+value+"%");
        } else{
            psmt = conn.prepareStatement("select * from books where user_define=1 order by ts desc limit ?,30");
            psmt2 = conn.prepareStatement("select count(*) from books where user_define=1");
            psmt.setInt(1, start);
        }
        rs = psmt.executeQuery();
        rs2 = psmt2.executeQuery();
        
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

        if(rs2.next()) {
            total_book_number = rs2.getInt(1);
        }

        rs.close();
        rs2.close();
	} catch (Exception e) {
		throw e;
	} finally {
        book_number = book_list.size();
        value = StringEscapeUtils.escapeHtml4(value);
		try {
			if (psmt != null) psmt.close();
			if (psmt2 != null) psmt2.close();
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
    <div class="heading">
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
                    <input type="text" name="value" title="输入你的检索词" class="layui-input" id="input-box"
                    onkeyup="this.value=this.value.replace(/[%]/g,'')" required>
                </div>
                <button class="layui-btn layui-btn-primary" type="submit">
                    <i class="layui-icon">&#xe615;</i>
                </button>
            </div>
        </form> 
        <div class="layui-inline" style="float:right; margin-right: 20px;">
            <a href="insertpage.html">
                <button class="layui-btn function-button" type="button">新增图书</button>
            </a>
            <a href="search.jsp" style="margin-left: 10px;">
                <button class="layui-btn function-button" type="button">我的图书</button>
            </a>
        </div>
    </div>

    <div class="content">
        <%-- 面包屑 --%>
        <div class="layui-breadcrumb" lay-separator=">" id="breadcrumb">
            <a href="index.html">首页</a>
            <%if(c!=null){%>
            <a><cite><%=field[choose]%>：<%=value%></cite></a>
            <%}else{%>
            <a><cite>我的图书</cite></a>
            <%}%>
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
            String id = StringEscapeUtils.escapeHtml4(book.get("id"));
            String b_cate = book.get("b_cate");
            String s_cate = book.get("s_cate");
            String name = StringEscapeUtils.escapeHtml4(book.get("name")); 
            String author = StringEscapeUtils.escapeHtml4(book.get("author")); 
            String discription = StringEscapeUtils.escapeHtml4(book.get("discription")); 
            String press = StringEscapeUtils.escapeHtml4(book.get("press")); 
            String image = StringEscapeUtils.escapeHtml4(book.get("image")); 
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
                            <a href="updatepage.jsp?id=<%=id%>">
                                <button class="layui-btn layui-btn-primary">修改内容</button>
                            </a>
                            <a href="delete.jsp?id=<%=id%>" onclick="if(confirm('确定删除?')==false) return false;">
                                <button class="layui-btn layui-btn-primary">删除书本</button>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>  
        </div>
        <div id='page-box'></div>
    </div>

    <script>

        layui.use('laypage', function () {
            var laypage = layui.laypage;
            laypage.render({
                elem: 'page-box',
                count: <%=total_book_number%>,
                limit: 30,
                curr: <%=page_num%>,
                layout: ['prev', 'page', 'next', 'skip'],
                jump: function (obj, first) {
                    if(!first){
                        if(<%=c%>!=null){
                            var v = encodeURI("<%=value%>");
                            var url = "search.jsp?field=<%=c%>&value="+ v +"&page_num=" + obj.curr;
                        }
                        else{
                            var url = "search.jsp?page_num=" + obj.curr;
                        }
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