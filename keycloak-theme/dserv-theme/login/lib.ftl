<#-- DServ Theme Library Functions -->

<#function msg key>
    <#return msg(key, '')>
</#function>

<#function msg key, defaultValue>
    <#if .vars['msg']?has_content>
        <#return .vars['msg'](key, defaultValue)>
    <#else>
        <#return defaultValue>
    </#if>
</#function>

<#function url key>
    <#if .vars['url']?has_content>
        <#return .vars['url'][key]>
    <#else>
        <#return ''>
    </#if>
</#function>

<#function properties key>
    <#if .vars['properties']?has_content>
        <#return .vars['properties'][key]!''>
    <#else>
        <#return ''>
    </#if>
</#function>
