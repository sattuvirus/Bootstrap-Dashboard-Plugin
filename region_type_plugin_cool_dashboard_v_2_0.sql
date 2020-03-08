prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.4.00.08'
,p_default_workspace_id=>1810418193191039
,p_default_application_id=>108
,p_default_owner=>'ADMIN'
);
end;
/
prompt --application/shared_components/plugins/region_type/cool_dashboard_v_2_0
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(21910779863318360)
,p_plugin_type=>'REGION TYPE'
,p_name=>'COOL.DASHBOARD_V_2.0'
,p_display_name=>'Cool Dashboard V 2.0'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FUNCTION SQL_TO_SYS_REFCURSOR (',
'    P_IN_SQL_STATEMENT   CLOB,',
'    P_IN_BINDS           SYS.DBMS_SQL.VARCHAR2_TABLE',
') RETURN SYS_REFCURSOR AS',
'    VR_CURS         BINARY_INTEGER;',
'    VR_REF_CURSOR   SYS_REFCURSOR;',
'    VR_EXEC         BINARY_INTEGER;',
'/* TODO make size dynamic */',
'    VR_BINDS        VARCHAR(100);',
'BEGIN',
'    VR_CURS         := DBMS_SQL.OPEN_CURSOR;',
'    DBMS_SQL.PARSE(',
'        VR_CURS,',
'        P_IN_SQL_STATEMENT,',
'        DBMS_SQL.NATIVE',
'    );',
'    IF P_IN_BINDS.COUNT > 0 THEN',
'        FOR I IN 1..P_IN_BINDS.COUNT LOOP',
'        /* TODO find out how to prevent ltrim */',
'            VR_BINDS   := LTRIM(',
'                P_IN_BINDS(I),',
'                '':''',
'            );',
'            DBMS_SQL.BIND_VARIABLE(',
'                VR_CURS,',
'                VR_BINDS,',
'                V(VR_BINDS)',
'            );',
'        END LOOP;',
'    END IF;',
'',
'    VR_EXEC         := DBMS_SQL.EXECUTE(VR_CURS);',
'    VR_REF_CURSOR   := DBMS_SQL.TO_REFCURSOR(VR_CURS);',
'    RETURN VR_REF_CURSOR;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        IF DBMS_SQL.IS_OPEN(VR_CURS) THEN',
'            DBMS_SQL.CLOSE_CURSOR(VR_CURS);',
'        END IF;',
'        RAISE;',
'END;',
'',
'FUNCTION F_AJAX (',
'    P_REGION   IN         APEX_PLUGIN.T_REGION,',
'    P_PLUGIN   IN         APEX_PLUGIN.T_PLUGIN',
') RETURN APEX_PLUGIN.T_REGION_AJAX_RESULT IS',
'    VR_RESULT       APEX_PLUGIN.T_REGION_AJAX_RESULT;',
'    VR_CUR          SYS_REFCURSOR;',
'    VR_BIND_NAMES   SYS.DBMS_SQL.VARCHAR2_TABLE;',
'BEGIN',
'/* undocumented function of APEX for get all bindings */',
'    VR_BIND_NAMES   := WWV_FLOW_UTILITIES.GET_BINDS(P_REGION.SOURCE);',
'',
'/* execute binding*/',
'    VR_CUR          := SQL_TO_SYS_REFCURSOR(',
'        RTRIM(',
'            P_REGION.SOURCE,',
'            '';''',
'        ),',
'        VR_BIND_NAMES',
'    );',
'',
'/* create json */',
'    APEX_JSON.OPEN_OBJECT;',
'    APEX_JSON.WRITE(',
'        ''row'',',
'        VR_CUR',
'    );',
'    APEX_JSON.CLOSE_OBJECT;',
'',
'    RETURN VR_RESULT;',
'END;',
'',
'FUNCTION F_RENDER (',
'    P_REGION                IN                      APEX_PLUGIN.T_REGION,',
'    P_PLUGIN                IN                      APEX_PLUGIN.T_PLUGIN,',
'    P_IS_PRINTER_FRIENDLY   IN                      BOOLEAN',
') RETURN APEX_PLUGIN.T_REGION_RENDER_RESULT IS',
'',
'    VR_RESULT         APEX_PLUGIN.T_REGION_RENDER_RESULT;',
'    VR_ITEMS2SUBMIT   APEX_APPLICATION_PAGE_REGIONS.AJAX_ITEMS_TO_SUBMIT%TYPE := APEX_PLUGIN_UTIL.PAGE_ITEM_NAMES_TO_JQUERY(P_REGION.AJAX_ITEMS_TO_SUBMIT);',
'BEGIN',
'    APEX_CSS.ADD_FILE(',
'        P_NAME        => ''Latest_Dashboard'',',
'        P_DIRECTORY   => P_PLUGIN.FILE_PREFIX,',
'        P_VERSION     => NULL,',
'        P_KEY         => ''LatestDashboard''',
'    );',
'    ',
'    APEX_JAVASCRIPT.ADD_LIBRARY(',
'        P_NAME        => ''Latest_Dashboard'',',
'        P_DIRECTORY   => P_PLUGIN.FILE_PREFIX,',
'        P_VERSION     => NULL,',
'        P_CHECK_TO_ADD_MINIFIED => False,',
'        P_KEY         => ''LatestDashboard''',
'    );',
'',
'   HTP.P(''<div id="'' || APEX_ESCAPE.HTML_ATTRIBUTE( P_REGION.STATIC_ID ) || ''-p" class="mat-flip-cards"></div>'');',
'',
'    APEX_JAVASCRIPT.ADD_ONLOAD_CODE( ''LatestDashboard.render(''',
'     || APEX_JAVASCRIPT.ADD_VALUE( P_REGION.STATIC_ID, TRUE )    ',
'     || APEX_JAVASCRIPT.ADD_VALUE( APEX_PLUGIN.GET_AJAX_IDENTIFIER, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( P_REGION.NO_DATA_FOUND_MESSAGE, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( VR_ITEMS2SUBMIT, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( P_REGION.ESCAPE_OUTPUT, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( P_REGION.ATTRIBUTE_01, FALSE )',
'     || '');'' );',
'',
'    RETURN VR_RESULT;',
'END;'))
,p_api_version=>2
,p_render_function=>'F_RENDER'
,p_ajax_function=>'F_AJAX'
,p_standard_attributes=>'SOURCE_SQL:AJAX_ITEMS_TO_SUBMIT:NO_DATA_FOUND_MESSAGE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'This is New version of Cool Dashboard V 2.0 plugin where you can show your data into different cards view.'
,p_version_identifier=>'2.0.0'
,p_about_url=>'https://github.com/sattuvirus'
,p_files_version=>6
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(21911560183329769)
,p_plugin_id=>wwv_flow_api.id(21910779863318360)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'ConfiguraionJSON'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'{ "cardWidth": 2, "refresh": 0 ,"releaveHideIcon":"fa-long-arrow-down"}	'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(21910905038318392)
,p_plugin_id=>wwv_flow_api.id(21910779863318360)
,p_name=>'SOURCE_SQL'
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select 1 as sort_order,',
'''https://www.google.com/'' as LINK1,',
'''Users'' title,',
'''250'' data,',
'''fa-users fa-fw fa-3x'' as icon_class,',
'''dark-blue'' as class1,',
'''dark-blue'' as class2,',
'''https://www.google.com/'' as link',
'from dual',
'union all',
'Select 2 as sort_order,',
'''https://www.google.com/'' as LINK1,',
'''Online'' title,',
'''150'' data,',
'''fa-phone fa-fw fa-3x'' as icon_class,',
'''red'' as class1,',
'''red'' as class2,',
'''https://www.google.com/'' as link',
'from dual',
'union all',
'Select 3 as sort_order,',
'''https://www.google.com/'' as LINK1,',
'''Off-line'' title,',
'''100'' data,',
'''fa-area-chart fa-fw fa-3x'' as icon_class,',
'''orange'' as class1,',
'''orange'' as class2,',
'''https://www.google.com/'' as link',
'from dual',
'union all',
'Select 4 as sort_order,',
'''https://www.google.com/'' as LINK1,',
'''Pending'' title,',
'''250'' data,',
'''fa fa-download fa-fw fa-3x'' as icon_class,',
'''green'' as class1,',
'''green'' as class2,',
'''https://www.google.com/'' as link',
'from dual'))
,p_depending_on_has_to_exist=>true
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E6A617661696E68616E647B666C6F61743A6C6566743B6865696768743A2D323270783B6D617267696E2D72696768743A31253B70616464696E673A3570783B706F736974696F6E3A72656C61746976653B77696474683A3234257D2E636972636C652D';
wwv_flow_api.g_varchar2_table(2) := '74696C657B6D617267696E2D626F74746F6D3A313570783B746578742D616C69676E3A63656E7465727D2E636972636C652D74696C652D68656164696E677B626F726465723A33707820736F6C69642072676261283235352C3235352C3235352C2E3329';
wwv_flow_api.g_varchar2_table(3) := '3B626F726465722D7261646975733A313030253B636F6C6F723A236666663B6865696768743A383070783B6D617267696E3A30206175746F202D343070783B706F736974696F6E3A72656C61746976653B7472616E736974696F6E3A616C6C202E337320';
wwv_flow_api.g_varchar2_table(4) := '656173652D696E2D6F75742030733B77696474683A383070787D2E636972636C652D74696C652D68656164696E67202E66617B6C696E652D6865696768743A383070787D2E636972636C652D74696C652D636F6E74656E747B70616464696E672D746F70';
wwv_flow_api.g_varchar2_table(5) := '3A353070787D2E636972636C652D74696C652D6E756D6265727B666F6E742D73697A653A323670783B666F6E742D7765696768743A3730303B6C696E652D6865696768743A313B70616464696E673A357078203020313570787D2E636972636C652D7469';
wwv_flow_api.g_varchar2_table(6) := '6C652D6465736372697074696F6E7B746578742D7472616E73666F726D3A7570706572636173657D2E636972636C652D74696C652D666F6F7465727B6261636B67726F756E642D636F6C6F723A7267626128302C302C302C2E31293B636F6C6F723A7267';
wwv_flow_api.g_varchar2_table(7) := '6261283235352C3235352C3235352C2E35293B646973706C61793A626C6F636B3B70616464696E673A3570783B7472616E736974696F6E3A616C6C202E337320656173652D696E2D6F75742030737D2E636972636C652D74696C652D666F6F7465723A68';
wwv_flow_api.g_varchar2_table(8) := '6F7665727B6261636B67726F756E642D636F6C6F723A7267626128302C302C302C2E32293B636F6C6F723A72676261283235352C3235352C3235352C2E35293B746578742D6465636F726174696F6E3A6E6F6E657D2E636972636C652D74696C652D6865';
wwv_flow_api.g_varchar2_table(9) := '6164696E672E6461726B2D626C75653A686F7665727B6261636B67726F756E642D636F6C6F723A233265343135347D2E636972636C652D74696C652D68656164696E672E677265656E3A686F7665727B6261636B67726F756E642D636F6C6F723A233133';
wwv_flow_api.g_varchar2_table(10) := '386637377D2E636972636C652D74696C652D68656164696E672E6F72616E67653A686F7665727B6261636B67726F756E642D636F6C6F723A236461386331307D2E636972636C652D74696C652D68656164696E672E626C75653A686F7665727B6261636B';
wwv_flow_api.g_varchar2_table(11) := '67726F756E642D636F6C6F723A233234373361367D2E636972636C652D74696C652D68656164696E672E7265643A686F7665727B6261636B67726F756E642D636F6C6F723A236237316331637D2E636972636C652D74696C652D68656164696E672E7075';
wwv_flow_api.g_varchar2_table(12) := '72706C653A686F7665727B6261636B67726F756E642D636F6C6F723A233766336439627D2E74696C652D696D677B746578742D736861646F773A3270782032707820337078207267626128302C302C302C2E39297D2E6461726B2D626C75657B6261636B';
wwv_flow_api.g_varchar2_table(13) := '67726F756E642D636F6C6F723A233334343935657D2E677265656E7B6261636B67726F756E642D636F6C6F723A233265376433327D2E626C75657B6261636B67726F756E642D636F6C6F723A233239383062397D2E6F72616E67657B6261636B67726F75';
wwv_flow_api.g_varchar2_table(14) := '6E642D636F6C6F723A236666613030307D2E7265647B6261636B67726F756E642D636F6C6F723A236535333933357D2E707572706C657B6261636B67726F756E642D636F6C6F723A233865343461647D2E6461726B2D677261797B6261636B67726F756E';
wwv_flow_api.g_varchar2_table(15) := '642D636F6C6F723A233766386338647D2E677261797B6261636B67726F756E642D636F6C6F723A233935613561367D2E6C696768742D677261797B6261636B67726F756E642D636F6C6F723A236264633363377D2E79656C6C6F777B6261636B67726F75';
wwv_flow_api.g_varchar2_table(16) := '6E642D636F6C6F723A236631633430667D2E746578742D6461726B2D626C75657B636F6C6F723A233334343935657D2E746578742D677265656E7B636F6C6F723A233136613038357D2E746578742D626C75657B636F6C6F723A233239383062397D2E74';
wwv_flow_api.g_varchar2_table(17) := '6578742D6F72616E67657B636F6C6F723A236633396331327D2E746578742D7265647B636F6C6F723A236537346333637D2E746578742D707572706C657B636F6C6F723A233865343461647D2E746578742D66616465647B636F6C6F723A726762612832';
wwv_flow_api.g_varchar2_table(18) := '35352C3235352C3235352C2E37297D612E636972636C652D74696C652D666F6F7465727B626F726465723A6E6F6E653B6261636B67726F756E643A236666663B70616464696E673A37707820313670783B746578742D7472616E73666F726D3A75707065';
wwv_flow_api.g_varchar2_table(19) := '72636173653B666F6E742D7765696768743A3530303B666F6E742D73697A653A313170783B6C65747465722D73706163696E673A2E3570783B636F6C6F723A233030336538353B626F782D736861646F773A30203370782035707820236434643464347D';
wwv_flow_api.g_varchar2_table(20) := '406D6564696120286D61782D77696474683A313030307078297B2E6A617661696E68616E647B77696474683A3438257D7D406D6564696120286D61782D77696474683A313230307078297B2E6A617661696E68616E647B706F736974696F6E3A72656C61';
wwv_flow_api.g_varchar2_table(21) := '746976653B77696474683A3234257D7D406D6564696120286D61782D77696474683A3630307078297B2E6A617661696E68616E647B636C6561723A6C6566743B77696474683A38382521696D706F7274616E743B6D617267696E3A302030203020313870';
wwv_flow_api.g_varchar2_table(22) := '787D7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(21912033773351083)
,p_plugin_id=>wwv_flow_api.id(21910779863318360)
,p_file_name=>'Latest_Dashboard.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '766172204C617465737444617368626F6172643D66756E6374696F6E28297B2275736520737472696374223B76617220653D7B76657273696F6E3A22312E302E30222C6973415045583A66756E6374696F6E28297B72657475726E22756E646566696E65';
wwv_flow_api.g_varchar2_table(2) := '6422213D747970656F6620617065787D2C64656275673A7B696E666F3A66756E6374696F6E2861297B652E69734150455828292626617065782E64656275672E696E666F2861297D2C6572726F723A66756E6374696F6E2861297B652E69734150455828';
wwv_flow_api.g_varchar2_table(3) := '293F617065782E64656275672E6572726F722861293A636F6E736F6C652E6572726F722861297D7D2C6C6F616465723A7B73746172743A66756E6374696F6E2861297B696628652E697341504558282929617065782E7574696C2E73686F775370696E6E';
wwv_flow_api.g_varchar2_table(4) := '65722824286129293B656C73657B76617220723D2428223C7370616E3E3C2F7370616E3E22293B722E6174747228226964222C226C6F61646572222B61292C722E616464436C617373282263742D6C6F6164657222293B76617220733D2428223C693E3C';
wwv_flow_api.g_varchar2_table(5) := '2F693E22293B732E616464436C617373282266612066612D726566726573682066612D32782066612D616E696D2D7370696E22292C732E63737328226261636B67726F756E64222C2272676261283132312C3132312C3132312C302E362922292C732E63';
wwv_flow_api.g_varchar2_table(6) := '73732822626F726465722D726164697573222C223130302522292C732E637373282270616464696E67222C223135707822292C732E6373732822636F6C6F72222C22776869746522292C722E617070656E642873292C242861292E617070656E64287229';
wwv_flow_api.g_varchar2_table(7) := '7D7D2C73746F703A66756E6374696F6E2865297B2428652B22203E202E752D50726F63657373696E6722292E72656D6F766528292C2428652B22203E202E63742D6C6F6164657222292E72656D6F766528297D7D2C6A736F6E53617665457874656E643A';
wwv_flow_api.g_varchar2_table(8) := '66756E6374696F6E28652C61297B76617220723D7B7D3B69662822737472696E67223D3D747970656F662061297472797B613D4A534F4E2E70617273652861297D63617463682865297B636F6E736F6C652E6572726F7228224572726F72207768696C65';
wwv_flow_api.g_varchar2_table(9) := '2074727920746F20706172736520746172676574436F6E6669672E20506C6561736520636865636B20796F757220436F6E666967204A534F4E2E205374616E6461726420436F6E6669672077696C6C20626520757365642E22292C636F6E736F6C652E65';
wwv_flow_api.g_varchar2_table(10) := '72726F722865292C636F6E736F6C652E6572726F722861297D656C736520723D613B7472797B723D242E657874656E642821302C652C61297D63617463682861297B636F6E736F6C652E6572726F7228224572726F72207768696C652074727920746F20';
wwv_flow_api.g_varchar2_table(11) := '6D657267652032204A534F4E7320696E746F207374616E64617264204A534F4E20696620616E7920617474726962757465206973206D697373696E672E20506C6561736520636865636B20796F757220436F6E666967204A534F4E2E205374616E646172';
wwv_flow_api.g_varchar2_table(12) := '6420436F6E6669672077696C6C20626520757365642E22292C636F6E736F6C652E6572726F722861292C723D652C636F6E736F6C652E6572726F722872297D72657475726E20727D2C6E6F446174614D6573736167653A7B73686F773A66756E6374696F';
wwv_flow_api.g_varchar2_table(13) := '6E28652C61297B76617220723D2428223C6469763E3C2F6469763E22292E63737328226D617267696E222C223132707822292E6373732822746578742D616C69676E222C2263656E74657222292E637373282270616464696E67222C2236347078203022';
wwv_flow_api.g_varchar2_table(14) := '292E616464436C61737328226E6F64617461666F756E646D65737361676522292C733D2428223C6469763E3C2F6469763E22292C6E3D2428223C7370616E3E3C2F7370616E3E22292E616464436C6173732822666122292E616464436C61737328226661';
wwv_flow_api.g_varchar2_table(15) := '2D73656172636822292E616464436C617373282266612D327822292E6373732822686569676874222C223332707822292E63737328227769647468222C223332707822292E6373732822636F6C6F72222C222344304430443022292E63737328226D6172';
wwv_flow_api.g_varchar2_table(16) := '67696E2D626F74746F6D222C223136707822293B732E617070656E64286E293B76617220643D2428223C7370616E3E3C2F7370616E3E22292E746578742861292E6373732822646973706C6179222C22626C6F636B22292E6373732822636F6C6F72222C';
wwv_flow_api.g_varchar2_table(17) := '222337303730373022292E6373732822666F6E742D73697A65222C223132707822293B722E617070656E642873292E617070656E642864292C242865292E617070656E642872297D2C686964653A66756E6374696F6E2865297B242865292E6368696C64';
wwv_flow_api.g_varchar2_table(18) := '72656E28222E6E6F64617461666F756E646D65737361676522292E72656D6F766528297D7D7D3B66756E6374696F6E20612865297B76617220613D2428223C6469763E3C2F6469763E22293B72657475726E20612E616464436C6173732822617065782D';
wwv_flow_api.g_varchar2_table(19) := '726F7722292C652E617070656E642861292C617D66756E6374696F6E207228652C722C732C6E297B76617220643D242865293B642E706172656E7428292E63737328226F766572666C6F77222C22696E686572697422293B766172206F3D66756E637469';
wwv_flow_api.g_varchar2_table(20) := '6F6E2865297B76617220613D2428223C6469763E3C2F6469763E22293B72657475726E20612E616464436C61737328226A617661696E68616E645F64617368626F61726420617065782D636F6E7461696E657222292C652E617070656E642861292C617D';
wwv_flow_api.g_varchar2_table(21) := '2864292C693D61286F292C743D303B6E2E72656C656176654869646549636F6E3B242E6561636828722C66756E6374696F6E28652C72297B742B3D6E2E6361726457696474683B76617220733D2428223C6469763E3C2F6469763E22293B732E61646443';
wwv_flow_api.g_varchar2_table(22) := '6C6173732822617065782D632D636F6C2D222B6E2E636172645769647468293B76617220643D2428223C6469763E3C2F6469763E22293B642E616464436C61737328226A617661696E68616E6422293B76617220633D2428223C6469763E3C2F6469763E';
wwv_flow_api.g_varchar2_table(23) := '22293B632E616464436C6173732822636972636C652D74696C6522293B76617220703D2428223C613E3C2F613E22293B702E61747472282268726566222C722E4C494E4B31293B766172206C3D2428223C6469763E3C2F6469763E22292C663D722E434C';
wwv_flow_api.g_varchar2_table(24) := '415353313B6C2E616464436C6173732822636972636C652D74696C652D68656164696E6722292E616464436C6173732866293B76617220763D722E49434F4E5F434C4153532C683D2428223C693E3C2F693E22293B682E616464436C6173732822666122';
wwv_flow_api.g_varchar2_table(25) := '292E616464436C6173732876292C632E617070656E642870292C702E617070656E64286C292C6C2E617070656E642868292C642E617070656E642863293B76617220753D2428223C6469763E3C2F6469763E22293B663D722E434C415353323B752E6164';
wwv_flow_api.g_varchar2_table(26) := '64436C6173732822636972636C652D74696C652D636F6E74656E7422292E616464436C6173732866292C632E617070656E642875293B76617220673D2428223C6469763E3C2F6469763E22293B672E616464436C6173732822636972636C652D74696C65';
wwv_flow_api.g_varchar2_table(27) := '2D6465736372697074696F6E20746578742D666164656422292C672E7465787428722E5449544C45292C752E617070656E642867293B76617220433D2428223C6469763E3C2F6469763E22293B432E616464436C6173732822636972636C652D74696C65';
wwv_flow_api.g_varchar2_table(28) := '2D6E756D62657220746578742D666164656422292C432E7465787428722E44415441292C752E617070656E642843293B76617220783D2428223C613E436C69636B20486572653C2F613E22293B782E616464436C6173732822636972636C652D74696C65';
wwv_flow_api.g_varchar2_table(29) := '2D666F6F74657222292C782E61747472282268726566222C722E4C494E4B293B766172206D3D2428223C693E3C2F693E22293B6D2E616464436C617373282266612066612066612D63686576726F6E2D636972636C652D726967687422292C782E617070';
wwv_flow_api.g_varchar2_table(30) := '656E64286D292C752E617070656E642878292C732E617070656E642864292C692E617070656E642873292C743E3D3132262628693D61286F292C743D30297D297D72657475726E7B72656E6465723A66756E6374696F6E28612C732C6E2C642C6F2C6929';
wwv_flow_api.g_varchar2_table(31) := '7B76617220743D2223222B612B222D70222C633D7B7D3B66756E6374696F6E207028297B242874292E63737328226D696E2D686569676874222C22313230707822292C652E6C6F616465722E73746172742874293B76617220613D643B7472797B617065';
wwv_flow_api.g_varchar2_table(32) := '782E7365727665722E706C7567696E28732C7B706167654974656D733A617D2C7B737563636573733A66756E6374696F6E2861297B2166756E6374696F6E28612C732C6E2C642C6F297B242861292E656D70747928292C732E726F772626732E726F772E';
wwv_flow_api.g_varchar2_table(33) := '6C656E6774683E303F7228612C732E726F772C302C6F293A28242861292E63737328226D696E2D686569676874222C2222292C652E6E6F446174614D6573736167652E73686F7728612C6E29292C652E6C6F616465722E73746F702861297D28742C612C';
wwv_flow_api.g_varchar2_table(34) := '6E2C302C63297D2C6572726F723A66756E6374696F6E2865297B636F6E736F6C652E6572726F7228652E726573706F6E736554657874297D2C64617461547970653A226A736F6E227D297D63617463682865297B636F6E736F6C652E6572726F72282245';
wwv_flow_api.g_varchar2_table(35) := '72726F72207768696C652074727920746F2067657420446174612066726F6D204150455822292C636F6E736F6C652E6572726F722865297D7D633D652E6A736F6E53617665457874656E64287B6361726457696474683A342C726566726573683A307D2C';
wwv_flow_api.g_varchar2_table(36) := '69292C7028293B7472797B617065782E6A5175657279282223222B61292E62696E6428226170657872656672657368222C66756E6374696F6E28297B7028297D297D63617463682865297B636F6E736F6C652E6572726F7228224572726F72207768696C';
wwv_flow_api.g_varchar2_table(37) := '652074727920746F2062696E6420415045582072656672657368206576656E7422292C636F6E736F6C652E6572726F722865297D632E726566726573682626632E726566726573683E302626736574496E74657276616C2866756E6374696F6E28297B70';
wwv_flow_api.g_varchar2_table(38) := '28297D2C3165332A632E72656672657368297D7D7D28293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(21912389452351097)
,p_plugin_id=>wwv_flow_api.id(21910779863318360)
,p_file_name=>'Latest_Dashboard.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
