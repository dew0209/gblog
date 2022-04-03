<#include "/common/nav.ftl"/>
<link href="/css/show_list_blog.css" rel="stylesheet" />
<@nav "博客列表">
    <div class="body-show-blog">
        <!-- 宣传 -->
        <div class="body-part-1">Enjoy Blog</div>
        <hr>
        <div>
            <div class="form-group body-part-2">
                <input type="text" class="form-control " placeholder="搜索您想要的">
            </div>
            <button type="submit" class="btn btn-info body-part-3">搜索</button>
            <div align="right">
                <!-- 书写博客的按钮 -->
                <a href="/post/write">
                    <button type="submit" class="btn btn-info" style="margin-right: 50px;margin-bottom: 10px">写博客&nbsp;<span class="glyphicon glyphicon-pencil"></span></button>
                </a>
            </div>
        </div>
        <hr>
        <!-- 博客列表展示区域 -->
        <table class="table table-striped body-part-4" style="box-shadow: none">
            <thead>
            <tr>
                <th>标题</th>
                <th>作者</th>
                <th>日期</th>
                <th>阅读</th>
            </tr>
            </thead>
            <tbody>
                <#--  -->
                <#list res.list as item>
                    <tr>
                        <td>
                            <#-- 详情页的id显示 -->
                            <a href="">${item.title}</a>
                        </td>
                        <td>
                            <a href="/user/${item.userId}">
                                <img style="width: 35px;height: 35px;border-radius: 35px" src="${item.avatar}" alt="">&nbsp;${item.username}
                            </a>
                        </td>
                        <td>${item.created?string('MM/dd/yyyy, HH:mm:ss')}</td>
                        <td>${item.viewCount}</td>
                    </tr>
                </#list>
            </tbody>
        </table>
        <div align="right">
            <nav aria-label="Page navigation">
                <ul class="pagination" style="margin-right: 5px">
                    <li>
                        <a href="#" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <#list 1..res.totalPage as i>
                        <#if i == res.currPage>
                            <li class="active"><a href="/post/${i}">${i}</a></li>
                        </#if>
                        <#if i != res.currPage>
                            <li class=""><a href="/post/${i}">${i}</a></li>
                        </#if>
                    </#list>
                    <li class="">
                        <a href="#" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</@nav>