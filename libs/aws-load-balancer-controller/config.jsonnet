local config = import 'jsonnet/config.jsonnet';

local versions = [
    {output: '2.2', ref: 'a46497dc49804fd0cb985cf8ce8e7ba8745819fc'},
    {output: '2.3', ref: '93fa739be6d96e15ec1735a50ace40eefb2ec2c6'},
];

config.new(
  name='aws-load-balancer-controller',
  specs=[
    {
      output: v.output,
      prefix: '^aws\\.k8s\\.elbv2\\..*',
      crds: [
        'https://raw.githubusercontent.com/aws/eks-charts/%s/stable/aws-load-balancer-controller/crds/crds.yaml' % [v.ref],
      ],
      localName: 'aws_load_balancer_controller',
    }
    for v in versions
  ]
)
