local config = import 'jsonnet/config.jsonnet';

config.new(
  name='cert-manager',
  specs=[
    {
      output: '1.3',
      prefix: '^io\\.cert-manager\\..*',
      crds: ['https://github.com/jetstack/cert-manager/releases/download/v1.3.2/cert-manager.crds.yaml'],
      localName: 'cert_manager',
    },
    {
      output: '1.4',
      prefix: '^io\\.cert-manager\\..*',
      crds: ['https://github.com/jetstack/cert-manager/releases/download/v1.4.4/cert-manager.crds.yaml'],
      localName: 'cert_manager',
    },
    {
      output: '1.5',
      prefix: '^io\\.cert-manager\\..*',
      crds: ['https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.crds.yaml'],
      localName: 'cert_manager',
    },
    {
      output: '1.6',
      prefix: '^io\\.cert-manager\\..*',
      crds: ['https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.crds.yaml'],
      localName: 'cert_manager',
    },
  ]
)
