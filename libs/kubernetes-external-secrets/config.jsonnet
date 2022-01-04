local config = import 'jsonnet/config.jsonnet';

local versions = [
  { output: '8.5', version: '8.5.1' },
];

config.new(
  name='kubernetes-external-secrets',
  specs=[
    {
      local url = 'https://raw.githubusercontent.com/external-secrets/kubernetes-external-secrets/%s/charts/kubernetes-external-secrets/crds' % v.version,
      output: v.output,
      prefix: '^io\\.kubernetes-client\\..*',
      crds: [
        '%s/kubernetes-client.io_externalsecrets_crd.yaml' % url,
      ],
      localName: 'kubernetes_external_secrets',
    }
    for v in versions
  ]
)
