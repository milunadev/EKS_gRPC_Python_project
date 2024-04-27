https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html




OJO TENER HELM INSTALADO EN LA MAQUINA
TAMBIEN AWS CLI



Esto se debe a que cuando instalas el AWS Load Balancer Controller con Helm, necesitará una cuenta de servicio de Kubernetes para interactuar con tu clúster EKS.
La cuenta de servicio de Kubernetes vincula la identidad dentro del clúster (la cuenta de servicio) con una identidad de AWS (el rol de IAM) a través de las anotaciones. Esta técnica se denomina IAM roles for service accounts (IRSA) y permite a los contenedores en tu clúster EKS llamar a AWS APIs.




https://github.com/hashicorp/terraform-provider-aws/issues/10104

SOL: https://github.com/hashicorp/terraform-provider-tls/issues/52
