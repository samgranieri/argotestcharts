{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Jenkins image name
*/}}
{{- define "jenkins.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Jenkins agent image name
*/}}
{{- define "jenkins.agent.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.agent.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "jenkins.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "jenkins.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "jenkins.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Gets the host to be used for this application.
When using Ingress, it will be set to the Ingress hostname.
*/}}
{{- define "jenkins.host" -}}
{{- if .Values.ingress.enabled }}
{{- .Values.ingress.hostname | default "" -}}
{{- else -}}
{{- .Values.jenkinsHost | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Gets the host to be used for this application.
When using Ingress, it will be set to the Ingress hostname.
*/}}
{{- define "jenkins.configAsCodeCM" -}}
{{- if .Values.configAsCode.existingConfigmap -}}
{{- .Values.configAsCode.existingConfigmap -}}
{{- else -}}
{{- printf "%s-casc" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Jenkins TLS secret name
*/}}
{{- define "jenkins.tlsSecretName" -}}
{{- $secretName := .Values.tls.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Jenkins JKS password secret name
*/}}
{{- define "jenkins.tlsPasswordsSecret" -}}
{{- $secretName := .Values.tls.passwordsSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-tls-pass" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "jenkins.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- end -}}
