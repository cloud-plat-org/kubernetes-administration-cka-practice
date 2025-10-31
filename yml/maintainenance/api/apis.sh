curl -k https://development:6443/version
curl -k https://development:6443/api/v1/namespaces/default/pods
/metrics # health check
/healthz # health check
/api # api server (core groups) *
/apis # api server (named groups) *
/logs # logs for third party integrations
