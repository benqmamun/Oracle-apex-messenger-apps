--------------------------------------------------------------------------------
-- Name: Sample Dynamic Actions
-- Copyright (c) 2012, 2022 Oracle and/or its affiliates.
-- Licensed under the Universal Permissive License v 1.0
-- as shown at https://oss.oracle.com/licenses/upl/
--------------------------------------------------------------------------------
prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_210200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2021.10.15'
,p_release=>'21.2.0'
,p_default_workspace_id=>1500461464044476
,p_default_application_id=>102
,p_default_id_offset=>37235237875337281
,p_default_owner=>'SALAM'
);
end;
/
 
prompt APPLICATION 102 - Sample Dynamic Actions
--
-- Application Export:
--   Application:     102
--   Name:            Sample Dynamic Actions
--   Date and Time:   13:42 Tuesday August 2, 2022
--   Exported By:     SALAM
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 19442310608650473765
--   Manifest End
--   Version:         21.2.0
--   Instance ID:     697854978334478
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_oracle_apex_timer
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(19442310608650473765)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.ORACLE.APEX.TIMER'
,p_display_name=>'Timer'
,p_category=>'INIT'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function render_timer (',
'    p_dynamic_action  in apex_plugin.t_dynamic_action,',
'    p_plugin          in apex_plugin.t_plugin )',
'    return apex_plugin.t_dynamic_action_render_result',
'is',
'    l_action     varchar2(10) := nvl(p_dynamic_action.attribute_01, ''add'');',
'    l_timer_name varchar2(20) := substr(nvl(case l_action',
'                                              when ''add''    then p_dynamic_action.attribute_02',
'                                              when ''remove'' then p_dynamic_action.attribute_03',
'                                            end, p_dynamic_action.id), 1, 20);',
'    l_expire_in  number       := nvl(p_dynamic_action.attribute_04, 1000);',
'    l_occurrence varchar2(10) := nvl(p_dynamic_action.attribute_05, ''infinite'');',
'',
'    l_result apex_plugin.t_dynamic_action_render_result;',
'begin',
'    apex_javascript.add_library (',
'        p_name      => ''com_oracle_apex_timer.min'',',
'        p_directory => p_plugin.file_prefix,',
'        p_version   => null );',
'',
'    l_result.javascript_function := ''com_oracle_apex_timer.init'';',
'    l_result.attribute_01        := l_action;',
'    l_result.attribute_02        := l_timer_name;',
'    l_result.attribute_03        := l_expire_in;',
'    l_result.attribute_04        := l_occurrence;',
'    return l_result;',
'end render_timer;'))
,p_api_version=>1
,p_render_function=>'render_timer'
,p_standard_attributes=>'ITEM:REGION:JAVASCRIPT_EXPRESSION:JQUERY_SELECTOR:TRIGGERING_ELEMENT:EVENT_SOURCE:REQUIRED'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'	&nbsp;</p>',
'<div id="cke_pastebin">',
'	This plug-in is a dynamic action which allows to periodically fire other dynamic actions in the browser.&nbsp;For example to refresh a region. But you can perform any action you want, because the plug-in just provides&nbsp;the infrastructure so that'
||' you can hook up your own actions which you want to execute periodically.</div>',
'<div>',
'	&nbsp;</div>',
'<ol>',
'	<li>',
'		Create a dynamic action with the &quot;Timer&quot; plug-in which sets up the periodic timer</li>',
'	<li>',
'		Create a dynamic action for the event &quot;Timer Expired [Plug-in]&quot; where you execute your periodic actions.</li>',
'</ol>',
''))
,p_version_identifier=>'1.0'
,p_about_url=>'http://www.oracleapex.info/'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(19442311111897484142)
,p_plugin_id=>wwv_flow_api.id(19442310608650473765)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Action'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'add'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Specify if you want to <strong>add</strong> or <strong>remove</strong> a timer. If you add a timer with the same name again, the existing one will be removed and created again. If you remove an existing timer, you have to specify a name when you add '
||'the timer so that you are able to identify it when you remove it.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(19442311719863486421)
,p_plugin_attribute_id=>wwv_flow_api.id(19442311111897484142)
,p_display_sequence=>10
,p_display_value=>'Add Timer'
,p_return_value=>'add'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(19442312106488492095)
,p_plugin_attribute_id=>wwv_flow_api.id(19442311111897484142)
,p_display_sequence=>20
,p_display_value=>'Remove Timer'
,p_return_value=>'remove'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(19442312419741552680)
,p_plugin_id=>wwv_flow_api.id(19442310608650473765)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Timer Name'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_display_length=>20
,p_max_length=>20
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(19442311111897484142)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'add'
,p_help_text=>'If you want to remove a timer with the "Remove Timer" action you have to specify a name for the timer when you create it. If you just want to create a timer you don''t have to specify a timer name.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(19442312907751558670)
,p_plugin_id=>wwv_flow_api.id(19442310608650473765)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Timer Name'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_display_length=>20
,p_max_length=>20
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(19442311111897484142)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'remove'
,p_help_text=>'Name of the timer you want to remove. Use the same name you used when you created the timer.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(19442313403857576407)
,p_plugin_id=>wwv_flow_api.id(19442310608650473765)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Expire in x Milliseconds'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_display_length=>10
,p_max_length=>10
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(19442311111897484142)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'add'
,p_help_text=>'Specify the number of milliseconds after which the timer should expire. There are 1000 milliseconds in one second.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(19442313892560582616)
,p_plugin_id=>wwv_flow_api.id(19442310608650473765)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Occurrence'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'infinite'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(19442311111897484142)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'add'
,p_lov_type=>'STATIC'
,p_help_text=>'Specify how often the timer should fire. The timer can be fired just <strong>once</strong> or <strong>infinite</strong> until you remove it with the "Remove Timer" action.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(19442314500872585043)
,p_plugin_attribute_id=>wwv_flow_api.id(19442313892560582616)
,p_display_sequence=>10
,p_display_value=>'Once'
,p_return_value=>'once'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(19442314906066586540)
,p_plugin_attribute_id=>wwv_flow_api.id(19442313892560582616)
,p_display_sequence=>20
,p_display_value=>'Infinite'
,p_return_value=>'infinite'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(19442310893197478786)
,p_plugin_id=>wwv_flow_api.id(19442310608650473765)
,p_name=>'timer_expired'
,p_display_name=>'Timer Expired'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '636F6D5F6F7261636C655F617065785F74696D65723D7B6372656174656454696D6572733A7B7D2C696E69743A66756E6374696F6E28297B76617220613D746869732E616374696F6E2E61747472696275746530312C663D746869732E616374696F6E2E';
wwv_flow_api.g_varchar2_table(2) := '61747472696275746530322C653D7061727365496E7428746869732E616374696F6E2E61747472696275746530332C3130292C633D746869732E616374696F6E2E61747472696275746530342C643D746869732E6166666563746564456C656D656E7473';
wwv_flow_api.g_varchar2_table(3) := '3B66756E6374696F6E206228297B696628633D3D3D22696E66696E69746522297B636F6D5F6F7261636C655F617065785F74696D65722E6372656174656454696D6572735B665D3D73657454696D656F757428622C65297D656C73657B64656C65746520';
wwv_flow_api.g_varchar2_table(4) := '636F6D5F6F7261636C655F617065785F74696D65722E6372656174656454696D6572735B665D7D642E74726967676572282274696D65725F657870697265642E434F4D5F4F5241434C455F415045585F54494D4552222C66297D696628613D3D3D226164';
wwv_flow_api.g_varchar2_table(5) := '6422297B696628636F6D5F6F7261636C655F617065785F74696D65722E6372656174656454696D6572735B665D297B636C65617254696D656F757428636F6D5F6F7261636C655F617065785F74696D65722E6372656174656454696D6572735B665D297D';
wwv_flow_api.g_varchar2_table(6) := '636F6D5F6F7261636C655F617065785F74696D65722E6372656174656454696D6572735B665D3D73657454696D656F757428622C65297D656C73657B696628613D3D3D2272656D6F766522297B696628636F6D5F6F7261636C655F617065785F74696D65';
wwv_flow_api.g_varchar2_table(7) := '722E6372656174656454696D6572735B665D297B636C65617254696D656F757428636F6D5F6F7261636C655F617065785F74696D65722E6372656174656454696D6572735B665D293B64656C65746520636F6D5F6F7261636C655F617065785F74696D65';
wwv_flow_api.g_varchar2_table(8) := '722E6372656174656454696D6572735B665D7D7D7D7D7D3B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(19442324296945805561)
,p_plugin_id=>wwv_flow_api.id(19442310608650473765)
,p_file_name=>'com_oracle_apex_timer.min.js'
,p_mime_type=>'text/javascript'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
