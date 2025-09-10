<#import "lib.ftl" as lib>

<#macro registrationLayout displayMessage=true displayInfo=false displayRequiredFields=false showAnotherWayIfPresent=true>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}" lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${msg("loginTitleHtml",(realm.displayName!''))}</title>
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico" />
    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <link rel="stylesheet" href="${url.resourcesPath}/css/dserv-theme.css" />
</head>
<body class="${properties.kcBodyClass!}">
    <div class="dserv-container">
        <div class="dserv-card">
            <div class="dserv-card-header">
                <#nested "header">
            </div>
            <div class="dserv-card-body">
                <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                    <div class="dserv-alert dserv-alert-${message.type}">
                        <span class="dserv-alert-text">${kcSanitize(message.summary)?no_esc}</span>
                    </div>
                </#if>
                <#nested "form">
                <#if displayInfo>
                    <div class="dserv-info">
                        <#nested "info">
                    </div>
                </#if>
                <#if showAnotherWayIfPresent>
                    <#nested "socialProviders">
                </#if>
            </div>
        </div>
    </div>
</body>
</html>
</#macro>
