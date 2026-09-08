<mxGraphModel dx="1289" dy="879" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1500" pageHeight="1000" math="0" shadow="0">
  <root>
    <mxCell id="0" />
    <mxCell id="1" parent="0" />
    
    <!-- ========================================== -->
    <!-- CLIENT TIER BOUNDARY CONTAINER             -->
    <!-- ========================================== -->
    <mxCell id="box_client" parent="1" style="shape=rectangle;fillColor=none;strokeColor=#94A3B8;strokeWidth=2;dashed=1;verticalAlign=top;align=center;fontSize=14;fontStyle=1;whiteSpace=wrap;html=1;" value="CLIENT TIER (Mobile App Client - Flutter/Dart)" vertex="1">
      <mxGeometry height="280" width="1100" x="50" y="40" as="geometry" />
    </mxCell>

    <!-- Client Components -->
    <mxCell id="nd_devices" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#F8FAFC;strokeColor=#475569;strokeWidth=2;fontStyle=1;" value="User Devices&#xa;(iOS / Android Mobile &amp; Tablet)" vertex="1">
      <mxGeometry height="60" width="180" x="80" y="90" as="geometry" />
    </mxCell>
    
    <mxCell id="nd_ui" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#EFF6FF;strokeColor=#2563EB;strokeWidth=1.5;fontStyle=1;" value="Flutter Presentation UI&#xa;(Widgets, Navbar, Views)" vertex="1">
      <mxGeometry height="60" width="220" x="320" y="90" as="geometry" />
    </mxCell>
    
    <mxCell id="nd_state" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#EFF6FF;strokeColor=#2563EB;strokeWidth=1.5;" value="State &amp; Theme Manager&#xa;(AppStateNotifier, Local State)" vertex="1">
      <mxGeometry height="60" width="220" x="320" y="190" as="geometry" />
    </mxCell>
    
    <mxCell id="nd_nav" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#EFF6FF;strokeColor=#2563EB;strokeWidth=1.5;" value="GoRouter Navigation&#xa;(nav.dart Routing Engine)" vertex="1">
      <mxGeometry height="60" width="200" x="580" y="90" as="geometry" />
    </mxCell>
    
    <mxCell id="nd_sdk" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#EFF6FF;strokeColor=#2563EB;strokeWidth=2.5;fontStyle=1;" value="Supabase Client SDK&#xa;(Auth, Database, Realtime,&#xa;Service API Wrappers)" vertex="1">
      <mxGeometry height="160" width="200" x="820" y="90" as="geometry" />
    </mxCell>

    <!-- ========================================== -->
    <!-- CLOUD BACKEND BOUNDARY CONTAINER (Supabase)-->
    <!-- ========================================== -->
    <mxCell id="box_backend" parent="1" style="shape=rectangle;fillColor=none;strokeColor=#94A3B8;strokeWidth=2;dashed=1;verticalAlign=top;align=center;fontSize=14;fontStyle=1;whiteSpace=wrap;html=1;" value="CLOUD BACKEND TIER (Supabase BaaS)" vertex="1">
      <mxGeometry height="420" width="760" x="50" y="420" as="geometry" />
    </mxCell>

    <!-- Backend Components -->
    <mxCell id="nd_auth" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=1.5;fontStyle=1;" value="Supabase Auth Engine&#xa;(JWT &amp; Session Tokens Manager)" vertex="1">
      <mxGeometry height="60" width="220" x="80" y="470" as="geometry" />
    </mxCell>
    
    <mxCell id="nd_rls" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFBEB;strokeColor=#D97706;strokeWidth=1.5;fontStyle=1;" value="PostgreSQL RLS Policies&#xa;(Role-Based Access Rules)" vertex="1">
      <mxGeometry height="60" width="220" x="80" y="570" as="geometry" />
    </mxCell>
    
    <mxCell id="nd_db" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=2.5;fontStyle=1;" value="PostgreSQL Database Engine&#xa;&#xa;Schema Tables:&#xa;- User &amp; Patient &amp; Dentist&#xa;- Appointment &amp; Leave_Request&#xa;- History &amp; Payments&#xa;- Notification" vertex="1">
      <mxGeometry height="160" width="240" x="360" y="470" as="geometry" />
    </mxCell>
    
    <mxCell id="nd_realtime" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=1.5;" value="Supabase Realtime Channel&#xa;(WebSockets Listeners)" vertex="1">
      <mxGeometry height="60" width="220" x="80" y="670" as="geometry" />
    </mxCell>
    
    <mxCell id="nd_webhooks" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=1.5;" value="Database Event Webhooks&#xa;(Triggers on changes)" vertex="1">
      <mxGeometry height="60" width="240" x="360" y="670" as="geometry" />
    </mxCell>

    <!-- ========================================== -->
    <!-- EXTERNAL INTEGRATIONS BOUNDARY CONTAINER   -->
    <!-- ========================================== -->
    <mxCell id="box_external" parent="1" style="shape=rectangle;fillColor=none;strokeColor=#94A3B8;strokeWidth=2;dashed=1;verticalAlign=top;align=center;fontSize=14;fontStyle=1;whiteSpace=wrap;html=1;" value="EXTERNAL INTEGRATIONS TIER" vertex="1">
      <mxGeometry height="420" width="300" x="850" y="420" as="geometry" />
    </mxCell>

    <!-- External Components -->
    <mxCell id="nd_fcm" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#F3E8FF;strokeColor=#7E22CE;strokeWidth=1.5;fontStyle=1;" value="Firebase Cloud Messaging&#xa;(FCM &amp; APNs Push Services)" vertex="1">
      <mxGeometry height="70" width="220" x="890" y="470" as="geometry" />
    </mxCell>
    
    <mxCell id="nd_ai" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#F3E8FF;strokeColor=#7E22CE;strokeWidth=1.5;fontStyle=1;" value="AI Prediction &amp; Chatbot API&#xa;(Gemini/OpenAI endpoint)&#xa;- Traffic Prediction&#xa;- Automated FAQs Bot" vertex="1">
      <mxGeometry height="80" width="220" x="890" y="600" as="geometry" />
    </mxCell>

    <!-- ========================================== -->
    <!-- FLOW ARROWS                                -->
    <!-- ========================================== -->
    
    <!-- Client Internal Flows -->
    <mxCell id="edge_dev_ui" value="Render / Touch Inputs" edge="1" parent="1" source="nd_devices" target="nd_ui" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#475569;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="edge_ui_state" value="Bind variables" edge="1" parent="1" source="nd_ui" target="nd_state" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.2;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="edge_ui_nav" value="Redirect actions" edge="1" parent="1" source="nd_ui" target="nd_nav" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.2;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="edge_ui_sdk" value="Data queries" edge="1" parent="1" source="nd_ui" target="nd_sdk" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="540" y="70"/><mxPoint x="830" y="70"/></Array></mxGeometry>
    </mxCell>

    <!-- Client to Backend Flows -->
    <mxCell id="edge_sdk_auth" value="HTTPS Auth queries" edge="1" parent="1" source="nd_sdk" target="nd_auth" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="920" y="320"/><mxPoint x="190" y="320"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="edge_sdk_rls" value="HTTPS REST (PostgREST)" edge="1" parent="1" source="nd_sdk" target="nd_rls" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="870" y="350"/><mxPoint x="290" y="350"/><mxPoint x="290" y="600"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="edge_rls_db" value="CRUD execution" edge="1" parent="1" source="nd_rls" target="nd_db" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#D97706;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="edge_sdk_realtime" value="WebSockets (WSS)" edge="1" parent="1" source="nd_sdk" target="nd_realtime" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="790" y="380"/><mxPoint x="140" y="380"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="edge_realtime_db" value="Pub/Sub changes" edge="1" parent="1" source="nd_realtime" target="nd_db" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#0D9488;strokeWidth=1.2;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="320" y="700"/><mxPoint x="320" y="610"/></Array></mxGeometry>
    </mxCell>

    <!-- Webhooks & Integrations Flows -->
    <mxCell id="edge_db_webhooks" value="Emit Database Event" edge="1" parent="1" source="nd_db" target="nd_webhooks" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#0D9488;strokeWidth=1.2;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="edge_webhooks_fcm" value="Post Payload" edge="1" parent="1" source="nd_webhooks" target="nd_fcm" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#0D9488;strokeWidth=1.2;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="640" y="700"/><mxPoint x="640" y="505"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="edge_fcm_dev" value="Push Notification Alerts" edge="1" parent="1" source="nd_fcm" target="nd_devices" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#7E22CE;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="1000" y="360"/><mxPoint x="110" y="360"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="edge_sdk_ai" value="REST JSON requests" edge="1" parent="1" source="nd_sdk" target="nd_ai" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="960" y="300"/><mxPoint x="960" y="300"/></Array></mxGeometry>
    </mxCell>

  </root>
</mxGraphModel>
