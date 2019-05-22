<!DOCTYPE html>

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

        .content .sort {
            display: block;
            max-width: 1200px;
            line-height: 25px;
            background-color: #E2E2E2;
        }

        .content .sort .left-padding {
            float: left;
            width: 50px;
            margin: 10px 20px 0 20px;
        }

        .content .sort .sort-content {
            margin-left: 120px;
            padding: 10px 20px 10px 20px;
            width: calc(100% - 140px);
            background-color: #F2F2F2;
        }

        #sc div {
            display: inline-block;
            width: 150px;
            height: 25px;
            margin-right: 10px;
        }

        #sc div {
            /* 放不下文字...表示 */
            overflow: hidden;
            word-break: keep-all;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

    </style>
</head>

<body>

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
        <div class="layui-breadcrumb" lay-separator=">" id="breadcrumb">
            <a href="index.html">首页</a>
            <a href="">国际新闻</a>
            <a href="">亚太地区</a>
            <a><cite>正文</cite></a>
        </div>

        <div class="sort">
            <div>
                <hr style="margin-top: 20px; margin-bottom: 0;">
            </div>
            <div class="left-padding"><span>分类：</span></div>
            <div class="sort-content" id="sc">
                <div>分类1aaaaaa</div>
                <div>青少年励志/大学生指南</div>
                <div>分类1ccccc</div>
                <div>分类1ddd</div>
                <div>分类1eee</div>
                <div>微电子学、集成电路(IC)</div>
                <div>分类1</div>
                <div>分类1</div>
                <div>分类1</div>
                <div>分类1</div>
            </div>
            <div>
                <hr style="margin-top: 0; margin-bottom: 20px;">
            </div>
        </div>

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
        </div>
    </div>


    <script>
        layui.use(['form', 'element'], function () {
            var form = layui.form;
            var element = layui.element;
            element.on('tab(demo)', function (data) {
                console.log(data);
            });
        });
    </script>
</body>

</html>