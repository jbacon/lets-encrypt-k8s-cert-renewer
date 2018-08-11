{{- define (.Chart.Name+".labels") }}
labels:
  app: {{ template "fullname" . }}
  chart: {{ .Chart.Name }}-{{ .Chart.Version }}
  release: {{ .Release.Name }}
  #time: {{ .Release.Time.Seconds | quote }}
{{- end }}
{{ .Chart.Name }}