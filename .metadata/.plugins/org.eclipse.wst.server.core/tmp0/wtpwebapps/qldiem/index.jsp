<%
   // New location to be redirected
   String site = new String("index.html");
   response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", site); 
%>