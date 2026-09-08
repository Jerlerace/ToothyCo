<mxGraphModel dx="1289" dy="879" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1500" pageHeight="1050" math="0" shadow="0">
  <root>
    <mxCell id="0" />
    <mxCell id="1" parent="0" />
    
    <!-- ========================================== -->
    <!-- SYSTEM BOUNDARY                            -->
    <!-- ========================================== -->
    <mxCell id="system_boundary" parent="1" style="shape=rectangle;fillColor=none;strokeColor=#94A3B8;strokeWidth=2;dashed=1;verticalAlign=top;align=center;fontSize=14;fontStyle=1;whiteSpace=wrap;html=1;" value="Toothy Clinic Mobile App System" vertex="1">
      <mxGeometry height="980" width="760" x="200" y="20" as="geometry" />
    </mxCell>

    <!-- ========================================== -->
    <!-- ACTORS (UML Stick Figures)                 -->
    <!-- ========================================== -->
    <mxCell id="act_patient" parent="1" style="shape=umlActor;whiteSpace=wrap;html=1;fillColor=#ECFDF5;strokeColor=#059669;strokeWidth=2;verticalLabelPosition=bottom;verticalAlign=top;align=center;fontStyle=1;" value="Patient" vertex="1">
      <mxGeometry height="80" width="40" x="60" y="240" as="geometry" />
    </mxCell>
    
    <mxCell id="act_dentist" parent="1" style="shape=umlActor;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=2;verticalLabelPosition=bottom;verticalAlign=top;align=center;fontStyle=1;" value="Dentist" vertex="1">
      <mxGeometry height="80" width="40" x="60" y="560" as="geometry" />
    </mxCell>
    
    <mxCell id="act_admin" parent="1" style="shape=umlActor;whiteSpace=wrap;html=1;fillColor=#FFF1F2;strokeColor=#E11D48;strokeWidth=2;verticalLabelPosition=bottom;verticalAlign=top;align=center;fontStyle=1;" value="Admin" vertex="1">
      <mxGeometry height="80" width="40" x="1020" y="440" as="geometry" />
    </mxCell>

    <!-- ========================================== -->
    <!-- SHARED USE CASES (Slate Theme)             -->
    <!-- ========================================== -->
    <mxCell id="uc_auth" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#F8FAFC;strokeColor=#475569;strokeWidth=1.5;fontStyle=1;align=center;" value="Register &amp; Login" vertex="1">
      <mxGeometry height="60" width="160" x="380" y="50" as="geometry" />
    </mxCell>
    
    <mxCell id="uc_profile" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#F8FAFC;strokeColor=#475569;strokeWidth=1.5;fontStyle=1;align=center;" value="Manage Profile &amp; Settings" vertex="1">
      <mxGeometry height="60" width="180" x="580" y="50" as="geometry" />
    </mxCell>

    <!-- ========================================== -->
    <!-- PATIENT USE CASES (Green Theme)            -->
    <!-- ========================================== -->
    <mxCell id="uc_view_pricing" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#ECFDF5;strokeColor=#059669;strokeWidth=1.5;fontStyle=1;align=center;" value="View Procedures&#xa;&amp; Est. Prices" vertex="1">
      <mxGeometry height="60" width="180" x="240" y="160" as="geometry" />
    </mxCell>
    
    <mxCell id="uc_book_appt" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#ECFDF5;strokeColor=#059669;strokeWidth=1.5;fontStyle=1;align=center;" value="Book Dental Appointment" vertex="1">
      <mxGeometry height="60" width="180" x="480" y="160" as="geometry" />
    </mxCell>
    
    <mxCell id="uc_patient_history" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#ECFDF5;strokeColor=#059669;strokeWidth=1.5;fontStyle=1;align=center;" value="View Personal&#xa;Treatment History" vertex="1">
      <mxGeometry height="60" width="180" x="700" y="160" as="geometry" />
    </mxCell>
    
    <mxCell id="uc_ai_chatbot" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#ECFDF5;strokeColor=#059669;strokeWidth=1.5;fontStyle=1;align=center;" value="Chat with AI FAQ Bot" vertex="1">
      <mxGeometry height="60" width="180" x="340" y="260" as="geometry" />
    </mxCell>
    
    <mxCell id="uc_notifications" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#ECFDF5;strokeColor=#059669;strokeWidth=1.5;fontStyle=1;align=center;" value="Receive Push Alerts&#xa;(Booking/Reminders)" vertex="1">
      <mxGeometry height="60" width="180" x="580" y="260" as="geometry" />
    </mxCell>

    <!-- ========================================== -->
    <!-- DENTIST USE CASES (Teal Theme)             -->
    <!-- ========================================== -->
    <mxCell id="uc_set_avail" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=1.5;fontStyle=1;align=center;" value="Manage Weekly&#xa;Availability Slots" vertex="1">
      <mxGeometry height="60" width="180" x="240" y="440" as="geometry" />
    </mxCell>
    
    <mxCell id="uc_request_leave" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=1.5;fontStyle=1;align=center;" value="Submit Leave Application&#xa;&amp; Date Blocks" vertex="1">
      <mxGeometry height="60" width="200" x="460" y="440" as="geometry" />
    </mxCell>
    
    <mxCell id="uc_view_appts" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=1.5;fontStyle=1;align=center;" value="View Assigned Appointments&#xa;&amp; Today's Patients" vertex="1">
      <mxGeometry height="60" width="200" x="700" y="440" as="geometry" />
    </mxCell>
    
    <mxCell id="uc_log_treatment" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=1.5;fontStyle=1;align=center;" value="Log Treatment Records&#xa;&amp; Medical Notes" vertex="1">
      <mxGeometry height="60" width="190" x="320" y="540" as="geometry" />
    </mxCell>
    
    <mxCell id="uc_dentist_analytics" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#F0FDFA;strokeColor=#0D9488;strokeWidth=1.5;fontStyle=1;align=center;" value="View Dentist Analytics&#xa;(Fulfillment Rates)" vertex="1">
      <mxGeometry height="60" width="190" x="560" y="540" as="geometry" />
    </mxCell>

    <!-- ========================================== -->
    <!-- ADMIN USE CASES (Rose Theme)               -->
    <!-- ========================================== -->
    <mxCell id="uc_user_mgmt" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFF1F2;strokeColor=#E11D48;strokeWidth=1.5;fontStyle=1;align=center;" value="Manage User Accounts&#xa;&amp; System Roles" vertex="1">
      <mxGeometry height="60" width="200" x="240" y="700" as="geometry" />
    </mxCell>
    
    <mxCell id="uc_dentist_reqs" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFF1F2;strokeColor=#E11D48;strokeWidth=1.5;fontStyle=1;align=center;" value="Review Dentist Signup&#xa;Registration Requests" vertex="1">
      <mxGeometry height="60" width="210" x="500" y="700" as="geometry" />
    </mxCell>
    
    <mxCell id="uc_patient_mgmt" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFF1F2;strokeColor=#E11D48;strokeWidth=1.5;fontStyle=1;align=center;" value="Manage Patient Records&#xa;(Add/Edit/Deactivate)" vertex="1">
      <mxGeometry height="60" width="200" x="240" y="800" as="geometry" />
    </mxCell>
    
    <mxCell id="uc_procedures_pricing" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFF1F2;strokeColor=#E11D48;strokeWidth=1.5;fontStyle=1;align=center;" value="Configure Dental Procedures&#xa;&amp; Pricing Rates" vertex="1">
      <mxGeometry height="60" width="210" x="480" y="800" as="geometry" />
    </mxCell>
    
    <mxCell id="uc_leave_approvals" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFF1F2;strokeColor=#E11D48;strokeWidth=1.5;fontStyle=1;align=center;" value="Approve/Reject Dentist&#xa;Leave Applications" vertex="1">
      <mxGeometry height="60" width="200" x="720" y="800" as="geometry" />
    </mxCell>
    
    <mxCell id="uc_clinic_analytics" parent="1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#FFF1F2;strokeColor=#E11D48;strokeWidth=1.5;fontStyle=1;align=center;" value="View Clinic Dashboard&#xa;(Revenue, Popular Treatments)" vertex="1">
      <mxGeometry height="60" width="230" x="470" y="890" as="geometry" />
    </mxCell>

    <!-- ========================================== -->
    <!-- ACTOR ASSOCIATIONS                         -->
    <!-- ========================================== -->
    
    <!-- Patient Associations -->
    <mxCell id="edge_pat_auth" edge="1" parent="1" source="act_patient" target="uc_auth" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="edge_pat_profile" edge="1" parent="1" source="act_patient" target="uc_profile" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="edge_pat_pricing" edge="1" parent="1" source="act_patient" target="uc_view_pricing" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="edge_pat_book" edge="1" parent="1" source="act_patient" target="uc_book_appt" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="edge_pat_history" edge="1" parent="1" source="act_patient" target="uc_patient_history" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="edge_pat_chatbot" edge="1" parent="1" source="act_patient" target="uc_ai_chatbot" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="edge_pat_notify" edge="1" parent="1" source="act_patient" target="uc_notifications" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>

    <!-- Dentist Associations -->
    <mxCell id="edge_den_auth" edge="1" parent="1" source="act_dentist" target="uc_auth" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="180" y="550"/><mxPoint x="180" y="100"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="edge_den_profile" edge="1" parent="1" source="act_dentist" target="uc_profile" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="190" y="560"/><mxPoint x="190" y="110"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="edge_den_set_avail" edge="1" parent="1" source="act_dentist" target="uc_set_avail" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="edge_den_leave" edge="1" parent="1" source="act_dentist" target="uc_request_leave" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="edge_den_appts" edge="1" parent="1" source="act_dentist" target="uc_view_appts" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="edge_den_log_treat" edge="1" parent="1" source="act_dentist" target="uc_log_treatment" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="edge_den_anal" edge="1" parent="1" source="act_dentist" target="uc_dentist_analytics" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    
    <!-- Admin Associations -->
    <mxCell id="edge_adm_auth" edge="1" parent="1" source="act_admin" target="uc_auth" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="980" y="430"/><mxPoint x="980" y="100"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="edge_adm_profile" edge="1" parent="1" source="act_admin" target="uc_profile" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="970" y="440"/><mxPoint x="970" y="110"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="edge_adm_users" edge="1" parent="1" source="act_admin" target="uc_user_mgmt" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="970" y="480"/><mxPoint x="970" y="730"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="edge_adm_reqs" edge="1" parent="1" source="act_admin" target="uc_dentist_reqs" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="960" y="490"/><mxPoint x="960" y="740"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="edge_adm_patients" edge="1" parent="1" source="act_admin" target="uc_patient_mgmt" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="980" y="500"/><mxPoint x="980" y="830"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="edge_adm_proc" edge="1" parent="1" source="act_admin" target="uc_procedures_pricing" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="970" y="510"/><mxPoint x="970" y="840"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="edge_adm_leave" edge="1" parent="1" source="act_admin" target="uc_leave_approvals" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="960" y="520"/><mxPoint x="960" y="850"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="edge_adm_anal" edge="1" parent="1" source="act_admin" target="uc_clinic_analytics" style="edgeStyle=none;html=1;strokeColor=#475569;strokeWidth=1.5;endArrow=none;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="950" y="530"/><mxPoint x="950" y="920"/></Array></mxGeometry>
    </mxCell>

    <!-- ========================================== -->
    <!-- INCLUDE & EXTEND RELATIONSHIPS             -->
    <!-- ========================================== -->
    <mxCell id="rel_book_pricing" value="&lt;&lt;include&gt;&gt;" edge="1" parent="1" source="uc_book_appt" target="uc_view_pricing" style="edgeStyle=orthogonalEdgeStyle;dashed=1;html=1;strokeColor=#64748B;strokeWidth=1.2;endArrow=open;endSize=8;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="rel_book_notify" value="&lt;&lt;include&gt;&gt;" edge="1" parent="1" source="uc_book_appt" target="uc_notifications" style="edgeStyle=orthogonalEdgeStyle;dashed=1;html=1;strokeColor=#64748B;strokeWidth=1.2;endArrow=open;endSize=8;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="570" y="240"/><mxPoint x="670" y="240"/></Array></mxGeometry>
    </mxCell>
    <mxCell id="rel_leave_notify" value="&lt;&lt;include&gt;&gt;" edge="1" parent="1" source="uc_leave_approvals" target="uc_notifications" style="edgeStyle=orthogonalEdgeStyle;dashed=1;html=1;strokeColor=#64748B;strokeWidth=1.2;endArrow=open;endSize=8;labelBackgroundColor=#ffffff;">
      <mxGeometry relative="1" as="geometry"><Array as="points"><mxPoint x="820" y="360"/><mxPoint x="670" y="360"/></Array></mxGeometry>
    </mxCell>

  </root>
</mxGraphModel>
