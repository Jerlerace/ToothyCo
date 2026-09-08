<mxGraphModel dx="1289" dy="879" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1500" pageHeight="1000" math="0" shadow="0">
  <root>
    <mxCell id="0" />
    <mxCell id="1" parent="0" />
    
    <!-- ========================================== -->
    <!-- EXTERNAL ENTITIES / ACTORS (Slate Theme)   -->
    <!-- ========================================== -->
    <mxCell id="act_patient" parent="1" style="shape=rectangle;whiteSpace=wrap;html=1;fillColor=#F8FAFC;strokeColor=#475569;strokeWidth=2.5;fontStyle=1;" value="Patient&#xa;(Mobile App User)" vertex="1">
      <mxGeometry height="60" width="140" x="60" y="240" as="geometry" />
    </mxCell>
    
    <mxCell id="act_dentist" parent="1" style="shape=rectangle;whiteSpace=wrap;html=1;fillColor=#F8FAFC;strokeColor=#475569;strokeWidth=2.5;fontStyle=1;" value="Dentist&#xa;(Mobile/Tablet User)" vertex="1">
      <mxGeometry height="60" width="140" x="60" y="480" as="geometry" />
    </mxCell>
    
    <mxCell id="act_admin" parent="1" style="shape=rectangle;whiteSpace=wrap;html=1;fillColor=#F8FAFC;strokeColor=#475569;strokeWidth=2.5;fontStyle=1;" value="Admin&#xa;(Clinic Manager)" vertex="1">
      <mxGeometry height="60" width="140" x="60" y="720" as="geometry" />
    </mxCell>

    <!-- ========================================== -->
    <!-- PROCESSES (Blue Theme)                    -->
    <!-- ========================================== -->
    <mxCell id="prc_auth" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#EFF6FF;strokeColor=#2563EB;strokeWidth=2;fontStyle=1;" value="1.0 Authentication &amp;&#xa;Role Assignment" vertex="1">
      <mxGeometry height="60" width="240" x="360" y="80" as="geometry" />
    </mxCell>
    
    <mxCell id="prc_booking" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#EFF6FF;strokeColor=#2563EB;strokeWidth=2;fontStyle=1;" value="2.0 Appointment Booking&#xa;&amp; Validation" vertex="1">
      <mxGeometry height="60" width="240" x="360" y="240" as="geometry" />
    </mxCell>
    
    <mxCell id="prc_schedule" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#EFF6FF;strokeColor=#2563EB;strokeWidth=2;fontStyle=1;" value="3.0 Schedule &amp;&#xa;Leave Management" vertex="1">
      <mxGeometry height="60" width="240" x="360" y="400" as="geometry" />
    </mxCell>
    
    <mxCell id="prc_records" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#EFF6FF;strokeColor=#2563EB;strokeWidth=2;fontStyle=1;" value="4.0 Medical Records&#xa;&amp; Treatment Logs" vertex="1">
      <mxGeometry height="60" width="240" x="360" y="560" as="geometry" />
    </mxCell>
    
    <mxCell id="prc_billing" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#EFF6FF;strokeColor=#2563EB;strokeWidth=2;fontStyle=1;" value="5.0 Cost Transparency&#xa;&amp; Billing Management" vertex="1">
      <mxGeometry height="60" width="240" x="360" y="720" as="geometry" />
    </mxCell>
    
    <mxCell id="prc_notification" parent="1" style="shape=rectangle;rounded=1;whiteSpace=wrap;html=1;fillColor=#EFF6FF;strokeColor=#2563EB;strokeWidth=2;fontStyle=1;" value="6.0 In-App Alerts&#xa;&amp; Dispatcher" vertex="1">
      <mxGeometry height="60" width="240" x="360" y="880" as="geometry" />
    </mxCell>

    <!-- ========================================== -->
    <!-- DATA STORES (Teal Theme, Open Sides)       -->
    <!-- ========================================== -->
    <mxCell id="sto_users" parent="1" style="shape=partialRectangle;top=1;bottom=1;left=0;right=0;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=2;fontStyle=1;" value="D1 User &amp; Profile Tables" vertex="1">
      <mxGeometry height="60" width="240" x="800" y="80" as="geometry" />
    </mxCell>
    
    <mxCell id="sto_appointments" parent="1" style="shape=partialRectangle;top=1;bottom=1;left=0;right=0;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=2;fontStyle=1;" value="D2 Appointments Table" vertex="1">
      <mxGeometry height="60" width="240" x="800" y="240" as="geometry" />
    </mxCell>
    
    <mxCell id="sto_availability" parent="1" style="shape=partialRectangle;top=1;bottom=1;left=0;right=0;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=2;fontStyle=1;" value="D3 Dentist Availability Table" vertex="1">
      <mxGeometry height="60" width="240" x="800" y="380" as="geometry" />
    </mxCell>
    
    <mxCell id="sto_leave" parent="1" style="shape=partialRectangle;top=1;bottom=1;left=0;right=0;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=2;fontStyle=1;" value="D4 Leave Requests Table" vertex="1">
      <mxGeometry height="60" width="240" x="800" y="480" as="geometry" />
    </mxCell>
    
    <mxCell id="sto_history" parent="1" style="shape=partialRectangle;top=1;bottom=1;left=0;right=0;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=2;fontStyle=1;" value="D5 Treatment History Table" vertex="1">
      <mxGeometry height="60" width="240" x="800" y="580" as="geometry" />
    </mxCell>
    
    <mxCell id="sto_procedures" parent="1" style="shape=partialRectangle;top=1;bottom=1;left=0;right=0;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=2;fontStyle=1;" value="D6 Procedures Table" vertex="1">
      <mxGeometry height="60" width="240" x="800" y="700" as="geometry" />
    </mxCell>
    
    <mxCell id="sto_payments" parent="1" style="shape=partialRectangle;top=1;bottom=1;left=0;right=0;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=2;fontStyle=1;" value="D7 Payments Table" vertex="1">
      <mxGeometry height="60" width="240" x="800" y="800" as="geometry" />
    </mxCell>
    
    <mxCell id="sto_notifications" parent="1" style="shape=partialRectangle;top=1;bottom=1;left=0;right=0;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=2;fontStyle=1;" value="D8 Notifications Table" vertex="1">
      <mxGeometry height="60" width="240" x="800" y="880" as="geometry" />
    </mxCell>

    <!-- ========================================== -->
    <!-- DATA FLOW EDGES (Labeled Arrows)          -->
    <!-- ========================================== -->
    
    <!-- 1.0 Auth Flow Connections -->
    <mxCell id="flow_pat_to_p1" value="Registration Details (email, password)" edge="1" parent="1" source="act_patient" target="prc_auth" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#475569;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="240" y="250"/><mxPoint x="240" y="90"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="flow_den_to_p1" value="Credentials &amp; Specialization details" edge="1" parent="1" source="act_dentist" target="prc_auth" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#475569;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="260" y="490"/><mxPoint x="260" y="110"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="flow_adm_to_p1" value="User Role Changes (Patient &lt;&gt; Dentist)" edge="1" parent="1" source="act_admin" target="prc_auth" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#475569;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="280" y="730"/><mxPoint x="280" y="130"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="flow_p1_to_pat" value="Session Tokens &amp; Dashboard access" edge="1" parent="1" source="prc_auth" target="act_patient" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="300" y="120"/><mxPoint x="300" y="270"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="flow_p1_to_d1" value="Create/Update user profile record" edge="1" parent="1" source="prc_auth" target="sto_users" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="flow_d1_to_p1" value="Read credentials &amp; verify roles" edge="1" parent="1" source="sto_users" target="prc_auth" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#0D9488;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="720" y="120"/><mxPoint x="720" y="120"/></Array></mxGeometry>
    </mxCell>

    <!-- 2.0 Booking Flow Connections -->
    <mxCell id="flow_pat_to_p2" value="Booking request (Date, Time, Doctor)" edge="1" parent="1" source="act_patient" target="prc_booking" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#059669;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="flow_p2_to_pat" value="Status updates &amp; confirmations" edge="1" parent="1" source="prc_booking" target="act_patient" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="270" y="290"/><mxPoint x="270" y="290"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="flow_p2_to_d2" value="Insert/Update appointment row" edge="1" parent="1" source="prc_booking" target="sto_appointments" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="flow_p2_to_d3" value="Query slots to avoid double-bookings" edge="1" parent="1" source="prc_booking" target="sto_availability" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="680" y="280"/><mxPoint x="680" y="400"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="flow_p2_to_d6" value="Read procedure durations" edge="1" parent="1" source="prc_booking" target="sto_procedures" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="650" y="290"/><mxPoint x="650" y="710"/></Array></mxGeometry>
    </mxCell>

    <!-- 3.0 Scheduling & Leave Connections -->
    <mxCell id="flow_den_to_p3" value="Leave requests &amp; active work hours" edge="1" parent="1" source="act_dentist" target="prc_schedule" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#0D9488;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="flow_adm_to_p3" value="Leave decisions (Approve/Reject)" edge="1" parent="1" source="act_admin" target="prc_schedule" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#F43F5E;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="250" y="740"/><mxPoint x="250" y="440"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="flow_p3_to_d3" value="Upsert weekly schedule availability" edge="1" parent="1" source="prc_schedule" target="sto_availability" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="flow_p3_to_d4" value="Insert leave application records" edge="1" parent="1" source="prc_schedule" target="sto_leave" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="690" y="440"/><mxPoint x="690" y="500"/></Array></mxGeometry>
    </mxCell>

    <!-- 4.0 Medical Records & Treatment Connections -->
    <mxCell id="flow_den_to_p4" value="Log treatments (procedure_id, notes)" edge="1" parent="1" source="act_dentist" target="prc_records" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#0D9488;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="270" y="530"/><mxPoint x="270" y="580"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="flow_adm_to_p4" value="Upsert patient demographics" edge="1" parent="1" source="act_admin" target="prc_records" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#F43F5E;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="270" y="760"/><mxPoint x="270" y="600"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="flow_p4_to_d5" value="Insert completed treatment details" edge="1" parent="1" source="prc_records" target="sto_history" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="flow_p4_to_d1" value="Update patient allergies &amp; medical info" edge="1" parent="1" source="prc_records" target="sto_users" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="640" y="580"/><mxPoint x="640" y="110"/></Array></mxGeometry>
    </mxCell>

    <!-- 5.0 Billing & Pricing Connections -->
    <mxCell id="flow_pat_to_p5" value="Read pricing catalogs" edge="1" parent="1" source="act_patient" target="prc_billing" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#059669;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="210" y="270"/><mxPoint x="210" y="730"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="flow_adm_to_p5" value="Update procedure catalog fees" edge="1" parent="1" source="act_admin" target="prc_billing" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#F43F5E;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="flow_p5_to_d6" value="Query procedure rates &amp; edit costs" edge="1" parent="1" source="prc_billing" target="sto_procedures" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="670" y="740"/><mxPoint x="670" y="720"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="flow_p5_to_d7" value="Generate/Log invoice details" edge="1" parent="1" source="prc_billing" target="sto_payments" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="680" y="760"/><mxPoint x="680" y="820"/></Array></mxGeometry>
    </mxCell>

    <!-- 6.0 Notification Flow Connections -->
    <mxCell id="flow_p6_to_d8" value="Insert push/in-app alert record" edge="1" parent="1" source="prc_notification" target="sto_notifications" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#2563EB;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="flow_d8_to_p6" value="Fetch user's unread notifications" edge="1" parent="1" source="sto_notifications" target="prc_notification" style="edgeStyle=orthogonalEdgeStyle;round=1;html=1;strokeColor=#0D9488;strokeWidth=1.5;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="750" y="910"/><mxPoint x="750" y="910"/></Array></mxGeometry>
    </mxCell>

  </root>
</mxGraphModel>
