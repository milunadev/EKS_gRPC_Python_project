# MODULO DE NETWORKING PARA EKS
Este módulo de Terraform se utiliza para configurar una red VPC completa en AWS, incluyendo subredes públicas y privadas, tablas de ruteo, gateways de Internet, y NAT Gateways. Está diseñado para proporcionar una separación clara entre recursos de red públicos y privados.

## Requisitos

- Terraform v0.12 o superior
- Proveedor de AWS v3.x

## Recursos Gestionados

Este módulo gestiona los siguientes recursos:
- **VPC**
    - **Subredes Públicas y Privadas**: Cada subnet está etiquetada no solo con el nombre del proyecto sino también con etiquetas clave para la integración con EKS:
    - Tag `kubernetes.io/role/elb` para subredes públicas: Permite el descubrimiento por los balanceadores de carga externos de EKS.
    - Tag `kubernetes.io/role/internal-elb` para subredes privadas: Usado por los balanceadores de carga internos.
    
    Estas etiquetas son cruciales para la creación automática y administración de los recursos de red por parte del plano de control de Kubernetes en EKS.

- Internet Gateway (IGW): Para que las subredes publics puedan tener acceso y ser accesadas desde Internet, eso tpermite exponer los recursos.
- NAT Gateway: Esto para que los recursos en redes privadas puedan tenr acceso a Internet, para temas de actualizacion, parches, etc. Pero NO las expone a Internet por lo que mantiene seguras nuestras redes priavadas.
- Tablas de ruteo para subredes públicas y privadas: Cada tabla con la ruta necesaria ya sea al NAT gateway o Internet Gateway dependiendo de si es rd publica o privada.
- Asociaciones de tablas de ruteo

## Variables

- `availability_zones`: Lista de zonas de disponibilidad para la creación de subredes.
- `project_name`: Nombre del proyecto para etiquetar los recursos.
- `public_subnet_number`: Número de subredes públicas a crear.
- `private_subnet_number`: Número de subredes privadas a crear.

## Outputs

- `vpc_id`: El ID de la VPC creada.
- `public_subnet_ids`: Los IDs de las subredes públicas creadas.
- `private_subnet_ids`: Los IDs de las subredes privadas creadas.

## Ejemplo de Uso

```hcl
module "networking" {
  source = "./modules/networking"

  availability_zones     = ["us-west-1a", "us-west-1b", "us-west-1c"]
  project_name           = "miProyecto"
  public_subnet_number   = 3
  private_subnet_number  = 3
}