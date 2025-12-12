<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 
    此页面由HomeController根据用户角色自动跳转到对应的首页
    如果直接访问此页面，则根据session中的用户角色进行跳转
--%>
<c:choose>
    <c:when test="${sessionScope.user.role == 'student'}">
        <jsp:forward page="student/index.jsp"/>
    </c:when>
    <c:when test="${sessionScope.user.role == 'teacher'}">
        <jsp:forward page="teacher/index.jsp"/>
    </c:when>
    <c:when test="${sessionScope.user.role == 'admin'}">
        <jsp:forward page="admin/index.jsp"/>
    </c:when>
    <c:otherwise>
        <script type="text/javascript">
            window.location.href = "/login";
        </script>
    </c:otherwise>
</c:choose>
