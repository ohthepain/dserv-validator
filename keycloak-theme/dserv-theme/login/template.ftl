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
    <style>
/* DServ Keycloak Theme Styles - Inspired by React Auth Component */
:root {
  --dserv-primary: #2563eb;
  --dserv-primary-glow: #3b82f6;
  --dserv-primary-dark: #1d4ed8;
  --dserv-secondary: #64748b;
  --dserv-success: #10b981;
  --dserv-warning: #f59e0b;
  --dserv-error: #ef4444;
  --dserv-background: #f8fafc;
  --dserv-background-gradient: linear-gradient(135deg, #f8fafc 0%, #ffffff 50%, #e0e7ff 100%);
  --dserv-card-bg: #ffffff;
  --dserv-text: #1e293b;
  --dserv-text-light: #64748b;
  --dserv-text-muted: #94a3b8;
  --dserv-border: #e2e8f0;
  --dserv-border-light: rgba(226, 232, 240, 0.4);
  --dserv-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  --dserv-shadow-elegant: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}

* {
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  background: var(--dserv-background-gradient);
  color: var(--dserv-text);
  margin: 0;
  padding: 0;
  line-height: 1.6;
  min-height: 100vh;
}

.dserv-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
}

.dserv-card {
  background: var(--dserv-card-bg);
  border: 0;
  border-radius: 12px;
  box-shadow: var(--dserv-shadow-elegant);
  width: 100%;
  max-width: 400px;
  overflow: hidden;
}

.dserv-card-header {
  padding: 0;
  background: transparent;
}

.dserv-login-header {
  text-align: center;
  margin-bottom: 2rem;
}

.dserv-brand {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.dserv-icon {
  width: 2rem;
  height: 2rem;
  background: linear-gradient(135deg, var(--dserv-primary) 0%, var(--dserv-primary-glow) 100%);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.dserv-icon-svg {
  width: 1.25rem;
  height: 1.25rem;
  color: white;
}

.dserv-title {
  font-size: 1.5rem;
  font-weight: 700;
  background: linear-gradient(135deg, var(--dserv-primary) 0%, var(--dserv-primary-glow) 100%);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  margin: 0;
}

.dserv-subtitle {
  color: var(--dserv-text-muted);
  margin: 0;
  font-size: 0.875rem;
}

.dserv-card-body {
  padding: 2rem;
}

.dserv-form-container {
  width: 100%;
}

.dserv-form-header {
  text-align: center;
  margin-bottom: 1.5rem;
}

.dserv-form-title {
  font-size: 1.25rem;
  font-weight: 600;
  margin: 0 0 0.5rem 0;
  color: var(--dserv-text);
}

.dserv-form-description {
  color: var(--dserv-text-muted);
  margin: 0;
  font-size: 0.875rem;
}

.dserv-tabs {
  width: 100%;
}

.dserv-tab-list {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0;
  margin-bottom: 1.5rem;
  background: #f1f5f9;
  border-radius: 8px;
  padding: 4px;
}

.dserv-tab-trigger {
  background: transparent;
  border: none;
  padding: 0.75rem 1rem;
  border-radius: 6px;
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  color: var(--dserv-text-muted);
}

.dserv-tab-trigger.dserv-tab-active {
  background: white;
  color: var(--dserv-text);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.dserv-tab-content {
  display: block;
}

.dserv-form-group {
  margin-bottom: 1rem;
}

.dserv-label {
  display: block;
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--dserv-text);
  margin-bottom: 0.5rem;
}

.dserv-input {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 1px solid var(--dserv-border);
  border-radius: 8px;
  font-size: 0.875rem;
  transition: all 0.2s ease;
  background: white;
  color: var(--dserv-text);
}

.dserv-input:focus {
  outline: none;
  border-color: var(--dserv-primary);
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.dserv-input::placeholder {
  color: var(--dserv-text-muted);
}

.dserv-form-options {
  margin-bottom: 1rem;
}

.dserv-checkbox {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.dserv-checkbox input[type="checkbox"] {
  width: 1rem;
  height: 1rem;
  accent-color: var(--dserv-primary);
}

.dserv-checkbox label {
  font-size: 0.875rem;
  color: var(--dserv-text-muted);
  cursor: pointer;
}

.dserv-button {
  width: 100%;
  padding: 0.75rem 1rem;
  border: none;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  text-decoration: none;
  display: inline-block;
  text-align: center;
}

.dserv-button-primary {
  background: var(--dserv-primary);
  color: white;
}

.dserv-button-primary:hover {
  background: var(--dserv-primary-dark);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
}

.dserv-button-primary:active {
  transform: translateY(0);
}

.dserv-social-section {
  margin-top: 1.5rem;
}

.dserv-divider {
  position: relative;
  margin: 1.5rem 0;
}

.dserv-divider::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 0;
  right: 0;
  height: 1px;
  background: var(--dserv-border);
}

.dserv-divider-text {
  position: relative;
  background: var(--dserv-card-bg);
  padding: 0 1rem;
  font-size: 0.75rem;
  text-transform: uppercase;
  color: var(--dserv-text-muted);
  font-weight: 500;
}

.dserv-social-buttons {
  margin-top: 1.5rem;
}

.dserv-social-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0.75rem;
}

.dserv-social-button {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.75rem 1rem;
  border: 1px solid var(--dserv-border);
  border-radius: 8px;
  background: white;
  color: var(--dserv-text);
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  text-decoration: none;
}

.dserv-social-button:hover {
  background: #f8fafc;
  border-color: var(--dserv-primary);
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.dserv-social-icon {
  width: 1rem;
  height: 1rem;
}

.dserv-footer-links {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1rem;
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid var(--dserv-border-light);
}

.dserv-footer-link {
  font-size: 0.75rem;
  color: var(--dserv-text-muted);
  text-decoration: none;
  transition: color 0.2s ease;
}

.dserv-footer-link:hover {
  color: var(--dserv-text);
  text-decoration: underline;
}

.dserv-footer-separator {
  font-size: 0.75rem;
  color: var(--dserv-text-muted);
}

.dserv-debug-section {
  text-align: center;
  margin-top: 1rem;
}

.dserv-debug-button {
  background: none;
  border: none;
  color: var(--dserv-text-muted);
  font-size: 0.75rem;
  cursor: pointer;
  text-decoration: underline;
  transition: color 0.2s ease;
}

.dserv-debug-button:hover {
  color: var(--dserv-text);
}

.dserv-alert {
  padding: 1rem;
  border-radius: 8px;
  margin-bottom: 1.5rem;
  border-left: 4px solid;
}

.dserv-alert-error {
  background: #fef2f2;
  border-color: var(--dserv-error);
  color: #991b1b;
}

.dserv-alert-warning {
  background: #fffbeb;
  border-color: var(--dserv-warning);
  color: #92400e;
}

.dserv-alert-success {
  background: #f0fdf4;
  border-color: var(--dserv-success);
  color: #166534;
}

.dserv-alert-text {
  font-weight: 500;
}

.dserv-info {
  margin-top: 1.5rem;
  padding-top: 1.5rem;
  border-top: 1px solid var(--dserv-border);
  text-align: center;
}

.dserv-registration-info {
  color: var(--dserv-text-muted);
  font-size: 0.875rem;
}

.dserv-registration-info a {
  color: var(--dserv-primary);
  text-decoration: none;
  font-weight: 600;
}

.dserv-registration-info a:hover {
  text-decoration: underline;
}

/* Responsive Design */
@media (max-width: 480px) {
  .dserv-container {
    padding: 0.5rem;
  }
  
  .dserv-card-body {
    padding: 1.5rem;
  }
  
  .dserv-title {
    font-size: 1.25rem;
  }
  
  .dserv-social-row {
    grid-template-columns: 1fr;
  }
}

/* Loading State */
.dserv-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none !important;
}

/* Focus Management */
.dserv-input:focus,
.dserv-button:focus,
.dserv-social-button:focus {
  outline: 2px solid var(--dserv-primary);
  outline-offset: 2px;
}
    </style>
</head>
<body class="${properties.kcBodyClass!}">
    <div class="dserv-container">
        <div class="dserv-card">
            <div class="dserv-card-header">
                <#nested "header">
            </div>
            <div class="dserv-card-body">
                <#if displayMessage && message?has_content && message.summary?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                    <div class="dserv-alert dserv-alert-${message.type!}">
                        <span class="dserv-alert-text">${message.summary}</span>
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
