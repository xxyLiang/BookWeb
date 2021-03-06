var cate_list = ['小说', '文学', '青春文学', '传记', '励志与成功', '管理', '经济', '金融与投资', '历史', '心理学', '政治/军事', '社会科学', '科普读物', '计算机与互联网', '电子与通信'];

cate_arr = {};
cate_arr[""] = [""];
cate_arr["小说"] = ['世界名著', '中国古典小说', '中国当代小说', '中国近现代小说', '乡土', '作品集', '侦探/悬疑/推理', '军事', '历史', '四大名著', '外国小说', '官场', '宫廷', '影视小说', '情感/家庭/婚姻', '惊悚/恐怖', '期刊杂志', '武侠', '港澳台小说', '社会', '科幻小说', '穿越/重生/架空', '职场', '财经', '都市', '魔幻/奇幻/玄幻'];
cate_arr["文学"] = ['中国文学', '作品集', '儿童文学', '名家作品', '外国文学', '影视文学', '戏剧曲艺', '散文/随笔/书信', '文学史', '文学理论', '文学评论与研究', '期刊杂志', '民间文学', '纪实文学', '诗歌词曲'];
cate_arr["青春文学"] = ['其他国外青春文学', '叛逆/成长', '古代言情', '大陆原创', '娱乐/偶像', '悬疑/惊悚', '校园', '港台青春文学', '爆笑/无厘头', '爱情/情感', '玄幻/科幻/新武侠', '韩国青春文学'];
cate_arr["传记"] = ['人物合集', '体坛之星', '军事人物', '历代帝王', '历史人物', '哲学家', '国学大师', '女性人物', '姓氏谱系', '学者', '宗教人物', '家族研究与传记', '建筑师/设计师', '政治人物', '教育家', '文娱明星', '文学家', '社会百相', '科学家', '经典传记', '自传', '艺术家', '财经人物', '领袖首脑'];
cate_arr["励志与成功"] = ['个人形象', '人在职场', '人际与社交', '出国/留学', '创业必修', '励志小品', '名人励志', '大师谈励志', '女性励志', '心灵鸡汤', '性格/习惯', '情商管理', '成功学', '文明礼仪', '智力与谋略', '智慧格言', '演讲与口才', '男性励志', '经典著作', '自我完善', '自我调节', '行业成功指南', '财富智慧', '青少年励志/大学生指南'];
cate_arr["管理"] = ['MBA与工商管理', '互联网+', '人力资源管理', '企业管理与培训', '供应链管理', '创业/商业史传', '商务实务', '市场营销', '战略管理', '生产与运作管理', '电子商务', '管理信息系统', '管理学', '管理工具书', '经典著作', '财务管理', '通俗读物', '项目管理', '领导学'];
cate_arr["经济"] = ['世界经济', '中国经济', '会计、审计', '工业经济', '工具书与参考书', '智能经济', '经典著作', '经济体制与改革', '经济史', '经济学理论', '经济计划与管理', '职业资格考试', '行业经济', '财政税收', '贸易经济', '通俗读物'];
cate_arr["金融与投资"] = ['个人理财', '中国金融银行', '互联网金融', '企业并购', '保险', '信用管理与信贷', '各国金融银行', '国际金融', '基金', '投资', '期货', '股票', '证券', '货币银行学', '金融市场与管理', '金融理论'];
cate_arr["历史"] = ['世界史', '中国史', '历史工具书', '历史热点', '历史研究与评论', '史学理论', '史家名著', '地方史志', '文物考古', '民族史', '经典著作', '通俗说史', '逸闻野史', '风俗习惯'];
cate_arr["心理学"] = ['人格心理学', '儿童/青少年心理学', '变态/病态心理学', '大众心理学', '女性心理学', '应用心理学', '心灵疗愈/催眠', '心理健康', '心理咨询与治疗', '心理学理论', '心理学研究方法', '心理百科', '性格色彩学', '生理心理学', '社会心理学', '经典著作'];
cate_arr["政治/军事"] = ['世界军事', '世界政治', '中国共产党', '中国军事', '中国政治', '党政读物', '公共管理', '军事史', '军事技术', '军事教材', '军事文学', '军事理论', '反恐', '各国共产党', '各国政治', '外交、国际关系', '工人、农民、青年、妇女运动与组织', '战略战术战役', '政治热点', '政治理论', '政治经典著作', '政治考试和教材', '武器装备', '经典军事著作', '马克思主义理论'];
cate_arr["社会科学"] = ['人口学', '人才学', '人类学', '公共关系', '教育', '新闻出版/档案管理', '民族学', '社会保障', '社会学', '社会生活与社会问题', '社会科学丛书、文集、连续出版物', '社会科学文献检索', '社会科学理论', '社会结构和社会关系', '社会调查', '社区', '经典著作', '统计学', '语言文字'];
cate_arr["科普读物"] = ['人类故事', '儿童科普', '地球科学', '天文航天', '数理化', '生物世界', '百科知识', '神秘现象', '科学史话', '科普图鉴'];
cate_arr["计算机与互联网"] = ['IT人文/互联网', '专用软件', '人工智能', '信息系统', '办公软件', '单片机与嵌入式', '图形图像/多媒体', '大数据与云计算', '操作系统', '数据库', '数码产品攻略', '新手学电脑', '游戏开发', '电子商务', '硬件与维护', '移动开发', '编程语言与程序设计', '网络与通信', '网页制作/Web技术', '考试认证', '计算机安全', '计算机工具书', '计算机控制与仿真', '计算机理论、基础知识', '软件工程及软件方法学', '辅助设计与工程计算'];
cate_arr["电子与通信"] = ['光电子技术、激光技术', '半导体技术', '基本电子电路', '基础与理论', '广播', '微电子学、集成电路(IC)', '无线电导航', '无线电设备、电信设备', '无线通信', '电子元件、组件', '电子对抗（干扰及抗干扰）', '电视', '真空电子技术', '移动通信', '通信', '雷达'];

layui.use(['form', 'jquery'], function () {
    var form = layui.form;
    var $ = layui.$;

    $(document).ready(function init() {
        b = document.getElementById("b_cate");
        for (var i = 0; i < cate_list.length; i++) {
            b.options.add(new Option(cate_list[i], cate_list[i]));
        }
        form.render('select');
    });

    form.on('select(b_cate)', function (data) {
        var s_obj = document.getElementById("s_cate");
        var s_list = cate_arr[data.value];
        s_obj.options.length = 1;
        for (var i = 0; i < s_list.length; i++) {
            s_obj.options.add(new Option(s_list[i], s_list[i]));
        }
        form.render('select');
    });

});

filechange = function (event) {
    var imgURL = window.URL.createObjectURL(event.target.files[0]);
    document.getElementById("show-img").src = imgURL;
}
