local config = import 'jsonnet/config.jsonnet';

config.new(
  name='vertical-pod-autoscaler',
  specs=[
    {
      output: '0.9',
      prefix: '^io\\.k8s\\.autoscaling\\.*',
      crds: [
        'https://raw.githubusercontent.com/kubernetes/autoscaler/vertical-pod-autoscaler-0.9.2/vertical-pod-autoscaler/deploy/vpa-beta-crd.yaml',
        'https://raw.githubusercontent.com/kubernetes/autoscaler/vertical-pod-autoscaler-0.9.2/vertical-pod-autoscaler/deploy/vpa-beta2-crd.yaml',
        'https://raw.githubusercontent.com/kubernetes/autoscaler/vertical-pod-autoscaler-0.9.2/vertical-pod-autoscaler/deploy/vpa-crd.yaml',
        'https://raw.githubusercontent.com/kubernetes/autoscaler/vertical-pod-autoscaler-0.9.2/vertical-pod-autoscaler/deploy/vpa-v1-crd.yaml',
      ],
      localName: 'vertical_pod_autoscaler',
    },
  ]
)
